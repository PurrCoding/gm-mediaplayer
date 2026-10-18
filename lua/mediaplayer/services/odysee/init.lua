AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	-- First try page HTML for JSON-LD VideoObject metadata
	self:Fetch( self.url,
		function( body, length, headers, code )
			local status, metadata = pcall(self.ParseOdyseeHTML, self, body)

			if status and metadata and metadata.title then
				self:SetMetadata(metadata, true)

				if self:IsTimed() then
					MediaPlayer.Metadata:Save(self)
				end

				callback(self._metadata)
			else
				self:FetchOEmbedMetadata(callback)
			end
		end,
		function( reason )
			self:FetchOEmbedMetadata(callback)
		end
	)
end

function SERVICE:ParseOdyseeHTML( html )
	local jsonLdPattern = '<script type="application/ld%+json">(.-)</script>'
	local jsonData = string.match(html, jsonLdPattern)

	if not jsonData then
		error("No JSON-LD found, attempting oEmbed")
	end

	local videoData = util.JSONToTable(jsonData)
	if not videoData or videoData["@type"] ~= "VideoObject" then
		error("JSON-LD is not a VideoObject, attempting oEmbed")
	end

	local metadata = {}

	metadata.title = videoData.name or "Odysee Video"
	metadata.title = string.gsub(metadata.title, "&quot;", '"')
	metadata.title = string.gsub(metadata.title, "&amp;", "&")
	metadata.title = string.gsub(metadata.title, "&lt;", "<")
	metadata.title = string.gsub(metadata.title, "&gt;", ">")

	if videoData.duration then
		metadata.duration = self:ParseISO8601Duration(videoData.duration)
	else
		metadata.duration = 0
	end

	-- Prefer official embedUrl from JSON-LD (includes full @channel/claim path)
	if videoData.embedUrl and videoData.embedUrl ~= "" then
		-- Decode percent-encoding so we can append query params cleanly
		local embed = string.gsub(videoData.embedUrl, "%%(%x%x)", function(h)
			return string.char(tonumber(h, 16))
		end)
		metadata.embedUrl = embed
	end

	if videoData.thumbnailUrl then
		metadata.thumbnail = videoData.thumbnailUrl
	end

	return metadata
end

function SERVICE:FetchOEmbedMetadata( callback )
	local oembedUrl = "https://odysee.com/$/oembed?url=" .. self.url .. "&format=json"

	self:Fetch( oembedUrl,
		function( body, length, headers, code )
			local status, metadata = pcall(self.ParseOEmbedMetadata, self, body)

			if not status or not metadata or not metadata.title then
				callback(false, "Failed to parse Odysee oEmbed metadata: " .. tostring(metadata))
				return
		end

			self:SetMetadata(metadata, true)
			callback(self._metadata)
		end,
		function( reason )
			callback(false, "Failed to fetch Odysee oEmbed metadata [reason=" .. tostring(reason) .. "]")
		end
	)
end

function SERVICE:ParseOEmbedMetadata( body )
	local response = util.JSONToTable(body)
	if not response then
		error("Invalid oEmbed JSON response")
	end

	local metadata = {}
	metadata.title = response.title or "Odysee Livestream"
	metadata.duration = 0

	if response.thumbnail_url then
		metadata.thumbnail = response.thumbnail_url
	end

	-- Extract embed src from oEmbed html iframe when present
	if response.html then
		local src = string.match(response.html, 'src="([^"]+)"')
		if src then
			local embed = string.gsub(src, "%%(%x%x)", function(h)
				return string.char(tonumber(h, 16))
			end)
			-- Strip existing query so we can control autoplay/t ourselves
			embed = string.match(embed, "^([^?]+)") or embed
			metadata.embedUrl = embed
		end
	end

	return metadata
end

function SERVICE:ParseISO8601Duration( duration )
	if not duration or not string.match(duration, "^PT") then
		return 0
	end

	local totalSeconds = 0

	local hours = string.match(duration, "(%d+)H")
	local minutes = string.match(duration, "(%d+)M")
	local seconds = string.match(duration, "(%d+)S")

	if hours then totalSeconds = totalSeconds + (tonumber(hours) * 3600) end
	if minutes then totalSeconds = totalSeconds + (tonumber(minutes) * 60) end
	if seconds then totalSeconds = totalSeconds + tonumber(seconds) end

	return totalSeconds > 0 and totalSeconds or 0
end
