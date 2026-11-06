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

SERVICE.Name 	= "YouTube"
SERVICE.Id 		= "yt"
SERVICE.Base 	= "browser"

-- Metadata is resolved entirely by the client-side iframe extractor
-- (public/youtube_meta.html), driven by the browser-side prefetch in
-- cl_init.lua (PreRequest / NetWriteRequest / NetReadRequest).
SERVICE.PrefetchMetadata = true

-- Debug flag: set to true to bypass the iframe prefetch and use server-side
-- HTML scraping directly.
SERVICE.ForceHTMLScraping = false

local YtVideoIdPattern = "[%a%d-_]+"
local UrlSchemes = {
	"youtube%.com/watch%?v=" .. YtVideoIdPattern,
	"youtube%.com/shorts/" .. YtVideoIdPattern,
	"youtu%.be/" .. YtVideoIdPattern,
}

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetYouTubeVideoId()
	return obj
end

function SERVICE:Match( url )
	for _, pattern in pairs(UrlSchemes) do
		if string.find( url, pattern ) then
			return true
		end
	end

	return false
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		-- YouTube Live resolves to 0 second video duration
		self._istimed = self:Duration() > 0
	end

	return self._istimed
end

function SERVICE:GetYouTubeVideoId()

	local videoId

	if self.videoId then

		videoId = self.videoId

	elseif self.urlinfo then

		local url = self.urlinfo

		-- https://www.youtube.com/watch?v=(videoId)
		if url.query and url.query.v and #url.query.v > 0 then
			videoId = url.query.v

		-- http://www.youtube.com/shorts/(videoId)
		elseif url.path and string.match(url.path, "^/shorts/([%a%d-_]+)") then
			videoId = string.match(url.path, "^/shorts/([%a%d-_]+)")

		-- https://youtu.be/(videoId)
		elseif string.match(url.host, "youtu.be") and
			url.path and string.match(url.path, "^/([%a%d-_]+)$") then

			videoId = string.match(url.path, "^/([%a%d-_]+)$")
		end

		self.videoId = videoId

	end

	return videoId

end