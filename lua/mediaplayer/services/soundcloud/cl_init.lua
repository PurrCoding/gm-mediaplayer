include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = "if(window.MediaPlayer) MediaPlayer.setVolume(%s * 100);"
local JS_Seek = [[
	if (window.MediaPlayer) {
		var seekTime = %s
		var curTime = MediaPlayer.currentTime

		var diffTime = Math.abs(curTime - seekTime)
		if (diffTime > 5) {
			MediaPlayer.currentTime = seekTime
		}
	}
]]

local EMBED_HTML = [[
	<!doctype html>
	<html><head>
		<meta charset="utf-8">
		<script src="https://w.soundcloud.com/player/api.js"></script>
	</head><body>
	<script>
		(async function() {
			const audioTrack = "https://soundcloud.com/{@audioPath}";
			const shouldPlay = {@shouldPlay};
			let frame = null;

			// Stage 1: ask oEmbed for SoundCloud's recommended iframe.
			try {
				const response = await fetch("https://soundcloud.com/oembed?format=json&url="
					+ encodeURIComponent(audioTrack));
				if (!response.ok) throw new Error("oEmbed HTTP " + response.status);
				const json = await response.json();
				if (json && json.html) {
					const container = document.createElement("div");
					container.innerHTML = json.html;
					frame = container.querySelector("iframe");
					if (frame) document.body.appendChild(frame);
				}
			} catch (error) {
				console.log("DEBUG:SoundCloud player oEmbed failed: " + error);
			}

			// Stage 2: build the official widget URL directly if oEmbed fails.
			if (!frame) {
				frame = document.createElement("iframe");
				const encodedTrack = encodeURIComponent(audioTrack).replace(/%2F/g, "/");
				frame.src = "https://w.soundcloud.com/player/?url=" + encodedTrack
					+ "&auto_play=" + (shouldPlay ? "true" : "false")
					+ "&hide_related=true&show_comments=false&show_user=true&visual=false";
				document.body.appendChild(frame);
			}

			frame.setAttribute("allow", "autoplay");
			frame.setAttribute("width", "100%");
			frame.setAttribute("height", "166");
			document.body.style.margin = "0";
			document.body.style.overflow = "hidden";

			const player = SC.Widget(frame);
			player.bind(SC.Widget.Events.READY, function() {
				player.getDuration(function(duration) {
					let totalDuration = duration || 0;
					let curTime = 0;
					if (!shouldPlay) return;

					frame.setAttribute("height", window.innerHeight);
					setInterval(function() {
						player.getPosition(function(position) { curTime = position; });
					}, 250);

					Object.defineProperty(player, "currentTime", {
						get: function() { return curTime / 1000; },
						set: function(time) { player.seekTo(time * 1000); }
					});
					Object.defineProperty(player, "duration", {
						get: function() { return totalDuration / 1000; }
					});

					player.play();
					window.MediaPlayer = player;
				});
			});
			player.bind(SC.Widget.Events.ERROR, function(event) {
				console.log("ERROR:SoundCloud widget error");
			});
		})();
	</script>
	</body></html>
]]

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local html = EMBED_HTML
	html = html:Replace("{@audioPath}", self:GetSoundCloudTrackId())
	html = html:Replace("{@shouldPlay}", "true")

	browser:SetHTML(html)

end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid(self.Browser) then
		self.Browser:RunJavascript(JS_Pause)
		self._Paused = true
	end

end

function SERVICE:SetVolume( volume )
	if not IsValid(self.Browser) then return end
	local js = JS_Volume:format( volume )
	self.Browser:RunJavascript(js)
end

function SERVICE:Sync()

	local seekTime = self:CurrentTime()
	if IsValid(self.Browser) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript(JS_Seek:format(seekTime))
	end
end

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end

