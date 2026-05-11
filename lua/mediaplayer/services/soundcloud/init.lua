AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:ParseSoundCloudHTML( body )
	local json = body:match('<script>window%.__sc_hydration = (.-);</script>')
	if not json then
		return nil, "Hydration JSON not found"
	end

	local data = util.JSONToTable(json)
	if not data then
		return nil, "Failed to parse JSON"
	end

	for i = 1, #data do
		if data[i]["hydratable"] and data[i]["hydratable"] == "sound" and data[i]["data"] then
			local metadata = data[i]["data"]

			-- Validate embeddability
			if metadata.embeddable_by ~= "all" or not metadata.public then
				return nil, "Track is not embeddable"
			end

			-- Extract and convert duration from ms to seconds
			local duration = metadata.duration or metadata.full_duration or 0
			duration = math.floor(duration / 1000)

			return {
				title = metadata.title or "Unknown",
				duration = duration
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	self:Fetch( self.url,
		function( body, length, headers, code )
			local status, metadata = pcall(self.ParseSoundCloudHTML, self, body)

			if status and metadata and metadata.title then
				self:SetMetadata(metadata, true)

				if self:IsTimed() then
					MediaPlayer.Metadata:Save(self)
				end

				callback(self._metadata)
			else
				local err = metadata or "Failed to parse metadata"
				callback(nil, ("SoundCloud Error: %s"):format(err))
			end
		end,
		function( reason )
			callback(nil, ("SoundCloud Error: %s"):format(reason))
		end
	)
end