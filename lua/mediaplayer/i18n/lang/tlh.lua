-- Klingon / tlhIngan Hol
MediaPlayer.i18n.RegisterLanguage("tlh", {

	-- Idle screen
	["mp.idle.no_media"]                = "pagh much chu'lu'",
	["mp.idle.hint"]                    = "much jan DaleghDI' %s yIqel, much tlhegh HaSta Datu'meH.",
	["mp.idle.press_e"]                 = "E yIchel, leghmeH",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "DaH MUCHLU'",
	["mp.ui.no_media"]                  = "pagh much chu'lu'",
	["mp.ui.next_up"]                   = "ghIq",
	["mp.ui.add_media"]                 = "MUCH CHEL",
	["mp.ui.added_by"]                  = "CHELPU'",
	["mp.ui.unknown"]                   = "Sovbe'lu'",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "qa'",
	["mp.ui.shuffle"]                   = "mIS",
	["mp.ui.toggle_queue_lock"]         = "tlhegh ngaQmoHwI' choH",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MUCH YINEJ",
	["mp.ui.request_url"]               = "URL YITLHOB",

	-- Context menu properties
	["mp.property.pause"]               = "yImev",
	["mp.property.resume"]              = "yItaH",
	["mp.property.skip"]                = "yIlung",
	["mp.property.seek"]                = "yInej",
	["mp.property.seek_title"]          = "much jan",
	["mp.property.seek_prompt"]         = "poH yIngu': HH:MM:SS (rep, tup, lup):",
	["mp.property.seek_confirm"]        = "yInej",
	["mp.property.seek_cancel"]         = "yIqIl",
	["mp.property.request_url"]         = "URL yItlhob",
	["mp.property.copy_url"]            = "URL yIlIng",
	["mp.property.fullscreen"]          = "HaSta naQ choH (F11)",
	["mp.property.turn_on"]             = "yIchu'",
	["mp.property.turn_off"]            = "yImev",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  much jan",
	["mp.menu.fullscreen"]              = "HaSta naQ",
	["mp.menu.turn_off_all"]            = "Hoch yImev",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "URL tlhoblu'bogh potlhbe'.",
	["mp.error.request_failed"]         = "tlhob lujpu': %s",
	["mp.error.audio_load_failed"]      = "QoQ '%s' lIHlaHbe'",
	["mp.error.audio_stream"]           = "QoQ Hev qay'pu'. yInIDqa'.",
	["mp.success.url_copied"]           = "much URL lInglu'pu'.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "much tlhoblu'bogh Qapbe'; lurDechmey chaw'lu'bogh:\n",
	["mp.error.queue_locked"]           = "tlhegh ngaQlu'pu'. much chellaHbe'.",
	["mp.error.request_denied"]         = "much tlhob DatlhobboghDaj 'eHbe'lu'.",
	["mp.error.queue_full"]             = "much jan tlhegh buy'.",
	["mp.error.duplicate_request"]      = "much tlhoblu'bogh tlheghDaq tu'lu'pu'",
	["mp.error.metadata_fetch"]         = "much De' SuqmeH qay'pu'.",
	["mp.error.queue_denied"]           = "much tlhoblu'bogh tlheghDaq chellaHbe'.",
	["mp.error.media_url_failed"]       = "much URL ta'laHbe'.",
	["mp.error.request_error"]          = "[tlhob Qagh] %s",
	["mp.success.added_to_queue"]       = "'%s' tlheghDaq chellu'pu'",
	["mp.error.no_permission"]          = "chaw' Daghajbe'.",
	["mp.error.seek_past_duration"]     = "nej poH tlhoblu'bogh much poH pIq law' Hoch pIq puS.",

	-- Settings
	["mp.settings.title"]               = "QUTLH",
	["mp.settings.audio"]               = "QoQ",
	["mp.settings.3d_audio"]            = "3D logh QoQ",
	["mp.settings.proximity_min"]       = "chuq'a' mIn",
	["mp.settings.proximity_max"]       = "chuq'a' rav",
	["mp.settings.proximity_units"]     = "%s 'uj",
	["mp.settings.mute_unfocused"]      = "buQbe'DI' QoQ yItammoH",
	["mp.settings.language"]            = "Hol",
	["mp.settings.language_auto"]       = "tlhoS (De'wI')",
	["mp.settings.show_radius"]         = "chuq'a' 'aghmeH",
	["mp.settings.subtitles"]           = "ghItlh bIngDaq",
	["mp.settings.subtitles_off"]       = "Qotlh",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "logh much jan",
	["mp.tool.spatial.label"]           = "logh much",
	["mp.tool.spatial.desc"]            = "qo'Daq QoQ yIrarmeH pagh Doch yItlha'moH.",
	["mp.tool.spatial.usage"]           = "poS chel: logh much lan. nIH chel: teq.",
	["mp.tool.spatial.help_place"]      = "Doch, ghot, ghap NPC poS yIchel logh QoQ rarmeH. qo' yIchel lanmeH.",
	["mp.tool.spatial.help_remove"]     = "DoS nIH yIchel logh much teqmeH.",
	["mp.tool.spatial.help_sidebar"]    = "much DatlhobmeH ghap much DaSeHmeH, Doch yIlegh 'ej C yIqel — much jan Hoch rur.",
	["mp.tool.spatial.hint_press_c"]    = "logh much lanlu'pu'! Doch DaleghDI' C yIqel, much DatlhobmeH.",
	["mp.tool.spatial.undo"]            = "logh much",

	-- Spatial player
	["mp.spatial.no_permission"]        = "logh much jan DaSeHmeH chaw' Daghajbe'.",
})