include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"

local JS_Volume = [[
	(function() {
		var v = %s;
		window.__mpVolume = v;
		var p = window.MediaPlayer;
		if (!p) return;
		try {
			if (v > 0) {
				p.muted = false;
				if (p.hasAttribute && p.hasAttribute("muted")) p.removeAttribute("muted");
			}
			p.volume = v;
		} catch (e) {}
	})();
]]

local JS_Seek = [[
	if (window.MediaPlayer) {
		var seekTime = %s;
		var curTime = window.MediaPlayer.currentTime;
		var diffTime = Math.abs(curTime - seekTime);
		if (diffTime > 5) {
			window.MediaPlayer.currentTime = seekTime;
		}
	}
]]

--[[
	Odysee embed uses Video.js. Prefer the video inside .video-js-parent,
	then any <video>. Autoplay often starts muted — force unmute and keep
	a short volume watchdog.
]]
local JS_Interface = [[
	(function() {
		window.__mpVolume = {@volume};

		window.__mpApplyVolume = function() {
			var p = window.MediaPlayer;
			if (!p) return;
			var v = (typeof window.__mpVolume === "number") ? window.__mpVolume : 0.5;
			try {
				if (v > 0) {
					p.muted = false;
					if (p.hasAttribute && p.hasAttribute("muted")) p.removeAttribute("muted");
				}
				p.volume = v;
			} catch (e) {}
		};

		function findPlayer() {
			var parent = document.querySelector(".video-js-parent");
			if (parent) {
				var v = parent.querySelector("video");
				if (v) return v;
			}
			return document.querySelector("video.vjs-tech")
				|| document.querySelector("video");
		}

		var consentHandled = false;
		var checkerInterval = setInterval(function() {
			var consentBtn = document.querySelector("#onetrust-accept-btn-handler");
			if (consentBtn && !consentHandled) {
				consentBtn.click();
				consentHandled = true;
				return;
			}

			var player = findPlayer();
			if (!player) return;

			if (player.paused) {
				try { player.play(); } catch (e) {}
				return;
			}

			// readyState >= 2 (HAVE_CURRENT_DATA) is enough to take control
			if (player.readyState < 2) return;

			clearInterval(checkerInterval);

			document.body.style.backgroundColor = "black";
			window.MediaPlayer = player;
			window.__mpApplyVolume();

			player.addEventListener("play", function() {
				window.__mpApplyVolume();
			});

			player.addEventListener("volumechange", function() {
				var v = window.__mpVolume;
				if (v > 0 && player.muted) {
					player.muted = false;
				}
			});

			// Short watchdog: Odysee sometimes re-mutes right after start
			var ticks = 0;
			var watchdog = setInterval(function() {
				window.__mpApplyVolume();
				if (++ticks >= 40) clearInterval(watchdog);
			}, 100);
		}, 50);
	})();
]]

function SERVICE:GetEmbedURL()
	-- Prefer metadata embedUrl (full @channel/claim path from JSON-LD / oEmbed)
	local metaEmbed = self._metadata and self._metadata.embedUrl
	if metaEmbed and metaEmbed ~= "" then
		local url = metaEmbed
		if not string.find(url, "[?&]autoplay=") then
			url = url .. (string.find(url, "?", 1, true) and "&" or "?") .. "autoplay=1"
		end
		return url
	end

	local path = self:GetOdyseeEmbedPath()
	if path == "" then
		path = self:GetOdyseeVideoId()
	end

	return ("https://odysee.com/$/embed/%s?autoplay=1"):format(path)
end

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript(JS_Play)
		self._Paused = nil
		self:SetVolume(self:Volume())
		return
	end

	BaseClass.OnBrowserReady(self, browser)

	local embedUrl = self:GetEmbedURL()
	local curTime = self:CurrentTime()

	if self:IsTimed() and curTime > 3 then
		embedUrl = embedUrl .. (string.find(embedUrl, "?", 1, true) and "&" or "?") .. "t=" .. math.Round(curTime)
	end

	local vol = tonumber(self:Volume()) or 0.5
	if vol < 0 then vol = 0 end
	if vol > 1 then vol = 1 end

	local interface = JS_Interface:Replace("{@volume}", string.format("%.4f", vol))

	browser:OpenURL(embedUrl)
	browser.OnDocumentReady = function(pnl)
		browser:QueueJavascript(interface)
	end

end

function SERVICE:Pause()
	BaseClass.Pause(self)

	if IsValid(self.Browser) then
		self.Browser:RunJavascript(JS_Pause)
		self._Paused = true
	end
end

function SERVICE:SetVolume( volume )
	if not IsValid(self.Browser) then return end
	volume = tonumber(volume) or 0
	self.Browser:RunJavascript(JS_Volume:format(volume))
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid(self.Browser) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript(JS_Seek:format(seekTime))
	end
end

function SERVICE:IsMouseInputEnabled()
	return IsValid(self.Browser)
end
