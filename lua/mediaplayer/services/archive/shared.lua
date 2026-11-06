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

SERVICE.Name 	= "Internet Archive"
SERVICE.Id 		= "ia"
SERVICE.Base 	= "browser"

local urllib = url

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetArchiveVideoId()
	return obj
end

local function parseURL(url)
	local success, urlinfo = pcall(urllib.parse2, url)
	if not success then return false end

	return urlinfo
end

function SERVICE:Match( url )

	local info = parseURL(url)
	if info then
		if info.host and info.host:match("archive%.org") and
		   		info.path and info.path:match("^/details/(.+)$") then
			return true
		end
	end


	return false
end

function SERVICE:GetArchiveVideoId()

	local videoId

	if self.videoId then

		videoId = self.videoId

	elseif self.urlinfo then

		local url = self.urlinfo

		-- Extract identifier
		local identifier = url.path:match("^/details/([^/]+)")
		if identifier then

			-- Extract specific file if present
			local file = url.path:match("^/details/[^/]+/(.+)$")

			-- Handle URL encoding
			if file then
				local success, decoded = pcall(urllib.unescape, file)
				if success then
					file = decoded
				end
			end

			self.videoId = identifier .. (file and "," .. file or "")
		end

	end

	return videoId

end
