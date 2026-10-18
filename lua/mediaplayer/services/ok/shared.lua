DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "OK"
SERVICE.Id 		= "ok"
SERVICE.Base 	= "browser"

local ValidTypes = {
	video = true,
	live = true,
}

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetOKVideoData()
	return obj
end

function SERVICE:Match( url )
	if not url or not string.find( url, "ok%.ru" ) then
		return false
	end

	local path = string.match( url, "ok%.ru(/[^%s?#]*)" ) or ""
	local typeID, videoID = string.match( path, "^/([%w%-_]+)/(%d+)" )
	if typeID and videoID and ValidTypes[typeID] then
		return true
	end

	return false
end

function SERVICE:GetOKVideoData()
	if self.okData then
		return self.okData
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path and self.url then
		path = string.match( self.url, "ok%.ru(/[^%s?#]*)" )
	end
	if not path then
		return nil
	end

	local typeID, videoID = string.match( path, "^/([%w%-_]+)/(%d+)" )
	if typeID and videoID and ValidTypes[typeID] then
		self.okData = typeID .. "," .. videoID
		return self.okData
	end

	return nil
end

function SERVICE:GetOKVideoId()
	local data = self:GetOKVideoData()
	if not data then return nil end
	local parts = string.Explode( ",", data )
	return parts[2]
end

function SERVICE:IsTimed()
	if self._metadata and self._metadata.duration then
		return self._metadata.duration > 0
	end
	return true
end
