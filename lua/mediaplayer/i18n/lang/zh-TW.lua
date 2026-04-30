-- Traditional Chinese / 繁體中文
MediaPlayer.i18n.RegisterLanguage("zh-tw", {

	-- Idle screen
	["mp.idle.no_media"]                = "沒有正在播放的媒體",
	["mp.idle.hint"]                    = "看著媒體播放器時按住 %s 以顯示佇列選單。",
	["mp.idle.press_e"]                 = "按 E 開始觀看",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "正在播放",
	["mp.ui.no_media"]                  = "沒有正在播放的媒體",
	["mp.ui.next_up"]                   = "接下來",
	["mp.ui.add_media"]                 = "新增媒體",
	["mp.ui.added_by"]                  = "新增者",
	["mp.ui.unknown"]                   = "未知",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "您已經投過跳過票了。",
	["mp.voteskip.vote_cast"]           = "投票跳過：%d/%d 票（還需 %d 票）",
	["mp.voteskip.passed"]              = "投票跳過通過！正在跳過...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "重複",
	["mp.ui.shuffle"]                   = "隨機播放",
	["mp.ui.toggle_queue_lock"]         = "切換佇列鎖定",

	-- Browser controls
	["mp.ui.search_for_media"]          = "搜尋媒體",
	["mp.ui.request_url"]               = "請求 URL",

	-- Context menu properties
	["mp.property.pause"]               = "暫停",
	["mp.property.resume"]              = "繼續",
	["mp.property.skip"]                = "跳過",
	["mp.property.seek"]                = "跳轉",
	["mp.property.seek_title"]          = "媒體播放器",
	["mp.property.seek_prompt"]         = "請輸入 HH:MM:SS 格式的時間（時、分、秒）：",
	["mp.property.seek_confirm"]        = "跳轉",
	["mp.property.seek_cancel"]         = "取消",
	["mp.property.request_url"]         = "請求 URL",
	["mp.property.copy_url"]            = "複製 URL 到剪貼簿",
	["mp.property.fullscreen"]          = "切換全螢幕 (F11)",
	["mp.property.turn_on"]             = "開啟",
	["mp.property.turn_off"]            = "關閉",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  媒體播放器",
	["mp.menu.fullscreen"]              = "全螢幕",
	["mp.menu.turn_off_all"]            = "全部關閉",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "請求的 URL 無效。",
	["mp.error.request_failed"]         = "請求失敗：%s",
	["mp.error.audio_load_failed"]      = "無法載入音訊 '%s'",
	["mp.error.audio_stream"]           = "接收音訊串流時發生問題，請重試。",
	["mp.success.url_copied"]           = "媒體 URL 已複製到剪貼簿。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "請求的媒體不受支援；允許的服務如下：\n",
	["mp.error.queue_locked"]           = "佇列已鎖定，無法新增媒體。",
	["mp.error.request_denied"]         = "您的媒體請求已被拒絕。",
	["mp.error.queue_full"]             = "媒體播放器佇列已滿。",
	["mp.error.duplicate_request"]      = "請求的媒體已在佇列中",
	["mp.error.metadata_fetch"]         = "取得請求媒體的中繼資料時發生問題。",
	["mp.error.queue_denied"]           = "請求的媒體無法加入佇列。",
	["mp.error.media_url_failed"]       = "無法處理媒體 URL。",
	["mp.error.request_error"]          = "[請求錯誤] %s",
	["mp.success.added_to_queue"]       = "'%s' 已新增至佇列",
	["mp.error.no_permission"]          = "您沒有權限執行此操作。",
	["mp.error.seek_past_duration"]     = "請求的跳轉時間超過了媒體時長。",

	-- Settings
	["mp.settings.title"]               = "設定",
	["mp.settings.audio"]               = "音訊",
	["mp.settings.3d_audio"]            = "3D 空間音訊",
	["mp.settings.proximity_min"]       = "最小接近距離",
	["mp.settings.proximity_max"]       = "最大接近距離",
	["mp.settings.proximity_units"]     = "%s 單位",
	["mp.settings.mute_unfocused"]      = "失去焦點時靜音",
	["mp.settings.show_radius"]         = "顯示接近半徑",
	["mp.settings.subtitles"]           = "字幕",
	["mp.settings.subtitles_off"]       = "關閉",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "不支援的媒體類型",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "空間媒體播放器",
	["mp.tool.spatial.label"]           = "空間媒體",
	["mp.tool.spatial.desc"]            = "將 MediaPlayer 音訊固定到世界中或讓其跟隨實體。",
	["mp.tool.spatial.usage"]           = "左鍵點擊：放置空間源。右鍵點擊：移除。",
	["mp.tool.spatial.help_place"]      = "左鍵點擊道具、玩家或 NPC 以附加空間音訊源。左鍵點擊世界以將其固定在原地。",
	["mp.tool.spatial.help_remove"]     = "右鍵點擊目標以移除其空間源。",
	["mp.tool.spatial.help_sidebar"]    = "要請求媒體或控制播放，請看著物體並按住 C 開啟側邊欄——它的使用方式與其他媒體播放器相同。",
	["mp.tool.spatial.hint_press_c"]    = "空間媒體源已放置！看著物體並按住 C 開啟側邊欄以請求媒體。",
	["mp.tool.spatial.undo"]            = "空間媒體源",

	-- Spatial player
	["mp.spatial.no_permission"]        = "您沒有權限控制此空間媒體源。",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "鏡像媒體播放器",
	["mp.tool.mimic.desc"]              = "將另一個媒體播放器的影片輸出鏡像到第二個螢幕。",
	["mp.tool.mimic.usage"]             = "左鍵點擊：複製來源。右鍵點擊：貼上到目標。重新裝填 (R)：移除鏡像。",
	["mp.tool.mimic.help_copy"]         = "左鍵點擊一個媒體播放器將其複製為影片來源。",
	["mp.tool.mimic.help_paste"]        = "右鍵點擊其他媒體播放器進行貼上——它們將鏡像來源。可以貼上到多個螢幕。",
	["mp.tool.mimic.help_remove"]       = "在鏡像播放器上按重新裝填 (R) 以移除並恢復原始狀態。",
	["mp.tool.mimic.source_copied"]     = "來源已複製！右鍵點擊其他媒體播放器進行貼上。",
	["mp.tool.mimic.pasted"]            = "鏡像已套用！此螢幕現在鏡像來源。",
	["mp.tool.mimic.removed"]           = "鏡像已移除。實體已恢復正常。",
	["mp.tool.mimic.undo"]              = "鏡像媒體播放器",
	["mp.tool.mimic.error_not_mp"]      = "此實體沒有媒體播放器。",
	["mp.tool.mimic.error_spatial"]     = "無法鏡像空間媒體播放器。",
	["mp.tool.mimic.error_same"]        = "來源和目標不能是同一個實體。",
	["mp.tool.mimic.error_no_source"]   = "尚未複製來源。請先左鍵點擊一個媒體播放器。",
	["mp.tool.mimic.error_source_gone"] = "複製的來源已不存在。請左鍵點擊一個新的來源。",
	["mp.tool.mimic.error_mimic_source"] = "無法從鏡像播放器複製。請從原始來源複製。",
	["mp.tool.mimic.error_already_linked"] = "此實體已在鏡像該來源。",
	["mp.tool.mimic.error_not_mimic"]   = "此實體不是鏡像播放器。",
	["mp.tool.mimic.error_has_content"] = "無法鏡像正在播放自身內容的媒體播放器。請先停止或清除其媒體。",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "已達瀏覽器上限",
	["mp.error.browser_limit_detail"]   = "所有瀏覽器槽位均在使用中（%d/%d 活躍）。",
	["mp.error.browser_limit_note"]     = "正在等待槽位釋放。這不是一個錯誤。",
})