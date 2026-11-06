--[[
  Media Player Redux
  Copyright (c) 2014–2026 GMod Media Player authors

  Originally created by Samuel Maddock
  (https://github.com/samuelmaddock/gm-mediaplayer)

  This file is part of the Media Player Redux project
  (https://github.com/PurrCoding/gm-mediaplayer)

  Licensed under the MIT License.
  See LICENSE.md in the project root for the full license text.
  The copyright notice and this permission notice must be retained
  in all copies or substantial portions of the Software.
]]

if SERVER then
	AddCSLuaFile "shared.lua"
	AddCSLuaFile "cl_init.lua"
end
include "shared.lua"

ENT.UseDelay = 0.5 -- seconds

function ENT:Use(ply)
	if not IsValid(ply) then return end

	-- Delay request
	if ply.NextUse and ply.NextUse > CurTime() then
		return
	end

	local mp = self:GetMediaPlayer()

	if not mp then
		ErrorNoHalt("MediaPlayer test entity doesn't have player installed\n")
		debug.Trace()
		return
	end

	if mp:HasListener(ply) then
		mp:RemoveListener(ply)
	else
		mp:AddListener(ply)
	end

	ply.NextUse = CurTime() + self.UseDelay
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:OnEntityCopyTableFinish( data )
	local mp = self:GetMediaPlayer()
	data.MediaPlayerSnapshot = mp:GetSnapshot()
	data._mp = nil
end

function ENT:PostEntityPaste( ply, ent, createdEnts )
	local snapshot = self.MediaPlayerSnapshot
	if not snapshot then return end

	local mp = self:GetMediaPlayer()
	self:SetMediaPlayerID( mp:GetId() )

	mp:RestoreSnapshot( snapshot )

	self.MediaPlayerSnapshot = nil
end

function ENT:KeyValue( key, value )
	if key == "model" then
		self.Model = value
	end
end

function ENT:AcceptInput( name, activator, caller, data )
	local mp = self:GetMediaPlayer()
	if not IsValid(mp) then return false end

	local ply = IsValid(activator) and activator:IsPlayer() and activator

	if name == "AddPlayer" then
		if ply and not mp:HasListener(ply) then
			mp:AddListener(ply)
		end
	elseif name == "RemovePlayer" then
		if ply and mp:HasListener(ply) then
			mp:RemoveListener(ply)
		end
	elseif name == "RemoveAllPlayers" then
		mp:SetListeners({})
	elseif name == "PlayPauseMedia" then
		mp:PlayPause()
	elseif name == "SkipMedia" then
		mp:OnMediaFinished()
	elseif name == "ClearMedia" then
		mp:ClearMediaQueue()
		mp:OnMediaFinished()
	else
		return false
	end

	return true
end
