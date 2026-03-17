AddCSLuaFile "shared.lua"
include "shared.lua"

DEFINE_BASECLASS( "mp_base" )

local HearRadiusCvar = CreateConVar( "mediaplayer_spatial_hear_radius", 1800, {
	FCVAR_ARCHIVE,
	FCVAR_NOTIFY,
	FCVAR_REPLICATED
}, "How far spatial media anchors can be heard before listeners are removed." )

function MEDIAPLAYER:NetWriteUpdate()
	local entIndex = IsValid(self.Entity) and self.Entity:EntIndex() or 0
	net.WriteUInt(entIndex, 16)
end

function MEDIAPLAYER:UpdateListeners()
	local ent = self:GetEntity()

	if not IsValid(ent) then
		self:SetListeners({})
		return
	end

	local radius = math.max( HearRadiusCvar:GetFloat(), 1 )
	local radiusSqr = radius * radius
	local pos = ent:GetPos()
	local listeners = {}

	for _, ply in ipairs(player.GetHumans()) do
		if IsValid(ply) and ply:GetPos():DistToSqr(pos) <= radiusSqr then
			table.insert( listeners, ply )
		end
	end

	self:SetListeners( listeners )
end

function MEDIAPLAYER:CanPlayerRequestMedia( ply, media )
	if not self:IsPlayerPrivileged(ply) then
		return false, MediaPlayer.L("mp.spatial.no_permission")
	end

	return BaseClass.CanPlayerRequestMedia( self, ply, media )
end