DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "BitChute"
SERVICE.Id 		= "bitchute"
SERVICE.Base 	= "browser"

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetBitChuteVideoId()
	return obj
end

function SERVICE:Match( url )
	return url and string.find( url, "bitchute%.com" ) ~= nil
end

function SERVICE:GetBitChuteVideoId()
	if self.videoId then
		return self.videoId
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path and self.url then
		path = string.match( self.url, "bitchute%.com(/[^%s?#]*)" )
	end
	if not path then
		return nil
	end

	-- /video/ID or /embed/ID
	local id = string.match( path, "^/(?:video|embed)/([%w%-_]+)" )
	if id then
		self.videoId = id
		return id
	end

	return nil
end

function SERVICE:IsTimed()
	if self._metadata and self._metadata.duration then
		return self._metadata.duration > 0
	end
	return true
end
