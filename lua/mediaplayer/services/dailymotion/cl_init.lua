include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"
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
	var checkerInterval = setInterval(function() {
		if (document.querySelector(".np_DialogConsent-accept")) {
			document.querySelector(".np_DialogConsent-accept").click();
		}

		if (document.querySelector(".consent_screen-button.consent_screen-accept")) {
			document.querySelector(".consent_screen-button.consent_screen-accept").click();
		}

		var player = document.querySelector("video#video");
		if (!!player && player.paused == false && player.readyState == 4) {
			clearInterval(checkerInterval);

			window.MediaPlayer = player;
		}
	}, 50);
]]

function SERVICE:GetURL()
	local videoId = self:GetDailymotionVideoId()
	return ("https://www.dailymotion.com/embed/video/%s?rel=0&autoplay=1"):format( videoId )
end

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local curTime = self:CurrentTime()
	local url = self:GetURL()

	-- Add start time to URL if the video didn't just begin
	if self:IsTimed() and curTime > 3 then
		url = url .. "&start=" .. math.Round(curTime)
	end

	browser:OpenURL( url )
	browser.OnDocumentReady = function(pnl)
		browser:QueueJavascript( JS_Interface )
	end

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