DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Kick"
SERVICE.Id 		= "kick"
SERVICE.Base 	= "browser"

local IgnoredPaths = {
	category = true,
	browse = true,
}

function SERVICE:New( url )
	local obj = BaseClass.New( self, url )
	obj._data = obj:GetKickChannel()
	return obj
end

function SERVICE:Match( url )
	return string.find( url, "kick%.com" ) ~= nil
end

function SERVICE:GetKickChannel()
	if self.channelId then
		return self.channelId
	end

	if self.urlinfo and self.urlinfo.path then
		local channel = string.match( self.urlinfo.path, "^/([%a%d-_]+)" )
		if channel and not IgnoredPaths[channel] then
			self.channelId = channel
			return channel
		end
	end

	return nil
end

-- Kick is live-only in this integration
function SERVICE:IsTimed()
	return false
end
