DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Kick"
SERVICE.Id 		= "kick"
SERVICE.Base 	= "browser"

local Ignored = {
	category = true,
	browse = true,
	videos = true,
}

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetKickData()
	return obj
end

function SERVICE:Match( url )
	if not url or not string.find( url, "kick%.com" ) then
		return false
	end

	local path = string.match( url, "kick%.com(/[^%s?#]*)" ) or ""

	-- VOD: /channel/videos/{uuid}
	if string.match( path, "^/([%a%d-_]+)/videos/([%w%-]+)" ) then
		return true
	end

	-- Live: /channel
	local data = string.match( path, "^/([%a%d-_]+)/?$" )
		or string.match( path, "^/([%a%d-_]+)" )
	if data and not Ignored[data] then
		return true
	end

	return false
end

--[[
	Returns path token used for page open:
	  live  → "channel"
	  vod   → "channel/videos/uuid"
]]
function SERVICE:GetKickData()
	if self._kickData then
		return self._kickData
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path and self.url then
		path = string.match( self.url, "kick%.com(/[^%s?#]*)" )
	end
	if not path then return nil end

	local channel, uuid = string.match( path, "^/([%a%d-_]+)/videos/([%w%-]+)" )
	if channel and uuid then
		self._kickData = channel .. "/videos/" .. uuid
		self._kickVodId = uuid
		self._kickChannel = channel
		return self._kickData
	end

	local live = string.match( path, "^/([%a%d-_]+)" )
	if live and not Ignored[live] then
		self._kickData = live
		self._kickChannel = live
		return live
	end

	return nil
end

function SERVICE:GetKickChannel()
	if self._kickChannel then return self._kickChannel end
	self:GetKickData()
	return self._kickChannel
end

function SERVICE:GetKickVodId()
	if self._kickVodId then return self._kickVodId end
	self:GetKickData()
	return self._kickVodId
end

function SERVICE:IsKickVOD()
	return self:GetKickVodId() ~= nil
end

function SERVICE:IsTimed()
	return self:IsKickVOD()
end
