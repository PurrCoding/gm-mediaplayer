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

	-- Voteskip
	["mp.voteskip.already_voted"]       = "Вы уже проголосовали за пропуск.",
	["mp.voteskip.vote_cast"]           = "Голосование: %d/%d голосов (нужно ещё %d)",
	["mp.voteskip.passed"]              = "Голосование принято! Пропускаем...",

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
	["mp.settings.show_radius"]         = "Показать радиус близости",
	["mp.settings.subtitles"]           = "Субтитры",
	["mp.settings.subtitles_off"]       = "Выкл.",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "Неподдерживаемый тип медиа",

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

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Зеркальный медиаплеер",
	["mp.tool.mimic.desc"]              = "Отразите видеовыход другого медиаплеера на второй экран.",
	["mp.tool.mimic.usage"]             = "ЛКМ: скопировать источник. ПКМ: вставить на цель(и). Перезарядка (R): удалить зеркало.",
	["mp.tool.mimic.help_copy"]         = "Нажмите ЛКМ на медиаплеер, чтобы скопировать его как источник видео.",
	["mp.tool.mimic.help_paste"]        = "Нажмите ПКМ на другие медиаплееры, чтобы вставить — они будут отражать источник. Можно вставить на несколько экранов.",
	["mp.tool.mimic.help_remove"]       = "Нажмите Перезарядку (R) на зеркальном плеере, чтобы удалить его и восстановить оригинал.",
	["mp.tool.mimic.source_copied"]     = "Источник скопирован! Нажмите ПКМ на другие медиаплееры, чтобы вставить.",
	["mp.tool.mimic.pasted"]            = "Зеркало применено! Этот экран теперь отражает источник.",
	["mp.tool.mimic.removed"]           = "Зеркало удалено. Объект восстановлен.",
	["mp.tool.mimic.undo"]              = "Зеркальный медиаплеер",
	["mp.tool.mimic.error_not_mp"]      = "У этой сущности нет медиаплеера.",
	["mp.tool.mimic.error_spatial"]     = "Невозможно отразить пространственный медиаплеер.",
	["mp.tool.mimic.error_same"]        = "Источник и цель не могут быть одной и той же сущностью.",
	["mp.tool.mimic.error_no_source"]   = "Источник ещё не скопирован. Сначала нажмите ЛКМ на медиаплеер.",
	["mp.tool.mimic.error_source_gone"] = "Скопированный источник больше не существует. Нажмите ЛКМ на новый источник.",
	["mp.tool.mimic.error_mimic_source"] = "Невозможно копировать с зеркального плеера. Копируйте с оригинального источника.",
	["mp.tool.mimic.error_already_linked"] = "Эта сущность уже отражает этот источник.",
	["mp.tool.mimic.error_not_mimic"]   = "Эта сущность не является зеркальным плеером.",
	["mp.tool.mimic.error_has_content"] = "Невозможно отразить медиаплеер, который воспроизводит собственный контент. Сначала остановите или очистите его медиа.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Достигнут лимит браузеров",
	["mp.error.browser_limit_detail"]   = "Все слоты браузера заняты (%d/%d активных).",
	["mp.error.browser_limit_note"]     = "Ожидание освобождения слота. Это не ошибка.",
})