DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "VK Video"
SERVICE.Id 		= "vk"
SERVICE.Base 	= "browser"

SERVICE.PrefetchMetadata = true

-- video-OID_ID or live-OID_ID
local VK_ID_PATTERN = "((?:video|live)%-%d+_%d+)"

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetVKVideoId()
	return obj
end

function SERVICE:Match( url )
	if not url or not string.find( url, "vkvideo%.ru" ) then
		return false
	end

	-- /video-OID_ID, /live-OID_ID, or ?z=video-... / ?z=live-...
	if string.find( url, "(?:video|live)%-%d+_%d+" ) then
		return true
	end

	-- Lua patterns have no non-capturing groups; check both forms
	if string.find( url, "video%-%d+_%d+" ) or string.find( url, "live%-%d+_%d+" ) then
		return true
	end

	return false
end

function SERVICE:GetVKVideoId()
	if self.videoId then
		return self.videoId
	end

	local path = self.urlinfo and self.urlinfo.path
	local query = self.urlinfo and self.urlinfo.query

	if not path and self.url then
		path = string.match( self.url, "vkvideo%.ru(/[^%s?#]*)" ) or ""
	end

	local function tryExtract( str )
		if not str then return nil end
		return string.match( str, "(video%-%d+_%d+)" )
			or string.match( str, "(live%-%d+_%d+)" )
	end

	if path then
		local full = tryExtract( path )
		if full then
			self.videoId = full
			return full
		end
	end

	if query and query.z then
		local full = tryExtract( query.z )
		if full then
			self.videoId = full
			return full
		end
	end

	if self.url then
		local full = string.match( self.url, "[?&]z=(video%-%d+_%d+)" )
			or string.match( self.url, "[?&]z=(live%-%d+_%d+)" )
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
	-- video-OID_ID or live-OID_ID → oid, id for video_ext.php
	local oid, id = string.match( data, "(?:video|live)%-(%d+)_(%d+)" )
	-- Lua has no non-capturing groups
	if not oid then
		oid, id = string.match( data, "video%-(%d+)_(%d+)" )
	end
	if not oid then
		oid, id = string.match( data, "live%-(%d+)_(%d+)" )
	end
	return oid, id
end

function SERVICE:IsVKLive()
	local data = self:GetVKVideoId()
	return data and string.StartWith( data, "live-" ) or false
end

function SERVICE:IsTimed()
	if self:IsVKLive() then
		return false
	end
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end
