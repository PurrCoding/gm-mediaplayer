-- Chinese Traditional (Taiwanese) / 繁體中文
MediaPlayer.i18n.RegisterLanguage("zh-TW", {

	-- Idle screen
	["mp.idle.no_media"]                = "沒有正在播放的媒體",
	["mp.idle.hint"]                    = "看著媒體播放器時按住 %s 可開啟佇列選單。",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "正在播放",
	["mp.ui.no_media"]                  = "沒有正在播放的媒體",
	["mp.ui.next_up"]                   = "即將播放",
	["mp.ui.add_media"]                 = "新增媒體",
	["mp.ui.added_by"]                  = "新增者",
	["mp.ui.unknown"]                   = "未知",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "重複播放",
	["mp.ui.shuffle"]                   = "隨機播放",
	["mp.ui.toggle_queue_lock"]         = "切換佇列鎖定",

	-- Browser controls
	["mp.ui.search_for_media"]          = "搜尋媒體",
	["mp.ui.request_url"]               = "請求URL",

	-- Context menu properties
	["mp.property.pause"]               = "暫停",
	["mp.property.resume"]              = "繼續",
	["mp.property.skip"]                = "跳過",
	["mp.property.seek"]                = "跳轉",
	["mp.property.seek_title"]          = "媒體播放器",
	["mp.property.seek_prompt"]         = "請輸入 HH:MM:SS 格式的時間（時、分、秒）：",
	["mp.property.seek_confirm"]        = "跳轉",
	["mp.property.seek_cancel"]         = "取消",
	["mp.property.request_url"]         = "請求URL",
	["mp.property.copy_url"]            = "複製URL到剪貼簿",
	["mp.property.fullscreen"]          = "切換全螢幕 (F11)",
	["mp.property.turn_on"]             = "開啟",
	["mp.property.turn_off"]            = "關閉",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  媒體播放器",
	["mp.menu.fullscreen"]              = "全螢幕",
	["mp.menu.turn_off_all"]            = "全部關閉",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "請求的URL無效。",
	["mp.error.request_failed"]         = "請求失敗：%s",
	["mp.error.audio_load_failed"]      = "無法載入媒體播放器音訊 '%s'",
	["mp.error.audio_stream"]           = "接收音訊串流時出現問題，請重試。",
	["mp.success.url_copied"]           = "媒體URL已複製到剪貼簿。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "請求的媒體不受支援；支援的服務如下：\n",
	["mp.error.queue_locked"]           = "佇列已鎖定，無法新增請求的媒體。",
	["mp.error.request_denied"]         = "您的媒體請求已被拒絕。",
	["mp.error.queue_full"]             = "媒體播放器佇列已滿。",
	["mp.error.duplicate_request"]      = "請求的媒體已在佇列中",
	["mp.error.metadata_fetch"]         = "取得請求媒體的中繼資料時出現問題。",
	["mp.error.queue_denied"]           = "請求的媒體無法加入佇列。",
	["mp.success.added_to_queue"]       = "已將 '%s' 新增至佇列",
	["mp.error.no_permission"]          = "您沒有權限執行此操作。",
	["mp.error.seek_past_duration"]     = "請求的跳轉時間超過了媒體時長。",
})