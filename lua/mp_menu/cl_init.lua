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

MP = MP or {}
MP.EVENTS = MP.EVENTS or {}

MP.EVENTS.UI = {

	--[[--------------------------------------------------------
		Sidebar events
	----------------------------------------------------------]]

	SETUP_SIDEBAR = "mp.events.ui.sidebarChanged",
	SETUP_PLAYBACK_PANEL = "mp.events.ui.setupPlaybackPanel",
	SETUP_MEDIA_PANEL = "mp.events.ui.setupMediaPanel",

	MEDIA_PLAYER_CHANGED = "mp.events.ui.mediaPlayerChanged",

	OPEN_REQUEST_MENU = "mp.events.ui.openRequestMenu",
	REMOVE_MEDIA = "mp.events.ui.removeMedia",
	SKIP_MEDIA = "mp.events.ui.skipMedia",
	TOGGLE_LOCK = "mp.events.ui.toggleLock",
	TOGGLE_PAUSE = "mp.events.ui.togglePause",
	TOGGLE_REPEAT = "mp.events.ui.toggleRepeat",
	TOGGLE_SHUFFLE = "mp.events.ui.toggleShuffle",
	SEEK = "mp.events.ui.seek",

	START_SEEKING = "mp.events.ui.startSeeking",
	STOP_SEEKING = "mp.events.ui.stopSeeking",

	PRIVILEGED_PLAYER = "mp.events.ui.privilegedPlayer"

}

include "sidebar.lua"
