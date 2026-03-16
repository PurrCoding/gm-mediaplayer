-- MediaPlayer - Bilibili Support (plugin addon)
-- Drop this addon alongside PurrCoding/gm-mediaplayer.

if SERVER then
	AddCSLuaFile()

	AddCSLuaFile( "mediaplayer/services/bilibili/shared.lua" )
	AddCSLuaFile( "mediaplayer/services/bilibili/cl_init.lua" )
end

local function TryRegister()
	if not MediaPlayer or not MediaPlayer.RegisterService then return false end
	if MediaPlayer.Services and MediaPlayer.Services.bili then return true end -- already registered

	SERVICE = {}

	if SERVER then
		include( "mediaplayer/services/bilibili/init.lua" )
	else
		include( "mediaplayer/services/bilibili/cl_init.lua" )
	end

	MediaPlayer.RegisterService( SERVICE )
	SERVICE = nil

	print( "[MediaPlayer] Registered Bilibili service" )
	return true
end

-- Wait until gm-mediaplayer is loaded.
hook.Add( "Think", "MediaPlayer_BilibiliSupport_Register", function()
	if TryRegister() then
		hook.Remove( "Think", "MediaPlayer_BilibiliSupport_Register" )
	end
end )
