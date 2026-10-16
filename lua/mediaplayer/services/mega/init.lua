AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local metadata = {
		title = self._metaTitle or "MEGA Video",
		duration = self._metaDuration or 0,
	}

	self:SetMetadata( metadata, true )

	if metadata.duration > 0 then
		MediaPlayer.Metadata:Save( self )
	end

	callback( self._metadata )
end

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end

	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
end
