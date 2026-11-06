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

SERVICE.Name 	= "Google Drive"
SERVICE.Id 		= "gd"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetGoogleDriveId()
	return obj
end

function SERVICE:Match( url )
	return url:match("drive.google.com")
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end

	return self._istimed
end

function SERVICE:GetGoogleDriveId()

	local videoId

	if self.videoId then

		videoId = self.videoId

	elseif self.urlinfo then

		local url = self.urlinfo

		-- https://drive.google.com/file/d/(fileId)
		if url.path and url.path:match("^/file/d/([%a%d-_]+)/") then
			videoId = url.path:match("^/file/d/([%a%d-_]+)/")
		end

		self.videoId = videoId

	end

	return videoId

end
