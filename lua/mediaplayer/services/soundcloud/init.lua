AddCSLuaFile "shared.lua"
include "shared.lua"

local ENCRYPTED_STREAM_ERR = "SoundCloud track only offers encrypted/DRM streams (not playable in GMod)"

local function IsEncryptedStreamError(err)
	return isstring(err) and err:find("encrypted/DRM", 1, true) ~= nil
end

-- True if media has at least one non-encrypted transcoding usable in GMod CEF.
-- Major-label / AD_SUPPORTED tracks often only expose cbc-/ctr-encrypted-hls.
local function HasPlayableTranscoding(media)
	if not istable(media) or not istable(media.transcodings) then
		-- Unknown media block: do not hard-fail (hydration often omits it).
		return true
	end
	if #media.transcodings == 0 then
		return false
	end
	for _, t in ipairs(media.transcodings) do
		local proto = ""
		if istable(t.format) and isstring(t.format.protocol) then
			proto = t.format.protocol:lower()
		elseif isstring(t.protocol) then
			proto = t.protocol:lower()
		end
		if proto ~= ""
			and not proto:find("encrypted", 1, true)
			and proto:sub(1, 4) ~= "cbc-"
			and proto:sub(1, 4) ~= "ctr-" then
			return true
		end
	end
	return false
end

local function BuildTitle(track)
	local title = track.title or "Unknown"
	local user = track.user and (track.user.username or track.user.permalink)
	if user and user ~= "" and not title:find(user, 1, true) then
		return ("%s - %s"):format(user, title)
	end
	return title
end

local function MetadataFromResolve(data)
	if not istable(data) then return nil, "invalid resolve payload" end

	local track = data
	if data.collection and istable(data.collection[1]) then
		track = data.collection[1]
	end
	if data.kind and data.kind ~= "track" and data.tracks then
		return nil, "playlists/sets are not supported"
	end

	local durationMs = tonumber(track.full_duration) or tonumber(track.duration) or 0
	local title = track.title
	if not title or title == "" then return nil, "missing title" end

	if track.embeddable_by and track.embeddable_by ~= "all" and track.embeddable_by ~= "me" then
		return nil, "Track is not embeddable"
	end
	if track.public == false then
		return nil, "Track is not public"
	end

	if not HasPlayableTranscoding(track.media) then
		return nil, ENCRYPTED_STREAM_ERR
	end

	return {
		title = BuildTitle(track),
		duration = math.floor(math.max(0, durationMs) / 1000)
	}
end

-- ---------------------------------------------------------------------------
-- Dynamic client_id (yt-dlp style)
-- ---------------------------------------------------------------------------
local CLIENT_ID_TTL = 6 * 60 * 60
local CLIENT_ID_FALLBACK = "nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic"

local SoundCloudClientId = {
	value = CLIENT_ID_FALLBACK,
	fetchedAt = 0,
	refreshing = false,
}

local function ClientIdIsFresh()
	return SoundCloudClientId.value
		and SoundCloudClientId.value ~= ""
		and (CurTime() - SoundCloudClientId.fetchedAt) < CLIENT_ID_TTL
end

local function ExtractClientIdFromJS(body)
	if not isstring(body) or body == "" then return nil end
	return body:match('client_id%s*:%s*"([0-9a-zA-Z]{32})"')
		or body:match("client_id%s*:%s*'([0-9a-zA-Z]{32})'")
		or body:match('"client_id"%s*:%s*"([0-9a-zA-Z]{32})"')
end

