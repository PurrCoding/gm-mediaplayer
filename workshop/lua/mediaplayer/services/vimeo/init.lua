AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrl = "https://vimeo.com/api/oembed.json?url=https://vimeo.com/%s"

local function OnReceiveMetadata( self, callback, body )

	local metadata = {}

	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse video's metadata response." )
	end

	metadata.title		= data.title
	metadata.duration	= tonumber(data.duration)
	metadata.thumbnail	= data.thumbnail_url

	self:SetMetadata(metadata, true)
	MediaPlayer.Metadata:Save(self)

	callback(self._metadata)

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

		local videoId = self:GetVimeoVideoId()
		local apiurl = MetadataUrl:format( videoId )

		self:Fetch( apiurl,
			function( body, length, headers, code )
				OnReceiveMetadata( self, callback, body )
			end,
			function( code )
				callback(false, "Failed to load Vimeo [" .. tostring(code) .. "]")
			end
		)

	end
end
