AddCSLuaFile "shared.lua"
include "shared.lua"

local API_URL = "https://ok.ru/web-api/videoyandexfeed/%s"

local patterns = {
	title = "<ovs:title>(.+)</ovs:title>",
	duration = "<ovs:duration>(.+)</ovs:duration>",
}

local function ParseMetaDataFromHTML( html )
	local metadata = {}

	metadata.title = html:match( patterns.title )
	if metadata.title then
		-- Basic entity decode for common cases
		metadata.title = metadata.title:gsub( "&amp;", "&" )
		metadata.title = metadata.title:gsub( "&quot;", '"' )
		metadata.title = metadata.title:gsub( "&lt;", "<" )
		metadata.title = metadata.title:gsub( "&gt;", ">" )
	end

	metadata.duration = tonumber( html:match( patterns.duration ) ) or 0

	return metadata
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local videoId = self:GetOKVideoId()
	if not videoId then
		return callback( false, "Invalid OK URL." )
	end

	self:Fetch( API_URL:format( videoId ),
		function( body, length, headers, code )
			local status, metadata = pcall( ParseMetaDataFromHTML, body )
			if not status or not metadata or not metadata.title then
				return callback( false, "Failed to parse OK metadata." )
			end

			self:SetMetadata( metadata, true )

			if metadata.duration and metadata.duration > 0 then
				MediaPlayer.Metadata:Save( self )
			end

			callback( self._metadata )
		end,
		function( code )
			callback( false, "Failed to load OK [" .. tostring( code ) .. "]" )
		end
	)
end
