-- Dutch / Nederlands
MediaPlayer.i18n.RegisterLanguage("nl", {

	-- Idle screen
	["mp.idle.no_media"]                = "Geen media aan het afspelen",
	["mp.idle.hint"]                    = "Houd %s ingedrukt terwijl je naar de mediaspeler kijkt om het wachtrijmenu te openen.",
	["mp.idle.press_e"]                 = "Druk op E om te beginnen met kijken",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "NU AAN HET AFSPELEN",
	["mp.ui.no_media"]                  = "Geen media aan het afspelen",
	["mp.ui.next_up"]                   = "VOLGENDE",
	["mp.ui.add_media"]                 = "MEDIA TOEVOEGEN",
	["mp.ui.added_by"]                  = "TOEGEVOEGD DOOR",
	["mp.ui.unknown"]                   = "Onbekend",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "Je hebt al gestemd om over te slaan.",
	["mp.voteskip.vote_cast"]           = "Stemming: %d/%d stemmen (nog %d nodig)",
	["mp.voteskip.passed"]              = "Stemming aangenomen! Overslaan...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Herhalen",
	["mp.ui.shuffle"]                   = "Willekeurig",
	["mp.ui.toggle_queue_lock"]         = "Wachtrijvergrendeling aan/uit",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MEDIA ZOEKEN",
	["mp.ui.request_url"]               = "URL AANVRAGEN",

	-- Context menu properties
	["mp.property.pause"]               = "Pauzeren",
	["mp.property.resume"]              = "Hervatten",
	["mp.property.skip"]                = "Overslaan",
	["mp.property.seek"]                = "Zoeken",
	["mp.property.seek_title"]          = "Mediaspeler",
	["mp.property.seek_prompt"]         = "Voer een tijd in HH:MM:SS-formaat in (uren, minuten, seconden):",
	["mp.property.seek_confirm"]        = "Zoeken",
	["mp.property.seek_cancel"]         = "Annuleren",
	["mp.property.request_url"]         = "URL aanvragen",
	["mp.property.copy_url"]            = "URL naar klembord kopiëren",
	["mp.property.fullscreen"]          = "Volledig scherm schakelen (F11)",
	["mp.property.turn_on"]             = "Inschakelen",
	["mp.property.turn_off"]            = "Uitschakelen",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediaspeler",
	["mp.menu.fullscreen"]              = "Volledig scherm",
	["mp.menu.turn_off_all"]            = "Alles uitschakelen",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "De aangevraagde URL was ongeldig.",
	["mp.error.request_failed"]         = "Aanvraag mislukt: %s",
	["mp.error.audio_load_failed"]      = "Kan audio '%s' niet laden",
	["mp.error.audio_stream"]           = "Er was een probleem bij het ontvangen van de audiostream, probeer het opnieuw.",
	["mp.success.url_copied"]           = "De media-URL is naar het klembord gekopieerd.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "De aangevraagde media wordt niet ondersteund; geaccepteerde diensten zijn als volgt:\n",
	["mp.error.queue_locked"]           = "De media kon niet worden toegevoegd omdat de wachtrij vergrendeld is.",
	["mp.error.request_denied"]         = "Je media-aanvraag is geweigerd.",
	["mp.error.queue_full"]             = "De wachtrij van de mediaspeler is vol.",
	["mp.error.duplicate_request"]      = "De aangevraagde media staat al in de wachtrij",
	["mp.error.metadata_fetch"]         = "Er was een probleem bij het ophalen van de metadata van de aangevraagde media.",
	["mp.error.queue_denied"]           = "De aangevraagde media kon niet in de wachtrij worden geplaatst.",
	["mp.error.media_url_failed"]       = "Kan de media-URL niet verwerken.",
	["mp.error.request_error"]          = "[Aanvraagfout] %s",
	["mp.success.added_to_queue"]       = "'%s' toegevoegd aan de wachtrij",
	["mp.error.no_permission"]          = "Je hebt geen toestemming om dat te doen.",
	["mp.error.seek_past_duration"]     = "De aangevraagde zoektijd lag voorbij het einde van de mediaduur.",

	-- Settings
	["mp.settings.title"]               = "INSTELLINGEN",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D ruimtelijk geluid",
	["mp.settings.proximity_min"]       = "Minimale nabijheidsafstand",
	["mp.settings.proximity_max"]       = "Maximale nabijheidsafstand",
	["mp.settings.proximity_units"]     = "%s eenheden",
	["mp.settings.mute_unfocused"]      = "Dempen wanneer niet gefocust",
	["mp.settings.show_radius"]         = "Nabijheidsradius tonen",
	["mp.settings.subtitles"]           = "Ondertiteling",
	["mp.settings.subtitles_off"]       = "Uit",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "Niet-ondersteund mediatype",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Ruimtelijke mediaspeler",
	["mp.tool.spatial.label"]           = "Ruimtelijke media",
	["mp.tool.spatial.desc"]            = "Pin MediaPlayer-audio aan de wereld of laat het een entiteit volgen.",
	["mp.tool.spatial.usage"]           = "Linksklik: ruimtelijke bron plaatsen. Rechtsklik: verwijderen.",
	["mp.tool.spatial.help_place"]      = "Klik links op een prop, speler of NPC om een ruimtelijke audiobron te bevestigen. Klik op de wereld om het op zijn plaats te pinnen.",
	["mp.tool.spatial.help_remove"]     = "Klik rechts op een doel om de ruimtelijke bron te verwijderen.",
	["mp.tool.spatial.help_sidebar"]    = "Om media aan te vragen of het afspelen te bedienen, kijk naar het object en houd C ingedrukt om de zijbalk te openen — het werkt hetzelfde als elke andere mediaspeler.",
	["mp.tool.spatial.hint_press_c"]    = "Ruimtelijke mediabron geplaatst! Houd C ingedrukt terwijl je naar het object kijkt om de zijbalk te openen en media aan te vragen.",
	["mp.tool.spatial.undo"]            = "Ruimtelijke mediabron",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Je hebt geen toestemming om deze ruimtelijke mediabron te bedienen.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Spiegel-mediaspeler",
	["mp.tool.mimic.desc"]              = "Spiegel de video-uitvoer van een andere mediaspeler naar een tweede scherm.",
	["mp.tool.mimic.usage"]             = "Linksklik: bron kopiëren. Rechtsklik: plakken op doel(en). Herladen (R): spiegel verwijderen.",
	["mp.tool.mimic.help_copy"]         = "Klik links op een mediaspeler om deze als videobron te kopiëren.",
	["mp.tool.mimic.help_paste"]        = "Klik rechts op andere mediaspelers om te plakken — ze spiegelen de bron. Je kunt op meerdere schermen plakken.",
	["mp.tool.mimic.help_remove"]       = "Druk op Herladen (R) op een spiegelspeler om deze te verwijderen en het origineel te herstellen.",
	["mp.tool.mimic.source_copied"]     = "Bron gekopieerd! Klik rechts op andere mediaspelers om te plakken.",
	["mp.tool.mimic.pasted"]            = "Spiegel toegepast! Dit scherm spiegelt nu de bron.",
	["mp.tool.mimic.removed"]           = "Spiegel verwijderd. Entiteit hersteld.",
	["mp.tool.mimic.undo"]              = "Spiegel-mediaspeler",
	["mp.tool.mimic.error_not_mp"]      = "Deze entiteit heeft geen mediaspeler.",
	["mp.tool.mimic.error_spatial"]     = "Kan geen ruimtelijke mediaspeler spiegelen.",
	["mp.tool.mimic.error_same"]        = "Bron en doel kunnen niet dezelfde entiteit zijn.",
	["mp.tool.mimic.error_no_source"]   = "Nog geen bron gekopieerd. Klik eerst links op een mediaspeler.",
	["mp.tool.mimic.error_source_gone"] = "De gekopieerde bron bestaat niet meer. Klik links op een nieuwe bron.",
	["mp.tool.mimic.error_mimic_source"] = "Kan niet kopiëren van een spiegelspeler. Kopieer van de originele bron.",
	["mp.tool.mimic.error_already_linked"] = "Deze entiteit spiegelt die bron al.",
	["mp.tool.mimic.error_not_mimic"]   = "Deze entiteit is geen spiegelspeler.",
	["mp.tool.mimic.error_has_content"] = "Kan geen mediaspeler spiegelen die eigen content afspeelt. Stop of wis eerst de media.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Browserlimiet bereikt",
	["mp.error.browser_limit_detail"]   = "Alle browserslots zijn in gebruik (%d/%d actief).",
	["mp.error.browser_limit_note"]     = "Wachten tot een slot vrijkomt. Dit is geen bug.",
})