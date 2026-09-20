# Implementing a Custom Video Service

Services live under `lua/mediaplayer/services/<name>/` with the usual GMod split:

```
shared.lua   — Id, Match, New, URL helpers
init.lua     — SERVER metadata (HTTP APIs)
cl_init.lua  — CLIENT playback (browser / HTML5)
```

Registration happens automatically when the services loader includes your folder (see `sh_services.lua`). The service table must call into the registration path used by existing services (set `SERVICE.Id`, inherit base, and ensure the file is loaded).

---

## 1. Concepts

| Piece | Role |
|-------|------|
| `SERVICE.Id` | Short unique id (`dm`, `yt`, …) stored with media |
| `SERVICE.Base` | Usually `browser` for embeds, or omit for pure base |
| `Match(url)` | Whether this service handles the URL |
| `New(url)` | Construct instance; set `_data` / video id |
| `GetMetadata(callback)` | Server (or client prefetch) title, duration, … |
| `OnBrowserReady` / play JS | Client embed and `window.MediaPlayer` binding |

Base classes:

- `mp_service_base` — metadata, owner, timing, volume API
- `mp_service_browser` — DHTML browser pool, size, volume hooks

---

## 2. Minimal browser service (shared.lua)

```lua
DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name = "Example"
SERVICE.Id   = "ex"
SERVICE.Base = "browser"

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetExampleId()
	return obj
end

function SERVICE:Match( url )
	return string.find( url, "example%.com/watch/" )
end

function SERVICE:GetExampleId()
	if self.videoId then return self.videoId end
	if self.urlinfo and self.urlinfo.path then
		self.videoId = string.match( self.urlinfo.path, "^/watch/([%w%-_]+)" )
	end
	return self.videoId
end
```

`BaseClass.New` parses `url` into `urlinfo` via the shared URL library.

---

## 3. Server metadata (init.lua)

```lua
AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrl = "https://api.example.com/videos/%s"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local id = self:GetExampleId()
	self:Fetch( MetadataUrl:format( id ),
		function( body, length, headers, code )
			local data = util.JSONToTable( body )
			if not data then
				return callback( false, "Failed to parse metadata." )
			end

			local metadata = {
				title    = data.title or "Unknown",
				duration = tonumber( data.duration ) or 0,
			}

			self:SetMetadata( metadata, true )
			MediaPlayer.Metadata:Save( self )
			callback( self._metadata )
		end,
		function( code )
			callback( false, "Metadata request failed [" .. tostring( code ) .. "]" )
		end
	)
end
```

Use `self:Fetch` (from the base service) so headers / errors stay consistent. Cache via `GetCachedMetadata` / `MediaPlayer.Metadata:Save` when appropriate.

For client-driven metadata (YouTube-style), set flags such as `PrefetchMetadata` on the service and implement the client prefetch path used by `youtube/`.

---

## 4. Client playback (cl_init.lua)

```lua
include "shared.lua"
DEFINE_BASECLASS( "mp_service_browser" )

local JS_Interface = [[
	var checkerInterval = setInterval(function() {
		var player = document.querySelector("video");
		if (player && player.readyState >= 3) {
			clearInterval(checkerInterval);
			window.MediaPlayer = player;
		}
	}, 50);
]]

function SERVICE:GetURL()
	return ("https://example.com/embed/%s?autoplay=1"):format( self:GetExampleId() )
end

function SERVICE:OnBrowserReady( browser )
	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	local curTime = self:CurrentTime()
	if self:IsTimed() and curTime > 3 then
		url = url .. "&start=" .. math.Round( curTime )
	end

	browser:OpenURL( url )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( JS_Interface )
	end
end

function SERVICE:SetVolume( volume )
	if IsValid( self.Browser ) then
		self.Browser:RunJavascript(
			("if(window.MediaPlayer) MediaPlayer.volume = %s;"):format( volume )
		)
	end
end
```

Implement `Pause` / seek JS similarly to `dailymotion/cl_init.lua` (run Javascript against `window.MediaPlayer`).

**Contract:** the page should expose an element or adapter as `window.MediaPlayer` with `play`, `pause`, `currentTime`, and `volume` when possible so the base browser service can drive it.

---

## 5. Reference implementations

| Service | Study for |
|---------|-----------|
| `dailymotion/` | Clean API metadata + embed JS |
| `youtube/` | Client metadata prefetch, live vs timed |
| `soundcloud/` | Audio-focused browser service |
| `audiofile/` | Non-browser / direct media |
| `webpage.lua` | Generic www fallback |

---

## 6. Testing checklist

1. `MediaPlayer.ValidUrl` / request UI accepts your URL
2. Title and duration appear in the queue
3. Second player syncs start time
4. Volume, pause, and seek (if timed)
5. Works on entity screens and, if desired, add Id to the spatial whitelist
6. Failure paths (private video, bad id) return clear callback errors

---

## 7. Pitfalls

- Forgetting `SERVICE.Id` or colliding with an existing Id
- Not setting `_data` / unique id → metadata cache and history break
- Blocking the server in `GetMetadata` — always async `Fetch`
- Never assigning `window.MediaPlayer` → volume/seek do nothing
- Assuming `mediaplayer_allow_webpages` — do not rely on www for first-class platforms

---

## Related

- [Video services](video-services.md)
- [Architecture](architecture.md)
- [Development](development.md)
