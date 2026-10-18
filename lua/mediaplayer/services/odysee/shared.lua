DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Odysee"
SERVICE.Id 		= "odysee"
SERVICE.Base 	= "browser"

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)
	obj._data = obj:GetOdyseeEmbedPath()
	return obj
end

function SERVICE:Match( url )
	return string.match( url, "odysee%.com" ) ~= nil
end

-- Returns the path segment used in embed URLs.
-- Prefer "@channel:x/claim:y" when a channel is present (official oEmbed style).
-- Fallback: bare claim name for legacy / claim-only links.
function SERVICE:GetOdyseeEmbedPath()
	local path = self.urlinfo and self.urlinfo.path or ""

	-- https://odysee.com/@channel:1/video-title:a
	local channel, claim = string.match(path, "/(@[^/]+)/([^/]+)$")
	if channel and claim then
		return channel .. "/" .. claim
	end

	-- https://odysee.com/video-title:a  (no channel)
	local claimOnly = string.match(path, "/([^/]+)$")
	if claimOnly and claimOnly ~= "" and not string.StartWith(claimOnly, "$") then
		return claimOnly
	end

	return ""
end

-- Backwards-compatible alias used by older call sites
function SERVICE:GetOdyseeVideoId()
	return self:GetOdyseeEmbedPath()
end

function SERVICE:GetOdyseeChannel()
	local path = self.urlinfo and self.urlinfo.path or ""
	return string.match(path, "/(@[^/]+)/")
end

function SERVICE:IsTimed()
	return self._metadata and self._metadata.duration and self._metadata.duration > 0
end
