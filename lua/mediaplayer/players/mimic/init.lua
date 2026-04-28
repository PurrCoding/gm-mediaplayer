AddCSLuaFile "shared.lua"
include "shared.lua"

DEFINE_BASECLASS( "mp_entity" )

function MEDIAPLAYER:NetWriteUpdate()
	-- Write entity index (same as entity type)
	local entIndex = IsValid( self.Entity ) and self.Entity:EntIndex() or 0
	net.WriteUInt( entIndex, 16 )

	-- Write source media player ID
	net.WriteString( self._SourceMPId or "" )
end

---
-- Mimic players don't advance their own queue.
--
function MEDIAPLAYER:NextMedia()
	-- no-op
end

---
-- Mimic players don't set their own media.
--
function MEDIAPLAYER:SetMedia( media )
	-- no-op
end

---
-- When a player becomes a mimic listener, also add them to the source
-- so the source's browser/DHTML panel exists on their client.
--
function MEDIAPLAYER:AddListener( ply )
	BaseClass.AddListener( self, ply )

	-- Auto-add to source
	local sourceMP = self:GetSourceMediaPlayer()
	if sourceMP and sourceMP:IsValid() and not sourceMP:HasListener( ply ) then
		self._AutoSourceListeners = self._AutoSourceListeners or {}
		self._AutoSourceListeners[ply] = true
		sourceMP:AddListener( ply )
	end
end

---
-- When a player is removed from the mimic, also remove them from the
-- source IF we were the ones who added them.
--
function MEDIAPLAYER:RemoveListener( ply )
	BaseClass.RemoveListener( self, ply )

	-- Only remove from source if we auto-added them
	if self._AutoSourceListeners and self._AutoSourceListeners[ply] then
		self._AutoSourceListeners[ply] = nil

		local sourceMP = self:GetSourceMediaPlayer()
		if sourceMP and sourceMP:IsValid() and sourceMP:HasListener( ply ) then
			sourceMP:RemoveListener( ply )
		end
	end
end