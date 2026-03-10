-- Dutch / Nederlands
MediaPlayer.i18n.RegisterLanguage("nl", {

	-- Idle screen
	["mp.idle.no_media"]                = "Geen media aan het afspelen",
	["mp.idle.hint"]                    = "Houd %s ingedrukt terwijl je naar de mediaspeler kijkt om het wachtrijmenu te openen.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "NU AAN HET AFSPELEN",
	["mp.ui.no_media"]                  = "Geen media aan het afspelen",
	["mp.ui.next_up"]                   = "VOLGENDE",
	["mp.ui.add_media"]                 = "MEDIA TOEVOEGEN",
	["mp.ui.added_by"]                  = "TOEGEVOEGD DOOR",
	["mp.ui.unknown"]                   = "Onbekend",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Herhalen",
	["mp.ui.shuffle"]                   = "Willekeurig",
	["mp.ui.toggle_queue_lock"]         = "Wachtrijvergrendeling aan/uit",

	-- Browser controls
	["mp.ui.search_for_media"]          = "ZOEK NAAR MEDIA",
	["mp.ui.request_url"]               = "URL AANVRAGEN",

	-- Context menu properties
	["mp.property.pause"]               = "Pauzeren",
	["mp.property.resume"]              = "Hervatten",
	["mp.property.skip"]                = "Overslaan",
	["mp.property.seek"]                = "Spoelen",
	["mp.property.seek_title"]          = "Mediaspeler",
	["mp.property.seek_prompt"]         = "Voer een tijd in HH:MM:SS-formaat in (uren, minuten, seconden):",
	["mp.property.seek_confirm"]        = "Spoelen",
	["mp.property.seek_cancel"]         = "Annuleren",
	["mp.property.request_url"]         = "URL aanvragen",
	["mp.property.copy_url"]            = "URL naar klembord kopiëren",
	["mp.property.fullscreen"]          = "Volledig scherm aan/uit (F11)",
	["mp.property.turn_on"]             = "Inschakelen",
	["mp.property.turn_off"]            = "Uitschakelen",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediaspeler",
	["mp.menu.fullscreen"]              = "Volledig scherm",
	["mp.menu.turn_off_all"]            = "Alles uitschakelen",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "De opgevraagde URL was ongeldig.",
	["mp.error.request_failed"]         = "Aanvraag mislukt: %s",
	["mp.error.audio_load_failed"]      = "Kan mediaspeler-audio '%s' niet laden",
	["mp.error.audio_stream"]           = "Er was een probleem bij het ontvangen van de audiostream, probeer het opnieuw.",
	["mp.success.url_copied"]           = "De media-URL is naar het klembord gekopieerd.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "De opgevraagde media wordt niet ondersteund; geaccepteerde diensten zijn als volgt:\n",
	["mp.error.queue_locked"]           = "De opgevraagde media kon niet worden toegevoegd omdat de wachtrij vergrendeld is.",
	["mp.error.request_denied"]         = "Je media-aanvraag is geweigerd.",
	["mp.error.queue_full"]             = "De wachtrij van de mediaspeler is vol.",
	["mp.error.duplicate_request"]      = "De opgevraagde media staat al in de wachtrij",
	["mp.error.metadata_fetch"]         = "Er was een probleem bij het ophalen van de metadata van de opgevraagde media.",
	["mp.error.queue_denied"]           = "De opgevraagde media kon niet in de wachtrij worden geplaatst.",
	["mp.success.added_to_queue"]       = "'%s' is aan de wachtrij toegevoegd",
	["mp.error.no_permission"]          = "Je hebt geen toestemming om dat te doen.",
	["mp.error.seek_past_duration"]     = "De opgevraagde spoeltijd lag voorbij het einde van de mediaduur.",

	-- Settings
	["mp.settings.title"]               = "INSTELLINGEN",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D ruimtelijk geluid",
	["mp.settings.proximity_min"]       = "Minimale afstand",
	["mp.settings.proximity_max"]       = "Maximale afstand",
	["mp.settings.mute_unfocused"]      = "Dempen wanneer niet gefocust",
})