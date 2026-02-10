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

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._YTPaused then
		self.Browser:RunJavascript( JS_Play )
		self._YTPaused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetYouTubeVideoId()
	local curTime = self:CurrentTime()

	local baseUrl = MediaPlayer.GetConfigValue( "youtube.url" )
	local hash = ("v=%s"):format(videoId)

	if self.IsTimed then
		hash = hash .. ("&t=%d"):format(curTime)
	end

	local url = baseUrl .. "#" .. hash
	browser:OpenURL( url )

end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid(self.Browser) then
		self.Browser:RunJavascript(JS_Pause)
		self._YTPaused = true
	end

end

function SERVICE:SetVolume( volume )
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

do	-- Metadata Prefech
	function SERVICE:PreRequest( callback )

		local videoId = self:GetYouTubeVideoId()

		local panel = vgui.Create("DHTML")
		panel:SetSize(500,500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		svc = self
		function panel:ConsoleMessage(msg)
			print(msg)

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback(errmsg)
				panel:Remove()
				return
			end

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				svc._metaTitle = metadata.title
				svc._metaDuration = metadata.duration
				svc._metaisLive = metadata.isLive
				callback()
				panel:Remove()
			end
		end

		local baseUrl = MediaPlayer.GetConfigValue( "youtube.url_meta" )
		local hash = ("v=%s"):format(videoId)

		local url = baseUrl .. "#" .. hash
		panel:OpenURL(url)

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )
	end

	function SERVICE:NetWriteRequest()
		net.WriteString( self._metaTitle )
		net.WriteUInt( self._metaDuration, 16 )
		net.WriteBool(self._metaisLive)
	end
end
