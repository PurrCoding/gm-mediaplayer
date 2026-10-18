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
	if not url then return false end
	if not string.find( url, "bitchute%.com" ) then
		return false
	end

	-- Only concrete video / embed links (not homepage, channels, etc.)
	if string.match( url, "bitchute%.com/video/[%w%-_]+" ) then
		return true
	end
	if string.match( url, "bitchute%.com/embed/[%w%-_]+" ) then
		return true
	end

	return false
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
	local videoId = string.match( path, "^/video/([%w%-_]+)" )
		or string.match( path, "^/embed/([%w%-_]+)" )

	if videoId then
		self.videoId = videoId
	end

	return videoId
end

function SERVICE:IsTimed()
	if self._metadata and self._metadata.duration then
		return self._metadata.duration > 0
	end
	return true
end
