-- Pirate Speak
MediaPlayer.i18n.RegisterLanguage("en-PT", {

	-- Idle screen
	["mp.idle.no_media"]                = "No shanties playin'",
	["mp.idle.hint"]                    = "Hold %s while gazin' at the media player to reveal the queue menu, ye scallywag.",
	["mp.idle.press_e"]                 = "Press E to start watchin', matey",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "NOW PLAYIN'",
	["mp.ui.no_media"]                  = "No shanties playin'",
	["mp.ui.next_up"]                   = "NEXT ON DECK",
	["mp.ui.add_media"]                 = "ADD BOOTY",
	["mp.ui.added_by"]                  = "HAULED IN BY",
	["mp.ui.unknown"]                   = "Unknown Scallywag",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Play Again, Matey",
	["mp.ui.shuffle"]                   = "Scramble th' Deck",
	["mp.ui.toggle_queue_lock"]         = "Lock th' Queue, Arr",

	-- Browser controls
	["mp.ui.search_for_media"]          = "SEARCH FER BOOTY",
	["mp.ui.request_url"]               = "REQUEST URL, ARR",

	-- Context menu properties
	["mp.property.pause"]               = "Hold Yer Horses",
	["mp.property.resume"]              = "Set Sail Again",
	["mp.property.skip"]                = "Skip, Ye Landlubber",
	["mp.property.seek"]                = "Chart a New Course",
	["mp.property.seek_title"]          = "Media Player",
	["mp.property.seek_prompt"]         = "Enter a time in HH:MM:SS format (hours, minutes, seconds), savvy?",
	["mp.property.seek_confirm"]        = "Chart Course",
	["mp.property.seek_cancel"]         = "Belay That",
	["mp.property.request_url"]         = "Request URL",
	["mp.property.copy_url"]            = "Swipe URL to clipboard",
	["mp.property.fullscreen"]          = "Toggle Fullscreen (F11)",
	["mp.property.turn_on"]             = "Hoist the Colors",
	["mp.property.turn_off"]            = "Lower the Colors",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Media Player",
	["mp.menu.fullscreen"]              = "Fullscreen",
	["mp.menu.turn_off_all"]            = "Silence All Shanties",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "That URL be no good, matey.",
	["mp.error.request_failed"]         = "Request failed, arr: %s",
	["mp.error.audio_load_failed"]      = "Failed to load th' audio '%s', blast it!",
	["mp.error.audio_stream"]           = "There be a problem receivin' the audio stream, try again ye scurvy dog.",
	["mp.success.url_copied"]           = "Media URL has been swiped to yer clipboard, arr!",

	-- Server notifications
	["mp.error.service_whitelist"]      = "That media be not supported; accepted services be as follows, savvy:\n",
	["mp.error.queue_locked"]           = "The media couldn't be added, the queue be locked tight!",
	["mp.error.request_denied"]         = "Yer media request has been denied, walk the plank!",
	["mp.error.queue_full"]             = "The queue be full to the brim, no room aboard!",
	["mp.error.duplicate_request"]      = "That media already be in the queue, ye bilge rat",
	["mp.error.metadata_fetch"]         = "There be a problem fetchin' the metadata, arr.",
	["mp.error.queue_denied"]           = "The media couldn't be queued up, matey.",
	["mp.error.media_url_failed"]       = "Failed to process that media URL, blast!",
	["mp.error.request_error"]          = "[Request Error] %s",
	["mp.success.added_to_queue"]       = "'%s' added to the queue, yo ho!",
	["mp.error.no_permission"]          = "Ye don't have permission to do that, landlubber!",
	["mp.error.seek_past_duration"]     = "Yer seek time sailed past the end of the media, arr!",

	-- Settings
	["mp.settings.title"]               = "SETTIN'S",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D Spatial Audio",
	["mp.settings.proximity_min"]       = "Proximity Min Distance",
	["mp.settings.proximity_max"]       = "Proximity Max Distance",
	["mp.settings.proximity_units"]     = "%s fathoms",
	["mp.settings.mute_unfocused"]      = "Mute When Unfocused",
	["mp.settings.language"]            = "Tongue",
	["mp.settings.language_auto"]       = "Auto (System)",
	["mp.settings.show_radius"]         = "Show Proximity Radius",
	["mp.settings.subtitles"]           = "Subtitles",
	["mp.settings.subtitles_off"]       = "Off",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Spatial Media Player",
	["mp.tool.spatial.label"]           = "Spatial Media",
	["mp.tool.spatial.desc"]            = "Pin MediaPlayer audio to the world or make it follow a vessel.",
	["mp.tool.spatial.usage"]           = "Left click: place a spatial source. Right click: scuttle it.",
	["mp.tool.spatial.help_place"]      = "Left click a prop, player, or NPC to attach a spatial audio source to it. Left click the world to drop anchor.",
	["mp.tool.spatial.help_remove"]     = "Right click a target to scuttle its spatial source.",
	["mp.tool.spatial.help_sidebar"]    = "To request media or control playback, gaze at the object and hold C to open the sidebar — it works the same as any other media player, savvy?",
	["mp.tool.spatial.hint_press_c"]    = "Spatial media source placed, arr! Hold C while gazin' at the object to open the sidebar and request media.",
	["mp.tool.spatial.undo"]            = "Spatial Media Source",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Ye don't have permission to control this spatial media source, landlubber!",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Browser Limit Reached, Arr!",
	["mp.error.browser_limit_detail"]   = "All browser slots be taken (%d/%d active).",
	["mp.error.browser_limit_note"]     = "Waitin' fer a slot to free up. This be no bug, matey.",
})