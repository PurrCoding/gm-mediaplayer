include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"

local JS_Volume = [[
	if (window.MediaPlayer) {
		var v = %s;
		if (v > 0) { window.MediaPlayer.muted = false; }
		window.MediaPlayer.volume = v;
	}
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
	Bind when the <video> is actually playing, then apply volume once.
	{@volume} is replaced with the current MediaPlayer volume (0–1).
	READY: is observed by the browser base HookBrowserReady path.
]]
local JS_Interface = [[
	var checkerInterval = setInterval(function() {
		var player = document.getElementsByTagName("video")[0];
		if (!!player && player.paused == false && player.readyState >= 3) {
			clearInterval(checkerInterval);

			document.body.style.backgroundColor = "black";
			window.MediaPlayer = player;

			player.muted = false;
			player.volume = {@volume};

			console.log("READY:");

			// If the embed re-mutes after autoplay policy, clear mute only
			setTimeout(function() {
				if (window.MediaPlayer && window.MediaPlayer.muted) {
					window.MediaPlayer.muted = false;
				}
			}, 300);
		}
	}, 50);
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
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	local curTime = self:CurrentTime()

	if self:IsTimed() and curTime > 3 then
		url = url .. ( string.find( url, "%?", 1, true ) and "&" or "?" ) .. "t=" .. math.Round( curTime )
	end

	-- Capture volume at open time; apply inside JS only after playback starts
	local vol = tonumber( self:Volume() ) or 0.15
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
	self.Browser:RunJavascript( JS_Volume:format( volume ) )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end
