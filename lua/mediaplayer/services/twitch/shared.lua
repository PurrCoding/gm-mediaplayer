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

SERVICE.Name 	= "Twitch.TV - Stream"
SERVICE.Id 		= "twl"
SERVICE.Base 	= "browser"

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)

	local channel = obj:GetTwitchChannel()
	obj._data = channel

	return obj
end

function SERVICE:Match( url )
	return string.match(url, "twitch.tv") and
			string.match(url, ".tv/[%w_]+$")
end

function SERVICE:IsTimed()
	return false
end

function SERVICE:GetTwitchChannel()

	local channel

	if self._twitchChannel then

		channel = self._twitchChannel

	elseif self.urlinfo then

		local url = self.urlinfo

		channel = string.match(url.path, "^/([%w_]+)")
		self._twitchChannel = channel

	end

	return channel

end
