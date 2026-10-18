AddCSLuaFile "shared.lua"
include "shared.lua"

local PlaybackApi = "https://web.kick.com/api/v1/stream/%s/playback"
local ChannelApi = "https://kick.com/api/v2/channels/%s"

local function OnReceiveVodMetadata( self, callback, body )
	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse Kick VOD metadata." )
	end

	local session = data.video_session or {}
	local metadata = {}
	metadata.title = session.video_title or ( "Kick VOD: " .. ( self:GetKickVodId() or "" ) )
	metadata.duration = tonumber( session.video_duration ) or 0

	local playback = data.playback_url or {}
	if isstring( playback.thumbnail ) and playback.thumbnail ~= "" then
		metadata.thumbnail = playback.thumbnail:gsub( "%{index%}", "0" )
	end

	self:SetMetadata( metadata, true )

	if metadata.duration > 0 then
		MediaPlayer.Metadata:Save( self )
	end

	callback( self._metadata )
end

local function OnReceiveLiveMetadata( self, callback, body, channel )
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

	if istable( live.thumbnail ) and isstring( live.thumbnail.url ) then
		metadata.thumbnail = live.thumbnail.url
	end

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
		local apiurl = PlaybackApi:format( uuid )

		self:Fetch( apiurl,
			function( body, length, headers, code )
				OnReceiveVodMetadata( self, callback, body )
			end,
			function( code )
				local metadata = {
					title = "Kick VOD: " .. ( uuid or data ),
					duration = 0,
				}
				self:SetMetadata( metadata, true )
				callback( self._metadata )
			end
		)
		return
	end

	-- Live channel: api/v2/channels/{slug} + livestream.is_live
	local channel = self:GetKickChannel() or data
	local apiurl = ChannelApi:format( channel )

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveLiveMetadata( self, callback, body, channel )
		end,
		function( code )
			callback( false, "Failed to load Kick channel [" .. tostring( code ) .. "]" )
		end
	)
end
