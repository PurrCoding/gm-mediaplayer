include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local EMBED_URL = "https://www.bitchute.com/api/beta9/embed/%s?startTime=%d&autoPlay=true"

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
	Embed API already supports autoPlay + startTime.
	Once the <video> is playing, isolate it (MEGA-style) so Video.js
	cannot fight play/pause/seek.
]]
local JS_Interface = [[
	(function() {
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

		var checkerInterval = setInterval(function() {
			var player = document.getElementById("player_one")
				|| document.querySelector("video");
			if (!player) return;

			if (player.paused) {
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					var req = player.play();
					if (req && req.catch) req.catch(function() {});
				} catch (e) {}
				return;
			}

			if (player.readyState < 2) return;

			clearInterval(checkerInterval);
			isolate(player);

			var req = player.play();
			if (req && req.catch) req.catch(function() {});
		}, 50);
	})();
]]

function SERVICE:GetURL()
	local videoId = self:GetBitChuteVideoId() or ""
	local startTime = 0

	if self:IsTimed() then
		local cur = math.floor( self:CurrentTime() or 0 )
		if cur > 0 then
			startTime = cur
		end
	end

	return EMBED_URL:format( videoId, startTime )
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
