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
-- Fetch metadata by scraping the YouTube watch page server-side.
-- Used as a fallback when the iframe prefetch fails or returns empty/unknown data,
-- or when ForceHTMLScraping is enabled.
--
function SERVICE:FetchHTMLMetadata( callback )
	local videoId  = self:GetYouTubeVideoId()
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

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	-- Use HTML scraping when forced (debug) or when the iframe prefetch
	-- didn't produce a usable title (automatic fallback).
	if self.ForceHTMLScraping or not self._metaTitle then
		self:FetchHTMLMetadata(callback)
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

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end

	self._metaTitle    = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
	self._metaisLive   = net.ReadBool()

	-- Treat the "Unknown" sentinel (written by cl_init when title was nil/empty)
	-- as nil so that FetchHTMLMetadata is triggered as a fallback.
	if self._metaTitle == "" or self._metaTitle == "Unknown" then
		self._metaTitle = nil
	end
end