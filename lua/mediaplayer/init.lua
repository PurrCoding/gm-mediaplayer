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
AddCSLuaFile "sh_metadata.lua"
AddCSLuaFile "sh_cvars.lua"
AddCSLuaFile "i18n/sh_i18n.lua"

include "shared.lua"
include "sv_requests.lua"