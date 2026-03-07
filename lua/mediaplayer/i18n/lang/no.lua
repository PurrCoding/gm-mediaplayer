-- Norwegian / Norsk
MediaPlayer.i18n.RegisterLanguage("no", {

	-- Idle screen
	["mp.idle.no_media"]                = "Ingen media spilles",
	["mp.idle.hint"]                    = "Hold %s mens du ser på mediespilleren for å åpne kømenyen.",

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
	["mp.property.seek_title"]          = "Mediespiller",
	["mp.property.seek_prompt"]         = "Skriv inn et tidspunkt i TT:MM:SS-format (timer, minutter, sekunder):",
	["mp.property.seek_confirm"]        = "Spol",
	["mp.property.seek_cancel"]         = "Avbryt",
	["mp.property.request_url"]         = "Be om URL",
	["mp.property.copy_url"]            = "Kopier URL til utklippstavlen",
	["mp.property.fullscreen"]          = "Veksle fullskjerm (F11)",
	["mp.property.turn_on"]             = "Slå på",
	["mp.property.turn_off"]            = "Slå av",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediespiller",
	["mp.menu.fullscreen"]              = "Fullskjerm",
	["mp.menu.turn_off_all"]            = "Slå av alle",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Den forespurte URL-en var ugyldig.",
	["mp.error.request_failed"]         = "Forespørsel mislyktes: %s",
	["mp.error.audio_load_failed"]      = "Kunne ikke laste inn mediespillerlyd '%s'",
	["mp.error.audio_stream"]           = "Det oppstod et problem med å motta lydstrømmen, vennligst prøv igjen.",
	["mp.success.url_copied"]           = "Medie-URL-en er kopiert til utklippstavlen.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Det forespurte mediet støttes ikke; godkjente tjenester er som følger:\n",
	["mp.error.queue_locked"]           = "Det forespurte mediet kunne ikke legges til fordi køen er låst.",
	["mp.error.request_denied"]         = "Medieforespørselen din ble avvist.",
	["mp.error.queue_full"]             = "Mediespillerens kø er full.",
	["mp.error.duplicate_request"]      = "Det forespurte mediet er allerede i køen",
	["mp.error.metadata_fetch"]         = "Det oppstod et problem med å hente metadata for det forespurte mediet.",
	["mp.error.queue_denied"]           = "Det forespurte mediet kunne ikke legges i køen.",
	["mp.success.added_to_queue"]       = "'%s' lagt til i køen",
	["mp.error.no_permission"]          = "Du har ikke tillatelse til å gjøre det.",
	["mp.error.seek_past_duration"]     = "Den forespurte spoletiden var forbi slutten av mediets varighet.",
})