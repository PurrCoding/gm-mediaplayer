AddCSLuaFile "shared.lua"
include "shared.lua"

local PlaybackApi = "https://web.kick.com/api/v1/stream/%s/playback"

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
		-- thumbnail-sheet template; use index 0 as a best-effort still
		metadata.thumbnail = playback.thumbnail:gsub( "%{index%}", "0" )
	end

	self:SetMetadata( metadata, true )

	if metadata.duration > 0 then
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
				-- Fallback title if API blocks the request
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

	-- Live channel — no public metadata without auth
	local channel = self:GetKickChannel() or data
	local metadata = {
		title = "Kick: " .. channel,
		duration = 0,
	}

	self:SetMetadata( metadata, true )
	callback( self._metadata )
end
