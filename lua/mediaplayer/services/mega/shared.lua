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

SERVICE.Name 	= "MEGA"
SERVICE.Id 		= "mega"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true

local ValidTypes = {
	embed = true,
	file = true,
}

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetMegaFileKey()
	return obj
end

function SERVICE:Match( url )
	return string.find( url, "mega%.nz" ) ~= nil
end

function SERVICE:GetMegaFileKey()
	if self.megaKey then
		return self.megaKey
	end

	-- https://mega.nz/file/XXXX#YYYY or /embed/XXXX#YYYY
	local path, data, key = string.match( self.url or "",
		"mega%.nz/(%a+)/([%a%d-_]+)#([%a%d-_]+)" )

	if path and ValidTypes[path] and key then
		self.megaKey = data .. "#" .. key
		return self.megaKey
	end

	return nil
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end
