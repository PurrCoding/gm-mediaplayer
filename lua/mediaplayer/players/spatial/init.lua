AddCSLuaFile "shared.lua"
include "shared.lua"

DEFINE_BASECLASS( "mp_base" )

local HearRadiusCvar = CreateConVar( "mediaplayer_spatial_hear_radius", 1800, {
	FCVAR_ARCHIVE,
	FCVAR_NOTIFY,
	FCVAR_REPLICATED
}, "How far spatial media anchors can be heard before listeners are removed." )

-- Cache the squared radius to avoid recomputing every tick
local hearRadiusSqr = HearRadiusCvar:GetFloat() ^ 2

cvars.AddChangeCallback( "mediaplayer_spatial_hear_radius", function( _, _, new )
	local r = math.max( tonumber(new) or 1, 1 )
	hearRadiusSqr = r * r
end, "mp_spatial_radius_cache" )

function MEDIAPLAYER:UpdateListeners()
	-- Guard against re-entry from AddListener → BroadcastUpdate → UpdateListeners
	if self._updatingListeners then return end

	local ent = self:GetEntity()
	if not IsValid(ent) then
		self:SetListeners({})
		return
	end

	local pos = ent:GetPos()
	local listeners = {}
	local n = 0

	for _, ply in ipairs( player.GetHumans() ) do
		if ply:GetPos():DistToSqr(pos) <= hearRadiusSqr then
			n = n + 1
			listeners[n] = ply
		end
	end

	self._updatingListeners = true
	self:SetListeners( listeners )
	self._updatingListeners = false
end

function MEDIAPLAYER:CanPlayerRequestMedia( ply, media )
	if not self:IsPlayerPrivileged(ply) then
		return false, MediaPlayer.L("mp.spatial.no_permission")
	end

	return BaseClass.CanPlayerRequestMedia( self, ply, media )
end