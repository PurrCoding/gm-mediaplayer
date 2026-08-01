AddCSLuaFile "shared.lua"
include "shared.lua"

---
-- Helper function for converting ISO 8601 time strings.
-- e.g. "PT1H23M45S" -> 5025
--
local function convertISO8601Time( duration )
	if not isstring(duration) then return 0 end

	local hours   = tonumber( string.match(duration, "(%d+)H") ) or 0
	local minutes = tonumber( string.match(duration, "(%d+)M") ) or 0
	local seconds = tonumber( string.match(duration, "(%d+)S") ) or 0

	duration = hours * 3600 + minutes * 60 + seconds
	return duration
end

---
-- Get the value for an attribute from a html element
--
local function ParseElementAttribute( element, attribute )
	if not element then return end
	local output = string.match( element, attribute .. "%s-=%s-%b\"\"" )
	if not output then return end
	output = string.gsub( output, attribute .. "%s-=%s-", "" )
	return string.sub( output, 2, -2 )
end

---
-- Get the contents of a html element by removing tags.
-- Used as fallback for when title cannot be found via meta tag.
--
local function ParseElementContent( element )
	if not element then return end
	local output = string.gsub( element, "^%s-<%w->%s-", "" )
	return string.gsub( output, "%s-</%w->%s-$", "" )
end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"]          = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"]       = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"]           = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"]   = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">"
}

---
-- Parse video metadata from a raw YouTube watch page HTML body.
--
function SERVICE:ParseYTMetaDataFromHTML( html )
	local metadata = {}

	-- Title: prefer og:title meta tag, fall back to <title> element
	metadata.title = ParseElementAttribute( string.match(html, patterns["title"]), "content" )
		or ParseElementContent( string.match(html, patterns["title_fallback"]) )

	-- Decode HTML entities (e.g. &amp; -> &)
	metadata.title = url.htmlentities_decode( metadata.title )

	-- Live broadcast detection
	local isLiveBroadcast = tobool( ParseElementAttribute( string.match(html, patterns["live"]), "content" ) )
	local broadcastEndDate = string.match( html, patterns["live_enddate"] )

	if isLiveBroadcast and not broadcastEndDate then
		-- Ongoing live stream: mark duration as 0
		metadata.duration = 0
	else
		-- Try the legacy <meta itemprop="duration"> tag (ISO 8601) first.
		-- YouTube removed this tag around 2021, so it will usually be absent.
		local durationISO8601 = ParseElementAttribute( string.match(html, patterns["duration"]), "content" )
		if isstring(durationISO8601) then
			metadata.duration = math.max( 1, convertISO8601Time(durationISO8601) )
		else
			-- Modern fallback: parse lengthSeconds from the ytInitialPlayerResponse
			-- JSON blob that YouTube embeds directly in the page HTML.
			local lengthSeconds = tonumber( string.match(html, '"lengthSeconds"%s*:%s*"(%d+)"') )
			if lengthSeconds then
				metadata.duration = math.max( 1, lengthSeconds )
			end
		end
	end

	return metadata
end

---
-- [PRIMARY] Fetch video metadata from the server-side JSON API.
--
-- On success, the API returns JSON of the form:
--   {"success":true,"id":"...","title":"...",
--    "duration":1014,"live":false, ...}
--
-- On failure, the API returns an error object of the form:
--   {"success":false,"error":"Video is unplayable","reason":"unplayable"}
--
-- On success, callback( metadata ) is called.
-- On failure, callback( false, reason ) is called.
--
function SERVICE:FetchAPIMetadata( callback )
	local videoId = self:GetYouTubeVideoId()

	if not videoId then
		callback( false, "YouTube API: could not resolve video id" )
		return
	end

	local url = string.format( self.MetadataAPI, videoId )

	self:Fetch( url,
		function( body, length, headers, code )
			local decoded = util.JSONToTable( body )

			if not istable(decoded) or decoded.success ~= true or not isstring(decoded.title) then
				local reason

				if istable(decoded) then
					-- Prefer the structured error/reason fields returned by the
					-- API when the video is unavailable (e.g. unplayable, private).
					if decoded.error or decoded.reason then
						print(decoded.error, decoded.reason)
						reason = tostring( decoded.error or "unknown error" )
						if decoded.reason then
							reason = reason .. " (reason: " .. tostring(decoded.reason) .. ")"
						end
					else
						-- Generic fallback: report which required fields were bad.
						reason = "success = " .. tostring(decoded.success) ..
							", title = " .. type(decoded.title)
					end
				else
					reason = "invalid JSON response (HTTP " .. tostring(code) .. ")"
				end

				callback( false, "YouTube API fetch failed: " .. reason )
				return
			end

			local metadata = {}
			metadata.title = decoded.title

			if decoded.live then
				-- Ongoing live stream: mark duration as 0
				metadata.duration = 0
			else
				metadata.duration = math.max( 1, math.Round( tonumber(decoded.duration) or 0 ) )
			end

			self:SetMetadata( metadata, true )
			MediaPlayer.Metadata:Save( self )

			callback( self._metadata )
		end,
		function( reason )
			callback( false, "YouTube API fetch failed: " .. tostring(reason) )
		end
	)
