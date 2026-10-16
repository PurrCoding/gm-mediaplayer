DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Kick"
SERVICE.Id 		= "kick"
SERVICE.Base 	= "browser"

-- Same ignore list as Cinema sh_kick.lua
local Ignored = {
	category = true,
	browse = true,
}

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetKickChannel()
	return obj
end

--[[
	Cinema Match only checks host; GetURLInfo does the real gate:
	  path:match("^/([%a%d-_]+)") and not Ignored[data]
	MediaPlayer ValidUrl uses Match alone, so Match must enforce the same rules.
]]
function SERVICE:Match( url )
	if not url or not string.find( url, "kick%.com" ) then
		return false
	end

	local path = string.match( url, "kick%.com(/[^%s?#]*)" ) or ""
	-- Cinema: url.path:match("^/([%a%d-_]+)")
	local data = string.match( path, "^/([%a%d-_]+)" )
	if not data or Ignored[data] then
		return false
	end

	return true
end

function SERVICE:GetKickChannel()
	if self.channelId then
		return self.channelId
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path and self.url then
		path = string.match( self.url, "kick%.com(/[^%s?#]*)" )
	end
	if not path then
		return nil
	end

	-- Cinema GetURLInfo: local data = url.path:match("^/([%a%d-_]+)")
	local data = string.match( path, "^/([%a%d-_]+)" )
	if data and not Ignored[data] then
		self.channelId = data
		return data
	end

	return nil
end

function SERVICE:IsTimed()
	return false
end
