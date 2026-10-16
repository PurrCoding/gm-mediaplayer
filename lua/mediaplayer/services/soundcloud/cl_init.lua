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
	end
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

-- Client-side metadata probe (minimal):
-- 1) scrape client_id + api-widget resolve (incl. DRM gate)
-- 2) oEmbed title only if resolve failed for non-DRM reasons
-- No SC.Widget metadata probe — playback widget stays in EMBED_HTML only.
local METADATA_HTML = [[
<!doctype html><html><head><meta charset="utf-8"></head><body>
<script>
(async function() {
  const trackUrl = "https://soundcloud.com/{@audioPath}";
  const FALLBACK_CLIENT_ID = "nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic";
  let completed = false;
  let safetyTimeout = setTimeout(function() {
    if (completed) return;
    completed = true;
    console.log("ERROR:SoundCloud metadata probe timed out");
  }, 12000);

  const emit = function(title, duration) {
    if (completed || !title) return false;
    completed = true;
    clearTimeout(safetyTimeout);
    console.log("METADATA:" + JSON.stringify({
      title: String(title),
      duration: Math.floor(Math.max(0, Number(duration) || 0) / 1000)
    }));
    return true;
  };
  const debug = function(message) { console.log("DEBUG:SoundCloud probe: " + message); };

  async function scrapeClientId() {
    try {
      const page = await fetch("https://soundcloud.com/", { credentials: "omit" });
      if (!page.ok) throw new Error("homepage HTTP " + page.status);
      const html = await page.text();
      const srcs = [];
      const re = /<script[^>]+src=["']([^"']+)["']/gi;
      let m;
      while ((m = re.exec(html)) !== null) {
        if (/sndcdn\.com|soundcloud\.com/i.test(m[1])) srcs.push(m[1]);
      }
      for (let i = srcs.length - 1; i >= 0; i--) {
        let src = srcs[i];
        if (!/^https?:\/\//i.test(src)) {
          src = "https://a-v2.sndcdn.com" + (src.charAt(0) === "/" ? src : "/" + src);
        }
        try {
          const jsRes = await fetch(src, { credentials: "omit" });
          if (!jsRes.ok) continue;
          const js = await jsRes.text();
          const idMatch = js.match(/client_id\s*:\s*["']([0-9a-zA-Z]{32})["']/)
            || js.match(/"client_id"\s*:\s*"([0-9a-zA-Z]{32})"/);
          if (idMatch) return idMatch[1];
        } catch (e) {}
      }
    } catch (error) {
      debug("client_id scrape failed (" + error + ")");
    }
    return FALLBACK_CLIENT_ID;
  }

  function titleFromTrack(data) {
    if (!data || !data.title) return null;
    const user = data.user && (data.user.username || data.user.permalink);
    if (user && data.title.indexOf(user) === -1) return user + " - " + data.title;
    return data.title;
  }

  // Stage 1: resolve with fresh (or fallback) client_id
  try {
    const clientId = await scrapeClientId();
    const resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
      + encodeURIComponent(trackUrl)
      + "&format=json&client_id=" + encodeURIComponent(clientId);
    const response = await fetch(resolveUrl, { credentials: "omit" });
    if (!response.ok) throw new Error("resolve HTTP " + response.status);
    const data = await response.json();
    const track = (data && data.collection && data.collection[0]) || data;
    const duration = track && (track.full_duration || track.duration);
    const title = titleFromTrack(track);

    // Reject DRM-only streams — stop all further metadata stages.
    if (track && track.media && Array.isArray(track.media.transcodings) && track.media.transcodings.length > 0) {
      const playable = track.media.transcodings.some(function(t) {
        const proto = ((t.format && t.format.protocol) || t.protocol || "").toLowerCase();
        return proto && proto.indexOf("encrypted") === -1
          && proto.indexOf("cbc-") !== 0 && proto.indexOf("ctr-") !== 0;
      });
      if (!playable) {
        completed = true;
        clearTimeout(safetyTimeout);
        console.log("ERROR:SoundCloud track only offers encrypted/DRM streams (not playable in GMod)");
        return;
      }
    }

    if (title && Number(duration) > 0 && emit(title, duration)) return;
    debug("resolve response was incomplete");
  } catch (error) {
    debug("resolve unavailable; trying oEmbed only (" + error + ")");
  }

  // Stage 2 (last resort): oEmbed title only — no widget metadata probe
  try {
    const response = await fetch("https://soundcloud.com/oembed?format=json&url="
      + encodeURIComponent(trackUrl));
    if (!response.ok) throw new Error("oEmbed HTTP " + response.status);
    const data = await response.json();
    if (data && data.title && emit(data.title, 0)) return;
  } catch (error) {
    debug("oEmbed failed: " + error);
  }

  console.log("ERROR:SoundCloud client metadata probe exhausted");
})();
</script></body></html>
]];

function SERVICE:PreRequest(callback)
	local html = METADATA_HTML:Replace("{@audioPath}", self:GetSoundCloudTrackId() or "")
	self:DHTMLPrefetch(callback, { html = html, timeout = 12 })
end

function SERVICE:OnPrefetchMetadata(metadata, callback)
	self._metaEncrypted = false
	self._metaError = nil
	self._metaTitle = metadata.title
	self._metaDuration = tonumber(metadata.duration) or 0
	if not self._metaTitle or self._metaTitle == "" or self._metaTitle == "Unknown" then
		self._metaTitle = nil
	end
	callback()
end

function SERVICE:OnPrefetchError(errmsg, callback)
	-- DRM: mark so the server skips hydration and fails cleanly.
	if isstring(errmsg) and errmsg:find("encrypted/DRM", 1, true) then
		self._metaEncrypted = true
		self._metaError = errmsg
		self._metaTitle = nil
		self._metaDuration = 0
	end
	-- Non-DRM errors: allow server resolve / hydration fallback.
	callback()
end

function SERVICE:NetWriteRequest()
	net.WriteBool(self._metaEncrypted == true)
	net.WriteString(self._metaError or "")
	net.WriteString(self._metaTitle or "Unknown")
	net.WriteUInt(math.max(0, math.min(65535, self._metaDuration or 0)), 16)
end
