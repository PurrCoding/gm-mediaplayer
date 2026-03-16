DEFINE_BASECLASS( "mp_base" )

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.Name = "spatial"

local SpatialServiceWhitelist = {
	"yt",
	"bili",
	"sc",
	"twl",
	"dm",
	"ia",
	"odysee",
	"tt",
	"gd",
	"h5v",
	"af",
}

function MEDIAPLAYER:IsValid()
	if not BaseClass.IsValid(self) then
		return false
	end

	local ent = self.Entity

	if ent then
		return IsValid(ent)
	end

	-- The client may still be waiting for the anchor entity to exist.
	return true
end

function MEDIAPLAYER:Init(...)
	BaseClass.Init(self, ...)

	self.ServiceWhitelist = table.Copy( SpatialServiceWhitelist )
end

function MEDIAPLAYER:SetEntity(ent)
	self.Entity = ent

	if SERVER then
		local creator = ent.GetCreator and ent:GetCreator()

		if IsValid( creator ) and creator:IsPlayer() then
			self:SetOwner( creator )
		end
	end
end

function MEDIAPLAYER:GetEntity()
	if CLIENT and self._EntIndex then
		local ent = Entity(self._EntIndex)

		if IsValid(ent) and ent ~= NULL then
			ent:InstallMediaPlayer(self)
			self._EntIndex = nil
		else
			return nil
		end
	end

	return self.Entity
end

function MEDIAPLAYER:GetPos()
	return IsValid(self.Entity) and self.Entity:GetPos() or Vector(0, 0, 0)
end

function MEDIAPLAYER:GetLocation()
	if IsValid(self.Entity) and self.Entity.Location then
		return self.Entity:Location()
	end

	return self._Location
end

function MEDIAPLAYER:Think()
	BaseClass.Think(self)

	local ent = self:GetEntity()

	if IsValid(ent) then
		if ent._mp ~= self then
			self:Remove()
		end
	elseif SERVER then
		self:Remove()
	end
end

function MEDIAPLAYER:Remove()
	if self.Entity then
		self.Entity._mp = nil
	end

	BaseClass.Remove(self)
end
