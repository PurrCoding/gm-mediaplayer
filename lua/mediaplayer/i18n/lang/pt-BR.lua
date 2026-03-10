-- Portuguese (Brazil) / Português (Brasil)
MediaPlayer.i18n.RegisterLanguage("pt-BR", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nenhuma mídia em reprodução",
	["mp.idle.hint"]                    = "Segure %s enquanto olha para o reprodutor de mídia para abrir o menu da fila.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "REPRODUZINDO AGORA",
	["mp.ui.no_media"]                  = "Nenhuma mídia em reprodução",
	["mp.ui.next_up"]                   = "PRÓXIMO",
	["mp.ui.add_media"]                 = "ADICIONAR MÍDIA",
	["mp.ui.added_by"]                  = "ADICIONADO POR",
	["mp.ui.unknown"]                   = "Desconhecido",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Repetir",
	["mp.ui.shuffle"]                   = "Aleatório",
	["mp.ui.toggle_queue_lock"]         = "Alternar bloqueio da fila",

	-- Browser controls
	["mp.ui.search_for_media"]          = "PESQUISAR MÍDIA",
	["mp.ui.request_url"]               = "SOLICITAR URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pausar",
	["mp.property.resume"]              = "Retomar",
	["mp.property.skip"]                = "Pular",
	["mp.property.seek"]                = "Buscar",
	["mp.property.seek_title"]          = "Reprodutor de mídia",
	["mp.property.seek_prompt"]         = "Insira um horário no formato HH:MM:SS (horas, minutos, segundos):",
	["mp.property.seek_confirm"]        = "Buscar",
	["mp.property.seek_cancel"]         = "Cancelar",
	["mp.property.request_url"]         = "Solicitar URL",
	["mp.property.copy_url"]            = "Copiar URL para a área de transferência",
	["mp.property.fullscreen"]          = "Alternar tela cheia (F11)",
	["mp.property.turn_on"]             = "Ligar",
	["mp.property.turn_off"]            = "Desligar",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Reprodutor de mídia",
	["mp.menu.fullscreen"]              = "Tela cheia",
	["mp.menu.turn_off_all"]            = "Desligar tudo",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "A URL solicitada era inválida.",
	["mp.error.request_failed"]         = "Falha na solicitação: %s",
	["mp.error.audio_load_failed"]      = "Falha ao carregar o áudio do reprodutor de mídia '%s'",
	["mp.error.audio_stream"]           = "Houve um problema ao receber o fluxo de áudio, tente novamente.",
	["mp.success.url_copied"]           = "A URL da mídia foi copiada para a área de transferência.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "A mídia solicitada não é suportada; os serviços aceitos são os seguintes:\n",
	["mp.error.queue_locked"]           = "A mídia solicitada não pôde ser adicionada pois a fila está bloqueada.",
	["mp.error.request_denied"]         = "Sua solicitação de mídia foi negada.",
	["mp.error.queue_full"]             = "A fila do reprodutor de mídia está cheia.",
	["mp.error.duplicate_request"]      = "A mídia solicitada já estava na fila",
	["mp.error.metadata_fetch"]         = "Houve um problema ao obter os metadados da mídia solicitada.",
	["mp.error.queue_denied"]           = "A mídia solicitada não pôde ser adicionada à fila.",
	["mp.success.added_to_queue"]       = "'%s' adicionado à fila",
	["mp.error.no_permission"]          = "Você não tem permissão para fazer isso.",
	["mp.error.seek_past_duration"]     = "O tempo de busca solicitado ultrapassou a duração da mídia.",

	-- Settings
	["mp.settings.title"]               = "CONFIGURAÇÕES",
	["mp.settings.audio"]               = "Áudio",
	["mp.settings.3d_audio"]            = "Áudio espacial 3D",
	["mp.settings.proximity_min"]       = "Distância mínima",
	["mp.settings.proximity_max"]       = "Distância máxima",
	["mp.settings.mute_unfocused"]      = "Silenciar quando desfocado",
})