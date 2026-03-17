include "shared.lua"

DEFINE_BASECLASS( "mp_base" )

function MEDIAPLAYER:NetReadUpdate()
	local entIndex = net.ReadUInt(16)
	local ent = Entity(entIndex)
	local mpEnt = self.Entity

	if MediaPlayer.DEBUG then
		print("MEDIAPLAYER.NetReadUpdate[spatial]: ", ent, entIndex)
	end

	if ent ~= mpEnt then
		if IsValid(ent) and ent ~= NULL then
			ent:InstallMediaPlayer(self)
		else
			self._EntIndex = entIndex
		end
	end
end

function MEDIAPLAYER:SetMedia( media )
	if media then
		-- Browser and audio-file services both rely on Entity for positional
		-- behaviour. The anchor entity provides a dummy screen config so browser
		-- services can still initialize cleanly.
		media.Entity = self:GetEntity()
	end

	BaseClass.SetMedia( self, media )
end