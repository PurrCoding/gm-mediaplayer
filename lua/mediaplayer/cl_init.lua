if MediaPlayer then
	if MediaPlayer.__refresh then
		MediaPlayer.__refresh = nil
	else
		return -- MediaPlayer has already been registered
	end
end

include "controls/dmediaplayerhtml.lua"
include "controls/dhtmlcontrols.lua"
include "controls/dmediaplayerrequest.lua"
include "shared.lua"
include "cl_requests.lua"
include "cl_idlescreen.lua"
include "cl_screen.lua"

function MediaPlayer.Volume( volume )

	local cur = MediaPlayer.Cvars.Volume:GetFloat()

	if volume then

		-- Normalize volume
		volume = volume > 1 and volume / 100 or volume

		-- Set volume convar
		RunConsoleCommand( "mediaplayer_volume", volume )

		hook.Run( MP.EVENTS.VOLUME_CHANGED, volume, cur )

		cur = volume

	end

	return cur

end

local muted = false
local previousVolume
function MediaPlayer.ToggleMute()
	if not muted then
		previousVolume = MediaPlayer.Volume()
	end

	local vol = muted and previousVolume or 0
	MediaPlayer.Volume( vol )
	muted = not muted
end

function MediaPlayer.Resolution( resolution )

	if resolution then
		resolution = math.Clamp( resolution, 16, 4096 )
		RunConsoleCommand( "mediaplayer_resolution", resolution )
	end

	return MediaPlayer.Cvars.Resolution:GetFloat()

end


--[[---------------------------------------------------------
	Utility functions
-----------------------------------------------------------]]

function MediaPlayer.SetBrowserSize( browser, w, h, mp )

	local fullscreen = IsValid(mp) and mp._isFullscreen

	if fullscreen then
		w, h = ScrW(), ScrH()
	end

	browser:SetSize( w, h, fullscreen )
end

function MediaPlayer.OpenRequestMenu( mp )

	if IsValid(MediaPlayer._RequestMenu) then
		return
	end

	mp = MediaPlayer.GetByObject( mp )

	if not mp then
		Error( "MediaPlayer.OpenRequestMenu: Invalid media player.\n" )
		return
	end

	local req = vgui.Create( "MPRequestFrame" )
	req:SetMediaPlayer( mp )
	req:MakePopup()
	req:Center()

	req.OnClose = function()
		MediaPlayer._RequestMenu = nil
	end

	MediaPlayer._RequestMenu = req

end

function MediaPlayer.MenuRequest( url )

	local menu = MediaPlayer._RequestMenu

	if not IsValid(menu) then
		return
	end

	local mp = menu:GetMediaPlayer()

	menu:Close()

	MediaPlayer.Request( mp, url )

end


--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]

local common = {
	font		= "Roboto Medium",
	antialias	= true,
	extended	= true,
	weight		= 400
}

surface.CreateFont( "MediaTitle", table.Merge(common, { size = 72 }) )
surface.CreateFont( "MediaRequestButton", table.Merge(common, { size = 26 }) )
