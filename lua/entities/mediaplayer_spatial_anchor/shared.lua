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