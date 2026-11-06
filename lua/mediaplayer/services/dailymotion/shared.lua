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

SERVICE.Name 	= "Dailymotion"
SERVICE.Id 		= "dm"
SERVICE.Base 	= "browser"

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetDailymotionVideoId()
	return obj
end

function SERVICE:Match( url )
	return string.find( url, "dailymotion.com/video/([%a%d-_]+)")
end

function SERVICE:GetDailymotionVideoId()

	local videoId

	if self.videoId then

		videoId = self.videoId

	elseif self.urlinfo then

		local url = self.urlinfo

		-- https://www.dailymotion.com/(videoId)
		videoId = string.match(url.path, "^/video/([%a%d-_]+)")

		self.videoId = videoId

	end

	return videoId

end
