-- Client-side YouTube metadata and playlist resolver.
-- Network traffic is initiated by the requesting player's game client; the
-- server receives only bounded metadata/queue requests, never playlist pages.
MediaPlayer = MediaPlayer or {}
MediaPlayer.YouTubeMetadata = MediaPlayer.YouTubeMetadata or {}
local YT = MediaPlayer.YouTubeMetadata

local META_TTL = 30 * 24 * 60 * 60
local NEG_TTL = 12 * 60 * 60
local REQUEST_TIMEOUT = 8
local PLAYLIST_LIMIT = 50
local PLAYLIST_PAGE_LIMIT = 10
local PLAYLIST_DELAY = 0.35
local PARALLEL = 2

local API_PLAYER = "https://www.youtube.com/youtubei/v1/player?prettyPrint=false"
local API_BROWSE = "https://www.youtube.com/youtubei/v1/browse?prettyPrint=false"
local API_VISITOR = "https://www.youtube.com/youtubei/v1/visitor_id?prettyPrint=false"
local WEB_VERSION = "2.20261002.01.00"
local WEB_UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36"

local DEFAULT_POOL = {
    { name = "TVHTML5_SIMPLY", version = "1.0", id = "74", ua = "Mozilla/5.0 (ChromiumStylePlatform) Cobalt/Version", weight = 3.2 },
    { name = "TVHTML5", version = "7.20260114.12.00", id = "7", ua = "Mozilla/5.0 (ChromiumStylePlatform) Cobalt/Version", weight = 2.4 },
    { name = "ANDROID", version = "20.10.38", id = "3", ua = "com.google.android.youtube/20.10.38 (Linux; U; Android 14) gzip", weight = 2.2, extra = { androidSdkVersion = 34 } },
    { name = "IOS", version = "20.10.4", id = "5", ua = "com.google.ios.youtube/20.10.4 (iPhone16,2; U; CPU iOS 18_3_2 like Mac OS X;)", weight = 2.0, extra = { deviceModel = "iPhone16,2", osName = "iPhone", osVersion = "18.3.2" } },
    { name = "ANDROID_VR", version = "1.65.10", id = "28", ua = "com.google.android.apps.youtube.vr.oculus/1.65.10 (Linux; U; Android 12L; eureka-user Build/SQ3A.220605.009.A1) gzip", weight = 1.6, extra = { androidSdkVersion = 32, deviceMake = "Oculus", deviceModel = "Quest 3", osName = "Android", osVersion = "12L" } },
    { name = "MWEB", version = WEB_VERSION, id = "2", ua = WEB_UA, weight = 1.4 },
    { name = "WEB", version = WEB_VERSION, id = "1", ua = WEB_UA, weight = 1.3 },
    { name = "VISIONOS", version = "1.02", id = "101", ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 15_7_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15", weight = 1.2, extra = { deviceMake = "Apple", deviceModel = "RealityDevice17,1", osName = "visionOS", osVersion = "26.5.23O471" } }
}

local function Debug(stage, msg)
    if MediaPlayer.DEBUG then MsgN("[MediaPlayer][YouTubeClient][" .. stage .. "] " .. tostring(msg or "")) end
end

local function ValidVideoID(id)
    return isstring(id) and #id == 11 and id:match("^[%w_%-]+$") ~= nil and not id:match("^%d+$")
end

local function Decode(s)
    if not isstring(s) then return s end
    s = s:gsub("&amp;", "&"):gsub("&quot;", '"'):gsub("&#39;", "'"):gsub("&lt;", "<"):gsub("&gt;", ">")
    return s
end

local function Text(value)
    if isstring(value) then return value end
    if not istable(value) then return nil end
    if isstring(value.simpleText) then return value.simpleText end
    if isstring(value.text) then return value.text end
    if istable(value.runs) then
        local out = {}
        for _, run in ipairs(value.runs) do
            if istable(run) and isstring(run.text) then out[#out + 1] = run.text end
        end
        if #out > 0 then return table.concat(out) end
    end
end

local function ParseISO(value)
    if not isstring(value) then return nil end
    local h = tonumber(value:match("(%d+)H")) or 0
    local m = tonumber(value:match("(%d+)M")) or 0
    local s = tonumber(value:match("(%d+)S")) or 0
    if not value:match("^PT") then return nil end
    return h * 3600 + m * 60 + s
end

local function ParseClock(value)
    if not isstring(value) then return nil end
    local parts = {}
    for p in value:gmatch("[^:]+") do parts[#parts + 1] = tonumber(p) end
    if #parts < 2 or #parts > 3 then return nil end
    for _, p in ipairs(parts) do if not p then return nil end end
    if #parts == 2 then return parts[1] * 60 + parts[2] end
    return parts[1] * 3600 + parts[2] * 60 + parts[3]
end

-- SQLite is local to this game client. If the runtime does not expose sql in
-- the client realm, all operations safely degrade to the bounded memory cache.
local function SQLStr(value)
    if sql and sql.SQLStr then return sql.SQLStr(tostring(value or "")) end
    return "'" .. tostring(value or ""):gsub("'", "''") .. "'"
end

local function DBQuery(query)
    if not sql or not sql.Query then return nil end
    local ok, result = pcall(sql.Query, query)
    if not ok or result == false then return nil end
    return result
end

local function InitDB()
    if YT._dbReady then return end
    YT._dbReady = true
    DBQuery([[CREATE TABLE IF NOT EXISTS mp_yt_meta_cache (
        video_id TEXT PRIMARY KEY, title TEXT NOT NULL, duration INTEGER NOT NULL,
        live INTEGER NOT NULL DEFAULT 0, source TEXT NOT NULL DEFAULT '', updated_at INTEGER NOT NULL)]])
    DBQuery([[CREATE TABLE IF NOT EXISTS mp_yt_negative_cache (
        video_id TEXT PRIMARY KEY, reason TEXT NOT NULL, updated_at INTEGER NOT NULL)]])
    DBQuery([[CREATE TABLE IF NOT EXISTS mp_yt_client_versions (
        client_name TEXT PRIMARY KEY, version TEXT NOT NULL, user_agent TEXT NOT NULL, updated_at INTEGER NOT NULL)]])
    DBQuery([[CREATE TABLE IF NOT EXISTS mp_yt_client_stats (
        client_name TEXT PRIMARY KEY, wins INTEGER NOT NULL DEFAULT 0, fails INTEGER NOT NULL DEFAULT 0, updated_at INTEGER NOT NULL)]])
    DBQuery([[CREATE TABLE IF NOT EXISTS mp_yt_visitor_data (
        region TEXT PRIMARY KEY, visitor_data TEXT NOT NULL, updated_at INTEGER NOT NULL)]])
end

local metaMem, negMem, wins, fails, visitorMem = {}, {}, {}, {}, {}
InitDB()
local pool = {}
for _, c in ipairs(DEFAULT_POOL) do
    local copy = table.Copy(c)
    local row = DBQuery("SELECT version, user_agent FROM mp_yt_client_versions WHERE client_name=" .. SQLStr(c.name) .. " LIMIT 1")
    if istable(row) and row[1] then
        copy.version = row[1].version or copy.version
        copy.ua = row[1].user_agent or copy.ua
    end
    local stats = DBQuery("SELECT wins, fails FROM mp_yt_client_stats WHERE client_name=" .. SQLStr(c.name) .. " LIMIT 1")
    if istable(stats) and stats[1] then
        wins[c.name] = tonumber(stats[1].wins) or 0
        fails[c.name] = tonumber(stats[1].fails) or 0
    end
    pool[#pool + 1] = copy
end

local function CacheGet(id)
    local e = metaMem[id]
    if e and e.expires > os.time() then return e.meta end
    metaMem[id] = nil
    InitDB()
    local rows = DBQuery("SELECT title, duration, live, source, updated_at FROM mp_yt_meta_cache WHERE video_id=" .. SQLStr(id) .. " LIMIT 1")
    if not istable(rows) or not rows[1] then return nil end
    local r = rows[1]
    local updated = tonumber(r.updated_at) or 0
    if os.time() - updated > META_TTL then
        DBQuery("DELETE FROM mp_yt_meta_cache WHERE video_id=" .. SQLStr(id))
        return nil
    end
    local m = { title = r.title, duration = tonumber(r.duration), live = tonumber(r.live) == 1, source = r.source or "sqlite" }
    metaMem[id] = { meta = m, expires = updated + META_TTL }
    return m
end

local function CacheSet(id, meta)
    if not meta or not isstring(meta.title) or meta.title == "" or not isnumber(meta.duration) then return end
    metaMem[id] = { meta = meta, expires = os.time() + META_TTL }
    InitDB()
    local q = SQLStr
    if not sql or not sql.SQLStr then return end
    DBQuery("INSERT OR REPLACE INTO mp_yt_meta_cache (video_id,title,duration,live,source,updated_at) VALUES (" ..
        q(id) .. "," .. q(meta.title) .. "," .. math.max(0, math.floor(meta.duration)) .. "," ..
        (meta.live and 1 or 0) .. "," .. q(meta.source or "innertube") .. "," .. os.time() .. ")")
end

local function NegativeGet(id)
    local e = negMem[id]
    if e and e.expires > os.time() then return e.reason end
    negMem[id] = nil
    local rows = DBQuery("SELECT reason, updated_at FROM mp_yt_negative_cache WHERE video_id=" .. SQLStr(id) .. " LIMIT 1")
    if not istable(rows) or not rows[1] then return nil end
    local row = rows[1]
    local updated = tonumber(row.updated_at) or 0
    if os.time() - updated > NEG_TTL then
        DBQuery("DELETE FROM mp_yt_negative_cache WHERE video_id=" .. SQLStr(id))
        return nil
    end
    negMem[id] = { reason = row.reason, expires = updated + NEG_TTL }
    return row.reason
end

local function NegativeSet(id, reason)
    if reason ~= "private" and reason ~= "not_found" then return end
    negMem[id] = { reason = reason, expires = os.time() + NEG_TTL }
    if not sql or not sql.SQLStr then return end
    DBQuery("INSERT OR REPLACE INTO mp_yt_negative_cache (video_id,reason,updated_at) VALUES (" ..
        SQLStr(id) .. "," .. SQLStr(reason) .. "," .. os.time() .. ")")
end

local function Record(name, ok)
    wins[name] = (wins[name] or 0) + (ok and 1 or 0)
    fails[name] = (fails[name] or 0) + (ok and 0 or 1)
    InitDB()
    if not sql or not sql.SQLStr then return end
    if math.random() > 0.2 then return end
    local q = SQLStr
    DBQuery("INSERT OR REPLACE INTO mp_yt_client_stats (client_name,wins,fails,updated_at) VALUES (" ..
        q(name) .. "," .. (wins[name] or 0) .. "," .. (fails[name] or 0) .. "," .. os.time() .. ")")
end

local function PickClients(count)
    local remaining, selected = table.Copy(pool), {}
    for _ = 1, math.min(count, #remaining) do
        local total = 0
        for _, c in ipairs(remaining) do
            local w = c.weight + (wins[c.name] or 0) / (1 + (fails[c.name] or 0) * 0.5)
            total = total + math.max(0.1, w)
        end
        local r, idx = math.Rand(0, total), #remaining
        for i, c in ipairs(remaining) do
            r = r - math.max(0.1, c.weight + (wins[c.name] or 0) / (1 + (fails[c.name] or 0) * 0.5))
            if r <= 0 then idx = i break end
        end
        selected[#selected + 1] = table.remove(remaining, idx)
    end
    return selected
end

local function PlayerPayload(id, c)
    local client = { clientName = c.name, clientVersion = c.version, hl = "en", gl = "US" }
    if c.extra then table.Merge(client, c.extra) end
    return { context = { client = client }, videoId = id, contentCheckOk = true, racyCheckOk = true }
end

local function RequestJSON(url, body, headers, callback)
    local finished = false
    local function done(ok, data, err)
        if finished then return end
        finished = true
        callback(ok, data, err)
    end
    local request = {
        url = url, method = "POST", headers = headers or {},
        body = util.TableToJSON(body or {}),
        type = "application/json; charset=utf-8",
        success = function(code, response)
            if code ~= 200 or not isstring(response) then return done(false, nil, "HTTP " .. tostring(code)) end
            local ok, parsed = pcall(util.JSONToTable, response)
            if not ok or not istable(parsed) then return done(false, nil, "invalid JSON") end
            done(true, parsed)
        end,
        failed = function(reason) done(false, nil, tostring(reason or "request failed")) end
    }
    -- GMod's HTTP implementation accepts a raw POST body on supported builds.
    local queued = HTTP(request)
    if queued == false then done(false, nil, "HTTP request could not be queued") end
    timer.Simple(REQUEST_TIMEOUT, function() done(false, nil, "timeout") end)
end

local function GetVisitorData(callback)
    local cached = visitorMem.US
    if cached and cached.expires > os.time() then return callback(cached.value) end
    local rows = DBQuery("SELECT visitor_data, updated_at FROM mp_yt_visitor_data WHERE region='US' LIMIT 1")
    if istable(rows) and rows[1] and os.time() - (tonumber(rows[1].updated_at) or 0) < 86400 then
        local value = rows[1].visitor_data
        visitorMem.US = { value = value, expires = os.time() + 2700 }
        return callback(value)
    end
    RequestJSON(API_VISITOR, { context = { client = { clientName = "WEB", clientVersion = WEB_VERSION, hl = "en", gl = "US" } } }, {
        ["Content-Type"] = "application/json", ["Accept"] = "application/json",
        ["User-Agent"] = WEB_UA, ["X-YouTube-Client-Name"] = "1",
        ["X-YouTube-Client-Version"] = WEB_VERSION
    }, function(ok, data)
        local value = ok and ((data.responseContext and data.responseContext.visitorData) or data.visitorData) or nil
        if isstring(value) and value ~= "" then
            visitorMem.US = { value = value, expires = os.time() + 2700 }
            if sql and sql.SQLStr then
                DBQuery("INSERT OR REPLACE INTO mp_yt_visitor_data (region,visitor_data,updated_at) VALUES ('US'," ..
                    SQLStr(value) .. "," .. os.time() .. ")")
            end
            callback(value)
        else
            callback(nil)
        end
    end)
end

local function Classify(data)
    local status = data and data.playabilityStatus and data.playabilityStatus.status or ""
    local reason = string.lower(Text(data and data.playabilityStatus and data.playabilityStatus.reason) or "")
    local has = istable(data and data.videoDetails) or istable(data and data.microformat)
    if status == "OK" or status == "LIVE_STREAM_OFFLINE" or status == "CONTENT_CHECK_REQUIRED" then return true, "unknown" end
    if status == "AGE_CHECK_REQUIRED" or status == "AGE_VERIFICATION_REQUIRED" then return has, "age_restricted" end
    if reason:find("not available in your country", 1, true) or reason:find("not available in your region", 1, true) or reason:find("blocked in your country", 1, true) then return has, "region_blocked" end
    if status == "LOGIN_REQUIRED" then
        if reason:find("private", 1, true) then return false, "private" end
        if reason:find("age", 1, true) then return has, "age_restricted" end
        return has, "login_required"
    end
    if status == "ERROR" then
        if reason:find("unavailable", 1, true) or reason:find("does not exist", 1, true) or reason:find("removed", 1, true) then return false, "not_found" end
        return false, "unplayable"
    end
    return has, "unknown"
end

local function ParsePlayer(data, id, source)
    if not istable(data) then return nil end
    local d = data.videoDetails or {}
    local m = data.microformat and data.microformat.playerMicroformatRenderer or {}
    if not next(d) and not next(m) then return nil end
    local duration = tonumber(d.lengthSeconds) or tonumber(m.lengthSeconds) or ParseISO(Text(m.duration))
    local title = Text(d.title) or Text(m.title)
    local live = d.isLive == true or d.isLiveContent == true or (m.liveBroadcastDetails and m.liveBroadcastDetails.isLiveNow == true)
    if live and duration and duration > 0 then live = false end
    return { title = title and Decode(title) or nil, duration = live and 0 or duration, live = live, source = source or "innertube", videoId = id }
end

local function FetchOneClient(id, c, callback)
    GetVisitorData(function(visitor)
        local headers = {
            ["Content-Type"] = "application/json", ["Accept"] = "application/json",
            ["User-Agent"] = c.ua, ["Referer"] = "https://www.youtube.com/",
            ["X-YouTube-Client-Name"] = c.id, ["X-YouTube-Client-Version"] = c.version,
            ["Accept-Language"] = "en-US,en;q=0.9"
        }
        local payload = PlayerPayload(id, c)
        if visitor then payload.context.client.visitorData = visitor end
        RequestJSON(API_PLAYER, payload, headers, function(ok, data, err)
            if not ok then Record(c.name, false) return callback(false, nil, err) end
            local usable, reason = Classify(data)
            if not usable then
                Record(c.name, false)
                return callback(false, nil, reason)
            end
            local meta = ParsePlayer(data, id, c.name)
            if not meta then Record(c.name, false) return callback(false, nil, "no metadata") end
            Record(c.name, true)
            callback(true, meta)
        end)
    end)
end

function YT:GetMetadata(id, callback)
    if not ValidVideoID(id) then callback(false, nil, "invalid YouTube video id") return end
    local cached = CacheGet(id)
    if cached then Debug("cache-hit", id) callback(true, cached) return end
    local negative = NegativeGet(id)
    if negative then Debug("negative-cache-hit", id .. " | " .. negative) callback(false, nil, negative) return end
    Debug("resolve", id)
    local attempted, best, hardError = {}, nil, nil
    local function attemptBatch(batch, retry)
        if #batch == 0 then
            if best then CacheSet(id, best) return callback(true, best) end
            NegativeSet(id, hardError)
            return callback(false, nil, hardError or "all YouTube clients failed")
        end
        local left = #batch
        local function settled(ok, meta, err, c)
            if ok and meta then
                if meta.title or meta.duration ~= nil then
                    if not best then best = meta
                    else
                        best.title = best.title or meta.title
                        best.duration = best.duration or meta.duration
                        best.live = best.live or meta.live
                    end
                end
            elseif err == "private" or err == "not_found" or err == "login_required" then
                hardError = err
            end
            left = left - 1
            if left == 0 then
                if best and best.title and best.duration ~= nil then
                    CacheSet(id, best)
                    callback(true, best)
                elseif not retry then
                    timer.Simple(0.08, function()
                        local rest = {}
                        for _, client in ipairs(pool) do if not attempted[client.name] then rest[#rest + 1] = client end end
                        attemptBatch(rest, true)
                    end)
                elseif best then
                    CacheSet(id, best)
                    callback(true, best)
                else
                    NegativeSet(id, hardError)
                    callback(false, nil, hardError or "YouTube metadata unavailable")
                end
            end
        end
        for _, c in ipairs(batch) do
            attempted[c.name] = true
            FetchOneClient(id, c, function(ok, meta, err) settled(ok, meta, err, c) end)
        end
    end
    attemptBatch(PickClients(PARALLEL), false)
end

local function WalkPlaylist(node, items, seen, state)
    if not istable(node) then return end
    local renderer = node.playlistVideoRenderer
    if istable(renderer) then
        local id = renderer.videoId
        if ValidVideoID(id) and not seen[id] and #items < PLAYLIST_LIMIT then
            seen[id] = true
            items[#items + 1] = { id = id, title = Text(renderer.title), duration = tonumber(renderer.lengthSeconds) or ParseClock(Text(renderer.lengthText)) }
        end
        return
    end
    if istable(node.playlistMetadataRenderer) and not state.title then state.title = Text(node.playlistMetadataRenderer.title) end
    if istable(node.playlistHeaderRenderer) and not state.title then state.title = Text(node.playlistHeaderRenderer.title) end
    if istable(node.continuationCommand) and isstring(node.continuationCommand.token) then state.token = node.continuationCommand.token end
    if istable(node.continuationItemRenderer) then
        local ep = node.continuationItemRenderer.continuationEndpoint
        local cmd = istable(ep) and ep.continuationCommand or nil
        if istable(cmd) and isstring(cmd.token) then state.token = cmd.token end
    end
    for _, child in pairs(node) do WalkPlaylist(child, items, seen, state) end
end

local function FetchPlaylistPage(listId, token, callback)
    local body = { context = { client = { clientName = "WEB", clientVersion = WEB_VERSION, hl = "en", gl = "US" } } }
    if token then body.continuation = token else body.browseId = "VL" .. listId end
    RequestJSON(API_BROWSE, body, {
        ["Content-Type"] = "application/json", ["Accept"] = "application/json",
        ["User-Agent"] = WEB_UA, ["Origin"] = "https://www.youtube.com",
        ["Referer"] = "https://www.youtube.com/", ["X-YouTube-Client-Name"] = "1",
        ["X-YouTube-Client-Version"] = WEB_VERSION
    }, callback)
end

function YT:GetPlaylist(url, callback)
    local listId = isstring(url) and url:match("[?&]list=([%w_%-]+)")
    if not listId or #listId > 64 or listId:sub(1, 2) == "RD" then callback(false, nil, nil, "unsupported playlist") return end
    local items, seen, state, page = {}, {}, { title = nil, token = nil }, 0
    local function nextPage(token)
        if #items >= PLAYLIST_LIMIT or page >= PLAYLIST_PAGE_LIMIT or (page > 0 and not token) then
            return callback(true, items, state.title)
        end
        page = page + 1
        FetchPlaylistPage(listId, token, function(ok, data, err)
            if not ok then return callback(false, nil, nil, err) end
            local before = #items
            state.token = nil
            WalkPlaylist(data, items, seen, state)
            Debug("playlist-page", string.format("list=%s page=%d videos=%d", listId, page, #items - before))
            if state.token and #items < PLAYLIST_LIMIT then nextPage(state.token)
            else callback(true, items, state.title) end
        end)
    end
    nextPage(nil)
end

function YT:TryRequestPlaylist(mpId, url)
    if not isstring(url) or not (url:lower():find("youtube%.com") or url:lower():find("youtu%.be")) then return false end
    local listId = url:match("[?&]list=([%w_%-]+)")
    if not listId then return false end
    if listId:sub(1, 2) == "RD" then
        if url:match("[?&]v=") or url:lower():find("youtu%.be/") then return false end
        MediaPlayer.ChatError("Auto-generated YouTube Mix playlists are not supported.")
        return true
    end
    if self._playlistBusy then
        MediaPlayer.ChatError("A YouTube playlist is already being loaded.")
        return true
    end
    self._playlistBusy = true
    Debug("playlist-start", listId)
    self:GetPlaylist(url, function(ok, items, title, err)
        if not ok or not istable(items) or #items == 0 then
            YT._playlistBusy = false
            MediaPlayer.ChatError("Couldn't load YouTube playlist: " .. tostring(err or "no videos found"))
            return
        end
        Debug("playlist-loaded", string.format("%s (%d videos)", tostring(title or listId), #items))
        local index = 0
        local timerName = "MediaPlayer.YouTubePlaylist.Client"
        timer.Create(timerName, PLAYLIST_DELAY, math.min(#items, PLAYLIST_LIMIT), function()
            if not IsValid(MediaPlayer.GetById(mpId)) then
                timer.Remove(timerName)
                YT._playlistBusy = false
                return
            end
            index = index + 1
            local item = items[index]
            if not item then YT._playlistBusy = false timer.Remove(timerName) return end
            if item.title and item.duration ~= nil then
                CacheSet(item.id, { title = Decode(item.title), duration = item.duration, live = false, source = "playlist" })
            end
            MediaPlayer.Request(mpId, "https://www.youtube.com/watch?v=" .. item.id)
            if index >= math.min(#items, PLAYLIST_LIMIT) then
                YT._playlistBusy = false
                timer.Remove(timerName)
            end
        end)
    end)
    return true
end
