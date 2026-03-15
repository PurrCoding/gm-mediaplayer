if MediaPlayer and MediaPlayer._source then
	if MediaPlayer.__refresh then
		MediaPlayer.__refresh = nil
	elseif MediaPlayer._source == MEDIAPLAYER_VERSION.GetSource()
	   and MediaPlayer._version == MEDIAPLAYER_VERSION.GetVersion() then
		return -- Same version already loaded, skip
	end
end

AddCSLuaFile "controls/dmediaplayerhtml.lua"
AddCSLuaFile "controls/dhtmlcontrols.lua"
AddCSLuaFile "controls/dmediaplayerrequest.lua"
AddCSLuaFile "cl_init.lua"
AddCSLuaFile "cl_requests.lua"
AddCSLuaFile "cl_idlescreen.lua"
AddCSLuaFile "cl_screen.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "sh_events.lua"
AddCSLuaFile "sh_mediaplayer.lua"
AddCSLuaFile "sh_services.lua"
AddCSLuaFile "sh_history.lua"
AddCSLuaFile "sh_metadata.lua"
AddCSLuaFile "sh_cvars.lua"
AddCSLuaFile "i18n/sh_i18n.lua"

include "shared.lua"
include "sv_requests.lua"

-- TODO: move this into its own file
MediaPlayer.net = MediaPlayer.net or {}

function MediaPlayer.net.ReadMediaPlayer()

	local mpId = net.ReadString()
	local mp = MediaPlayer.GetById(mpId)

	if not IsValid(mp) then
		if MediaPlayer.DEBUG then
			print("MEDIAPLAYER.Request: Invalid media player ID", mpId, mp)
		end
		return false
	end

	return mp

end

-- Runtime conflict guard: detect if another addon overwrites the global after load
timer.Create("MediaPlayer_ConflictGuard", 30, 0, function()
	if MediaPlayer and MEDIAPLAYER_VERSION and MediaPlayer._source ~= MEDIAPLAYER_VERSION.GetSource() then
		MsgC(Color(255, 100, 100), "[MediaPlayer] WARNING: Another addon has overwritten the MediaPlayer global! Expected source '" .. MEDIAPLAYER_VERSION.GetSource() .. "', found '" .. tostring(MediaPlayer._source) .. "'\n")
		timer.Remove("MediaPlayer_ConflictGuard")
	end
end)