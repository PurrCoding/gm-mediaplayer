-- Polish / Polski
MediaPlayer.i18n.RegisterLanguage("pl", {

	-- Idle screen
	["mp.idle.no_media"]                = "Brak odtwarzanych mediów",
	["mp.idle.hint"]                    = "Przytrzymaj %s patrząc na odtwarzacz mediów, aby wyświetlić menu kolejki.",
	["mp.idle.press_e"]                 = "Naciśnij E, aby rozpocząć oglądanie",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "TERAZ ODTWARZANE",
	["mp.ui.no_media"]                  = "Brak odtwarzanych mediów",
	["mp.ui.next_up"]                   = "NASTĘPNE",
	["mp.ui.add_media"]                 = "DODAJ MEDIUM",
	["mp.ui.added_by"]                  = "DODANE PRZEZ",
	["mp.ui.unknown"]                   = "Nieznany",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Powtórz",
	["mp.ui.shuffle"]                   = "Losowo",
	["mp.ui.toggle_queue_lock"]         = "Przełącz blokadę kolejki",

	-- Browser controls
	["mp.ui.search_for_media"]          = "SZUKAJ MEDIÓW",
	["mp.ui.request_url"]               = "POPROŚ O URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pauza",
	["mp.property.resume"]              = "Wznów",
	["mp.property.skip"]                = "Pomiń",
	["mp.property.seek"]                = "Przewiń",
	["mp.property.seek_title"]          = "Odtwarzacz mediów",
	["mp.property.seek_prompt"]         = "Wprowadź czas w formacie GG:MM:SS (godziny, minuty, sekundy):",
	["mp.property.seek_confirm"]        = "Przewiń",
	["mp.property.seek_cancel"]         = "Anuluj",
	["mp.property.request_url"]         = "Poproś o URL",
	["mp.property.copy_url"]            = "Kopiuj URL do schowka",
	["mp.property.fullscreen"]          = "Przełącz pełny ekran (F11)",
	["mp.property.turn_on"]             = "Włącz",
	["mp.property.turn_off"]            = "Wyłącz",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Odtwarzacz mediów",
	["mp.menu.fullscreen"]              = "Pełny ekran",
	["mp.menu.turn_off_all"]            = "Wyłącz wszystko",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Podany URL był nieprawidłowy.",
	["mp.error.request_failed"]         = "Żądanie nie powiodło się: %s",
	["mp.error.audio_load_failed"]      = "Nie udało się załadować dźwięku '%s'",
	["mp.error.audio_stream"]           = "Wystąpił problem z odbiorem strumienia audio, spróbuj ponownie.",
	["mp.success.url_copied"]           = "URL mediów został skopiowany do schowka.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Żądane medium nie jest obsługiwane; akceptowane usługi to:\n",
	["mp.error.queue_locked"]           = "Nie można dodać mediów, ponieważ kolejka jest zablokowana.",
	["mp.error.request_denied"]         = "Twoje żądanie mediów zostało odrzucone.",
	["mp.error.queue_full"]             = "Kolejka odtwarzacza mediów jest pełna.",
	["mp.error.duplicate_request"]      = "Żądane medium jest już w kolejce",
	["mp.error.metadata_fetch"]         = "Wystąpił problem z pobieraniem metadanych żądanego medium.",
	["mp.error.queue_denied"]           = "Żądane medium nie mogło zostać dodane do kolejki.",
	["mp.error.media_url_failed"]       = "Nie udało się przetworzyć URL mediów.",
	["mp.error.request_error"]          = "[Błąd żądania] %s",
	["mp.success.added_to_queue"]       = "'%s' dodano do kolejki",
	["mp.error.no_permission"]          = "Nie masz uprawnień, aby to zrobić.",
	["mp.error.seek_past_duration"]     = "Żądany czas przewijania przekroczył czas trwania mediów.",

	-- Settings
	["mp.settings.title"]               = "USTAWIENIA",
	["mp.settings.audio"]               = "Dźwięk",
	["mp.settings.3d_audio"]            = "Dźwięk przestrzenny 3D",
	["mp.settings.proximity_min"]       = "Minimalna odległość bliskości",
	["mp.settings.proximity_max"]       = "Maksymalna odległość bliskości",
	["mp.settings.proximity_units"]     = "%s jednostek",
	["mp.settings.mute_unfocused"]      = "Wycisz gdy nieaktywne",
	["mp.settings.language"]            = "Język",
	["mp.settings.language_auto"]       = "Automatyczny (systemowy)",
	["mp.settings.show_radius"]         = "Pokaż promień bliskości",
	["mp.settings.subtitles"]           = "Napisy",
	["mp.settings.subtitles_off"]       = "Wyłączone",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Przestrzenny odtwarzacz mediów",
	["mp.tool.spatial.label"]           = "Media przestrzenne",
	["mp.tool.spatial.desc"]            = "Przypnij dźwięk MediaPlayer do świata lub pozwól mu podążać za obiektem.",
	["mp.tool.spatial.usage"]           = "Lewy klik: umieść źródło przestrzenne. Prawy klik: usuń.",
	["mp.tool.spatial.help_place"]      = "Kliknij lewym przyciskiem na prop, gracza lub NPC, aby dołączyć przestrzenne źródło dźwięku. Kliknij na świat, aby przypiąć je w miejscu.",
	["mp.tool.spatial.help_remove"]     = "Kliknij prawym przyciskiem na cel, aby usunąć jego źródło przestrzenne.",
	["mp.tool.spatial.help_sidebar"]    = "Aby poprosić o media lub sterować odtwarzaniem, patrz na obiekt i przytrzymaj C, aby otworzyć panel boczny — działa tak samo jak każdy inny odtwarzacz mediów.",
	["mp.tool.spatial.hint_press_c"]    = "Źródło mediów przestrzennych umieszczone! Przytrzymaj C patrząc na obiekt, aby otworzyć panel boczny i poprosić o media.",
	["mp.tool.spatial.undo"]            = "Źródło mediów przestrzennych",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Nie masz uprawnień do sterowania tym źródłem mediów przestrzennych.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Osiągnięto limit przeglądarek",
	["mp.error.browser_limit_detail"]   = "Wszystkie sloty przeglądarki są zajęte (%d/%d aktywnych).",
	["mp.error.browser_limit_note"]     = "Oczekiwanie na zwolnienie slotu. To nie jest błąd.",
})