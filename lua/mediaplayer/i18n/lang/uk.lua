-- Ukrainian / Українська
MediaPlayer.i18n.RegisterLanguage("uk", {

	-- Idle screen
	["mp.idle.no_media"]                = "Медіа не відтворюється",
	["mp.idle.hint"]                    = "Утримуйте %s, дивлячись на медіаплеєр, щоб відкрити меню черги.",
	["mp.idle.press_e"]                 = "Натисніть E, щоб почати перегляд",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "ЗАРАЗ ВІДТВОРЮЄТЬСЯ",
	["mp.ui.no_media"]                  = "Медіа не відтворюється",
	["mp.ui.next_up"]                   = "ДАЛІ",
	["mp.ui.add_media"]                 = "ДОДАТИ МЕДІА",
	["mp.ui.added_by"]                  = "ДОДАВ",
	["mp.ui.unknown"]                   = "Невідомо",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Повтор",
	["mp.ui.shuffle"]                   = "Перемішати",
	["mp.ui.toggle_queue_lock"]         = "Перемкнути блокування черги",

	-- Browser controls
	["mp.ui.search_for_media"]          = "ПОШУК МЕДІА",
	["mp.ui.request_url"]               = "ЗАПИТАТИ URL",

	-- Context menu properties
	["mp.property.pause"]               = "Пауза",
	["mp.property.resume"]              = "Продовжити",
	["mp.property.skip"]                = "Пропустити",
	["mp.property.seek"]                = "Перемотка",
	["mp.property.seek_title"]          = "Медіаплеєр",
	["mp.property.seek_prompt"]         = "Введіть час у форматі ГГ:ХХ:СС (години, хвилини, секунди):",
	["mp.property.seek_confirm"]        = "Перемотати",
	["mp.property.seek_cancel"]         = "Скасувати",
	["mp.property.request_url"]         = "Запитати URL",
	["mp.property.copy_url"]            = "Скопіювати URL до буфера обміну",
	["mp.property.fullscreen"]          = "Перемкнути повноекранний режим (F11)",
	["mp.property.turn_on"]             = "Увімкнути",
	["mp.property.turn_off"]            = "Вимкнути",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Медіаплеєр",
	["mp.menu.fullscreen"]              = "Повний екран",
	["mp.menu.turn_off_all"]            = "Вимкнути все",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Запитаний URL недійсний.",
	["mp.error.request_failed"]         = "Помилка запиту: %s",
	["mp.error.audio_load_failed"]      = "Не вдалося завантажити аудіо '%s'",
	["mp.error.audio_stream"]           = "Виникла проблема з отриманням аудіопотоку, спробуйте ще раз.",
	["mp.success.url_copied"]           = "URL медіа скопійовано до буфера обміну.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Запитане медіа не підтримується; дозволені сервіси:\n",
	["mp.error.queue_locked"]           = "Медіа не вдалося додати, оскільки чергу заблоковано.",
	["mp.error.request_denied"]         = "Ваш запит медіа було відхилено.",
	["mp.error.queue_full"]             = "Черга медіаплеєра заповнена.",
	["mp.error.duplicate_request"]      = "Запитане медіа вже в черзі",
	["mp.error.metadata_fetch"]         = "Виникла проблема з отриманням метаданих запитаного медіа.",
	["mp.error.queue_denied"]           = "Запитане медіа не вдалося додати до черги.",
	["mp.error.media_url_failed"]       = "Не вдалося обробити URL медіа.",
	["mp.error.request_error"]          = "[Помилка запиту] %s",
	["mp.success.added_to_queue"]       = "'%s' додано до черги",
	["mp.error.no_permission"]          = "У вас немає дозволу на цю дію.",
	["mp.error.seek_past_duration"]     = "Запитаний час перемотки перевищує тривалість медіа.",

	-- Settings
	["mp.settings.title"]               = "НАЛАШТУВАННЯ",
	["mp.settings.audio"]               = "Аудіо",
	["mp.settings.3d_audio"]            = "3D просторове аудіо",
	["mp.settings.proximity_min"]       = "Мінімальна відстань наближення",
	["mp.settings.proximity_max"]       = "Максимальна відстань наближення",
	["mp.settings.proximity_units"]     = "%s одиниць",
	["mp.settings.mute_unfocused"]      = "Вимкнути звук при втраті фокусу",
	["mp.settings.language"]            = "Мова",
	["mp.settings.language_auto"]       = "Автоматично (системна)",
	["mp.settings.show_radius"]         = "Показати радіус наближення",
	["mp.settings.subtitles"]           = "Субтитри",
	["mp.settings.subtitles_off"]       = "Вимк.",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Просторовий медіаплеєр",
	["mp.tool.spatial.label"]           = "Просторове медіа",
	["mp.tool.spatial.desc"]            = "Закріпіть аудіо MediaPlayer у світі або прив'яжіть його до об'єкта.",
	["mp.tool.spatial.usage"]           = "ЛКМ: розмістити просторове джерело. ПКМ: видалити.",
	["mp.tool.spatial.help_place"]      = "Натисніть ЛКМ на проп, гравця або NPC, щоб прикріпити просторове джерело звуку. Натисніть на світ, щоб закріпити його на місці.",
	["mp.tool.spatial.help_remove"]     = "Натисніть ПКМ на ціль, щоб видалити її просторове джерело.",
	["mp.tool.spatial.help_sidebar"]    = "Щоб запитати медіа або керувати відтворенням, дивіться на об'єкт і утримуйте C для відкриття бічної панелі — вона працює так само, як будь-який інший медіаплеєр.",
	["mp.tool.spatial.hint_press_c"]    = "Просторове джерело медіа розміщено! Утримуйте C, дивлячись на об'єкт, щоб відкрити бічну панель і запитати медіа.",
	["mp.tool.spatial.undo"]            = "Просторове джерело медіа",

	-- Spatial player
	["mp.spatial.no_permission"]        = "У вас немає дозволу керувати цим просторовим джерелом медіа.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Досягнуто ліміт браузерів",
	["mp.error.browser_limit_detail"]   = "Усі слоти браузера зайняті (%d/%d активних).",
	["mp.error.browser_limit_note"]     = "Очікування звільнення слота. Це не помилка.",
})