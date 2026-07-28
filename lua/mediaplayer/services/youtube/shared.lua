DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "YouTube"
SERVICE.Id 		= "yt"
SERVICE.Base 	= "browser"

-- The iframe prefetch runs client-side and its result is used as the final
-- fallback in the GetMetadata chain (API -> HTML scrape -> prefetch).
SERVICE.PrefetchMetadata = true

-- Set to true to bypass the JSON API and use server-side HTML scraping.
SERVICE.ForceHTMLScraping = false

-- Custom endpoint created by PurrCoding. Please do not overly abuse it,
-- and do not use it in third-party addons. No warranty for reliability is
-- guaranteed, even though this is backed by edge scripts.
SERVICE.MetadataAPI = "https://gm-api.physcannon.top/index.ts?id=%s"

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