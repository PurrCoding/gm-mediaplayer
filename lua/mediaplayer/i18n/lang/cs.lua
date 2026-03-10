-- Czech / Čeština
MediaPlayer.i18n.RegisterLanguage("cs", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nic se nepřehrává",
	["mp.idle.hint"]                    = "Podržte %s a dívejte se na přehrávač médií pro zobrazení nabídky fronty.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "PRÁVĚ SE PŘEHRÁVÁ",
	["mp.ui.no_media"]                  = "Nic se nepřehrává",
	["mp.ui.next_up"]                   = "DALŠÍ",
	["mp.ui.add_media"]                 = "PŘIDAT MÉDIUM",
	["mp.ui.added_by"]                  = "PŘIDAL",
	["mp.ui.unknown"]                   = "Neznámý",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Opakovat",
	["mp.ui.shuffle"]                   = "Náhodně",
	["mp.ui.toggle_queue_lock"]         = "Přepnout zámek fronty",

	-- Browser controls
	["mp.ui.search_for_media"]          = "HLEDAT MÉDIA",
	["mp.ui.request_url"]               = "ZADAT URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pozastavit",
	["mp.property.resume"]              = "Pokračovat",
	["mp.property.skip"]                = "Přeskočit",
	["mp.property.seek"]                = "Přetočit",
	["mp.property.seek_title"]          = "Přehrávač médií",
	["mp.property.seek_prompt"]         = "Zadejte čas ve formátu HH:MM:SS (hodiny, minuty, sekundy):",
	["mp.property.seek_confirm"]        = "Přetočit",
	["mp.property.seek_cancel"]         = "Zrušit",
	["mp.property.request_url"]         = "Zadat URL",
	["mp.property.copy_url"]            = "Kopírovat URL do schránky",
	["mp.property.fullscreen"]          = "Přepnout celou obrazovku (F11)",
	["mp.property.turn_on"]             = "Zapnout",
	["mp.property.turn_off"]            = "Vypnout",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Přehrávač médií",
	["mp.menu.fullscreen"]              = "Celá obrazovka",
	["mp.menu.turn_off_all"]            = "Vypnout vše",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Požadovaná URL byla neplatná.",
	["mp.error.request_failed"]         = "Požadavek selhal: %s",
	["mp.error.audio_load_failed"]      = "Nepodařilo se načíst audio '%s'",
	["mp.error.audio_stream"]           = "Při přijímání audio streamu došlo k problému, zkuste to prosím znovu.",
	["mp.success.url_copied"]           = "URL média byla zkopírována do schránky.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Požadované médium není podporováno; přijímané služby jsou následující:\n",
	["mp.error.queue_locked"]           = "Požadované médium nemohlo být přidáno, protože fronta je uzamčena.",
	["mp.error.request_denied"]         = "Váš požadavek na médium byl zamítnut.",
	["mp.error.queue_full"]             = "Fronta přehrávače médií je plná.",
	["mp.error.duplicate_request"]      = "Požadované médium je již ve frontě",
	["mp.error.metadata_fetch"]         = "Při získávání metadat požadovaného média došlo k problému.",
	["mp.error.queue_denied"]           = "Požadované médium nemohlo být zařazeno do fronty.",
	["mp.success.added_to_queue"]       = "'%s' přidáno do fronty",
	["mp.error.no_permission"]          = "Na toto nemáte oprávnění.",
	["mp.error.seek_past_duration"]     = "Požadovaný čas přetočení přesáhl délku média.",

	-- Settings
	["mp.settings.title"]               = "NASTAVENÍ",
	["mp.settings.audio"]               = "Zvuk",
	["mp.settings.3d_audio"]            = "3D prostorový zvuk",
	["mp.settings.proximity_min"]       = "Minimální vzdálenost",
	["mp.settings.proximity_max"]       = "Maximální vzdálenost",
	["mp.settings.mute_unfocused"]      = "Ztlumit při ztrátě fokusu",
})