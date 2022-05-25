include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local GdriveURL = "https://drive.google.com/uc?export=open&confirm=yTib&id=%s"

local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"
local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Seek = [[
	if (window.MediaPlayer) {
		var seekTime = %s;
		var curTime = window.MediaPlayer.currentTime;
	
		var diffTime = Math.abs(curTime - seekTime);
		if (diffTime > 5) {
			window.MediaPlayer.currentTime = seekTime
		}
	}
]]

local JS_Interface = [[
	function check() {
		var player = document.getElementsByTagName('video')[0];
		if (!!player && player.paused == false && player.readyState == 4) {
			clearInterval(checkerInterval);

			document.body.style.backgroundColor = "black";
			window.MediaPlayer = player;

		}
	}
	var checkerInterval = setInterval(check, 50);
]]

function SERVICE:OnBrowserReady( browser )

	BaseClass.OnBrowserReady( self, browser )

	local fileId = self:GetGoogleDriveFileId()

	browser:OpenURL( GdriveURL:format(fileId) )
	browser.OnDocumentReady = function(pnl)
		browser:QueueJavascript( JS_Interface )
	end

end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid(self.Browser) then
		self.Browser:RunJavascript(JS_Pause)
		self._YTPaused = true
	end

end

function SERVICE:SetVolume( volume )
	local js = JS_Volume:format( MediaPlayer.Volume() )
	self.Browser:RunJavascript(js)
end

function SERVICE:Sync()

	local seekTime = self:CurrentTime()
	if seekTime > 0 then
		self.Browser:RunJavascript(JS_Seek:format(seekTime))
	end
end