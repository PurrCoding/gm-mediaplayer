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

--[[--------------------------------------------
	Vote object
----------------------------------------------]]

local VOTE = {}
VOTE.__index = VOTE

function VOTE:New( ply, value )
	local obj = setmetatable( {}, self )

	obj.player = ply
	obj.value = value or 1

	return obj
end

function VOTE:IsValid()
	return IsValid(self.player)
end

function VOTE:GetPlayer()
	return self.player
end

function VOTE:GetValue()
	return self.value
end

MediaPlayer.VOTE = VOTE