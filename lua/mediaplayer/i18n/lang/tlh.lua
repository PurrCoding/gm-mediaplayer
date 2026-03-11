-- Klingon (tlhIngan Hol)
MediaPlayer.i18n.RegisterLanguage("tlh", {

	-- Idle screen
	["mp.idle.no_media"]                = "QoQ tu'lu'be'! (No songs of battle!)",
	["mp.idle.hint"]                    = "Hold %s while gazing upon the media player to reveal the queue, warrior.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "DaH MUCH (NOW PLAYING)",
	["mp.ui.no_media"]                  = "QoQ tu'lu'be'!",
	["mp.ui.next_up"]                   = "veb (NEXT)",
	["mp.ui.add_media"]                 = "QoQ CHEL (ADD SONG)",
	["mp.ui.added_by"]                  = "CHELTA'",
	["mp.ui.unknown"]                   = "ngoD Sov pagh (Unknown)",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "qaStaHvIS much! (Repeat!)",
	["mp.ui.shuffle"]                   = "mIS much (Shuffle)",
	["mp.ui.toggle_queue_lock"]         = "ngaq toghmey (Toggle Lock)",

	-- Browser controls
	["mp.ui.search_for_media"]          = "QoQ SAM (SEARCH FOR SONGS)",
	["mp.ui.request_url"]               = "URL CHEL",

	-- Context menu properties
	["mp.property.pause"]               = "yImev! (Halt!)",
	["mp.property.resume"]              = "yItaH! (Continue!)",
	["mp.property.skip"]                = "yIghoS! (Move on!)",
	["mp.property.seek"]                = "poH Sam (Seek Time)",
	["mp.property.seek_title"]          = "QoQ jan (Media Player)",
	["mp.property.seek_prompt"]         = "Enter a time in HH:MM:SS format, warrior:",
	["mp.property.seek_confirm"]        = "Qapla'! (Engage!)",
	["mp.property.seek_cancel"]         = "Qo'! (Refuse!)",
	["mp.property.request_url"]         = "URL tlhob (Request URL)",
	["mp.property.copy_url"]            = "URL nob clipboard (Copy URL)",
	["mp.property.fullscreen"]          = "Hoch HaSta (Fullscreen) (F11)",
	["mp.property.turn_on"]             = "yIchu'! (Activate!)",
	["mp.property.turn_off"]            = "yImev! (Deactivate!)",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  QoQ jan (Media Player)",
	["mp.menu.fullscreen"]              = "Hoch HaSta (Fullscreen)",
	["mp.menu.turn_off_all"]            = "Hoch yImev! (Silence All!)",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "URL qab! (The URL is bad!)",
	["mp.error.request_failed"]         = "luj tlhob: %s (Request failed!)",
	["mp.error.audio_load_failed"]      = "QoQ '%s' lujpu'! QI'yaH! (Audio load failed!)",
	["mp.error.audio_stream"]           = "QoQ Hev qab — yInIDqa', petaQ! (Stream error — try again!)",
	["mp.success.url_copied"]           = "URL clipboard-Daq ngebta'. Qapla'! (URL copied!)",

	-- Server notifications
	["mp.error.service_whitelist"]      = "QoQ qablaw'; chaw'ta'bogh pat:\n (Media not supported:)\n",
	["mp.error.queue_locked"]           = "much ngaq! QoQ chellaHbe'! (Queue is locked!)",
	["mp.error.request_denied"]         = "tlhob 'e' botta'! (Request denied!)",
	["mp.error.queue_full"]             = "much buy'! pagh Daq! (Queue is full!)",
	["mp.error.duplicate_request"]      = "QoQ much-Daq tu'lu'! (Already in queue!)",
	["mp.error.metadata_fetch"]         = "De' Suq lujpu'! (Metadata fetch failed!)",
	["mp.error.queue_denied"]           = "QoQ chellaHbe'! (Cannot queue!)",
	["mp.success.added_to_queue"]       = "'%s' much-Daq chellu'pu'. Qapla'! (Added to queue!)",
	["mp.error.no_permission"]          = "chaw' Hutlh SoH, petaQ! (You have no permission!)",
	["mp.error.seek_past_duration"]     = "poH pIq 'oH! Dub QoQ! (Seek time past duration!)",

	-- Settings
	["mp.settings.title"]               = "QUTLUCH (SETTINGS)",
	["mp.settings.audio"]               = "QoQ wab (Audio)",
	["mp.settings.3d_audio"]            = "3D logh wab (3D Spatial Audio)",
	["mp.settings.proximity_min"]       = "chuq mach (Min Distance)",
	["mp.settings.proximity_max"]       = "chuq tIn (Max Distance)",
	["mp.settings.mute_unfocused"]      = "tam qaStaHvIS leSbe' (Mute When Unfocused)",
})