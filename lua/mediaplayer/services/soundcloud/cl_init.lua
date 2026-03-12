include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = "if(window.MediaPlayer) MediaPlayer.setVolume(%s * 100);"
local JS_Seek = [[
	if (window.MediaPlayer) {
		var seekTime = %s
		var curTime = MediaPlayer.currentTime

		var diffTime = Math.abs(curTime - seekTime)
		if (diffTime > 5) {
			MediaPlayer.currentTime = seekTime
		}
	}
]]

local EMBED_HTML = [[
	<!doctype html>
	<html>

	<head>
		<script src="https://w.soundcloud.com/player/api.js"></script>
	</head>

	<body>
		<script>
			(async () => {
				const audioTrack = "https://soundcloud.com/{@audioPath}"
				const shouldPlay = {@shouldPlay}

				const response = await fetch(`https://soundcloud.com/oembed?format=json&url=${audioTrack}`)
				const json = await response.json()

				if (!!json && !!json.html) {
					const container = document.createElement('div');
					container.innerHTML = json.html;

					document.body.appendChild(container)
					document.body.style.overflow = 'hidden';

					const frame = container.firstElementChild
					var player = SC.Widget(frame);
					player.bind(SC.Widget.Events.READY, function () {
						var totalDuration = 0
						var curVol = 0
						var curTime = 0

						player.getDuration((duration) => {
							totalDuration = duration

							if (shouldPlay) {
								frame.setAttribute("height", window.innerHeight)

								setInterval(function () {
									player.getVolume((volume) => { curVol = volume });
									player.getPosition((currentTime) => { curTime = currentTime });
								}, 100);

								{ // Native audio controll
									player.currentTime = 0;
									player.duration = 0;

									Object.defineProperty(player, "currentTime", {
										get() {
											return curTime / 1000;
										},
										set(time) {
											player.seekTo(time * 1000);
										},
									});

									Object.defineProperty(player, "duration", {
										get() {
											return totalDuration / 1000;
										},
									});

									player.play()
									window.MediaPlayer = player

								}
							} else {
								var metadata = {
									duration: Math.round(totalDuration / 1000),
									title: json.title
								}

								console.log("METADATA:" + JSON.stringify(metadata))
							}
						});
					});
				}
			})()

		</script>
	</body>

	</html>
]]

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local html = EMBED_HTML
	html = html:Replace("{@audioPath}", self:GetSoundCloudTrackId())
	html = html:Replace("{@shouldPlay}", "true")

	browser:SetHTML(html)

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

do	-- Metadata Prefech
	function SERVICE:PreRequest( callback )

		local trackid = self:GetSoundCloudTrackId()

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

				callback(("SoundCloud Error: %s"):format(errmsg))
				panel:Remove()
			end
		end

		local html = EMBED_HTML
		html = html:Replace("{@audioPath}", trackid)
		html = html:Replace("{@shouldPlay}", "false")

		panel:SetHTML(html)

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