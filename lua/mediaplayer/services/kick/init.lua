AddCSLuaFile "shared.lua"
include "shared.lua"

local PlaybackApi = "https://web.kick.com/api/v1/stream/%s/playback"
local ChannelApi = "https://kick.com/api/v2/channels/%s"
local ChannelVideosApi = "https://kick.com/api/v2/channels/%s/videos"
local VideoApi = "https://kick.com/api/v1/video/%s"

local KickHeaders = {
	["Accept"] = "application/json",
	["Referer"] = "https://kick.com/",
}

local function MsToSeconds( ms )
	ms = tonumber( ms ) or 0
	if ms <= 0 then return 0 end
	-- Channel/video APIs use milliseconds; playback API uses seconds
	if ms > 100000 then
		return math.floor( ms / 1000 )
	end
	return math.floor( ms )
end

local function ApplyVodMetadata( self, callback, title, duration )
	local metadata = {
		title = title or ( "Kick VOD: " .. ( self:GetKickVodId() or "" ) ),
		duration = tonumber( duration ) or 0,
	}

	self:SetMetadata( metadata, true )

	if metadata.duration > 0 then
		MediaPlayer.Metadata:Save( self )
	end

	callback( self._metadata )
end

--[[
	Page URLs use livestream.vod_id (e.g. 01a1465b-…).
	Channel video list has title/duration but only video.uuid.
	Match via api/v1/video/{uuid} → livestream.vod_id.
]]
local function ResolveVodFromChannelList( self, channel, vodId, callback )
	self:Fetch( ChannelVideosApi:format( channel ),
		function( body, length, headers, code )
			if code ~= 200 then
				return callback( false, "Failed to list Kick VODs [" .. tostring( code ) .. "]" )
			end

			local list = util.JSONToTable( body )
			if not istable( list ) then
				return callback( false, "Invalid Kick VOD list response." )
			end

			local index = 1

			local function tryNext()
				if index > #list then
					return callback( false, "Kick VOD not found on channel." )
				end

				local item = list[index]
				index = index + 1

				local vuuid = istable( item.video ) and item.video.uuid
				if not vuuid then
					return tryNext()
				end

				self:Fetch( VideoApi:format( vuuid ),
					function( body2, length2, headers2, code2 )
						if code2 == 200 then
							local video = util.JSONToTable( body2 )
							local live = istable( video ) and video.livestream
							if istable( live ) and live.vod_id == vodId then
								local title = live.session_title or item.session_title
								local duration = MsToSeconds( live.duration or item.duration )
								return ApplyVodMetadata( self, callback, title, duration )
							end
						end
						tryNext()
					end,
					function()
						tryNext()
					end,
					KickHeaders
				)
			end

			tryNext()
		end,
		function( err )
			callback( false, "Failed to list Kick VODs [" .. tostring( err ) .. "]" )
		end,
		KickHeaders
	)
end

local function OnReceivePlaybackMetadata( self, callback, body, code, channel, vodId )
	if code ~= 200 then
		return ResolveVodFromChannelList( self, channel, vodId, callback )
	end

	local data = util.JSONToTable( body )
	local session = istable( data ) and data.video_session
	if not istable( session ) then
		return ResolveVodFromChannelList( self, channel, vodId, callback )
	end

	local title = session.video_title
	local duration = tonumber( session.video_duration ) or 0

	local playback = data.playback_url or {}

	if ( not title or title == "" ) or duration <= 0 then
		return ResolveVodFromChannelList( self, channel, vodId, callback )
	end

	ApplyVodMetadata( self, callback, title, duration )
end

local function OnReceiveLiveMetadata( self, callback, body, code, channel )
	if code ~= 200 then
		return callback( false, "Failed to load Kick channel [" .. tostring( code ) .. "]" )
	end

	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse Kick channel metadata." )
	end

	local live = data.livestream
	if not istable( live ) or live.is_live ~= true then
		return callback( false, "Kick channel is not live." )
	end

	local metadata = {}
	metadata.title = live.session_title or ( "Kick: " .. channel )
	metadata.duration = 0

	self:SetMetadata( metadata, true )
	callback( self._metadata )
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local data = self:GetKickData()
	if not data then
		return callback( false, "Invalid Kick URL." )
	end

	if self:IsKickVOD() then
		local uuid = self:GetKickVodId()
		local channel = self:GetKickChannel()
		local apiurl = PlaybackApi:format( uuid )

		self:Fetch( apiurl,
			function( body, length, headers, code )
				OnReceivePlaybackMetadata( self, callback, body, code, channel, uuid )
			end,
			function( err )
				ResolveVodFromChannelList( self, channel, uuid, callback )
			end,
			KickHeaders
		)
		return
	end

	local channel = self:GetKickChannel() or data
	local apiurl = ChannelApi:format( channel )

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveLiveMetadata( self, callback, body, code, channel )
		end,
		function( err )
			callback( false, "Failed to load Kick channel [" .. tostring( err ) .. "]" )
		end,
		KickHeaders
	)
end
