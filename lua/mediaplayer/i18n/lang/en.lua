-- English (Default/Fallback)
MediaPlayer.i18n.RegisterLanguage("en", {

	-- Idle screen
	["mp.idle.no_media"]                = "No media playing",
	["mp.idle.hint"]                    = "Hold %s while looking at the media player to reveal the queue menu.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "CURRENTLY PLAYING",
	["mp.ui.no_media"]                  = "No media playing",
	["mp.ui.next_up"]                   = "NEXT UP",
	["mp.ui.add_media"]                 = "ADD MEDIA",
	["mp.ui.added_by"]                  = "ADDED BY",
	["mp.ui.unknown"]                   = "Unknown",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Repeat",
	["mp.ui.shuffle"]                   = "Shuffle",
	["mp.ui.toggle_queue_lock"]         = "Toggle Queue Lock",

	-- Browser controls
	["mp.ui.search_for_media"]          = "SEARCH FOR MEDIA",
	["mp.ui.request_url"]               = "REQUEST URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pause",
	["mp.property.resume"]              = "Resume",
	["mp.property.skip"]                = "Skip",
	["mp.property.seek"]                = "Seek",
	["mp.property.seek_title"]          = "Media Player",
	["mp.property.seek_prompt"]         = "Enter a time in HH:MM:SS format (hours, minutes, seconds):",
	["mp.property.seek_confirm"]        = "Seek",
	["mp.property.seek_cancel"]         = "Cancel",
	["mp.property.request_url"]         = "Request URL",
	["mp.property.copy_url"]            = "Copy URL to clipboard",
	["mp.property.fullscreen"]          = "Toggle Fullscreen (F11)",
	["mp.property.turn_on"]             = "Turn On",
	["mp.property.turn_off"]            = "Turn Off",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Media Player",
	["mp.menu.fullscreen"]              = "Fullscreen",
	["mp.menu.turn_off_all"]            = "Turn Off All",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "The requested URL was invalid.",
	["mp.error.request_failed"]         = "Request failed: %s",
	["mp.error.audio_load_failed"]      = "Failed to load media player audio '%s'",
	["mp.error.audio_stream"]           = "There was a problem receiving the audio stream, please try again.",
	["mp.success.url_copied"]           = "Media URL has been copied into your clipboard.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "The requested media isn't supported; accepted services are as followed:\n",
	["mp.error.queue_locked"]           = "The requested media couldn't be added as the queue is locked.",
	["mp.error.request_denied"]         = "Your media request has been denied.",
	["mp.error.queue_full"]             = "The media player queue is full.",
	["mp.error.duplicate_request"]      = "The requested media was already in the queue",
	["mp.error.metadata_fetch"]         = "There was a problem fetching the requested media's metadata.",
	["mp.error.queue_denied"]           = "The requested media couldn't be queued.",
	["mp.success.added_to_queue"]       = "Added '%s' to the queue",
	["mp.error.no_permission"]          = "You don't have permission to do that.",
	["mp.error.seek_past_duration"]     = "Request seek time was past the end of the media duration.",

	-- Settings
	["mp.settings.title"]               = "SETTINGS",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D Spatial Audio",
	["mp.settings.proximity_min"]       = "Proximity Min Distance",
	["mp.settings.proximity_max"]       = "Proximity Max Distance",
	["mp.settings.mute_unfocused"]      = "Mute When Unfocused",
	["mp.settings.language"]            = "Language",
	["mp.settings.show_radius"]         = "Show Proximity Radius",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Spatial Media Player",
	["mp.tool.spatial.label"] 			= "Spatial Media",
	["mp.tool.spatial.desc"]            = "Pin MediaPlayer audio to the world or make it follow an entity.",
	["mp.tool.spatial.usage"]           = "Left click: place a spatial source. Right click: remove it.",
	["mp.tool.spatial.help_place"]      = "Left click a prop, player, or NPC to attach a spatial audio source to it. Left click the world to pin one in place.",
	["mp.tool.spatial.help_remove"]     = "Right click a target to remove its spatial source.",
	["mp.tool.spatial.help_sidebar"]    = "To request media or control playback, look at the object and hold C to open the sidebar — it works the same way as any other media player.",
	["mp.tool.spatial.hint_press_c"]    = "Spatial media source placed! Hold C while looking at the object to open the sidebar and request media.",

	-- Spatial player
	["mp.spatial.no_permission"]        = "You don't have permission to control this spatial media source.",
})