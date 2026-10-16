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
			window.MediaPlayer.currentTime = seekTime;
		}
	}
]]

local JS_Interface = [[
	var checkerInterval = setInterval(function() {
		var player = document.getElementsByTagName("video")[0];
		if (!!player && player.paused == false && player.readyState == 4) {
			if (player.muted) { player.muted = false; }
			clearInterval(checkerInterval);
			document.body.style.backgroundColor = "black";
			window.MediaPlayer = player;
		}
	}, 50);
]]

function SERVICE:GetURL()
	local embedUrl = self._metadata and self._metadata.embedUrl
	if embedUrl and embedUrl ~= "" then
		return embedUrl .. "?pub=7a20&rel=5&autoplay=2"
	end

	-- Fallback: open the watch page; player detection still works via <video>
	local videoId = self:GetRumbleVideoId()
	return ("https://rumble.com/%s.html"):format( videoId or "" )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	local curTime = self:CurrentTime()

	if self:IsTimed() and curTime > 3 then
		url = url .. ( string.find( url, "%?" ) and "&" or "?" ) .. "t=" .. math.Round( curTime )
	end

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
