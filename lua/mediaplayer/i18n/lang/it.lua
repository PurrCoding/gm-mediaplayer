-- Italian / Italiano
MediaPlayer.i18n.RegisterLanguage("it", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nessun media in riproduzione",
	["mp.idle.hint"]                    = "Tieni premuto %s guardando il lettore multimediale per aprire il menu della coda.",
	["mp.idle.press_e"]                 = "Premi E per iniziare a guardare",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "IN RIPRODUZIONE",
	["mp.ui.no_media"]                  = "Nessun media in riproduzione",
	["mp.ui.next_up"]                   = "PROSSIMO",
	["mp.ui.add_media"]                 = "AGGIUNGI MEDIA",
	["mp.ui.added_by"]                  = "AGGIUNTO DA",
	["mp.ui.unknown"]                   = "Sconosciuto",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "Hai già votato per saltare.",
	["mp.voteskip.vote_cast"]           = "Voteskip: %d/%d voti (%d ancora necessari)",
	["mp.voteskip.passed"]              = "Voteskip approvato! Salto in corso...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Ripeti",
	["mp.ui.shuffle"]                   = "Casuale",
	["mp.ui.toggle_queue_lock"]         = "Attiva/disattiva blocco coda",

	-- Browser controls
	["mp.ui.search_for_media"]          = "CERCA MEDIA",
	["mp.ui.request_url"]               = "RICHIEDI URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pausa",
	["mp.property.resume"]              = "Riprendi",
	["mp.property.skip"]                = "Salta",
	["mp.property.seek"]                = "Cerca",
	["mp.property.seek_title"]          = "Lettore multimediale",
	["mp.property.seek_prompt"]         = "Inserisci un tempo nel formato HH:MM:SS (ore, minuti, secondi):",
	["mp.property.seek_confirm"]        = "Cerca",
	["mp.property.seek_cancel"]         = "Annulla",
	["mp.property.request_url"]         = "Richiedi URL",
	["mp.property.copy_url"]            = "Copia URL negli appunti",
	["mp.property.fullscreen"]          = "Attiva/disattiva schermo intero (F11)",
	["mp.property.turn_on"]             = "Accendi",
	["mp.property.turn_off"]            = "Spegni",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Lettore multimediale",
	["mp.menu.fullscreen"]              = "Schermo intero",
	["mp.menu.turn_off_all"]            = "Spegni tutto",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "L'URL richiesto non era valido.",
	["mp.error.request_failed"]         = "Richiesta fallita: %s",
	["mp.error.audio_load_failed"]      = "Impossibile caricare l'audio '%s'",
	["mp.error.audio_stream"]           = "Si è verificato un problema nella ricezione del flusso audio, riprova.",
	["mp.success.url_copied"]           = "L'URL del media è stato copiato negli appunti.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Il media richiesto non è supportato; i servizi accettati sono i seguenti:\n",
	["mp.error.queue_locked"]           = "Il media non può essere aggiunto perché la coda è bloccata.",
	["mp.error.request_denied"]         = "La tua richiesta di media è stata rifiutata.",
	["mp.error.queue_full"]             = "La coda del lettore multimediale è piena.",
	["mp.error.duplicate_request"]      = "Il media richiesto è già nella coda",
	["mp.error.metadata_fetch"]         = "Si è verificato un problema nel recupero dei metadati del media richiesto.",
	["mp.error.queue_denied"]           = "Il media richiesto non può essere messo in coda.",
	["mp.error.media_url_failed"]       = "Impossibile elaborare l'URL del media.",
	["mp.error.request_error"]          = "[Errore di richiesta] %s",
	["mp.success.added_to_queue"]       = "'%s' aggiunto alla coda",
	["mp.error.no_permission"]          = "Non hai il permesso per farlo.",
	["mp.error.seek_past_duration"]     = "Il tempo di ricerca richiesto supera la durata del media.",

	-- Settings
	["mp.settings.title"]               = "IMPOSTAZIONI",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "Audio spaziale 3D",
	["mp.settings.proximity_min"]       = "Distanza minima di prossimità",
	["mp.settings.proximity_max"]       = "Distanza massima di prossimità",
	["mp.settings.proximity_units"]     = "%s unità",
	["mp.settings.mute_unfocused"]      = "Silenzia quando non in primo piano",
	["mp.settings.show_radius"]         = "Mostra raggio di prossimità",
	["mp.settings.subtitles"]           = "Sottotitoli",
	["mp.settings.subtitles_off"]       = "Disattivato",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "Tipo di media non supportato",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Lettore multimediale spaziale",
	["mp.tool.spatial.label"]           = "Media spaziale",
	["mp.tool.spatial.desc"]            = "Fissa l'audio di MediaPlayer al mondo o fallo seguire un'entità.",
	["mp.tool.spatial.usage"]           = "Clic sinistro: posiziona una sorgente spaziale. Clic destro: rimuovi.",
	["mp.tool.spatial.help_place"]      = "Clicca con il sinistro su un prop, giocatore o NPC per attaccare una sorgente audio spaziale. Clicca sul mondo per fissarla sul posto.",
	["mp.tool.spatial.help_remove"]     = "Clicca con il destro su un bersaglio per rimuovere la sua sorgente spaziale.",
	["mp.tool.spatial.help_sidebar"]    = "Per richiedere media o controllare la riproduzione, guarda l'oggetto e tieni premuto C per aprire la barra laterale — funziona come qualsiasi altro lettore multimediale.",
	["mp.tool.spatial.hint_press_c"]    = "Sorgente media spaziale posizionata! Tieni premuto C guardando l'oggetto per aprire la barra laterale e richiedere media.",
	["mp.tool.spatial.undo"]            = "Sorgente media spaziale",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Non hai il permesso di controllare questa sorgente media spaziale.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Lettore multimediale specchio",
	["mp.tool.mimic.desc"]              = "Rifletti l'uscita video di un altro lettore multimediale su un secondo schermo.",
	["mp.tool.mimic.usage"]             = "Clic sinistro: copia sorgente. Clic destro: incolla sul/sui bersaglio/i. Ricarica (R): rimuovi specchio.",
	["mp.tool.mimic.help_copy"]         = "Fai clic sinistro su un lettore multimediale per copiarlo come sorgente video.",
	["mp.tool.mimic.help_paste"]        = "Fai clic destro su altri lettori multimediali per incollare — rifletteranno la sorgente. Puoi incollare su più schermi.",
	["mp.tool.mimic.help_remove"]       = "Premi Ricarica (R) su un lettore specchio per rimuoverlo e ripristinare l'originale.",
	["mp.tool.mimic.source_copied"]     = "Sorgente copiata! Fai clic destro su altri lettori multimediali per incollare.",
	["mp.tool.mimic.pasted"]            = "Specchio applicato! Questo schermo ora riflette la sorgente.",
	["mp.tool.mimic.removed"]           = "Specchio rimosso. Entità ripristinata.",
	["mp.tool.mimic.undo"]              = "Lettore multimediale specchio",
	["mp.tool.mimic.error_not_mp"]      = "Questa entità non ha un lettore multimediale.",
	["mp.tool.mimic.error_spatial"]     = "Non è possibile riflettere un lettore multimediale spaziale.",
	["mp.tool.mimic.error_same"]        = "Sorgente e bersaglio non possono essere la stessa entità.",
	["mp.tool.mimic.error_no_source"]   = "Nessuna sorgente copiata. Fai prima clic sinistro su un lettore multimediale.",
	["mp.tool.mimic.error_source_gone"] = "La sorgente copiata non esiste più. Fai clic sinistro su una nuova sorgente.",
	["mp.tool.mimic.error_mimic_source"] = "Non è possibile copiare da un lettore specchio. Copia dalla sorgente originale.",
	["mp.tool.mimic.error_already_linked"] = "Questa entità sta già riflettendo quella sorgente.",
	["mp.tool.mimic.error_not_mimic"]   = "Questa entità non è un lettore specchio.",
	["mp.tool.mimic.error_has_content"] = "Non è possibile riflettere un lettore che sta riproducendo il proprio contenuto. Ferma o cancella prima i suoi media.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Limite browser raggiunto",
	["mp.error.browser_limit_detail"]   = "Tutti gli slot del browser sono in uso (%d/%d attivi).",
	["mp.error.browser_limit_note"]     = "In attesa che uno slot si liberi. Questo non è un bug.",
})