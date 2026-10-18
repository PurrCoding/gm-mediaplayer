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
	Like Kick: detach <video>, strip the rest of the page, full-bleed black.
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
					if (p.hasAttribute && p.hasAttribute("muted")) {
						p.removeAttribute("muted");
					}
				}
				p.volume = v;
			} catch (e) {}
		};

		function isolateVideo(player) {
			// Full-bleed layout
			document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
			document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

			// Move <video> onto body and drop every other node
			document.body.appendChild(player);
			var children = Array.prototype.slice.call(document.body.childNodes);
			for (var i = 0; i < children.length; i++) {
				if (children[i] !== player) {
					try { document.body.removeChild(children[i]); } catch (e) {}
				}
			}

			player.style.cssText = [
				"position:fixed",
				"top:0",
				"left:0",
				"width:100%",
				"height:100%",
				"max-width:100%",
				"max-height:100%",
				"object-fit:contain",
				"background:#000",
				"z-index:9999",
				"margin:0",
				"padding:0",
				"border:none"
			].join(";");

			player.removeAttribute("controls");
			player.controls = false;
		}

		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("video")[0];
			if (!player) return;

			if (player.paused) {
				try { player.play(); } catch (e) {}
				return;
			}

			if (player.readyState < 2) return;

			clearInterval(checkerInterval);

			isolateVideo(player);
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

			var ticks = 0;
			var watchdog = setInterval(function() {
				window.__mpApplyVolume();
				if (++ticks >= 40) {
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
