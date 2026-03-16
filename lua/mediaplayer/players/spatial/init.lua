AddCSLuaFile "shared.lua"
include "shared.lua"

DEFINE_BASECLASS( "mp_base" )

local HearRadiusCvar = CreateConVar( "mediaplayer_spatial_hear_radius", 1800, {
	FCVAR_ARCHIVE,
	FCVAR_NOTIFY,
	FCVAR_REPLICATED
}, "How far spatial media anchors can be heard before listeners are removed." )

local MaxRepeatCountCvar = CreateConVar( "mediaplayer_spatial_max_repeat_count", 16, {
	FCVAR_ARCHIVE,
	FCVAR_NOTIFY,
	FCVAR_REPLICATED
}, "Maximum number of additional finite repeats allowed for spatial media anchors." )

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
		return false, "You don't have permission to control this spatial media source."
	end

	return BaseClass.CanPlayerRequestMedia( self, ply, media )
end

local function CloneMediaForRepeat( media, suffix )
	local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()
	local clone = MediaPlayer.GetMediaForUrl( media:Url(), allowWebpage )

	local data = media:Data()
	if data then
		clone._data = string.format( "%s-loop%d", tostring(data), suffix )
	end

	clone:SetMetadata( table.Copy( media._metadata or {} ) )

	local owner = media:GetOwner()
	if IsValid(owner) and isfunction(clone.SetOwner) then
		clone:SetOwner( owner )
	end

	return clone
end

function MEDIAPLAYER:RequestSpatialMedia( media, ply, loopForever, repeatCount )
	if not IsValid(ply) then return end

	local allowed, msg = self:CanPlayerRequestMedia( ply, media )
	if not allowed then
		self:NotifyPlayer( ply, msg and msg or "Your media request has been denied." )
		return
	end

	if not self:HasListener(ply) then
		self:AddListener( ply )
	end

	if MediaPlayer.DEBUG then
		print( "MEDIAPLAYER.RequestSpatialMedia", media, ply, loopForever, repeatCount )
	end

	hook.Run( "PreMediaPlayerMediaRequest", self, media, ply )

	media:GetMetadata(function(data, err)
		if not data then
			err = err and err or "There was a problem fetching the requested media's metadata."
			print(err)
			self:NotifyPlayer( ply, "[Request Error] " .. err )
			return
		end

		media:SetOwner( ply )

		local queueMedia, queueMsg = self:ShouldQueueMedia( media )
		if not queueMedia then
			self:NotifyPlayer( ply,
				queueMsg and queueMsg or "The requested media couldn't be queued." )
			return
		end

		repeatCount = math.max( 0, math.floor( tonumber(repeatCount) or 0 ) )
		repeatCount = math.min( repeatCount, math.max( MaxRepeatCountCvar:GetInt(), 0 ) )
		repeatCount = math.min( repeatCount, math.max( self:GetQueueLimit() - 1, 0 ) )

		-- Remember the user's loop settings so the tool can repopulate them
		-- when reopening the request UI later.
		local anchor = self:GetEntity()
		if IsValid(anchor) then
			anchor:SetLoopForever( tobool(loopForever) )
			anchor:SetLoopCount( repeatCount )
		end

		-- Replace any current/queued media without waiting for the previous item
		-- to finish. The next SendMedia call cleanly stops the previous clientside
		-- playback path.
		self:SetQueueRepeat( false )
		self._Queue = {}

		self:AddMedia( media )

		for i = 1, repeatCount do
			self:AddMedia( CloneMediaForRepeat( media, i ) )
		end

		self:SetQueueRepeat( tobool(loopForever) )
		self:QueueUpdated()
		self:NextMedia()

		local suffix = ""
		if loopForever then
			suffix = " (looping forever)"
		elseif repeatCount > 0 then
			suffix = string.format( " (%d extra loops)", repeatCount )
		end

		self:NotifyPlayer( ply, string.format(
			"Playing '%s'%s.",
			media:Title(),
			suffix
		) )

		MediaPlayer.History:LogRequest( media )
		hook.Run( "PostMediaPlayerMediaRequest", self, media, ply )
	end)
end
