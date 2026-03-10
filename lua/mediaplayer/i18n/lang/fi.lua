-- Finnish / Suomi
MediaPlayer.i18n.RegisterLanguage("fi", {

	-- Idle screen
	["mp.idle.no_media"]                = "Ei toistettavaa mediaa",
	["mp.idle.hint"]                    = "Pidä %s pohjassa ja katso mediasoitinta avataksesi jononäkymän.",

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
	["mp.property.seek_prompt"]         = "Syötä aika muodossa HH:MM:SS (tunnit, minuutit, sekunnit):",
	["mp.property.seek_confirm"]        = "Kelaa",
	["mp.property.seek_cancel"]         = "Peruuta",
	["mp.property.request_url"]         = "Pyydä URL",
	["mp.property.copy_url"]            = "Kopioi URL leikepöydälle",
	["mp.property.fullscreen"]          = "Koko näyttö (F11)",
	["mp.property.turn_on"]             = "Käynnistä",
	["mp.property.turn_off"]            = "Sammuta",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediasoitin",
	["mp.menu.fullscreen"]              = "Koko näyttö",
	["mp.menu.turn_off_all"]            = "Sammuta kaikki",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Pyydetty URL oli virheellinen.",
	["mp.error.request_failed"]         = "Pyyntö epäonnistui: %s",
	["mp.error.audio_load_failed"]      = "Audion '%s' lataaminen epäonnistui",
	["mp.error.audio_stream"]           = "Äänistriimin vastaanottamisessa oli ongelma, yritä uudelleen.",
	["mp.success.url_copied"]           = "Median URL on kopioitu leikepöydälle.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Pyydettyä mediaa ei tueta; hyväksytyt palvelut ovat seuraavat:\n",
	["mp.error.queue_locked"]           = "Pyydettyä mediaa ei voitu lisätä, koska jono on lukittu.",
	["mp.error.request_denied"]         = "Mediapyyntösi on hylätty.",
	["mp.error.queue_full"]             = "Mediasoittimen jono on täynnä.",
	["mp.error.duplicate_request"]      = "Pyydetty media on jo jonossa",
	["mp.error.metadata_fetch"]         = "Pyydetyn median metatietojen haussa oli ongelma.",
	["mp.error.queue_denied"]           = "Pyydettyä mediaa ei voitu lisätä jonoon.",
	["mp.success.added_to_queue"]       = "'%s' lisätty jonoon",
	["mp.error.no_permission"]          = "Sinulla ei ole oikeutta tehdä tätä.",
	["mp.error.seek_past_duration"]     = "Pyydetty kelausaika ylitti median keston.",

	-- Settings
	["mp.settings.title"]               = "ASETUKSET",
	["mp.settings.audio"]               = "Ääni",
	["mp.settings.3d_audio"]            = "3D-tilaääni",
	["mp.settings.proximity_min"]       = "Vähimmäisetäisyys",
	["mp.settings.proximity_max"]       = "Enimmäisetäisyys",
	["mp.settings.mute_unfocused"]      = "Mykistä kun ei aktiivinen",
})