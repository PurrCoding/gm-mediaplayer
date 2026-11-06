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

MP.EVENTS = {
	MEDIA_CHANGED = "mediaChanged",
	QUEUE_CHANGED = "mp.events.queueChanged",
	PLAYER_STATE_CHANGED = "mp.events.playerStateChanged"
}

if CLIENT then

	table.Merge( MP.EVENTS, {
		VOLUME_CHANGED = "mp.events.volumeChanged",
		FULLSCREEN_STATE_CHANGED = "mp.events.fullscreenStateChanged"
	} )

end
