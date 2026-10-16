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
	return string.find( url, "ok%.ru" ) ~= nil
end

function SERVICE:GetOKVideoData()
	if self.okData then
		return self.okData
	end

	if self.urlinfo and self.urlinfo.path then
		local typeID, videoID = string.match( self.urlinfo.path, "^/([%w%-_]+)/(%d+)" )
		if typeID and videoID and ValidTypes[typeID] then
			self.okData = typeID .. "," .. videoID
			return self.okData
		end
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