-- Client-side, multi-stage metadata probe.
-- Stage 1: unofficial SoundCloud resolve endpoint.
-- Stage 2: oEmbed title and the official widget API.
-- Stage 3: direct widget URL if oEmbed is unavailable.
-- The server-side HTML parser remains the final fallback.
local METADATA_HTML = [[
<!doctype html><html><head><meta charset="utf-8">
<script src="https://w.soundcloud.com/player/api.js"></script></head><body>
<script>
(async function() {
  const trackUrl = "https://soundcloud.com/{@audioPath}";
  // SoundCloud playback requires a patched/newer CEF in Garry's Mod.
  const requiresGModPatchTool = {@requiresGModPatchTool};
  const emit = function(title, duration) {
    if (!title) return false;
    console.log("METADATA:" + JSON.stringify({
      title: title,
      duration: Math.floor(Math.max(0, Number(duration) || 0) / 1000),
      requiresGModPatchTool: requiresGModPatchTool
    }));
    return true;
  };
  const debug = function(message) { console.log("DEBUG:SoundCloud probe: " + message); };

  // Stage 1: API resolve. This endpoint is undocumented and may stop working.
  try {
    const resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
      + encodeURIComponent(trackUrl)
      + "&format=json&client_id=nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic&app_version=1792051948";
    const response = await fetch(resolveUrl);
    if (!response.ok) throw new Error("resolve HTTP " + response.status);
    const data = await response.json();
    if (data && data.title && Number(data.full_duration || data.duration || 0) > 0) {
      emit(data.title, data.full_duration || data.duration);
      return;
    }
    debug("resolve response did not contain a title");
  } catch (error) { debug("resolve unavailable; trying oEmbed/widget fallback (" + error + ")"); }

  // Stage 2: oEmbed. Prefer its title, but ask the official widget for duration.
  let embedUrl = null;
  let embedTitle = null;
  try {
    const response = await fetch("https://soundcloud.com/oembed?format=json&url="
      + encodeURIComponent(trackUrl));
    if (!response.ok) throw new Error("oEmbed HTTP " + response.status);
    const data = await response.json();
    embedTitle = data && data.title;
    const match = data && data.html && data.html.match(/src=["']([^"']+)["']/i);
    if (match) embedUrl = match[1].replace(/&amp;/g, "&");
    if (embedTitle && !embedUrl) debug("oEmbed had a title but no iframe URL");
  } catch (error) { debug("oEmbed failed: " + error); }

  // Stage 3: use either oEmbed's iframe URL or a direct permalink widget.
  try {
    const playerUrl = embedUrl || ("https://w.soundcloud.com/player/?url="
      + encodeURIComponent(trackUrl) + "&auto_play=false&hide_related=true&show_comments=false");
    const frame = document.createElement("iframe");
    frame.setAttribute("allow", "autoplay");
    frame.setAttribute("width", "100%");
    frame.setAttribute("height", "166");
    frame.src = playerUrl;
    document.body.appendChild(frame);
    const player = SC.Widget(frame);
    let finished = false;
    const finish = function(title, duration) {
      if (finished) return;
      finished = true;
      if (!title || !(Number(duration) > 0)) {
        console.log("ERROR:SoundCloud widget returned incomplete metadata");
        return;
      }
      emit(title || embedTitle, duration);
    };
    player.bind(SC.Widget.Events.READY, function() {
      player.getCurrentSound(function(sound) {
        player.getDuration(function(duration) {
          finish((sound && sound.title) || embedTitle, duration || (sound && sound.duration) || 0);
        });
      });
    });
    player.bind(SC.Widget.Events.ERROR, function() {
      debug("widget emitted an error");
    });
  } catch (error) {
    debug("widget fallback failed: " + error);
    console.log("ERROR:SoundCloud client metadata probe exhausted");
  }
})();
</script></body></html>
]];

function SERVICE:PreRequest(callback)
	local html = METADATA_HTML:Replace("{@audioPath}", self:GetSoundCloudTrackId() or "")
	html = html:Replace("{@requiresGModPatchTool}", self.RequiresGModPatchTool and "true" or "false")
	self:DHTMLPrefetch(callback, { html = html, timeout = 12 })
end

function SERVICE:OnPrefetchMetadata(metadata, callback)
	self._requiresGModPatchTool = metadata.requiresGModPatchTool == true
	self._metaTitle = metadata.title
	self._metaDuration = tonumber(metadata.duration) or 0
	if not self._metaTitle or self._metaTitle == "" or self._metaTitle == "Unknown" then
		self._metaTitle = nil
	end
	callback()
end

function SERVICE:OnPrefetchError(errmsg, callback)
	-- Let server-side HTML parsing try next.
	callback()
end

function SERVICE:NetWriteRequest()
	net.WriteString(self._metaTitle or "Unknown")
	net.WriteUInt(math.max(0, math.min(65535, self._metaDuration or 0)), 16)
end
