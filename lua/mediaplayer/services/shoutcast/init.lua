AddCSLuaFile "shared.lua"
include "shared.lua"

-- Parse a PLS playlist to extract the first File entry
local function ParsePLS( body )
	local streamUrl = body:match("File%d-=(%S+)")
	local title = body:match("Title%d-=([^\r\n]+)")
	return streamUrl, title
end

-- Parse a simple M3U playlist to extract the first stream URL
local function ParseM3U( body )
	local title
	local streamUrl

	for line in body:gmatch("[^\r\n]+") do
		line = line:match("^%s*(.-)%s*$") -- trim

		if line:match("^#EXTINF:") then
			title = line:match("#EXTINF:[^,]*,(.+)")
		elseif line ~= "" and not line:match("^#") then
			streamUrl = line
			break
		end
	end

	return streamUrl, title
end

local function IsPlaylistUrl( url )
	url = string.lower(url)
	return url:find("%.pls") or url:find("%.m3u") or url:find("tunein%-station")
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	if not self._metadata then
		self._metadata = {
			title    = "SHOUTcast Radio",
			duration = 0
		}
	end

	if IsPlaylistUrl(self.url) then
		self:Fetch( self.url,
			function( body, length, headers, code )
				if code ~= 200 or not body or body == "" then
					self._metadata.title = "SHOUTcast Radio"
					self:SetMetadata(self._metadata, true)
					MediaPlayer.Metadata:Save(self)
					callback(self._metadata)
					return
				end

				local streamUrl, title
				local lowerBody = body:lower()

				if lowerBody:find("%[playlist%]") or self.url:lower():find("%.pls") then
					streamUrl, title = ParsePLS(body)
				else
					streamUrl, title = ParseM3U(body)
				end

				if streamUrl then
					self._resolvedStreamUrl = streamUrl
				end

				self._metadata.title = title or "SHOUTcast Radio"
				self._metadata.duration = 0

				self:SetMetadata(self._metadata, true)
				MediaPlayer.Metadata:Save(self)
				callback(self._metadata)
			end,
			function( err )
				self._metadata.title = "SHOUTcast Radio"
				self:SetMetadata(self._metadata, true)
				callback(self._metadata)
			end
		)
	else
		self:SetMetadata(self._metadata, true)
		MediaPlayer.Metadata:Save(self)
		callback(self._metadata)
	end
end

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end

	local title = net.ReadString()
	local resolvedUrl = net.ReadString()

	self._metadata = self._metadata or {}
	self._metadata.title = title
	self._metadata.duration = 0

	if resolvedUrl and resolvedUrl ~= "" then
		self._resolvedStreamUrl = resolvedUrl
	end
end