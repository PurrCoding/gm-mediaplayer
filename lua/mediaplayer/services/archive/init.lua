AddCSLuaFile "shared.lua"
include "shared.lua"

local METADATA_URL = "https://archive.org/metadata/%s"

-- format support
local VALID_FORMATS = {
	["MPEG4"] = true,
	["h.264"] = true,
	["h.264 IA"] = true,
	["Ogg Video"] = true,
	["WebM"] = true,
	["MP4"] = true,
	["AVI"] = true,
	["MOV"] = true,
	["MKV"] = true,
	["Flac"] = true,
	["VBR MP3"] = true,
}

-- file selection logic
local function FindBestVideoFile(files, requestedFile)
	local candidates = {}

	for _, file in pairs(files) do
		if VALID_FORMATS[file.format] and file.name then
			-- Prioritize requested file
			if requestedFile then
				local normalizedRequested = requestedFile:gsub("+", " ")
				local normalizedFile = file.name:gsub("+", " ")

				if file.original == normalizedRequested or
				   file.name == requestedFile or
				   normalizedFile == normalizedRequested then
					return file
				end
			end

			table.insert(candidates, file)
		end
	end

	if #candidates == 0 then return nil end

	-- If no file was requested, take the first one from the list
	return candidates[1]
end

-- title generation
local function GenerateTitle(response, file, identifier)
	if response.metadata and response.metadata.title then
		local title = response.metadata.title
		if istable(title) then
			title = title[1] or identifier
		end

		-- Add file info if it's part of a collection
		if file.name and file.name ~= title then
			local fileName = file.name:gsub("%.%w+$", "") -- Remove extension
			fileName = fileName:gsub("+", " ") -- Replace + with spaces
			return title .. " - " .. fileName
		end

		return title
	end

	-- Fallback to file name
	if file.name then
		local title = file.name:gsub("%.%w+$", ""):gsub("+", " ")
		return title
	end

	return "Internet Archive: " .. identifier
end

-- thumbnail handling
local function GetThumbnail(files, videoFileName)
	local baseName = videoFileName:gsub("%.%w+$", "")

	for _, file in pairs(files) do
		if file.format == "Thumbnail" then
			-- Look for thumbnails matching the video file
			if file.original and file.original:find(baseName, 1, true) then
				return file.name
			end

		end
	end

	-- no thumbnail
	return nil
end

function SERVICE:GetMetadata( callback )
	if self._metadata then
		callback( self._metadata )
		return
	end

	local cache = MediaPlayer.Metadata:Query(self)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.GetMetadata Cache results:")
		PrintTable(cache or {})
	end

	if cache then

		local metadata = {}
		metadata.title = cache.title
		metadata.duration = tonumber(cache.duration)
		metadata.thumbnail = cache.thumbnail

		self:SetMetadata(metadata)
		MediaPlayer.Metadata:Save(self)

		callback(self._metadata)
	else

		local parts = string.Explode(",", self:GetArchiveVideoId())
		local identifier = parts[1]
		local requestedFile = parts[2]

		local function processMetadata(body, length, headers, code)
			if code ~= 200 or not body then
				return callback(false, "Failed to fetch metadata from Internet Archive")
			end

			local response = util.JSONToTable(body)
			if not response or not response.files then
				return callback(false, "Invalid metadata response")
			end

			local bestMatch = FindBestVideoFile(response.files, requestedFile)
			if not bestMatch then
				return callback(false, "No compatible video files found")
			end

			local info = {
				title = GenerateTitle(response, bestMatch, identifier),
				duration = math.Round(bestMatch.length or 0),
				thumbnail = GetThumbnail(response.files, bestMatch.name),
			}

			self:SetMetadata(info)
			MediaPlayer.Metadata:Save(self)

			callback(self._metadata)
		end

		local url = METADATA_URL:format(identifier)
		self:Fetch(url, processMetadata, onFailure)

		self:Fetch(url, onReceive, function( code )
			callback(false, "Failed to load Archive Video [" .. tostring(code) .. "]")
		end)

	end
end
