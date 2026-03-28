-- Norwegian / Norsk
MediaPlayer.i18n.RegisterLanguage("no", {

	-- Idle screen
	["mp.idle.no_media"]                = "Ingen media spilles",
	["mp.idle.hint"]                    = "Hold %s mens du ser på mediaspilleren for å vise kømenyen.",
	["mp.idle.press_e"]                 = "Trykk E for å begynne å se",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "SPILLES NÅ",
	["mp.ui.no_media"]                  = "Ingen media spilles",
	["mp.ui.next_up"]                   = "NESTE",
	["mp.ui.add_media"]                 = "LEGG TIL MEDIA",
	["mp.ui.added_by"]                  = "LAGT TIL AV",
	["mp.ui.unknown"]                   = "Ukjent",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Gjenta",
	["mp.ui.shuffle"]                   = "Tilfeldig",
	["mp.ui.toggle_queue_lock"]         = "Veksle kølås",

	-- Browser controls
	["mp.ui.search_for_media"]          = "SØK ETTER MEDIA",
	["mp.ui.request_url"]               = "BE OM URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pause",
	["mp.property.resume"]              = "Fortsett",
	["mp.property.skip"]                = "Hopp over",
	["mp.property.seek"]                = "Spol",
	["mp.property.seek_title"]          = "Mediaspiller",
	["mp.property.seek_prompt"]         = "Skriv inn tid i TT:MM:SS-format (timer, minutter, sekunder):",
	["mp.property.seek_confirm"]        = "Spol",
	["mp.property.seek_cancel"]         = "Avbryt",
	["mp.property.request_url"]         = "Be om URL",
	["mp.property.copy_url"]            = "Kopier URL til utklippstavlen",
	["mp.property.fullscreen"]          = "Veksle fullskjerm (F11)",
	["mp.property.turn_on"]             = "Slå på",
	["mp.property.turn_off"]            = "Slå av",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediaspiller",
	["mp.menu.fullscreen"]              = "Fullskjerm",
	["mp.menu.turn_off_all"]            = "Slå av alle",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Den forespurte URL-en var ugyldig.",
	["mp.error.request_failed"]         = "Forespørsel mislyktes: %s",
	["mp.error.audio_load_failed"]      = "Kunne ikke laste inn lyd '%s'",
	["mp.error.audio_stream"]           = "Det oppstod et problem med å motta lydstrømmen, vennligst prøv igjen.",
	["mp.success.url_copied"]           = "Medie-URL-en er kopiert til utklippstavlen.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Det forespurte mediet støttes ikke; aksepterte tjenester er som følger:\n",
	["mp.error.queue_locked"]           = "Mediet kunne ikke legges til fordi køen er låst.",
	["mp.error.request_denied"]         = "Medieforespørselen din ble avvist.",
	["mp.error.queue_full"]             = "Mediaspillerens kø er full.",
	["mp.error.duplicate_request"]      = "Det forespurte mediet er allerede i køen",
	["mp.error.metadata_fetch"]         = "Det oppstod et problem med å hente metadata for det forespurte mediet.",
	["mp.error.queue_denied"]           = "Det forespurte mediet kunne ikke legges i køen.",
	["mp.error.media_url_failed"]       = "Kunne ikke behandle medie-URL-en.",
	["mp.error.request_error"]          = "[Forespørselsfeil] %s",
	["mp.success.added_to_queue"]       = "'%s' lagt til i køen",
	["mp.error.no_permission"]          = "Du har ikke tillatelse til å gjøre det.",
	["mp.error.seek_past_duration"]     = "Den forespurte spoletiden var forbi slutten av mediets varighet.",

	-- Settings
	["mp.settings.title"]               = "INNSTILLINGER",
	["mp.settings.audio"]               = "Lyd",
	["mp.settings.3d_audio"]            = "3D romlig lyd",
	["mp.settings.proximity_min"]       = "Minimum nærhet",
	["mp.settings.proximity_max"]       = "Maksimum nærhet",
	["mp.settings.proximity_units"]     = "%s enheter",
	["mp.settings.mute_unfocused"]      = "Demp når ufokusert",
	["mp.settings.language"]            = "Språk",
	["mp.settings.language_auto"]       = "Automatisk (system)",
	["mp.settings.show_radius"]         = "Vis nærhetsradius",
	["mp.settings.subtitles"]           = "Undertekster",
	["mp.settings.subtitles_off"]       = "Av",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Romlig mediaspiller",
	["mp.tool.spatial.label"]           = "Romlig media",
	["mp.tool.spatial.desc"]            = "Fest MediaPlayer-lyd til verden eller la den følge en entitet.",
	["mp.tool.spatial.usage"]           = "Venstreklikk: plasser en romlig kilde. Høyreklikk: fjern.",
	["mp.tool.spatial.help_place"]      = "Venstreklikk på en prop, spiller eller NPC for å feste en romlig lydkilde. Klikk på verden for å feste den på stedet.",
	["mp.tool.spatial.help_remove"]     = "Høyreklikk på et mål for å fjerne den romlige kilden.",
	["mp.tool.spatial.help_sidebar"]    = "For å be om media eller kontrollere avspilling, se på objektet og hold C for å åpne sidepanelet — det fungerer på samme måte som enhver annen mediaspiller.",
	["mp.tool.spatial.hint_press_c"]    = "Romlig mediekilde plassert! Hold C mens du ser på objektet for å åpne sidepanelet og be om media.",
	["mp.tool.spatial.undo"]            = "Romlig mediekilde",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Du har ikke tillatelse til å kontrollere denne romlige mediekilden.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Nettlesergrense nådd",
	["mp.error.browser_limit_detail"]   = "Alle nettleserplasser er i bruk (%d/%d aktive).",
	["mp.error.browser_limit_note"]     = "Venter på at en plass skal bli ledig. Dette er ikke en feil.",
})