DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Rumble"
SERVICE.Id 		= "rumble"
SERVICE.Base 	= "browser"

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetRumbleVideoId()
	return obj
end

function SERVICE:Match( url )
	return string.find( url, "rumble%.com" ) ~= nil
end

function SERVICE:GetRumbleVideoId()
	if self.videoId then
		return self.videoId
	end

	if self.urlinfo and self.urlinfo.path then
		-- https://rumble.com/vXXXXX-title.html
		local id = string.match( self.urlinfo.path, "/([%a%d%p-_]+)%.html" )
		if id then
			self.videoId = id
			return id
		end
	end

	return nil
end

function SERVICE:IsTimed()
	if self._metadata and self._metadata.duration then
		return self._metadata.duration > 0
	end
	return true
end
