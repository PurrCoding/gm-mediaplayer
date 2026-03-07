-- Ukrainian / Українська
MediaPlayer.i18n.RegisterLanguage("uk", {

	-- Idle screen
	["mp.idle.no_media"]                = "Нічого не відтворюється",
	["mp.idle.hint"]                    = "Утримуйте %s, дивлячись на медіаплеєр, щоб відкрити меню черги.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "ЗАРАЗ ВІДТВОРЮЄТЬСЯ",
	["mp.ui.no_media"]                  = "Нічого не відтворюється",
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
	["mp.property.copy_url"]            = "Копіювати URL до буфера обміну",
	["mp.property.fullscreen"]          = "Перемкнути повноекранний режим (F11)",
	["mp.property.turn_on"]             = "Увімкнути",
	["mp.property.turn_off"]            = "Вимкнути",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Медіаплеєр",
	["mp.menu.fullscreen"]              = "Повний екран",
	["mp.menu.turn_off_all"]            = "Вимкнути все",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Запитана URL-адреса недійсна.",
	["mp.error.request_failed"]         = "Запит не виконано: %s",
	["mp.error.audio_load_failed"]      = "Не вдалося завантажити аудіо медіаплеєра '%s'",
	["mp.error.audio_stream"]           = "Виникла проблема з отриманням аудіопотоку, спробуйте ще раз.",
	["mp.success.url_copied"]           = "URL медіа скопійовано до буфера обміну.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Запитане медіа не підтримується; підтримувані сервіси:\n",
	["mp.error.queue_locked"]           = "Запитане медіа не може бути додане, оскільки чергу заблоковано.",
	["mp.error.request_denied"]         = "Ваш запит на медіа було відхилено.",
	["mp.error.queue_full"]             = "Черга медіаплеєра заповнена.",
	["mp.error.duplicate_request"]      = "Запитане медіа вже є в черзі",
	["mp.error.metadata_fetch"]         = "Виникла проблема з отриманням метаданих запитаного медіа.",
	["mp.error.queue_denied"]           = "Запитане медіа не вдалося додати до черги.",
	["mp.success.added_to_queue"]       = "'%s' додано до черги",
	["mp.error.no_permission"]          = "У вас немає дозволу на цю дію.",
	["mp.error.seek_past_duration"]     = "Запитаний час перемотки перевищує тривалість медіа.",
})