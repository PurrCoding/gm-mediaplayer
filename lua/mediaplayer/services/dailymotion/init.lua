--[[
  Media Player Redux
  Copyright (c) 2014–2026 GMod Media Player authors

  Originally created by Samuel Maddock
  (https://github.com/samuelmaddock/gm-mediaplayer)

  This file is part of the Media Player Redux project
  (https://github.com/PurrCoding/gm-mediaplayer)

  Licensed under the MIT License.
  See LICENSE.md in the project root for the full license text.
  The copyright notice and this permission notice must be retained
  in all copies or substantial portions of the Software.
]]

AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrl = "https://api.dailymotion.com/video/%s?fields=id,title,duration,status,mode,private"

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