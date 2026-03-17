-- Russian / Русский
MediaPlayer.i18n.RegisterLanguage("ru", {

	-- Idle screen
	["mp.idle.no_media"]                = "Медиа не воспроизводится",
	["mp.idle.hint"]                    = "Удерживайте %s, глядя на медиаплеер, чтобы открыть меню очереди.",
	["mp.idle.press_e"]                 = "Нажмите E, чтобы начать просмотр",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "СЕЙЧАС ВОСПРОИЗВОДИТСЯ",
	["mp.ui.no_media"]                  = "Медиа не воспроизводится",
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
	["mp.property.copy_url"]            = "Скопировать URL в буфер обмена",
	["mp.property.fullscreen"]          = "Переключить полноэкранный режим (F11)",
	["mp.property.turn_on"]             = "Включить",
	["mp.property.turn_off"]            = "Выключить",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Медиаплеер",
	["mp.menu.fullscreen"]              = "Полный экран",
	["mp.menu.turn_off_all"]            = "Выключить всё",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Запрошенный URL недействителен.",
	["mp.error.request_failed"]         = "Ошибка запроса: %s",
	["mp.error.audio_load_failed"]      = "Не удалось загрузить аудио '%s'",
	["mp.error.audio_stream"]           = "Возникла проблема при получении аудиопотока, попробуйте снова.",
	["mp.success.url_copied"]           = "URL медиа скопирован в буфер обмена.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Запрошенное медиа не поддерживается; допустимые сервисы:\n",
	["mp.error.queue_locked"]           = "Медиа не может быть добавлено, так как очередь заблокирована.",
	["mp.error.request_denied"]         = "Ваш запрос медиа был отклонён.",
	["mp.error.queue_full"]             = "Очередь медиаплеера заполнена.",
	["mp.error.duplicate_request"]      = "Запрошенное медиа уже в очереди",
	["mp.error.metadata_fetch"]         = "Возникла проблема при получении метаданных запрошенного медиа.",
	["mp.error.queue_denied"]           = "Запрошенное медиа не удалось поставить в очередь.",
	["mp.error.media_url_failed"]       = "Не удалось обработать URL медиа.",
	["mp.error.request_error"]          = "[Ошибка запроса] %s",
	["mp.success.added_to_queue"]       = "'%s' добавлено в очередь",
	["mp.error.no_permission"]          = "У вас нет разрешения на это действие.",
	["mp.error.seek_past_duration"]     = "Запрошенное время перемотки превышает длительность медиа.",

	-- Settings
	["mp.settings.title"]               = "НАСТРОЙКИ",
	["mp.settings.audio"]               = "Аудио",
	["mp.settings.3d_audio"]            = "3D пространственное аудио",
	["mp.settings.proximity_min"]       = "Минимальное расстояние близости",
	["mp.settings.proximity_max"]       = "Максимальное расстояние близости",
	["mp.settings.proximity_units"]     = "%s единиц",
	["mp.settings.mute_unfocused"]      = "Отключить звук при потере фокуса",
	["mp.settings.language"]            = "Язык",
	["mp.settings.language_auto"]       = "Автоматически (системный)",
	["mp.settings.show_radius"]         = "Показать радиус близости",
	["mp.settings.subtitles"]           = "Субтитры",
	["mp.settings.subtitles_off"]       = "Выкл.",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Пространственный медиаплеер",
	["mp.tool.spatial.label"]           = "Пространственное медиа",
	["mp.tool.spatial.desc"]            = "Закрепите аудио MediaPlayer в мире или привяжите его к объекту.",
	["mp.tool.spatial.usage"]           = "ЛКМ: разместить пространственный источник. ПКМ: удалить.",
	["mp.tool.spatial.help_place"]      = "Нажмите ЛКМ на проп, игрока или NPC, чтобы прикрепить пространственный источник звука. Нажмите на мир, чтобы закрепить его на месте.",
	["mp.tool.spatial.help_remove"]     = "Нажмите ПКМ на цель, чтобы удалить её пространственный источник.",
	["mp.tool.spatial.help_sidebar"]    = "Чтобы запросить медиа или управлять воспроизведением, смотрите на объект и удерживайте C для открытия боковой панели — она работает так же, как любой другой медиаплеер.",
	["mp.tool.spatial.hint_press_c"]    = "Пространственный источник медиа размещён! Удерживайте C, глядя на объект, чтобы открыть боковую панель и запросить медиа.",
	["mp.tool.spatial.undo"]            = "Пространственный источник медиа",

	-- Spatial player
	["mp.spatial.no_permission"]        = "У вас нет разрешения управлять этим пространственным источником медиа.",
})