local function ExtractScriptSrcs(html)
	local srcs = {}
	if not isstring(html) then return srcs end
	for src in html:gmatch('<script[^>]+src=["\']([^"\']+)["\']') do
		if src:find("sndcdn%.com", 1, false) or src:find("soundcloud%.com", 1, false) then
			srcs[#srcs + 1] = src
		end
	end
	return srcs
end

function SERVICE:RefreshClientId(onDone)
	if SoundCloudClientId.refreshing then
		if onDone then onDone(SoundCloudClientId.value) end
		return
	end
	SoundCloudClientId.refreshing = true

	local function finish(id)
		SoundCloudClientId.refreshing = false
		if id and #id == 32 then
			SoundCloudClientId.value = id
			SoundCloudClientId.fetchedAt = CurTime()
		end
		if onDone then onDone(SoundCloudClientId.value) end
	end

	self:Fetch("https://soundcloud.com/", function(body)
		local srcs = ExtractScriptSrcs(body)
		local index = #srcs
		local function tryNext()
			if index < 1 then
				finish(nil)
				return
			end
			local src = srcs[index]
			index = index - 1
			if not src:match("^https?://") then
				src = "https://a-v2.sndcdn.com" .. (src:match("^/") and src or ("/" .. src))
			end
			self:Fetch(src, function(js)
				local id = ExtractClientIdFromJS(js)
				if id then
					finish(id)
				else
					tryNext()
				end
			end, function()
				tryNext()
			end)
		end
		tryNext()
	end, function()
		finish(nil)
	end)
end

function SERVICE:GetClientId(onDone)
	if ClientIdIsFresh() then
		if onDone then onDone(SoundCloudClientId.value) end
		return
	end
	self:RefreshClientId(onDone)
end

function SERVICE:ResolveTrack(trackPath, onSuccess, onFailure)
	local trackUrl = "https://soundcloud.com/" .. trackPath

	local function attempt(clientId, isRetry)
		local resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
			.. string.gsub(trackUrl, "([^A-Za-z0-9_~%.%-])", function(c)
				return string.format("%%%02X", string.byte(c))
			end)
			.. "&format=json&client_id=" .. clientId

		self:Fetch(resolveUrl, function(body, _, _, code)
			local data = util.JSONToTable(body)
			local meta, err = MetadataFromResolve(data)
			if meta and meta.title then
				onSuccess(meta)
				return
			end

			if not isRetry and (code == 401 or code == 403 or not data) then
				self:RefreshClientId(function(newId)
					if newId and newId ~= clientId then
						attempt(newId, true)
					elseif onFailure then
						onFailure(err or "Theater_RequestFailed")
					end
				end)
				return
			end

			if onFailure then onFailure(err or "Failed to resolve track") end
		end, function(err)
			if not isRetry then
				self:RefreshClientId(function(newId)
					if newId and newId ~= clientId then
						attempt(newId, true)
					elseif onFailure then
						onFailure(err or "Failed to resolve track")
					end
				end)
			elseif onFailure then
				onFailure(err or "Failed to resolve track")
			end
		end)
	end

	self:GetClientId(function(clientId)
		attempt(clientId or CLIENT_ID_FALLBACK, false)
	end)
end

function SERVICE:ParseSoundCloudHTML(body)
	local json = body:match('<script>window%.__sc_hydration%s*=%s*(.-);</script>')
		or body:match('window%.__sc_hydration%s*=%s*(.-);%s*</script>')
	if not json then
		return nil, "Hydration JSON not found"
	end

	local data = util.JSONToTable(json)
	if not data then
		return nil, "Failed to parse JSON"
	end

	for i = 1, #data do
		local entry = data[i]
		local metadata = entry and (entry.data or entry)
		local isSound = (entry and entry.hydratable == "sound")
			or (metadata and (metadata.kind == "track" or metadata.full_duration or metadata.duration))

		if isSound and metadata and metadata.title then
			if metadata.embeddable_by and metadata.embeddable_by ~= "all" and metadata.embeddable_by ~= "me" then
				return nil, "Track is not embeddable"
			end
			if metadata.public == false then
				return nil, "Track is not public"
			end
			if not HasPlayableTranscoding(metadata.media) then
				return nil, ENCRYPTED_STREAM_ERR
			end

			local duration = metadata.full_duration or metadata.duration or 0
			return {
				title = BuildTitle(metadata),
				duration = math.floor(duration / 1000)
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

function SERVICE:GetMetadata(callback)
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	-- Client reported DRM-only stream: do not try any further crawlers.
	if self._metaEncrypted then
		callback(nil, ("SoundCloud Error: %s"):format(self._metaError or ENCRYPTED_STREAM_ERR))
		return
	end

	local function deliver(metadata)
		self:SetMetadata(metadata, true)
		if self:IsTimed() then
			MediaPlayer.Metadata:Save(self)
		end
		callback(self._metadata)
	end

	local function runHydrationFallback(primaryError)
		if IsEncryptedStreamError(primaryError) then
			callback(nil, ("SoundCloud Error: %s"):format(primaryError))
			return
		end

		self:Fetch(self.url,
			function(body, length, headers, code)
				local ok, pack = pcall(function()
					local meta, e = self:ParseSoundCloudHTML(body)
					return { meta = meta, err = e }
				end)
				if ok and pack and istable(pack.meta) and pack.meta.title then
					deliver(pack.meta)
					return
				end
				local msg = primaryError
					or (ok and pack and pack.err)
					or (not ok and tostring(pack))
					or "Failed to parse metadata"
				callback(nil, ("SoundCloud Error: %s"):format(msg))
			end,
			function(reason)
				callback(nil, ("SoundCloud Error: %s"):format(primaryError or reason))
			end
		)
	end

	-- Prefer client prefetch when present (non-DRM).
	if self._metaTitle and self._metaTitle ~= "" and self._metaTitle ~= "Unknown" then
		deliver({
			title = self._metaTitle,
			duration = math.max(0, self._metaDuration or 0)
		})
		return
	end

	-- Server resolve (primary when client prefetch missing).
	local trackPath = self:GetSoundCloudTrackId()
	if trackPath then
		self:ResolveTrack(trackPath, function(metadata)
			deliver(metadata)
		end, function(err)
			if IsEncryptedStreamError(err) then
				callback(nil, ("SoundCloud Error: %s"):format(err))
				return
			end
			runHydrationFallback(err)
		end)
		return
	end

	runHydrationFallback(nil)
end

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end
	self._metaEncrypted = net.ReadBool()
	self._metaError = net.ReadString()
	if self._metaError == "" then self._metaError = nil end
	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt(16)
	if self._metaTitle == "" or self._metaTitle == "Unknown" then
		self._metaTitle = nil
	end
end
