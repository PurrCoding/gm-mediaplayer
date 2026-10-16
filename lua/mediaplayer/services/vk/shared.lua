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

function SERVICE:Match( url )
	return string.find( url, "vkvideo%.ru" ) ~= nil
		or string.find( url, "vk%.com" ) ~= nil
end

function SERVICE:GetVKVideoId()
	if self.videoId then
		return self.videoId
	end

	local url = self.urlinfo
	if not url then return nil end

	-- https://vkvideo.ru/video-XXXXXXXX_YYYYYYYY
	if url.path then
		local id = string.match( url.path, "video%-(%d+_%d+)" )
		if id then
			self.videoId = "video-" .. id
			return self.videoId
		end
	end

	-- https://vkvideo.ru/video?z=video-XXXXXXXX_YYYYYYYY
	if url.query and url.query.z then
		local id = string.match( url.query.z, "video%-(%d+_%d+)" )
		if id then
			self.videoId = "video-" .. id
			return self.videoId
		end
	end

	return nil
end

function SERVICE:GetVKEmbedParts()
	local data = self:GetVKVideoId()
	if not data then return nil, nil end
	local oid, id = string.match( data, "video%-(%d+)_(%d+)" )
	return oid, id
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end
