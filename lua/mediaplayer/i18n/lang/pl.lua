-- Polish / Polski
MediaPlayer.i18n.RegisterLanguage("pl", {

	-- Idle screen
	["mp.idle.no_media"]                = "Brak odtwarzanych mediów",
	["mp.idle.hint"]                    = "Przytrzymaj %s, patrząc na odtwarzacz mediów, aby otworzyć menu kolejki.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "TERAZ ODTWARZANE",
	["mp.ui.no_media"]                  = "Brak odtwarzanych mediów",
	["mp.ui.next_up"]                   = "NASTĘPNE",
	["mp.ui.add_media"]                 = "DODAJ MEDIA",
	["mp.ui.added_by"]                  = "DODANE PRZEZ",
	["mp.ui.unknown"]                   = "Nieznany",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Powtarzanie",
	["mp.ui.shuffle"]                   = "Losowanie",
	["mp.ui.toggle_queue_lock"]         = "Przełącz blokadę kolejki",

	-- Browser controls
	["mp.ui.search_for_media"]          = "SZUKAJ MEDIÓW",
	["mp.ui.request_url"]               = "WYŚLIJ URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pauza",
	["mp.property.resume"]              = "Wznów",
	["mp.property.skip"]                = "Pomiń",
	["mp.property.seek"]                = "Przewiń",
	["mp.property.seek_title"]          = "Odtwarzacz mediów",
	["mp.property.seek_prompt"]         = "Wprowadź czas w formacie GG:MM:SS (godziny, minuty, sekundy):",
	["mp.property.seek_confirm"]        = "Przewiń",
	["mp.property.seek_cancel"]         = "Anuluj",
	["mp.property.request_url"]         = "Wyślij URL",
	["mp.property.copy_url"]            = "Kopiuj URL do schowka",
	["mp.property.fullscreen"]          = "Przełącz pełny ekran (F11)",
	["mp.property.turn_on"]             = "Włącz",
	["mp.property.turn_off"]            = "Wyłącz",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Odtwarzacz mediów",
	["mp.menu.fullscreen"]              = "Pełny ekran",
	["mp.menu.turn_off_all"]            = "Wyłącz wszystkie",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Podany URL jest nieprawidłowy.",
	["mp.error.request_failed"]         = "Żądanie nie powiodło się: %s",
	["mp.error.audio_load_failed"]      = "Nie udało się załadować dźwięku odtwarzacza mediów '%s'",
	["mp.error.audio_stream"]           = "Wystąpił problem z odbiorem strumienia audio, spróbuj ponownie.",
	["mp.success.url_copied"]           = "URL mediów został skopiowany do schowka.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Żądane media nie są obsługiwane; akceptowane serwisy to:\n",
	["mp.error.queue_locked"]           = "Żądane media nie mogły zostać dodane, ponieważ kolejka jest zablokowana.",
	["mp.error.request_denied"]         = "Twoje żądanie mediów zostało odrzucone.",
	["mp.error.queue_full"]             = "Kolejka odtwarzacza mediów jest pełna.",
	["mp.error.duplicate_request"]      = "Żądane media znajdują się już w kolejce",
	["mp.error.metadata_fetch"]         = "Wystąpił problem z pobraniem metadanych żądanych mediów.",
	["mp.error.queue_denied"]           = "Żądane media nie mogły zostać dodane do kolejki.",
	["mp.success.added_to_queue"]       = "Dodano '%s' do kolejki",
	["mp.error.no_permission"]          = "Nie masz uprawnień do wykonania tej czynności.",
	["mp.error.seek_past_duration"]     = "Żądany czas przewijania przekroczył czas trwania mediów.",

	-- Settings
	["mp.settings.title"]               = "USTAWIENIA",
	["mp.settings.audio"]               = "Dźwięk",
	["mp.settings.3d_audio"]            = "Dźwięk przestrzenny 3D",
	["mp.settings.proximity_min"]       = "Minimalna odległość",
	["mp.settings.proximity_max"]       = "Maksymalna odległość",
	["mp.settings.mute_unfocused"]      = "Wycisz gdy nieaktywne",
})