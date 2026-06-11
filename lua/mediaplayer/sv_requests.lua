util.AddNetworkString( "MEDIAPLAYER.RequestListen" )
util.AddNetworkString( "MEDIAPLAYER.RequestUpdate" )
util.AddNetworkString( "MEDIAPLAYER.RequestMedia" )
util.AddNetworkString( "MEDIAPLAYER.RequestPause" )
util.AddNetworkString( "MEDIAPLAYER.RequestSkip" )
util.AddNetworkString( "MEDIAPLAYER.RequestSeek" )
util.AddNetworkString( "MEDIAPLAYER.RequestRemove" )
util.AddNetworkString( "MEDIAPLAYER.RequestRepeat" )
util.AddNetworkString( "MEDIAPLAYER.RequestShuffle" )
util.AddNetworkString( "MEDIAPLAYER.RequestLock" )

local REQUEST_DELAY = 0.2

local function RequestWrapper( func )
	local nextRequests = {}
	return function( len, ply )
		if not IsValid(ply) then return end

		local sid = ply:SteamID64()
		if nextRequests[sid] and nextRequests[sid] > RealTime() then
			return
		end

		local mpId = net.ReadString()
		local mp = MediaPlayer.GetById(mpId)
		if not IsValid(mp) then return end

		func( mp, ply )

		nextRequests[sid] = RealTime() + REQUEST_DELAY
	end
end

net.Receive( "MEDIAPLAYER.RequestListen", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestListen:", mp:GetId(), ply)
	end

	-- Validate listener eligibility
	if ply:IsBot() then return end
	if not ply:IsConnected() then return end

	-- Allow hooks to block listener requests
	if hook.Run( "CanPlayerListenToMediaPlayer", mp, ply ) == false then
		return
	end

	if mp:HasListener(ply) then
		mp:RemoveListener(ply)
	else
		mp:AddListener(ply)
	end

end) )
---
-- Event called when a player requests a media update. This will occur when
-- a client determines it's not synced correctly.
--
-- @param len Net message length.
-- @param ply Player who sent the net message.
--
net.Receive( "MEDIAPLAYER.RequestUpdate", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestUpdate:", mp:GetId(), ply)
	end

	mp:SendMedia( mp:GetMedia(), ply )

end) )

net.Receive( "MEDIAPLAYER.RequestMedia", RequestWrapper(function(mp, ply)

	local url = net.ReadString()

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestMedia:", url, mp:GetId(), ply)
	end

	-- Validate URL length and format
	if not url or url == "" or #url > 2048 then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.invalid_url") )
		return
	end

	-- Sanitize URL to prevent injection attempts
	local sanitizedUrl = string.Trim(url)
	if sanitizedUrl ~= url then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.invalid_url") )
		return
	end

	local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()

	-- Validate the URL
	if not MediaPlayer.ValidUrl( sanitizedUrl ) and not allowWebpage then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.invalid_url") )
		return
	end

	-- Build the media object for the URL
	local media = MediaPlayer.GetMediaForUrl( sanitizedUrl, allowWebpage )
	if not media then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.media_url_failed") )
		return
	end

	-- Validate media object before processing
	if not media.Url or not media:Url() then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.media_url_failed") )
		return
	end

	media:NetReadRequest()
	mp:RequestMedia( media, ply )

end) )

net.Receive( "MEDIAPLAYER.RequestPause", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestPause:", mp:GetId(), ply)
	end

	mp:RequestPause( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestSkip", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestSkip:", mp:GetId(), ply)
	end

	mp:RequestSkip( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestSeek", RequestWrapper(function(mp, ply)

	local seekTime = net.ReadInt(32)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestSeek:", mp:GetId(), seekTime, ply)
	end

	-- Validate seek time range to prevent extreme values
	-- Clamp to reasonable range: -1 hour to +24 hours in seconds
	if seekTime < -3600 or seekTime > 86400 then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.invalid_seek") )
		return
	end

	-- Validate media is playing before allowing seek
	local media = mp:GetMedia()
	if not IsValid(media) then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.no_media") )
		return
	end

	-- Validate seek time is within media duration
	local duration = media:Duration()
	if duration > 0 and seekTime > duration then
		mp:NotifyPlayer( ply, MediaPlayer.L("mp.error.invalid_seek") )
		return
	end

	mp:RequestSeek( ply, seekTime )

end) )

net.Receive( "MEDIAPLAYER.RequestRemove", RequestWrapper(function(mp, ply)

	local mediaUID = net.ReadString()

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestRemove:", mp:GetId(), mediaUID, ply)
	end

	mp:RequestRemove( ply, mediaUID )

end) )

net.Receive( "MEDIAPLAYER.RequestRepeat", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestRepeat:", mp:GetId(), ply)
	end

	mp:RequestRepeat( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestShuffle", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestShuffle:", mp:GetId(), ply)
	end

	mp:RequestShuffle( ply )

end) )

net.Receive( "MEDIAPLAYER.RequestLock", RequestWrapper(function(mp, ply)

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.RequestLock:", mp:GetId(), ply)
	end

	mp:RequestLock( ply )

end) )

---
-- Server console command to truncate the metadata cache table.
-- Usage: mediaplayer_clearcache
--
---
-- Server/superadmin command to truncate the metadata cache table.
-- Allowed callers:
--   - Server console (no player entity)
--   - Singleplayer host (game.SinglePlayer())
--   - Superadmins (CAMI privilege "MediaPlayer_ClearCache", fallback: ply:IsSuperAdmin())
--
concommand.Add("mediaplayer_clearcache", function(ply, cmd, args)
	local isServerConsole = not IsValid(ply)
	local isSingleplayer  = game.SinglePlayer()

	local isAuthorized = isServerConsole or isSingleplayer

	if not isAuthorized then
		-- CAMI check with superadmin fallback
		if CAMI and CAMI.PlayerHasAccess then
			local hasAccess = false
			local success, result = pcall(function()
				return CAMI.PlayerHasAccess(ply, "MediaPlayer_ClearCache", function(b)
					hasAccess = b
				end)
			end)
			if success and result ~= nil then
				isAuthorized = result
			else
				isAuthorized = hasAccess
			end
		else
			isAuthorized = ply:IsSuperAdmin()
		end
	end

	if not isAuthorized then
		local msg = "[MediaPlayer] You do not have permission to run mediaplayer_clearcache.\n"
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTCONSOLE, msg)
		else
			Msg(msg)
		end
		return
	end

	local success = MediaPlayer.Metadata:Truncate()

	local msg = success
		and "[MediaPlayer] Metadata cache cleared successfully.\n"
		or  "[MediaPlayer] Failed to clear metadata cache. Check the console for SQL errors.\n"

	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, msg)
	else
		Msg(msg)
	end
end, nil, "Truncates the mediaplayer_metadata SQL table, clearing all cached media metadata. Superadmin only.")