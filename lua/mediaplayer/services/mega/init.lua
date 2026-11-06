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

AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
		return
	end

	local metadata = {
		title = self._metaTitle or "MEGA Video",
		duration = self._metaDuration or 0,
	}

	self:SetMetadata( metadata, true )

	if metadata.duration > 0 then
		MediaPlayer.Metadata:Save( self )
	end

	callback( self._metadata )
end

function SERVICE:NetReadRequest()
	if not self.PrefetchMetadata then return end

	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
end
