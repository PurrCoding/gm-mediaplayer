include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local EMBED_URL = "https://ok.ru/videoembed/%s?autoplay=1"

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
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

-- OK embeds often put <video> inside Shadow DOM
local JS_Interface = [[
	(function() {
		function findVideo(root) {
			if (!root) return null;
			var vid = root.querySelector && root.querySelector("video");
			if (vid) return vid;

			var rootContainer = root.querySelector && root.querySelector(".shadow-root-container");
			if (rootContainer && rootContainer.shadowRoot) {
				var v = findVideo(rootContainer.shadowRoot);
				if (v) return v;
			}

			var all = root.querySelectorAll ? root.querySelectorAll("*") : [];
			for (var i = 0; i < all.length; i++) {
				var el = all[i];
				if (el.shadowRoot) {
					var v2 = findVideo(el.shadowRoot);
					if (v2) return v2;
				}
			}
			return null;
		}

		var checkerInterval = setInterval(function() {
			var player = findVideo(document);
			if (player && !player.paused && player.readyState === 4) {
				clearInterval(checkerInterval);
				window.MediaPlayer = player;
			}
		}, 100);
	})();
]]

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetOKVideoId()
	browser:OpenURL( EMBED_URL:format( videoId or "" ) )
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
