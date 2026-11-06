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

hook.Add( "PopulateMenuBar", "MediaPlayerOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( MediaPlayer.L("mp.menu.title") )

	m:AddOption( MediaPlayer.L("mp.menu.fullscreen"), function()
		MediaPlayer.ToggleFullscreen()
	end )

	m:AddSpacer()

	m:AddOption( MediaPlayer.L("mp.menu.turn_off_all"), function()
		for _, mp in ipairs(MediaPlayer.GetAll()) do
			MediaPlayer.RequestListen( mp )
		end

		MediaPlayer.HideSidebar()
	end )

end )
