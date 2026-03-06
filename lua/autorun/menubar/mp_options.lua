hook.Add( "PopulateMenuBar", "MediaPlayerOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( MediaPlayer.L("mp.menu.title") )

	m:AddCVar( MediaPlayer.L("mp.menu.fullscreen"), "mediaplayer_fullscreen", "1", "0")

	m:AddSpacer()

	m:AddOption( MediaPlayer.L("mp.menu.turn_off_all"), function()
		for _, mp in ipairs(MediaPlayer.GetAll()) do
			MediaPlayer.RequestListen( mp )
		end

		MediaPlayer.HideSidebar()
	end )

end )
