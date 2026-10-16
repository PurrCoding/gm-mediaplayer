include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"

--[[
	Desired volume lives in window.__mpVolume so the embed can re-mute
	without us losing the user's slider value. Apply never forces 1.0.
]]
local JS_Volume = [[
	(function() {
		var v = %s;
		window.__mpVolume = v;
		var p = window.MediaPlayer;
		if (!p) return;
		if (v > 0) { p.muted = false; }
		p.volume = v;
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
	1. Wait until video is actually playing
	2. Bind MediaPlayer and install __mpApplyVolume
	3. Apply desired volume once, then defend against re-mute for a few seconds
	{@volume} → initial MediaPlayer volume (0–1)
]]
local JS_Interface = [[
	(function() {
		window.__mpVolume = {@volume};

		window.__mpApplyVolume = function() {
			var p = window.MediaPlayer;
			if (!p) return;
			var v = (typeof window.__mpVolume === "number") ? window.__mpVolume : 0.15;
			try {
				if (v > 0) {
					p.muted = false;
					// Some embeds set defaultMuted / attribute mute
					if (p.hasAttribute && p.hasAttribute("muted")) {
						p.removeAttribute("muted");
					}
				}
				p.volume = v;
			} catch (e) {}
		};

		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("video")[0];
			if (!player) return;

			// Start playback if still paused (autoplay may have been blocked)
			if (player.paused) {
				try { player.play(); } catch (e) {}
				return;
			}

			if (player.readyState < 2) return;

			clearInterval(checkerInterval);

			document.body.style.backgroundColor = "black";
			window.MediaPlayer = player;

			// Apply as soon as we hear real playback
			window.__mpApplyVolume();

			player.addEventListener("play", function() {
				window.__mpApplyVolume();
			});

			// If the player mutes itself (autoplay policy / embed UI), restore
			player.addEventListener("volumechange", function() {
				var v = window.__mpVolume;
				if (v > 0 && player.muted) {
					player.muted = false;
				}
			});

			// Short watchdog: Rumble often re-mutes in the first seconds
			var ticks = 0;
			var watchdog = setInterval(function() {
				window.__mpApplyVolume();
				if (++ticks >= 40) { // ~4s @ 100ms
					clearInterval(watchdog);
				}
			}, 100);

			console.log("READY:");
		}, 50);
	})();
]]

function SERVICE:GetURL()
	local embedUrl = self._metadata and self._metadata.embedUrl
	if embedUrl and embedUrl ~= "" then
		return embedUrl .. "?pub=7a20&rel=5&autoplay=2"
	end

	local videoId = self:GetRumbleVideoId()
	if self:IsRumbleShort() then
		return ("https://rumble.com/%s"):format( videoId or "" )
	end

	return ("https://rumble.com/%s.html"):format( videoId or "" )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		-- Re-apply volume after resume
		self:SetVolume( self:Volume() )
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	local curTime = self:CurrentTime()

	if self:IsTimed() and curTime > 3 then
		url = url .. ( string.find( url, "%?", 1, true ) and "&" or "?" ) .. "t=" .. math.Round( curTime )
	end

	local vol = tonumber( self:Volume() ) or 0.15
	if vol < 0 then vol = 0 end
	if vol > 1 then vol = 1 end

	local interface = JS_Interface:Replace( "{@volume}", string.format( "%.4f", vol ) )

	browser:OpenURL( url )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( interface )
	end
end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid( self.Browser ) then
		self.Browser:RunJavascript( JS_Pause )
		self._Paused = true
	end
end

function SERVICE:SetVolume( volume )
	if not IsValid( self.Browser ) then return end
	volume = tonumber( volume ) or 0
	self.Browser:RunJavascript( JS_Volume:format( volume ) )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end
