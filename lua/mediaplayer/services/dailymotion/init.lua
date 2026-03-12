AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrl = "https://api.dailymotion.com/video/%s?fields=id,title,duration,thumbnail_url,status,mode,private"

local function OnReceiveMetadata( self, callback, body )

	local metadata = {}

	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse video's metadata response." )
	end

	if data.private then return callback( false, "This video is Private." ) end
	if data.status ~= "published" then return callback( false, "This video is not Published." ) end

	metadata.title		= data.title
	metadata.duration	= tonumber(data.duration)
	metadata.thumbnail	= data.thumbnail_url

	self:SetMetadata(metadata, true)
	MediaPlayer.Metadata:Save(self)

	callback(self._metadata)

end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	local videoId = self:GetDailymotionVideoId()
	local apiurl = MetadataUrl:format( videoId )

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveMetadata( self, callback, body )
		end,
		function( code )
			callback(false, "Failed to load Dailymotion [" .. tostring(code) .. "]")
		end
	)
end