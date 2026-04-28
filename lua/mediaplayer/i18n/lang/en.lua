-- English (Default/Fallback)
MediaPlayer.i18n.RegisterLanguage("en", {

	-- Idle screen
	["mp.idle.no_media"]                = "No media playing",
	["mp.idle.hint"]                    = "Hold %s while looking at the media player to reveal the queue menu.",
	["mp.idle.press_e"]                 = "Press E to begin watching",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "CURRENTLY PLAYING",
	["mp.ui.no_media"]                  = "No media playing",
	["mp.ui.next_up"]                   = "NEXT UP",
	["mp.ui.add_media"]                 = "ADD MEDIA",
	["mp.ui.added_by"]                  = "ADDED BY",
	["mp.ui.unknown"]                   = "Unknown",

	-- Voteskip
	["mp.voteskip.already_voted"]   = "You have already voted to skip.",
	["mp.voteskip.vote_cast"]       = "Voteskip: %d/%d votes (%d more needed)",
	["mp.voteskip.passed"]          = "Voteskip passed! Skipping...",

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
	["mp.error.media_url_failed"]       = "Failed to process media URL.",
	["mp.error.request_error"]          = "[Request Error] %s",
	["mp.success.added_to_queue"]       = "Added '%s' to the queue",
	["mp.error.no_permission"]          = "You don't have permission to do that.",
	["mp.error.seek_past_duration"]     = "Request seek time was past the end of the media duration.",

	-- Settings
	["mp.settings.title"]               = "SETTINGS",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D Spatial Audio",
	["mp.settings.proximity_min"]       = "Proximity Min Distance",
	["mp.settings.proximity_max"]       = "Proximity Max Distance",
	["mp.settings.proximity_units"]     = "%s units",
	["mp.settings.mute_unfocused"]      = "Mute When Unfocused",
	["mp.settings.show_radius"]         = "Show Proximity Radius",
	["mp.settings.subtitles"]           = "Subtitles",
	["mp.settings.subtitles_off"]       = "Off",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Spatial Media Player",
	["mp.tool.spatial.label"]           = "Spatial Media",
	["mp.tool.spatial.desc"]            = "Pin MediaPlayer audio to the world or make it follow an entity.",
	["mp.tool.spatial.usage"]           = "Left click: place a spatial source. Right click: remove it.",
	["mp.tool.spatial.help_place"]      = "Left click a prop, player, or NPC to attach a spatial audio source to it. Left click the world to pin one in place.",
	["mp.tool.spatial.help_remove"]     = "Right click a target to remove its spatial source.",
	["mp.tool.spatial.help_sidebar"]    = "To request media or control playback, look at the object and hold C to open the sidebar — it works the same way as any other media player.",
	["mp.tool.spatial.hint_press_c"]    = "Spatial media source placed! Hold C while looking at the object to open the sidebar and request media.",
	["mp.tool.spatial.undo"]            = "Spatial Media Source",

	-- Spatial player
	["mp.spatial.no_permission"]        = "You don't have permission to control this spatial media source.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Browser Limit Reached",
	["mp.error.browser_limit_detail"]   = "All browser slots are in use (%d/%d active).",
	["mp.error.browser_limit_note"]     = "Waiting for a slot to free up. This is not a bug.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Mimic Media Player",
	["mp.tool.mimic.desc"]              = "Mirror another media player's video output onto a second screen.",
	["mp.tool.mimic.usage"]             = "Left click: copy source. Right click: paste onto target(s). Reload (R): remove mimic.",
	["mp.tool.mimic.help_copy"]         = "Left click a media player to copy it as the video source.",
	["mp.tool.mimic.help_paste"]        = "Right click other media players to paste — they will mirror the source. You can paste onto multiple screens.",
	["mp.tool.mimic.help_remove"]       = "Press Reload (R) on a mimic player to remove it and restore the original.",
	["mp.tool.mimic.source_copied"]     = "Source copied! Right click other media players to paste.",
	["mp.tool.mimic.pasted"]            = "Mimic applied! This screen now mirrors the source.",
	["mp.tool.mimic.removed"]           = "Mimic removed. Entity restored to normal.",
	["mp.tool.mimic.undo"]              = "Mimic Media Player",
	["mp.tool.mimic.error_spatial"]     = "Cannot mimic a spatial media player.",
	["mp.tool.mimic.error_same"]        = "Source and target cannot be the same entity.",
	["mp.tool.mimic.error_no_source"]   = "No source copied yet. Left click a media player first.",
	["mp.tool.mimic.error_source_gone"] = "The copied source no longer exists. Left click a new source.",
	["mp.tool.mimic.error_mimic_source"] = "Cannot copy from a mimic player. Copy from the original source instead.",
	["mp.tool.mimic.error_already_linked"] = "This entity is already mimicing that source.",
	["mp.tool.mimic.error_not_mimic"]  = "This entity is not a mimic player.",
	["mp.tool.mimic.error_has_content"] = "Cannot mimic a media player that is currently serving its own content. Stop or clear its media first.",
})