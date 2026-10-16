DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "VK Video"
SERVICE.Id 		= "vk"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetVKVideoId()
	return obj
end

--[[
	Cinema Match: url.host:match("vkvideo.ru") only (not vk.com).
	MediaPlayer ValidUrl uses Match alone, so also require a resolvable video id.
]]
function SERVICE:Match( url )
	if not url or not string.find( url, "vkvideo%.ru" ) then
		return false
	end

	-- path: /video-OID_ID  or query z=video-OID_ID
	if string.find( url, "video%-%d+_%d+" ) then
		return true
	end

	return false
end

--[[
	Cinema GetURLInfo stores Data as the full "video-OID_ID" token from:
	  path  — video-xxxxxxxxx_xxxxxxxxx
	  query.z — same form
	Embed uses oid/id from video%-(%d+)_(%d+)
]]
function SERVICE:GetVKVideoId()
	if self.videoId then
		return self.videoId
	end

	local path = self.urlinfo and self.urlinfo.path
	local query = self.urlinfo and self.urlinfo.query

	-- Fallback parse from raw URL if urlinfo incomplete
	if not path and self.url then
		path = string.match( self.url, "vkvideo%.ru(/[^%s?#]*)" ) or ""
	end

	if path then
		-- Prefer explicit full token (Cinema stores video-OID_ID)
		local full = string.match( path, "(video%-%d+_%d+)" )
		if full and full ~= "video" then
			self.videoId = full
			return full
		end
	end

	if query and query.z then
		local full = string.match( query.z, "(video%-%d+_%d+)" )
		if full then
			self.videoId = full
			return full
		end
	end

	-- Raw URL query fallback: ?z=video-...
	if self.url then
		local full = string.match( self.url, "[?&]z=(video%-%d+_%d+)" )
		if full then
			self.videoId = full
			return full
		end
	end

	return nil
end

function SERVICE:GetVKEmbedParts()
	local data = self:GetVKVideoId()
	if not data then return nil, nil end
	-- Cinema extractData: data:match("video%-(%d+)_(%d+)")
	local oid, id = string.match( data, "video%-(%d+)_(%d+)" )
	return oid, id
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end
