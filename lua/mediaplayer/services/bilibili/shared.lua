DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name = "Bilibili"
SERVICE.Id = "bili"
SERVICE.Base = "browser"

-- Metadata is fetched serverside for this service, so we don't require a
-- clientside PreRequest step.
SERVICE.PrefetchMetadata = false

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )

	local page = obj:GetBilibiliPage() or 1
	local bvid = obj:GetBilibiliBVID()
	local aid = obj:GetBilibiliAID()

	-- Include the selected page in the cache key / unique ID so multi-part videos
	-- do not collide with each other.
	if bvid then
		obj._data = string.format( "%s-p%d", bvid, page )
	elseif aid then
		obj._data = string.format( "av%s-p%d", aid, page )
	end

	return obj
end

function SERVICE:Match( url )
	if not url then return false end

	if string.find( url, "bilibili%.com/video/" ) then
		return true
	end

	if string.find( url, "player%.bilibili%.com/player%.html" ) then
		return true
	end

	if string.find( url, "bilibili%.com/blackboard/newplayer%.html" ) then
		return true
	end

	return false
end

function SERVICE:GetBilibiliBVID()
	if self.bvid then
		return self.bvid
	end

	if not self.urlinfo then
		return nil
	end

	local path = self.urlinfo.path or ""
	local bvid = string.match( path, "^/video/(BV[%w]+)" )

	if not bvid and self.urlinfo.query then
		bvid = self.urlinfo.query.bvid
	end

	if bvid then
		self.bvid = bvid
	end

	return bvid
end

function SERVICE:GetBilibiliAID()
	if self.aid then
		return self.aid
	end

	if not self.urlinfo then
		return nil
	end

	local path = self.urlinfo.path or ""
	local aid = string.match( path, "^/video/av(%d+)" )

	if not aid and self.urlinfo.query then
		aid = self.urlinfo.query.aid
	end

	if aid then
		self.aid = aid
	end

	return aid
end

function SERVICE:GetBilibiliPage()
	if self.page then
		return self.page
	end

	local page = 1

	if self.urlinfo and self.urlinfo.query then
		page = tonumber( self.urlinfo.query.p or self.urlinfo.query.page ) or 1
	end

	if page < 1 then page = 1 end
	self.page = page

	return page
end
