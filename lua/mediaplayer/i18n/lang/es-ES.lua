-- Spanish (Spain) / Español
MediaPlayer.i18n.RegisterLanguage("es-ES", {

	-- Idle screen
	["mp.idle.no_media"]                = "No se está reproduciendo ningún medio",
	["mp.idle.hint"]                    = "Mantén pulsado %s mientras miras al reproductor de medios para abrir el menú de cola.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "REPRODUCIENDO AHORA",
	["mp.ui.no_media"]                  = "No se está reproduciendo ningún medio",
	["mp.ui.next_up"]                   = "A CONTINUACIÓN",
	["mp.ui.add_media"]                 = "AÑADIR MEDIO",
	["mp.ui.added_by"]                  = "AÑADIDO POR",
	["mp.ui.unknown"]                   = "Desconocido",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Repetir",
	["mp.ui.shuffle"]                   = "Aleatorio",
	["mp.ui.toggle_queue_lock"]         = "Alternar bloqueo de cola",

	-- Browser controls
	["mp.ui.search_for_media"]          = "BUSCAR MEDIOS",
	["mp.ui.request_url"]               = "SOLICITAR URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pausar",
	["mp.property.resume"]              = "Reanudar",
	["mp.property.skip"]                = "Saltar",
	["mp.property.seek"]                = "Buscar",
	["mp.property.seek_title"]          = "Reproductor de medios",
	["mp.property.seek_prompt"]         = "Introduce un tiempo en formato HH:MM:SS (horas, minutos, segundos):",
	["mp.property.seek_confirm"]        = "Buscar",
	["mp.property.seek_cancel"]         = "Cancelar",
	["mp.property.request_url"]         = "Solicitar URL",
	["mp.property.copy_url"]            = "Copiar URL al portapapeles",
	["mp.property.fullscreen"]          = "Alternar pantalla completa (F11)",
	["mp.property.turn_on"]             = "Encender",
	["mp.property.turn_off"]            = "Apagar",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Reproductor de medios",
	["mp.menu.fullscreen"]              = "Pantalla completa",
	["mp.menu.turn_off_all"]            = "Apagar todo",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "La URL solicitada no es válida.",
	["mp.error.request_failed"]         = "Solicitud fallida: %s",
	["mp.error.audio_load_failed"]      = "No se pudo cargar el audio del reproductor de medios '%s'",
	["mp.error.audio_stream"]           = "Hubo un problema al recibir la transmisión de audio, inténtalo de nuevo.",
	["mp.success.url_copied"]           = "La URL del medio se ha copiado al portapapeles.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "El medio solicitado no es compatible; los servicios aceptados son los siguientes:\n",
	["mp.error.queue_locked"]           = "No se pudo añadir el medio solicitado porque la cola está bloqueada.",
	["mp.error.request_denied"]         = "Tu solicitud de medio ha sido denegada.",
	["mp.error.queue_full"]             = "La cola del reproductor de medios está llena.",
	["mp.error.duplicate_request"]      = "El medio solicitado ya estaba en la cola",
	["mp.error.metadata_fetch"]         = "Hubo un problema al obtener los metadatos del medio solicitado.",
	["mp.error.queue_denied"]           = "El medio solicitado no se pudo añadir a la cola.",
	["mp.success.added_to_queue"]       = "'%s' añadido a la cola",
	["mp.error.no_permission"]          = "No tienes permiso para hacer eso.",
	["mp.error.seek_past_duration"]     = "El tiempo de búsqueda solicitado supera la duración del medio.",
})