-- Italian / Italiano
MediaPlayer.i18n.RegisterLanguage("it", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nessun media in riproduzione",
	["mp.idle.hint"]                    = "Tieni premuto %s guardando il lettore multimediale per aprire il menu della coda.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "IN RIPRODUZIONE",
	["mp.ui.no_media"]                  = "Nessun media in riproduzione",
	["mp.ui.next_up"]                   = "PROSSIMO",
	["mp.ui.add_media"]                 = "AGGIUNGI MEDIA",
	["mp.ui.added_by"]                  = "AGGIUNTO DA",
	["mp.ui.unknown"]                   = "Sconosciuto",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Ripeti",
	["mp.ui.shuffle"]                   = "Casuale",
	["mp.ui.toggle_queue_lock"]         = "Attiva/Disattiva blocco coda",

	-- Browser controls
	["mp.ui.search_for_media"]          = "CERCA MEDIA",
	["mp.ui.request_url"]               = "RICHIEDI URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pausa",
	["mp.property.resume"]              = "Riprendi",
	["mp.property.skip"]                = "Salta",
	["mp.property.seek"]                = "Cerca",
	["mp.property.seek_title"]          = "Lettore multimediale",
	["mp.property.seek_prompt"]         = "Inserisci un orario nel formato HH:MM:SS (ore, minuti, secondi):",
	["mp.property.seek_confirm"]        = "Cerca",
	["mp.property.seek_cancel"]         = "Annulla",
	["mp.property.request_url"]         = "Richiedi URL",
	["mp.property.copy_url"]            = "Copia URL negli appunti",
	["mp.property.fullscreen"]          = "Attiva/Disattiva schermo intero (F11)",
	["mp.property.turn_on"]             = "Accendi",
	["mp.property.turn_off"]            = "Spegni",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Lettore multimediale",
	["mp.menu.fullscreen"]              = "Schermo intero",
	["mp.menu.turn_off_all"]            = "Spegni tutto",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "L'URL richiesto non è valido.",
	["mp.error.request_failed"]         = "Richiesta fallita: %s",
	["mp.error.audio_load_failed"]      = "Impossibile caricare l'audio del lettore multimediale '%s'",
	["mp.error.audio_stream"]           = "Si è verificato un problema nella ricezione dello stream audio, riprova.",
	["mp.success.url_copied"]           = "L'URL del media è stato copiato negli appunti.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Il media richiesto non è supportato; i servizi accettati sono i seguenti:\n",
	["mp.error.queue_locked"]           = "Il media richiesto non può essere aggiunto perché la coda è bloccata.",
	["mp.error.request_denied"]         = "La tua richiesta media è stata rifiutata.",
	["mp.error.queue_full"]             = "La coda del lettore multimediale è piena.",
	["mp.error.duplicate_request"]      = "Il media richiesto è già nella coda",
	["mp.error.metadata_fetch"]         = "Si è verificato un problema nel recupero dei metadati del media richiesto.",
	["mp.error.queue_denied"]           = "Il media richiesto non può essere aggiunto alla coda.",
	["mp.success.added_to_queue"]       = "'%s' aggiunto alla coda",
	["mp.error.no_permission"]          = "Non hai il permesso per farlo.",
	["mp.error.seek_past_duration"]     = "Il tempo di ricerca richiesto supera la durata del media.",

	-- Settings
	["mp.settings.title"]               = "IMPOSTAZIONI",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "Audio spaziale 3D",
	["mp.settings.proximity_min"]       = "Distanza minima",
	["mp.settings.proximity_max"]       = "Distanza massima",
	["mp.settings.mute_unfocused"]      = "Silenzia se non in primo piano",
})