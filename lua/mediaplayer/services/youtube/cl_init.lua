include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = [[
	if(window.MediaPlayer) {
		MediaPlayer.pause()
		mp_paused = true
	}
]]
local JS_Play = [[
	if(window.MediaPlayer) {
		MediaPlayer.play();
		mp_paused = false
	}
]]
local JS_Volume = [[
	if (window.MediaPlayer) {
		MediaPlayer.volume = %s;
	}
]]

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

do -- Request browser extensions

	function SERVICE:OnRequestBrowserURLChanged( browser, parent )
		if not IsValid(browser) or not IsValid(parent) then return end

		-- Nothing is currently being done here.
	end
end

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetYouTubeVideoId()
	local curTime = self:CurrentTime()

	local baseUrl = MediaPlayer.GetConfigValue( "youtube.url" )
	local hash = ("v=%s"):format(videoId)

	if self:IsTimed() then
		hash = hash .. ("&t=%d"):format(curTime)
	end

	local url = baseUrl .. "#" .. hash
	browser:OpenURL( url )

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

do	-- Metadata Prefetch
	function SERVICE:PreRequest( callback )
		local videoId = self:GetYouTubeVideoId()
		local baseUrl = MediaPlayer.GetConfigValue( "youtube.url_meta" )
		local url = baseUrl .. "#v=" .. videoId

		self:DHTMLPrefetch(callback, { url = url })
	end

	function SERVICE:OnPrefetchMetadata( metadata, callback )
		self._metaTitle = metadata.title
		self._metaDuration = metadata.duration
		self._metaisLive = metadata.isLive
		callback()
	end

	function SERVICE:NetWriteRequest()
		net.WriteString( self._metaTitle or "Unknown" )
		net.WriteUInt( self._metaDuration or 0, 16 )
		net.WriteBool( self._metaisLive or false )
	end
end