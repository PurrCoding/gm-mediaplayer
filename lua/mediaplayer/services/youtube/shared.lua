DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "YouTube"
SERVICE.Id 		= "yt"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true
SERVICE.ForceHTMLScraping = false  -- Set to true to bypass iframe and use server-side HTML scraping

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
