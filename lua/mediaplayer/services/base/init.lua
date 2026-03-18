AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:SetOwner( ply )
	self._Owner = ply
	self._OwnerName = ply:Nick()
	self._OwnerSteamID = ply:SteamID()
end

function SERVICE:GetMetadata( callback )

	if not self._metadata then
		self._metadata = {
			title 		= "Base service",
			duration 	= -1,
			url 		= ""
		}
	end

	callback(self._metadata)

end

---
-- Shared cache-check helper for all services.
-- Returns (metadata, found).
--
function SERVICE:GetCachedMetadata()
	if self._metadata then
		return self._metadata, true
	end

	local cache = MediaPlayer.Metadata:Query(self)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.GetMetadata Cache results:")
		PrintTable(cache or {})
	end

	if cache then
		local metadata = {}
		metadata.title = cache.title
		metadata.duration = tonumber(cache.duration)

		self:SetMetadata(metadata)
		MediaPlayer.Metadata:Save(self)

		return self._metadata, true
	end

	return nil, false
end

local HttpHeaders = {
	["Cache-Control"] = "no-cache",

	-- Keep Alive causes problems on dedicated servers apparently.
	-- ["Connection"] = "keep-alive",

	-- Don't use improperly formatted GMod user agent in case anything actually
	-- checks the user agent.
	["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
}


function SERVICE:Fetch( url, onReceive, onFailure, headers )

	if MediaPlayer.DEBUG then
		print( "SERVICE.Fetch", url )
	end

	local request = {
		url			= url,
		method		= "GET",

		success = function( code, body, headers )
			if MediaPlayer.DEBUG then
				print("HTTP Results[" .. code .. "]:", url)
				PrintTable(headers)
				print(body)
			end

			if isfunction(onReceive) then
				onReceive( body, body:len(), headers, code )
			end
		end,

		failed = function( err )
			if isfunction(onFailure) then
				onFailure( err )
			end
		end
	}

	-- Pass in extra headers
	if headers then
		local tbl = table.Copy( HttpHeaders )
		table.Merge( tbl, headers )
		request.headers = tbl
	else
		request.headers = HttpHeaders
	end

	if MediaPlayer.DEBUG then
		print "MediaPlayer.Service.Fetch REQUESTING"
		PrintTable(request)
	end

	HTTP(request)

end

function SERVICE:NetReadRequest()
	-- Read any additional net data here
end