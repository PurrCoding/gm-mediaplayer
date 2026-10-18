include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = [[
	(function() {
		var p = window.MediaPlayer;
		if (!p) return;
		try { p.pause(); } catch (e) {}
	})();
]]

local JS_Play = [[
	(function() {
		var p = window.MediaPlayer;
		if (!p) return;
		var req = p.play();
		if (req && req.catch) req.catch(function() {});
	})();
]]

local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"

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
	Same approach as MEGA:
	1. Use BitChute/Video.js UI only to start the stream once
	2. Detach <video>, wipe the rest of the page (kills Video.js controls/scripts)
	3. Own play/pause/volume/seek via native HTMLMediaElement APIs
]]
local JS_Interface = [[
	(function() {
		function tryClickPlay() {
			var btn = document.querySelector(".vjs-big-play-button")
				|| document.querySelector("button.vjs-play-control")
				|| document.querySelector(".vjs-play-control");
			if (btn) {
				try { btn.click(); } catch (e) {}
				return true;
			}
			return false;
		}

		function isolate(player) {
			document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
			document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

			document.body.appendChild(player);

			var nodes = Array.prototype.slice.call(document.body.childNodes);
			for (var i = 0; i < nodes.length; i++) {
				if (nodes[i] !== player) {
					try { document.body.removeChild(nodes[i]); } catch (e) {}
				}
			}

			var scripts = document.querySelectorAll("script");
			for (var s = 0; s < scripts.length; s++) {
				try { scripts[s].remove(); } catch (e) {}
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

			window.MediaPlayer = player;
		}

		// Click as soon as the button exists (before video is ready)
		tryClickPlay();

		var checkerInterval = setInterval(function() {
			// Keep poking the play button until playback starts
			tryClickPlay();

			var player = document.getElementsByTagName("video")[0];
			if (!player) return;

			if (player.paused) {
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					var req = player.play();
					if (req && req.catch) req.catch(function() {});
				} catch (e) {}
				return;
			}

			if (Number.isNaN(player.duration) && player.readyState < 2) return;

			clearInterval(checkerInterval);
			isolate(player);

			var req = player.play();
			if (req && req.catch) req.catch(function() {});
		}, 20);
	})();
]]

function SERVICE:GetURL()
	local videoId = self:GetBitChuteVideoId()
	return ("https://www.bitchute.com/embed/%s"):format( videoId or "" )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		if IsValid( self.Browser ) then
			self.Browser:RunJavascript( JS_Play )
		end
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	browser:OpenURL( url )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( JS_Interface )
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
	self.Browser:RunJavascript( JS_Volume:format( volume ) )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end
