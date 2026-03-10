-- Russian / Русский
MediaPlayer.i18n.RegisterLanguage("ru", {

	-- Idle screen
	["mp.idle.no_media"]                = "Ничего не воспроизводится",
	["mp.idle.hint"]                    = "Удерживайте %s, глядя на медиаплеер, чтобы открыть меню очереди.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "СЕЙЧАС ИГРАЕТ",
	["mp.ui.no_media"]                  = "Ничего не воспроизводится",
	["mp.ui.next_up"]                   = "ДАЛЕЕ",
	["mp.ui.add_media"]                 = "ДОБАВИТЬ МЕДИА",
	["mp.ui.added_by"]                  = "ДОБАВИЛ",
	["mp.ui.unknown"]                   = "Неизвестно",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Повтор",
	["mp.ui.shuffle"]                   = "Перемешать",
	["mp.ui.toggle_queue_lock"]         = "Переключить блокировку очереди",

	-- Browser controls
	["mp.ui.search_for_media"]          = "ПОИСК МЕДИА",
	["mp.ui.request_url"]               = "ЗАПРОСИТЬ URL",

	-- Context menu properties
	["mp.property.pause"]               = "Пауза",
	["mp.property.resume"]              = "Продолжить",
	["mp.property.skip"]                = "Пропустить",
	["mp.property.seek"]                = "Перемотка",
	["mp.property.seek_title"]          = "Медиаплеер",
	["mp.property.seek_prompt"]         = "Введите время в формате ЧЧ:ММ:СС (часы, минуты, секунды):",
	["mp.property.seek_confirm"]        = "Перемотать",
	["mp.property.seek_cancel"]         = "Отмена",
	["mp.property.request_url"]         = "Запросить URL",
	["mp.property.copy_url"]            = "Копировать URL в буфер обмена",
	["mp.property.fullscreen"]          = "Переключить полноэкранный режим (F11)",
	["mp.property.turn_on"]             = "Включить",
	["mp.property.turn_off"]            = "Выключить",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Медиаплеер",
	["mp.menu.fullscreen"]              = "Полный экран",
	["mp.menu.turn_off_all"]            = "Выключить все",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Запрошенный URL недействителен.",
	["mp.error.request_failed"]         = "Запрос не выполнен: %s",
	["mp.error.audio_load_failed"]      = "Не удалось загрузить аудио медиаплеера '%s'",
	["mp.error.audio_stream"]           = "Возникла проблема при получении аудиопотока, попробуйте ещё раз.",
	["mp.success.url_copied"]           = "URL медиа скопирован в буфер обмена.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Запрошенное медиа не поддерживается; поддерживаемые сервисы:\n",
	["mp.error.queue_locked"]           = "Запрошенное медиа не может быть добавлено, так как очередь заблокирована.",
	["mp.error.request_denied"]         = "Ваш запрос на медиа был отклонён.",
	["mp.error.queue_full"]             = "Очередь медиаплеера заполнена.",
	["mp.error.duplicate_request"]      = "Запрошенное медиа уже находится в очереди",
	["mp.error.metadata_fetch"]         = "Возникла проблема при получении метаданных запрошенного медиа.",
	["mp.error.queue_denied"]           = "Запрошенное медиа не удалось добавить в очередь.",
	["mp.success.added_to_queue"]       = "'%s' добавлено в очередь",
	["mp.error.no_permission"]          = "У вас нет прав для выполнения этого действия.",
	["mp.error.seek_past_duration"]     = "Запрошенное время перемотки превышает длительность медиа.",

	-- Settings
	["mp.settings.title"]               = "НАСТРОЙКИ",
	["mp.settings.audio"]               = "Аудио",
	["mp.settings.3d_audio"]            = "3D пространственный звук",
	["mp.settings.proximity_min"]       = "Минимальное расстояние",
	["mp.settings.proximity_max"]       = "Максимальное расстояние",
	["mp.settings.mute_unfocused"]      = "Без звука при потере фокуса",
})