include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"

-- Extract the live player, dismiss mature gate, strip chrome UI.
local JS_Interface = [[
	(async () => {
		var checkerInterval = setInterval(function() {
			var matureWarn = document.querySelector("button[data-test=\"mature\"]");
			if (!!matureWarn) {
				matureWarn.click();
				matureWarn.remove();
			}

			var player = document.getElementById("video-player");
			if (!!player) {
				clearInterval(checkerInterval);

				if (player.muted) { player.muted = false; }

				document.body.appendChild(player);
				var main = document.querySelector("div[class^=\"group/main\"]");
				if (main) { main.remove(); }
				document.body.style.backgroundColor = "black";

				window.MediaPlayer = player;
			}
		}, 50);
	})();
]]

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local channel = self:GetKickChannel()
	browser:OpenURL( ("https://kick.com/%s"):format( channel or "" ) )
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
