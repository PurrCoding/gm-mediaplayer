AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"
include "shared.lua"

cleanup.Register( "mediaplayer_spatial_anchor" )

function ENT:CanPlayerControl( ply )
	local mp = self:GetMediaPlayer()
	return IsValid(mp) and mp:IsPlayerPrivileged( ply )
end