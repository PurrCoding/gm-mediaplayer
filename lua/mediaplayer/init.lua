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

if MediaPlayer then
	if MediaPlayer.__refresh then
		MediaPlayer.__refresh = nil
	else
		return -- MediaPlayer has already been registered
	end
end

AddCSLuaFile "controls/dmediaplayerhtml.lua"
AddCSLuaFile "controls/dhtmlcontrols.lua"
AddCSLuaFile "controls/dmediaplayerrequest.lua"
AddCSLuaFile "cl_init.lua"
AddCSLuaFile "cl_requests.lua"
AddCSLuaFile "cl_chromeerror.lua"
AddCSLuaFile "cl_idlescreen.lua"
AddCSLuaFile "cl_screen.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "sh_events.lua"
AddCSLuaFile "sh_mediaplayer.lua"
AddCSLuaFile "sh_services.lua"
AddCSLuaFile "sh_history.lua"
AddCSLuaFile "sh_metadata.lua"
AddCSLuaFile "sh_cvars.lua"
AddCSLuaFile "sh_cami.lua"
AddCSLuaFile "i18n/sh_i18n.lua"

include "shared.lua"
include "sv_playlist.lua"
include "sv_requests.lua"