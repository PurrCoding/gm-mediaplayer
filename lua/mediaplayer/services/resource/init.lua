AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"
include "shared.lua"

local urllib = url
local FilenamePattern = "([^/]+)%.%S+$"
local FilenameExtPattern = "([^/]+%.%S+)$"

SERVICE.TitleIncludeExtension = true -- include extension in title

function SERVICE:GetMetadata( callback )
	if self._metadata then
		callback(self._metadata)
		return
	end

	local title

	local pattern = self.TitleIncludeExtension and
		FilenameExtPattern or FilenamePattern

	if self.urlinfo.path then
		local path = self.urlinfo.path
		path = string.match( path, pattern ) -- get filename

		if path then
			title = urllib.unescape( path )
		else
			title = self.url
		end
	else
		title = self.url
	end

	local metadata = {
		title = title or self.Name,
		url   = self.url
	}

	self:SetMetadata(metadata, true)

	callback(self._metadata)
end