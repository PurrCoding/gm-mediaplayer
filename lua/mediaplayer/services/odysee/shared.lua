--[[
  Media Player Redux
  Copyright (c) 2014–2026 GMod Media Player authors

  Originally created by Samuel Maddock
  (https://github.com/samuelmaddock/gm-mediaplayer)

  This file is part of the Media Player Redux project
  (https://github.com/PurrCoding/gm-mediaplayer)

  Licensed under the MIT License.
  See LICENSE.md in the project root for the full license text.
  The copyright notice and this permission notice must be retained
  in all copies or substantial portions of the Software.
]]

DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Odysee"
SERVICE.Id 		= "odysee"
SERVICE.Base 	= "browser"

--[[
	Valid video URL shapes:
	  https://odysee.com/@channel:1/video-title:a
	  https://odysee.com/video-title:a

	Rejected: root, channel-only (/@channel:1), $/embed/..., search, etc.
]]

local function ExtractOdyseePath( url )
	if not url or url == "" then return nil end

	-- Prefer path from the raw URL string so Match works before urlinfo exists
	local path = string.match( url, "odysee%.com(/[^%s?#]*)" )
	if not path or path == "" or path == "/" then
		return nil
	end

	-- Drop trailing slash for consistent matching
	if string.sub( path, -1 ) == "/" and #path > 1 then
		path = string.sub( path, 1, -2 )
	end

	return path
end

-- Returns "@channel:x/claim:y" or "claim:y", or nil if not a video path.
local function ParseOdyseeEmbedPath( path )
	if not path then return nil end

	-- Ignore site utility paths: $/embed, $/oembed, $/search, ...
	if string.StartWith( path, "/$" ) then
		return nil
	end

	-- https://odysee.com/@channel:1/video-title:a
	local channel, claim = string.match( path, "^/(@[^/]+)/([^/]+)$" )
	if channel and claim and claim ~= "" then
		return channel .. "/" .. claim
	end

	-- https://odysee.com/video-title:a  (claim-only, no channel)
	-- Must look like a claim (contains ':') or at least a non-empty slug,
	-- and must not be a bare @channel page.
	local claimOnly = string.match( path, "^/([^/]+)$" )
	if claimOnly and claimOnly ~= "" then
		if string.StartWith( claimOnly, "@" ) then
			return nil -- channel page, not a video
		end
		if string.StartWith( claimOnly, "$" ) then
			return nil
		end
		return claimOnly
	end

	return nil
end

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetOdyseeEmbedPath()
	return obj
end

function SERVICE:Match( url )
	local path = ExtractOdyseePath( url )
	return ParseOdyseeEmbedPath( path ) ~= nil
end

-- Returns the path segment used in embed URLs, or "".
function SERVICE:GetOdyseeEmbedPath()
	if self._odyseeEmbedPath ~= nil then
		return self._odyseeEmbedPath
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path or path == "" then
		path = ExtractOdyseePath( self.url )
	end

	local embed = ParseOdyseeEmbedPath( path )
	self._odyseeEmbedPath = embed or ""
	return self._odyseeEmbedPath
end

-- Backwards-compatible alias used by older call sites
function SERVICE:GetOdyseeVideoId()
	return self:GetOdyseeEmbedPath()
end

function SERVICE:GetOdyseeChannel()
	local path = self.urlinfo and self.urlinfo.path
	if not path or path == "" then
		path = ExtractOdyseePath( self.url )
	end
	if not path then return nil end
	return string.match( path, "^/(@[^/]+)/" )
end

function SERVICE:IsTimed()
	return self._metadata and self._metadata.duration and self._metadata.duration > 0
end
