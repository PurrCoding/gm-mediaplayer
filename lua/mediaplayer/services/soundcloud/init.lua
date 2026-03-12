AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

	local metadata = {}

	-- Title & Duration is taken from Client via PreRequest
	metadata.title = self._metaTitle
	metadata.duration = self._metaDuration

	self:SetMetadata(metadata, true)
	MediaPlayer.Metadata:Save(self)

	callback(self._metadata)
end

function SERVICE:NetReadRequest()

	if not self.PrefetchMetadata then return end

	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )

end