-- Pirate Speak
MediaPlayer.i18n.RegisterLanguage("en-PT", {

	-- Idle screen
	["mp.idle.no_media"]                = "No shanties playin'",
	["mp.idle.hint"]                    = "Hold %s while gazin' at the media player to reveal the queue menu, ye scallywag.",

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
	["mp.success.added_to_queue"]       = "'%s' added to the queue, yo ho!",
	["mp.error.no_permission"]          = "Ye don't have permission to do that, landlubber!",
	["mp.error.seek_past_duration"]     = "Yer seek time sailed past the end of the media, arr!",
})