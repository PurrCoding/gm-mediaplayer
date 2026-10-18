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
	if not url or not string.find( url, "rumble%.com" ) then
		return false
	end

	-- Watch page: /vXXXX-title.html
	if string.match( url, "rumble%.com/[^%s?#]+%.html" ) then
		return true
	end

	-- Shorts: /shorts/{id}
	if string.match( url, "rumble%.com/shorts/[%w%-_]+" ) then
		return true
	end

	return false
end

--[[
	Extract the path slug used for oEmbed
	- https://rumble.com/v7gwi6a-title....html  →  v7gwi6a-title....
	- https://rumble.com/shorts/v7gycdc         →  shorts/v7gycdc
	  (oEmbed accepts the path without forcing .html for shorts)
]]
function SERVICE:GetRumbleVideoId()
	if self.videoId then
		return self.videoId
	end

	local path = self.urlinfo and self.urlinfo.path
	if not path and self.url then
		path = string.match( self.url, "rumble%.com(/[^%s?#]*)" )
	end
	if not path then
		return nil
	end

	local slug = string.match( path, "/([%w%p%-_]+)%.html" )
	if slug then
		self.videoId = slug
		self._rumbleIsShort = false
		return slug
	end

	-- Shorts: /shorts/vXXXX
	local shortId = string.match( path, "^/shorts/([%w%-_]+)" )
	if shortId then
		self.videoId = "shorts/" .. shortId
		self._rumbleIsShort = true
		return self.videoId
	end

	return nil
end

function SERVICE:IsRumbleShort()
	if self._rumbleIsShort ~= nil then
		return self._rumbleIsShort
	end
	local id = self:GetRumbleVideoId()
	return id and string.StartWith( id, "shorts/" ) or false
end

function SERVICE:IsTimed()
	if self._metadata and self._metadata.duration then
		return self._metadata.duration > 0
	end
	return true
end
