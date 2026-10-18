AddCSLuaFile "shared.lua"
include "shared.lua"

local META_URL = "https://api.bitchute.com/api/beta9/video"

local HttpHeaders = {
	["Cache-Control"] = "no-cache",
	["Content-Type"] = "application/json",
	["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
}

local function ParseDuration( str )
	if not str or str == "" then return 0 end

	local h, m, s = string.match( str, "^(%d+):(%d+):(%d+)$" )
	if h then
		return tonumber( h ) * 3600 + tonumber( m ) * 60 + tonumber( s )
	end

	m, s = string.match( str, "^(%d+):(%d+)$" )
	if m then
		return tonumber( m ) * 60 + tonumber( s )
	end

	return tonumber( str ) or 0
end

local function OnReceiveMetadata( self, callback, body )
	local data = util.JSONToTable( body )
	if not data then
		return callback( false, "Failed to parse BitChute metadata." )
	end

	if not data.video_id then
		return callback( false, "Failed to parse BitChute metadata." )
	end

	if data.state_id and data.state_id ~= "published" and data.state_id ~= "live" then
		return callback( false, "This BitChute video is not available (" .. tostring( data.state_id ) .. ")." )
	end

	local duration = ParseDuration( data.duration )
	local isLive = ( data.state_id == "live" )
		or ( data.state_id == "live" and duration == 0 )
		or ( data.duration == "0:00" and data.state_id == "live" )

	-- Live streams: no fixed duration (IsTimed returns false when duration is 0)
	if isLive or ( data.state_id == "live" ) then
		duration = 0
	end

	local metadata = {}
	metadata.title = data.video_name or "BitChute Video"
	metadata.thumbnail = data.thumbnail_url or ""
	metadata.duration = duration

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

	local videoId = self:GetBitChuteVideoId()
	if not videoId then
		return callback( false, "Invalid BitChute URL." )
	end

	-- SERVICE:Fetch is GET-only; BitChute metadata requires POST
	HTTP( {
		url = META_URL,
		method = "POST",
		headers = HttpHeaders,
		body = util.TableToJSON( { video_id = videoId } ),
		success = function( code, body, headers )
			if MediaPlayer.DEBUG then
				print( "BitChute metadata HTTP[" .. tostring( code ) .. "]" )
			end

			if code ~= 200 then
				return callback( false, "Failed to load BitChute [" .. tostring( code ) .. "]" )
			end

			OnReceiveMetadata( self, callback, body )
		end,
		failed = function( err )
			callback( false, "Failed to load BitChute [" .. tostring( err ) .. "]" )
		end,
	} )
end
