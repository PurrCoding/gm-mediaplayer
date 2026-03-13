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
		var player = document.querySelector("video#vjs_video_3_html5_api")
		var consentBtn = document.querySelector("#onetrust-accept-btn-handler")

		if (!!consentBtn) {
			consentBtn.click()
			return
		}

		if (!consentBtn && !!player && !player.paused && player.readyState == 4) {
			if (player.muted == true) {
				player.muted = false
			}

			clearInterval(checkerInterval);

			window.MediaPlayer = player;
		}
	}, 50);
]]

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetOdyseeVideoId()

	if not self:IsTimed() then
		videoId = ("@%s/%s"):format(self:GetOdyseeChannel(), videoId)
	end

	local embedUrl = ("https://odysee.com/$/embed/%s?autoplay=1"):format(videoId)

	local curTime = self:CurrentTime()

	-- Add start time to URL if the video didn't just begin
	if self:IsTimed() and curTime > 3 then
		embedUrl = embedUrl .. "&t=" .. math.Round(curTime)
	end

	browser:OpenURL( embedUrl )
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

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end