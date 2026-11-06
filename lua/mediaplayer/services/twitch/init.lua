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

local urllib = url

function SERVICE:GetMetadata( callback )

	if self._metadata then
		callback( self._metadata )
		return
	end

	local channel = self:GetTwitchChannel()
	local metadata = {
		title = ("Twitch.TV Stream: %s"):format(channel)
	}

	self:SetMetadata(metadata, true)

	callback(self._metadata)

end