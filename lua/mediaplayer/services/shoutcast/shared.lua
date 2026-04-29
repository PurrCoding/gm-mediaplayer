DEFINE_BASECLASS( "mp_service_af" )

SERVICE.Name = "SHOUTcast Radio"
SERVICE.Id   = "scr"
SERVICE.Base = "af"

SERVICE.PrefetchMetadata = true

function SERVICE:Match( url )
	url = string.lower(url or "")

	-- Match SHOUTcast tune-in URLs with a station ID
	-- e.g. yp.shoutcast.com/sbin/tunein-station.pls?id=99497
	if url:find("shoutcast%.com/sbin/tunein%-station") and url:find("[?&]id=%d+") then
		return true
	end

	-- Match .pls playlist files
	if url:find("%.pls") then
		return true
	end

	-- Match simple .m3u but NOT .m3u8 (HLS is not supported by BASS)
	if url:find("%.m3u") and not url:find("%.m3u8") then
		return true
	end

	return false
end

-- Radio streams are live/infinite, not timed
function SERVICE:IsTimed()
	return false
end