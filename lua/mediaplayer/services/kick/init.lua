AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local channel = self:GetKickChannel()
	if not channel then
		return callback( false, "Invalid Kick URL." )
	end

	-- Kick has no reliable public metadata API without auth; use channel name.
	local metadata = {
		title = "Kick: " .. channel,
		duration = 0,
	}

	self:SetMetadata( metadata, true )
	callback( self._metadata )
end
