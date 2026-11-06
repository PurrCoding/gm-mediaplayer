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