end

---
-- [FALLBACK 1] Fetch metadata by scraping the YouTube watch page server-side.
-- Used when the JSON API is unavailable or returns unusable data.
--
function SERVICE:FetchHTMLMetadata( callback )
	local videoId  = self:GetYouTubeVideoId()

	if not videoId then
		callback( false, "YouTube HTML fallback: could not resolve video id" )
		return
	end

	local videoUrl = "https://www.youtube.com/watch?v=" .. videoId

	self:Fetch( videoUrl,
		function( body, length, headers, code )
			local status, metadata = pcall( self.ParseYTMetaDataFromHTML, self, body )

			if not status or not metadata.title or not isnumber(metadata.duration) then
				local errInfo
				if istable(metadata) then
					errInfo = "title = " .. type(metadata.title) .. ", duration = " .. type(metadata.duration)
				else
					errInfo = tostring(metadata)
				end
				callback( false, "YouTube HTML fallback failed: " .. errInfo )
				return
			end

			self:SetMetadata( metadata, true )
			MediaPlayer.Metadata:Save( self )
			callback( self._metadata )
		end,
		function( reason )
			callback( false, "YouTube HTML fallback fetch failed: " .. tostring(reason) )
		end,
		{
			["User-Agent"] = "Googlebot"
		}
	)
end

---
-- [OPTIONAL] Use metadata gathered client-side by the iframe prefetch
-- (received via NetReadRequest). Only used when EnableIframeScraping is true.
--
function SERVICE:UsePrefetchedMetadata( callback )
	if not self._metaTitle then
		callback( false, "YouTube prefetch: no prefetched title available" )
		return
	end

	local metadata = {}
	metadata.title = self._metaTitle

	if self._metaisLive then
		metadata.duration = 0
	else
		-- Guard against math.Round(nil) which would throw and leave _metadata unset
		metadata.duration = self._metaDuration and math.Round(self._metaDuration) or 0
	end

	self:SetMetadata( metadata, true )
	MediaPlayer.Metadata:Save( self )

	callback( self._metadata )
end

---
-- Metadata resolution.
--
-- Default (EnableIframeScraping = false):
--   cache -> JSON API (primary) -> HTML scrape (only active fallback)
--
-- Iframe scraping enabled (EnableIframeScraping = true):
--   JSON API is disabled entirely.
--   cache -> iframe prefetch -> HTML scrape (fallback)
--
-- Debug (ForceHTMLScraping = true):
--   cache -> HTML scrape
--
-- Each step advances to the next only when it fails via callback(false, reason).
--
function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	-- Debug override: bypass everything and go straight to HTML scraping.
	if self.ForceHTMLScraping then
		self:FetchHTMLMetadata(function( metadata, htmlReason )
			if metadata then
				callback( metadata )
				return
			end

			MsgN( "[MediaPlayer] " .. tostring(htmlReason) .. " — no further fallback available." )
			callback( metadata, htmlReason )
		end)
		return
	end

	-- Iframe scraping mode: JSON API disabled. Use client-side prefetch, with
	-- HTML scraping as the fallback.
	if self.EnableIframeScraping then
		self:UsePrefetchedMetadata(function( metadata, prefetchReason )
			if metadata then
				callback( metadata )
				return
			end

			MsgN( "[MediaPlayer] " .. tostring(prefetchReason) .. " — falling back to HTML scraping." )
			self:FetchHTMLMetadata( callback )
		end)
		return
	end

	-- Step 1: primary JSON API
	self:FetchAPIMetadata(function( metadata, apiReason )
		if metadata then
			callback( metadata )
			return
		end

		MsgN( "[MediaPlayer] " .. tostring(apiReason) .. " — falling back to HTML scraping." )

		-- Step 2: server-side HTML scrape (only active fallback)
		self:FetchHTMLMetadata(function( metadata2, htmlReason )
			if metadata2 then
				callback( metadata2 )
				return
			end

			-- Both sources failed. Surface the JSON API reason to the client
			-- (e.g. "Video is unplayable (reason: unplayable)"), since it is
			-- the primary source and carries the meaningful error. Log the
			-- HTML failure server-side for diagnostics.
			MsgN( "[MediaPlayer] HTML scrape also failed: " .. tostring(htmlReason) )
			callback( false, apiReason or htmlReason )
		end)
	end)
end

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end

	self._metaTitle    = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
	self._metaisLive   = net.ReadBool()

	-- Treat the "Unknown" sentinel (written by cl_init when title was nil/empty)
	-- as nil so that the fallback chain can detect missing prefetch data.
	if self._metaTitle == "" or self._metaTitle == "Unknown" then
		self._metaTitle = nil
	end
end