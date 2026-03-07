-- Hungarian / Magyar
MediaPlayer.i18n.RegisterLanguage("hu", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nincs lejátszott média",
	["mp.idle.hint"]                    = "Tartsd lenyomva a(z) %s gombot, miközben a médialejátszóra nézel, hogy megjelenjen a sorban állás menü.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "JELENLEG JÁTSZOTT",
	["mp.ui.no_media"]                  = "Nincs lejátszott média",
	["mp.ui.next_up"]                   = "KÖVETKEZŐ",
	["mp.ui.add_media"]                 = "MÉDIA HOZZÁADÁSA",
	["mp.ui.added_by"]                  = "HOZZÁADTA",
	["mp.ui.unknown"]                   = "Ismeretlen",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Ismétlés",
	["mp.ui.shuffle"]                   = "Keverés",
	["mp.ui.toggle_queue_lock"]         = "Sor zárolásának átkapcsolása",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MÉDIA KERESÉSE",
	["mp.ui.request_url"]               = "URL KÉRÉSE",

	-- Context menu properties
	["mp.property.pause"]               = "Szünet",
	["mp.property.resume"]              = "Folytatás",
	["mp.property.skip"]                = "Kihagyás",
	["mp.property.seek"]                = "Tekerés",
	["mp.property.seek_title"]          = "Médialejátszó",
	["mp.property.seek_prompt"]         = "Add meg az időt ÓÓ:PP:MM formátumban (óra, perc, másodperc):",
	["mp.property.seek_confirm"]        = "Tekerés",
	["mp.property.seek_cancel"]         = "Mégse",
	["mp.property.request_url"]         = "URL kérése",
	["mp.property.copy_url"]            = "URL másolása a vágólapra",
	["mp.property.fullscreen"]          = "Teljes képernyő átkapcsolása (F11)",
	["mp.property.turn_on"]             = "Bekapcsolás",
	["mp.property.turn_off"]            = "Kikapcsolás",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Médialejátszó",
	["mp.menu.fullscreen"]              = "Teljes képernyő",
	["mp.menu.turn_off_all"]            = "Összes kikapcsolása",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "A kért URL érvénytelen.",
	["mp.error.request_failed"]         = "A kérés sikertelen: %s",
	["mp.error.audio_load_failed"]      = "Nem sikerült betölteni a médialejátszó hangját: '%s'",
	["mp.error.audio_stream"]           = "Hiba történt a hangfolyam fogadásakor, kérjük próbáld újra.",
	["mp.success.url_copied"]           = "A média URL-je a vágólapra másolva.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "A kért média nem támogatott; az elfogadott szolgáltatások a következők:\n",
	["mp.error.queue_locked"]           = "A kért média nem adható hozzá, mert a sor zárolva van.",
	["mp.error.request_denied"]         = "A médiakérésed elutasítva.",
	["mp.error.queue_full"]             = "A médialejátszó sora megtelt.",
	["mp.error.duplicate_request"]      = "A kért média már a sorban van",
	["mp.error.metadata_fetch"]         = "Hiba történt a kért média metaadatainak lekérésekor.",
	["mp.error.queue_denied"]           = "A kért média nem helyezhető a sorba.",
	["mp.success.added_to_queue"]       = "'%s' hozzáadva a sorhoz",
	["mp.error.no_permission"]          = "Nincs jogosultságod ehhez a művelethez.",
	["mp.error.seek_past_duration"]     = "A kért tekerési idő meghaladta a média időtartamát.",
})