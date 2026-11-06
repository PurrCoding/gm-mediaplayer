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

local urllib = url

SERVICE.Name 	= "SoundCloud"
SERVICE.Id 		= "sc"
SERVICE.Base 	= "browser"
SERVICE.PrefetchMetadata = true

local Ignored = {
	["sets"] = true,
	["albums"] = true,
	["likes"] = true,
	["comments"] = true,
	["followers"] = true,
	["following"] = true,
	["tracks"] = true,
}

local function extractTrackId(urlinfo)
	if urlinfo.path then
		local path1, path2 = urlinfo.path:match("^/([%a%d-_]+)/([%a%d-_]+)/?$")
		if path1 and not Ignored[path1] and path2 and not Ignored[path2] then
			return ("%s/%s"):format(path1, path2)
		end
	end

	return false
end

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetSoundCloudTrackId()
	return obj
end

function SERVICE:Match( url )
	if url:match("soundcloud.com") then
		local success, urlinfo = pcall(urllib.parse2, url)
		if not success then return false end

		return extractTrackId(urlinfo)
	end

	return false
end

function SERVICE:GetSoundCloudTrackId()

	local trackId

	if self.trackId then

		trackId = self.trackId

	elseif self.urlinfo then

		local id = extractTrackId(self.urlinfo)
		if id then
			trackId = id
			self.trackId = trackId
		end
	end

	return trackId

end
