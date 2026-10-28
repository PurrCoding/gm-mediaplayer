--[[----------------------------------------------------------------------------
	YouTube playlist support (server)

	When a YouTube URL containing "list=" is requested through the normal media
	player request flow, the whole playlist is fetched server-side and each
	video is queued. Works for every request path (menu, chat, E2/Starfall)
	because it hooks the shared RequestMedia handler.

	Mix / radio playlists ("list=RD...") have no real playlist page, so they
	fall back to the single video (if the URL also has v=).
------------------------------------------------------------------------------]]

local MAX_PLAYLIST_ITEMS = 50    -- max videos queued per request (queue limit still applies)
local ENQUEUE_INTERVAL   = 0.3   -- seconds between queuing each video
local PLAYLIST_COOLDOWN  = 10    -- seconds between playlist requests per player

local nextPlaylist = {}   -- [sid] = next allowed RealTime
local busy = {}           -- [sid] = currently enqueuing

local function Notify( mp, ply, msg )
	if IsValid(mp) then mp:NotifyPlayer( ply, "[Playlist] " .. msg )
	elseif IsValid(ply) then ply:ChatPrint( "[Playlist] " .. msg ) end
end

--
-- Is this a YouTube playlist URL?
--   returns listId          -> treat as a playlist
--   returns nil             -> not a playlist (let the normal single-video flow run)
--   returns nil, reason     -> unsupported (mix with no video); caller should stop
--
function MediaPlayer.GetPlaylistId( url )
	local lower = string.lower( url )
	if not ( string.find( lower, "youtube%.com" ) or string.find( lower, "youtu%.be" ) ) then
		return nil
	end

	local listId = string.match( url, "[?&]list=([%w_%-]+)" )
	if not listId then return nil end

	-- Mix / autoplay radio playlists have no page to read.
	if string.sub( listId, 1, 2 ) == "RD" then
		if string.find( url, "[?&]v=" ) or string.find( lower, "youtu%.be/" ) then
			return nil   -- has a real video; play just that one
		end
		return nil, "Mix (auto-generated) playlists aren't supported."
	end

	return listId
end

-- Read a JSON string starting just after the opening quote, with unescaping.
local function ReadJSONString( s, start )
	local i, n = start, #s
	while i <= n do
		local c = string.sub( s, i, i )
		if c == "\\" then
			i = i + 2
		elseif c == "\"" then
			local raw = string.sub( s, start, i - 1 )
			local ok, tbl = pcall( util.JSONToTable, "[\"" .. raw .. "\"]" )
			if ok and istable(tbl) and isstring(tbl[1]) then return tbl[1] end
			return raw
		else
			i = i + 1
		end
	end
end

local function FindTitle( chunk )
	for _, marker in ipairs({ '"title":{"runs":[{"text":"', '"title":{"simpleText":"' }) do
		local _, e = string.find( chunk, marker, 1, true )
		if e then return ReadJSONString( chunk, e + 1 ) end
	end
end

