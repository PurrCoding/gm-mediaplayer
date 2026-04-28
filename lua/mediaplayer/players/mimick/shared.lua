DEFINE_BASECLASS( "mp_entity" )

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.Name = "mimick"
MEDIAPLAYER.Base = "entity"

function MEDIAPLAYER:Init( ... )
	BaseClass.Init( self, ... )
	self._SourceMPId = nil

	if SERVER then
		self._AutoSourceListeners = {}
	end
end

function MEDIAPLAYER:SetSourceId( id )
	self._SourceMPId = id
end

function MEDIAPLAYER:GetSourceId()
	return self._SourceMPId
end

function MEDIAPLAYER:GetSourceMediaPlayer()
	if not self._SourceMPId then return nil end
	return MediaPlayer.GetById( self._SourceMPId )
end

function MEDIAPLAYER:AddMedia( media )
	-- no-op
end

function MEDIAPLAYER:RequestMedia( media, ply )
	if IsValid( ply ) then
		ply:ChatPrint( "This is a mimick player — request media on the source screen instead." )
	end
end

function MEDIAPLAYER:Think()
	BaseClass.Think( self )

	-- Validate source still exists.
	-- ONLY clear _SourceMPId on the SERVER. On the server, the source MP
	-- is always present (installed on the entity) unless the entity is
	-- truly removed. On the CLIENT, the source MP may be temporarily
	-- absent because the local player was removed as a listener (E-toggle
	-- off). Clearing the ID on the client would permanently break the
	-- link, preventing reconnection when the source is toggled back on.
	if SERVER and self._SourceMPId then
		local sourceMP = MediaPlayer.GetById( self._SourceMPId )
		if not sourceMP or not sourceMP:IsValid() then
			self._SourceMPId = nil
		end
	end
end

function MEDIAPLAYER:GetSnapshot()
	local snap = BaseClass.GetSnapshot( self )
	snap.sourceMPId = self._SourceMPId
	return snap
end

function MEDIAPLAYER:RestoreSnapshot( snapshot )
	self._Queue = {}
	self:SetQueueRepeat( snapshot.queueRepeat or false )
	self:SetQueueShuffle( snapshot.queueShuffle or false )
	self:SetQueueLocked( snapshot.queueLocked or false )
	self._SourceMPId = snapshot.sourceMPId
end