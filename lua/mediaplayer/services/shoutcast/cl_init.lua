include "shared.lua"

DEFINE_BASECLASS( "mp_service_af" )

function SERVICE:Play()
	if self._resolvedStreamUrl then
		self.url = self._resolvedStreamUrl
	end
	BaseClass.Play( self )
end

function SERVICE:PreRequest( callback )
	local originalUrl = self.url

	local function tryLoadStream( streamUrl )
		self.url = streamUrl

		local function preload( cb )
			MediaPlayerUtils.LoadStreamChannel( streamUrl, "noplay noblock", cb )
		end

		MediaPlayerUtils.Retry(
			preload,
			function( channel )
				local title = channel:GetFileName()
				if not title or title == "" then
					title = "SHOUTcast Radio"
				end

				self:SetMetadataValue( "title", title )
				self:SetMetadataValue( "duration", 0 )
				self._resolvedStreamUrl = streamUrl

				channel:Stop()
				callback()
			end,
			function()
				callback(MediaPlayer.L("mp.error.audio_stream"))
			end,
			3
		)
	end

	local lowerUrl = string.lower(originalUrl)
	if lowerUrl:find("%.pls") or (lowerUrl:find("%.m3u") and not lowerUrl:find("%.m3u8")) then
		HTTP({
			url = originalUrl,
			method = "GET",
			success = function( code, body, headers )
				if code ~= 200 or not body then
					callback("Failed to fetch playlist")
					return
				end

				local streamUrl
				local lowerBody = body:lower()

				if lowerBody:find("%[playlist%]") or lowerUrl:find("%.pls") then
					streamUrl = body:match("File%d-=(%S+)")
				else
					for line in body:gmatch("[^\r\n]+") do
						line = line:match("^%s*(.-)%s*$")
						if line ~= "" and not line:match("^#") then
							streamUrl = line
							break
						end
					end
				end

				if streamUrl then
					tryLoadStream( streamUrl )
				else
					callback("No stream URL found in playlist")
				end
			end,
			failed = function( err )
				callback("Failed to fetch playlist: " .. tostring(err))
			end
		})
	else
		tryLoadStream( originalUrl )
	end
end

function SERVICE:NetWriteRequest()
	net.WriteString( self:Title() )
	net.WriteString( self._resolvedStreamUrl or "" )
end

-- Live radio streams cannot be seeked
function SERVICE:SyncTime()
end

-- Draw station info overlay on the visualizer
local surface = surface

function SERVICE:PostDraw()
	local title = self:Title()
	if title and title ~= "" then
		surface.SetFont("DermaDefaultBold")
		surface.SetTextColor(255, 255, 255, 200)

		local tw, th = surface.GetTextSize(title)
		surface.SetTextPos(10, 10)
		surface.DrawText(title)

		surface.SetFont("DermaDefault")
		surface.SetTextColor(255, 80, 80, 220)
		surface.SetTextPos(10, 10 + th + 4)
		surface.DrawText("● LIVE")
	end
end