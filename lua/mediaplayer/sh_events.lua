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
