AddCSLuaFile "shared.lua"
include "shared.lua"

local function BuildOEmbedUrl( videoId, isShort )
	if isShort then
		return "https://rumble.com/api/Media/oembed.json?url=https://rumble.com/" .. videoId
	end
	return "https://rumble.com/api/Media/oembed.json?url=https://rumble.com/" .. videoId .. ".html"
end

local function OnReceiveMetadata( self, callback, body )
	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse Rumble metadata response." )
	end

	local metadata = {}
	metadata.title = data.title or "Rumble Video"
	metadata.thumbnail = data.thumbnail_url

	local duration = tonumber( data.duration ) or 0
	metadata.duration = duration

	-- extracts embed from oEmbed html field
	if data.html then
		local embed = string.match( data.html, "(https://rumble%.com/embed/[%a%d-_]+/)" )
		if embed then
			metadata.embedUrl = embed
		end
	end

	self:SetMetadata( metadata, true )

	if duration > 0 then
		MediaPlayer.Metadata:Save( self )
	end

	callback( self._metadata )
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local videoId = self:GetRumbleVideoId()
	if not videoId then
		return callback( false, "Invalid Rumble URL." )
	end

	local apiurl = BuildOEmbedUrl( videoId, self:IsRumbleShort() )

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveMetadata( self, callback, body )
		end,
		function( code )
			callback( false, "Failed to load Rumble [" .. tostring( code ) .. "]" )
		end
	)
end