--
-- Parse the playlist HTML into { {id, title, duration}, ... } plus the list title.
--
local function ParsePlaylist( html )
	local items, seen = {}, {}
	local marker = '"playlistVideoRenderer":{"videoId":"'

	local starts, pos = {}, 1
	while true do
		local _, e = string.find( html, marker, pos, true )
		if not e then break end
		starts[#starts + 1] = e + 1
		pos = e + 1
	end

	for i, st in ipairs(starts) do
		local id = string.match( html, "^([%w_%-]+)\"", st )
		local stop = starts[i + 1] and (starts[i + 1] - 1) or math.min( #html, st + 8000 )
		local chunk = string.sub( html, st, stop )

		if id and #id == 11 and not seen[id] and not string.find( chunk, '"isPlayable":false', 1, true ) then
			seen[id] = true
			items[#items + 1] = {
				id = id,
				title = FindTitle( chunk ),
				duration = tonumber( string.match( chunk, '"lengthSeconds":"(%d+)"' ) ),
			}
		end
	end

	-- Fallback if YouTube changes the page layout: grab every videoId in order.
	-- (title/duration unknown here; the service fetches them per-video instead)
	if #items == 0 then
		for id in string.gmatch( html, '"videoId":"([%w_%-]+)"' ) do
			if #id == 11 and not seen[id] then
				seen[id] = true
				items[#items + 1] = { id = id }
			end
		end
	end

	local plTitle = string.match( html, '<meta property="og:title" content="(.-)">' )

	return items, plTitle
end

local function EnqueueItems( mp, ply, items, plTitle )
	local sid = ply:SteamID64() or "0"
	local space = mp:GetQueueLimit() - #mp._Queue
	local total = math.min( #items, MAX_PLAYLIST_ITEMS, math.max(space, 0) )

	if total <= 0 then
		busy[sid] = nil
		Notify( mp, ply, "Queue is full." )
		return
	end

	Notify( mp, ply, string.format( "Queuing %d video(s)%s%s...",
		total,
		plTitle and (" from '" .. plTitle .. "'") or "",
		(#items > total) and string.format( " (%d found, limited)", #items ) or "" ) )

	local i = 0
	local timerName = "MediaPlayer.Playlist." .. sid
	timer.Create( timerName, ENQUEUE_INTERVAL, total, function()
		i = i + 1
		if i >= total then busy[sid] = nil end

		if not IsValid(mp) or not IsValid(ply) then
			busy[sid] = nil
			timer.Remove( timerName )
			return
		end

		if #mp._Queue >= mp:GetQueueLimit() then
			busy[sid] = nil
			timer.Remove( timerName )
			Notify( mp, ply, "Queue filled up, stopping." )
			return
		end

		local item = items[i]
		local media = MediaPlayer.GetMediaForUrl( "https://www.youtube.com/watch?v=" .. item.id, false )
		if not media then return end

		-- Feed the title/length read from the playlist page so the service
		-- doesn't have to fetch each video again (falls back if missing).
		if item.title and item.title ~= "" and item.duration then
			media._metaTitle    = item.title
			media._metaDuration = item.duration
			media._metaisLive   = false
		end

		mp:RequestMedia( media, ply )
	end )
end

--
-- Entry point called from sv_requests. Returns true if the URL was a playlist
-- and has been handled (caller must NOT also queue it as a single video).
--
function MediaPlayer.TryQueuePlaylist( mp, ply, url )
	if not IsValid(mp) or not IsValid(ply) then return false end

	local listId, reason = MediaPlayer.GetPlaylistId( url )
	if reason then
		Notify( mp, ply, reason )
		return true   -- unsupported mix: handled (stop), don't queue anything
	end
	if not listId then return false end   -- not a playlist, let normal flow run

	if not string.match( listId, "^[%w_%-]+$" ) or #listId > 64 then
		return false
	end

	local sid = ply:SteamID64() or "0"
	if busy[sid] then
		Notify( mp, ply, "Still queuing your previous playlist." )
		return true
	end
	if (nextPlaylist[sid] or 0) > RealTime() then
		Notify( mp, ply, "Please wait a moment before requesting another playlist." )
		return true
	end
	nextPlaylist[sid] = RealTime() + PLAYLIST_COOLDOWN

	-- Pre-check queue lock / service whitelist once (so 50 videos don't each
	-- spam the same denial).
	local probe = MediaPlayer.GetMediaForUrl( "https://www.youtube.com/watch?v=dQw4w9WgXcQ", false )
	if probe then
		local allowed, msg = mp:CanPlayerRequestMedia( ply, probe )
		if not allowed then
			Notify( mp, ply, msg or "You can't request media here." )
			return true
		end
	end

	busy[sid] = true
	Notify( mp, ply, "Loading playlist..." )

	http.Fetch( "https://www.youtube.com/playlist?list=" .. listId,
		function( body, _, _, code )
			if not IsValid(ply) then busy[sid] = nil return end
			if code ~= 200 or not isstring(body) then
				busy[sid] = nil
				Notify( mp, ply, "Couldn't load the playlist. (HTTP " .. tostring(code) .. ")" )
				return
			end

			local ok, items, plTitle = pcall( ParsePlaylist, body )
			if not ok or not istable(items) or #items == 0 then
				busy[sid] = nil
				Notify( mp, ply, "No videos found (playlist may be private or a mix)." )
				return
			end

			if not IsValid(mp) then busy[sid] = nil return end
			EnqueueItems( mp, ply, items, plTitle )
		end,
		function( err )
			busy[sid] = nil
			Notify( mp, ply, "Couldn't load the playlist: " .. tostring(err) )
		end,
		{
			["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36",
			["Accept-Language"] = "en-US,en;q=0.9",
			["Cookie"] = "CONSENT=YES+1; SOCS=CAI",
		}
	)

	return true
end

hook.Add( "PlayerDisconnected", "MediaPlayer.Playlist", function( ply )
	local sid = ply:SteamID64() or "0"
	busy[sid] = nil
	timer.Remove( "MediaPlayer.Playlist." .. sid )
end )
