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

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Spatial Media Anchor"
ENT.Author = "SheepyLord"
ENT.Spawnable = false

ENT.Model = Model( "models/props_junk/PopCan01a.mdl" )
ENT.MediaPlayerType = "spatial"

ENT.IsMediaPlayerEntity = true

local DummyConfig = {
	offset = Vector(0, 0, 0),
	angle = Angle(0, 0, 0),
	width = 16,
	height = 9
}

function ENT:Initialize()
	if SERVER then
		if self:GetModel() ~= self.Model then
			self:SetModel( self.Model )
		end

		self:SetNoDraw( true )
		self:DrawShadow( false )
		self:SetNotSolid( true )
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		local mp = self:InstallMediaPlayer( self.MediaPlayerType )
		self:SetMediaPlayerID( mp:GetId() )
	end
end

if SERVER then
	function ENT:CPPIGetOwner()
		local mp = self:GetMediaPlayer()
		if mp then
			local owner = mp:GetOwner()
			if IsValid(owner) then
				return owner
			end
		end
		-- Fall back to GetCreator (standard GMod ownership)
		local creator = self:GetCreator()
		if IsValid(creator) then
			return creator
		end
		return nil
	end

	function ENT:CPPISetOwner(ply)
		self:SetCreator(ply)
		local mp = self:GetMediaPlayer()
		if mp then
			mp:SetOwner(ply)
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "MediaPlayerID" )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:GetMediaPlayerConfig()
	return DummyConfig
end

function ENT:OnRemove()
	local mp = self:GetMediaPlayer()
	if mp then
		mp:Remove()
	end
end