include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local PREVIEW_URL = "https://drive.google.com/file/d/%s/preview?autoplay=true"

local JS_Interface = [[
	(async () => {
		var player = YT.get("ucc-2");

		var done = false;
		player.addEventListener("onStateChange", function (event) {
			if (event.data == YT.PlayerState.PLAYING && !done) {
				done = true;

				window.MediaPlayer = player
			}
		})
	})();
]]


function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( [[
			if(window.MediaPlayer) {
				MediaPlayer.playVideo()
			}
		]] )

		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetGoogleDriveId()
	local url = PREVIEW_URL:format(videoId)

	browser:OpenURL( url )
	browser.OnDocumentReady = function(pnl)
		browser:QueueJavascript( JS_Interface )
	end

end

do -- Player Controls
	local JS_Pause = [[
		if(window.MediaPlayer) {
			MediaPlayer.pauseVideo()
		}
	]]
	local JS_Volume = [[
		if (window.MediaPlayer) {
			if (MediaPlayer.isMuted()) {
				MediaPlayer.unMute();
			}

			MediaPlayer.setVolume(%s * 100)
		}
	]]

	local JS_Seek = [[
		if (window.MediaPlayer) {
			var seekTime = %s
			var curTime = MediaPlayer.getCurrentTime()

			var diffTime = Math.abs(curTime - seekTime)
			if (diffTime > 5) {
				MediaPlayer.seekTo(seekTime, true)
			}
		}
	]]

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
end

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end

do	-- Metadata Prefech
	local METADATA_JS = [[
		(async  () => {
			var player = YT.get("ucc-2");

			player.addEventListener("onReady", function() {
				player.setVolume(0)
			})

			var done = false;
			player.addEventListener("onStateChange", function(event) {
				if (event.data == YT.PlayerState.PLAYING && !done) {
					done = true;

					var title = document.querySelector("meta[property='og:title']").getAttribute("content");
					var metadata = {
						duration: player.getDuration(),
						title: title
					}

					console.log("METADATA:" + JSON.stringify(metadata))
				}
			})
		})();
	]]

	function SERVICE:PreRequest( callback )

		local trackid = self:GetGoogleDriveId()

		local panel = vgui.Create("DHTML")
		panel:SetSize(500,500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		local svc = self
		function panel:ConsoleMessage(msg)

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				svc._metaTitle = metadata.title
				svc._metaDuration = metadata.duration
				callback()
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback(("Google Drive Error: %s"):format(errmsg))
				panel:Remove()
			end
		end

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(METADATA_JS)
			end
		end

		panel:OpenURL(PREVIEW_URL:format(trackid))

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )
	end

	function SERVICE:NetWriteRequest()
		net.WriteString( self._metaTitle )
		net.WriteUInt( self._metaDuration, 16 )
	end
end