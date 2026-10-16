DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Jellyfin"
SERVICE.Id 		= "jellyfin"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true

--[[
	Experimental: public/unauthenticated stream URLs only.
	Expects links shaped like:
	https://host/.../web/#/details?id=<itemId>&serverId=<serverId>
	Playback uses /Videos/<id>/stream?static=true on the same origin.
]]

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetJellyfinStreamUrl()
	return obj
end

function SERVICE:Match( url )
	if not string.find( url, "/web" ) then return false end
	-- Fragment params: id= and serverId=
	return string.find( url, "[?#&]id=" ) ~= nil
		or string.find( url, "#/details" ) ~= nil
end

function SERVICE:GetJellyfinStreamUrl()
	if self.streamUrl then
		return self.streamUrl
	end

	local raw = self.url or ""
	local itemId = string.match( raw, "[?#&]id=([%a%d%-]+)" )
	if not itemId then return nil end

	-- Base = scheme://host[:port] + path up to (but not including) /web
	local base = string.match( raw, "^(https?://[^/]+.-)/web" )
	if not base then
		base = string.match( raw, "^(https?://[^/]+)" )
	end
	if not base then return nil end

	self.streamUrl = base .. "/Videos/" .. itemId .. "/stream?static=true"
	return self.streamUrl
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end
