-- Finnish / Suomi
MediaPlayer.i18n.RegisterLanguage("fi", {

	-- Idle screen
	["mp.idle.no_media"]                = "Ei toistettavaa mediaa",
	["mp.idle.hint"]                    = "Pidä %s pohjassa katsoessasi mediasoitinta avataksesi jonovalikon.",
	["mp.idle.press_e"]                 = "Paina E aloittaaksesi katselun",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "NYT TOISTETAAN",
	["mp.ui.no_media"]                  = "Ei toistettavaa mediaa",
	["mp.ui.next_up"]                   = "SEURAAVAKSI",
	["mp.ui.add_media"]                 = "LISÄÄ MEDIA",
	["mp.ui.added_by"]                  = "LISÄNNYT",
	["mp.ui.unknown"]                   = "Tuntematon",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Toista uudelleen",
	["mp.ui.shuffle"]                   = "Sekoita",
	["mp.ui.toggle_queue_lock"]         = "Vaihda jonon lukitus",

	-- Browser controls
	["mp.ui.search_for_media"]          = "HAE MEDIAA",
	["mp.ui.request_url"]               = "PYYDÄ URL",

	-- Context menu properties
	["mp.property.pause"]               = "Tauko",
	["mp.property.resume"]              = "Jatka",
	["mp.property.skip"]                = "Ohita",
	["mp.property.seek"]                = "Kelaa",
	["mp.property.seek_title"]          = "Mediasoitin",
	["mp.property.seek_prompt"]         = "Syötä aika muodossa TT:MM:SS (tunnit, minuutit, sekunnit):",
	["mp.property.seek_confirm"]        = "Kelaa",
	["mp.property.seek_cancel"]         = "Peruuta",
	["mp.property.request_url"]         = "Pyydä URL",
	["mp.property.copy_url"]            = "Kopioi URL leikepöydälle",
	["mp.property.fullscreen"]          = "Vaihda koko näyttö (F11)",
	["mp.property.turn_on"]             = "Käynnistä",
	["mp.property.turn_off"]            = "Sammuta",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediasoitin",
	["mp.menu.fullscreen"]              = "Koko näyttö",
	["mp.menu.turn_off_all"]            = "Sammuta kaikki",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Pyydetty URL oli virheellinen.",
	["mp.error.request_failed"]         = "Pyyntö epäonnistui: %s",
	["mp.error.audio_load_failed"]      = "Äänen '%s' lataaminen epäonnistui",
	["mp.error.audio_stream"]           = "Äänivirran vastaanottamisessa oli ongelma, yritä uudelleen.",
	["mp.success.url_copied"]           = "Median URL on kopioitu leikepöydälle.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Pyydettyä mediaa ei tueta; hyväksytyt palvelut ovat seuraavat:\n",
	["mp.error.queue_locked"]           = "Mediaa ei voitu lisätä, koska jono on lukittu.",
	["mp.error.request_denied"]         = "Mediapyyntösi on hylätty.",
	["mp.error.queue_full"]             = "Mediasoittimen jono on täynnä.",
	["mp.error.duplicate_request"]      = "Pyydetty media on jo jonossa",
	["mp.error.metadata_fetch"]         = "Pyydetyn median metatietojen haussa oli ongelma.",
	["mp.error.queue_denied"]           = "Pyydettyä mediaa ei voitu lisätä jonoon.",
	["mp.error.media_url_failed"]       = "Median URL:n käsittely epäonnistui.",
	["mp.error.request_error"]          = "[Pyyntövirhe] %s",
	["mp.success.added_to_queue"]       = "'%s' lisätty jonoon",
	["mp.error.no_permission"]          = "Sinulla ei ole oikeutta tehdä sitä.",
	["mp.error.seek_past_duration"]     = "Pyydetty kelausaika ylitti median keston.",

	-- Settings
	["mp.settings.title"]               = "ASETUKSET",
	["mp.settings.audio"]               = "Ääni",
	["mp.settings.3d_audio"]            = "3D-tilaääni",
	["mp.settings.proximity_min"]       = "Läheisyyden minimietäisyys",
	["mp.settings.proximity_max"]       = "Läheisyyden maksimietäisyys",
	["mp.settings.proximity_units"]     = "%s yksikköä",
	["mp.settings.mute_unfocused"]      = "Mykistä kun ei aktiivinen",
	["mp.settings.language"]            = "Kieli",
	["mp.settings.language_auto"]       = "Automaattinen (järjestelmä)",
	["mp.settings.show_radius"]         = "Näytä läheisyyssäde",
	["mp.settings.subtitles"]           = "Tekstitykset",
	["mp.settings.subtitles_off"]       = "Pois",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Tilamediasoitin",
	["mp.tool.spatial.label"]           = "Tilamedia",
	["mp.tool.spatial.desc"]            = "Kiinnitä MediaPlayer-ääni maailmaan tai anna sen seurata entiteettiä.",
	["mp.tool.spatial.usage"]           = "Vasen klikkaus: aseta tilalähde. Oikea klikkaus: poista.",
	["mp.tool.spatial.help_place"]      = "Klikkaa vasemmalla proppia, pelaajaa tai NPC:tä kiinnittääksesi tilaäänilähteen. Klikkaa maailmaa kiinnittääksesi sen paikalleen.",
	["mp.tool.spatial.help_remove"]     = "Klikkaa oikealla kohdetta poistaaksesi sen tilalähteen.",
	["mp.tool.spatial.help_sidebar"]    = "Pyytääksesi mediaa tai hallitaksesi toistoa, katso objektia ja pidä C pohjassa avataksesi sivupalkin — se toimii kuten mikä tahansa muu mediasoitin.",
	["mp.tool.spatial.hint_press_c"]    = "Tilamedialähde asetettu! Pidä C pohjassa katsoessasi objektia avataksesi sivupalkin ja pyytääksesi mediaa.",
	["mp.tool.spatial.undo"]            = "Tilamedialähde",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Sinulla ei ole oikeutta hallita tätä tilamedialähdetä.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Selaimen raja saavutettu",
	["mp.error.browser_limit_detail"]   = "Kaikki selainpaikat ovat käytössä (%d/%d aktiivista).",
	["mp.error.browser_limit_note"]     = "Odotetaan paikan vapautumista. Tämä ei ole virhe.",1
})