AddCSLuaFile "shared.lua"
include "shared.lua"

DEFINE_BASECLASS( "mp_base" )

function MEDIAPLAYER:NetWriteUpdate()
	local entIndex = IsValid(self.Entity) and self.Entity:EntIndex() or 0
	net.WriteUInt(entIndex, 16)
end


function MEDIAPLAYER:CanPlayerRequestMedia( ply, media )
	if not self:IsPlayerPrivileged(ply) then
		return false, MediaPlayer.L("mp.spatial.no_permission")
	end

	return BaseClass.CanPlayerRequestMedia( self, ply, media )
end