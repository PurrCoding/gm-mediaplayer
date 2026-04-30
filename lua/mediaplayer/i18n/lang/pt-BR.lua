-- Portuguese (Brazil) / Português (Brasil)
MediaPlayer.i18n.RegisterLanguage("pt-br", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nenhuma mídia reproduzindo",
	["mp.idle.hint"]                    = "Segure %s enquanto olha para o reprodutor de mídia para exibir o menu da fila.",
	["mp.idle.press_e"]                 = "Pressione E para começar a assistir",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "REPRODUZINDO AGORA",
	["mp.ui.no_media"]                  = "Nenhuma mídia reproduzindo",
	["mp.ui.next_up"]                   = "PRÓXIMO",
	["mp.ui.add_media"]                 = "ADICIONAR MÍDIA",
	["mp.ui.added_by"]                  = "ADICIONADO POR",
	["mp.ui.unknown"]                   = "Desconhecido",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "Você já votou para pular.",
	["mp.voteskip.vote_cast"]           = "Voteskip: %d/%d votos (%d mais necessários)",
	["mp.voteskip.passed"]              = "Voteskip aprovado! Pulando...",

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
	["mp.property.seek_prompt"]         = "Insira um tempo no formato HH:MM:SS (horas, minutos, segundos):",
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
	["mp.error.audio_load_failed"]      = "Falha ao carregar o áudio '%s'",
	["mp.error.audio_stream"]           = "Houve um problema ao receber o fluxo de áudio, tente novamente.",
	["mp.success.url_copied"]           = "A URL da mídia foi copiada para a área de transferência.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "A mídia solicitada não é suportada; os serviços aceitos são os seguintes:\n",
	["mp.error.queue_locked"]           = "A mídia não pôde ser adicionada porque a fila está bloqueada.",
	["mp.error.request_denied"]         = "Sua solicitação de mídia foi negada.",
	["mp.error.queue_full"]             = "A fila do reprodutor de mídia está cheia.",
	["mp.error.duplicate_request"]      = "A mídia solicitada já está na fila",
	["mp.error.metadata_fetch"]         = "Houve um problema ao obter os metadados da mídia solicitada.",
	["mp.error.queue_denied"]           = "A mídia solicitada não pôde ser enfileirada.",
	["mp.error.media_url_failed"]       = "Falha ao processar a URL da mídia.",
	["mp.error.request_error"]          = "[Erro de solicitação] %s",
	["mp.success.added_to_queue"]       = "'%s' adicionado à fila",
	["mp.error.no_permission"]          = "Você não tem permissão para fazer isso.",
	["mp.error.seek_past_duration"]     = "O tempo de busca solicitado ultrapassou a duração da mídia.",

	-- Settings
	["mp.settings.title"]               = "CONFIGURAÇÕES",
	["mp.settings.audio"]               = "Áudio",
	["mp.settings.3d_audio"]            = "Áudio espacial 3D",
	["mp.settings.proximity_min"]       = "Distância mínima de proximidade",
	["mp.settings.proximity_max"]       = "Distância máxima de proximidade",
	["mp.settings.proximity_units"]     = "%s unidades",
	["mp.settings.mute_unfocused"]      = "Silenciar quando desfocado",
	["mp.settings.show_radius"]         = "Mostrar raio de proximidade",
	["mp.settings.subtitles"]           = "Legendas",
	["mp.settings.subtitles_off"]       = "Desativado",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "Tipo de mídia não suportado",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Reprodutor de mídia espacial",
	["mp.tool.spatial.label"]           = "Mídia espacial",
	["mp.tool.spatial.desc"]            = "Fixe o áudio do MediaPlayer no mundo ou faça-o seguir uma entidade.",
	["mp.tool.spatial.usage"]           = "Clique esquerdo: colocar uma fonte espacial. Clique direito: remover.",
	["mp.tool.spatial.help_place"]      = "Clique com o botão esquerdo em um prop, jogador ou NPC para anexar uma fonte de áudio espacial. Clique no mundo para fixá-la no lugar.",
	["mp.tool.spatial.help_remove"]     = "Clique com o botão direito em um alvo para remover sua fonte espacial.",
	["mp.tool.spatial.help_sidebar"]    = "Para solicitar mídia ou controlar a reprodução, olhe para o objeto e segure C para abrir a barra lateral — funciona da mesma forma que qualquer outro reprodutor de mídia.",
	["mp.tool.spatial.hint_press_c"]    = "Fonte de mídia espacial colocada! Segure C enquanto olha para o objeto para abrir a barra lateral e solicitar mídia.",
	["mp.tool.spatial.undo"]            = "Fonte de mídia espacial",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Você não tem permissão para controlar esta fonte de mídia espacial.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Reprodutor de mídia espelho",
	["mp.tool.mimic.desc"]              = "Espelhe a saída de vídeo de outro reprodutor de mídia em uma segunda tela.",
	["mp.tool.mimic.usage"]             = "Clique esquerdo: copiar fonte. Clique direito: colar no(s) alvo(s). Recarregar (R): remover espelho.",
	["mp.tool.mimic.help_copy"]         = "Clique com o botão esquerdo em um reprodutor de mídia para copiá-lo como fonte de vídeo.",
	["mp.tool.mimic.help_paste"]        = "Clique com o botão direito em outros reprodutores para colar — eles espelharão a fonte. Você pode colar em várias telas.",
	["mp.tool.mimic.help_remove"]       = "Pressione Recarregar (R) em um reprodutor espelho para removê-lo e restaurar o original.",
	["mp.tool.mimic.source_copied"]     = "Fonte copiada! Clique com o botão direito em outros reprodutores para colar.",
	["mp.tool.mimic.pasted"]            = "Espelho aplicado! Esta tela agora espelha a fonte.",
	["mp.tool.mimic.removed"]           = "Espelho removido. Entidade restaurada.",
	["mp.tool.mimic.undo"]              = "Reprodutor de mídia espelho",
	["mp.tool.mimic.error_not_mp"]      = "Esta entidade não possui um reprodutor de mídia.",
	["mp.tool.mimic.error_spatial"]     = "Não é possível espelhar um reprodutor de mídia espacial.",
	["mp.tool.mimic.error_same"]        = "Fonte e alvo não podem ser a mesma entidade.",
	["mp.tool.mimic.error_no_source"]   = "Nenhuma fonte copiada ainda. Clique com o botão esquerdo em um reprodutor de mídia primeiro.",
	["mp.tool.mimic.error_source_gone"] = "A fonte copiada não existe mais. Clique com o botão esquerdo em uma nova fonte.",
	["mp.tool.mimic.error_mimic_source"] = "Não é possível copiar de um reprodutor espelho. Copie da fonte original.",
	["mp.tool.mimic.error_already_linked"] = "Esta entidade já está espelhando essa fonte.",
	["mp.tool.mimic.error_not_mimic"]   = "Esta entidade não é um reprodutor espelho.",
	["mp.tool.mimic.error_has_content"] = "Não é possível espelhar um reprodutor que está servindo seu próprio conteúdo. Pare ou limpe suas mídias primeiro.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Limite de navegadores atingido",
	["mp.error.browser_limit_detail"]   = "Todos os slots do navegador estão em uso (%d/%d ativos).",
	["mp.error.browser_limit_note"]     = "Aguardando um slot ser liberado. Isso não é um bug.",
})