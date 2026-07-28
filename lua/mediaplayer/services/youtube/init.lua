AddCSLuaFile "shared.lua"
include "shared.lua"

---
-- Fetch video metadata from the server-side JSON API.
--
-- The API returns JSON of the form:
--   {"success":true,"id":"...","title":"...","author":"...",
--    "duration":1014,"views":161849,"live":false, ...}
--
-- On success, callback( metadata ) is called.
-- On failure, callback( false, reason ) is called.
--
function SERVICE:FetchAPIMetadata( callback )
	local videoId = self:GetYouTubeVideoId()

	if not videoId then
		callback( false, "YouTube API: could not resolve video id" )
		return
	end

	local url = string.format( self.MetadataAPI, videoId )

	self:Fetch( url,
		function( body, length, headers, code )
			local decoded = util.JSONToTable( body )

			if not istable(decoded) or decoded.success ~= true or not isstring(decoded.title) then
				local reason
				if istable(decoded) then
					reason = "success = " .. tostring(decoded.success) ..
						", title = " .. type(decoded.title)
				else
					reason = "invalid JSON response (HTTP " .. tostring(code) .. ")"
				end
				callback( false, "YouTube API fetch failed: " .. reason )
				return
			end

			local metadata = {}
			metadata.title = decoded.title

			if decoded.live then
				-- Ongoing live stream: mark duration as 0
				metadata.duration = 0
			else
				metadata.duration = math.max( 1, math.Round( tonumber(decoded.duration) or 0 ) )
			end

			self:SetMetadata( metadata, true )
			MediaPlayer.Metadata:Save( self )

			callback( self._metadata )
		end,
		function( reason )
			callback( false, "YouTube API fetch failed: " .. tostring(reason) )
		end
	)
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	self:FetchAPIMetadata( callback )
end