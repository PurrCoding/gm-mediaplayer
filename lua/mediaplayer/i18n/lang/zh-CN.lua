-- Chinese Simplified / 简体中文
MediaPlayer.i18n.RegisterLanguage("zh-CN", {

	-- Idle screen
	["mp.idle.no_media"]                = "没有正在播放的媒体",
	["mp.idle.hint"]                    = "看着媒体播放器时按住 %s 可打开队列菜单。",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "正在播放",
	["mp.ui.no_media"]                  = "没有正在播放的媒体",
	["mp.ui.next_up"]                   = "即将播放",
	["mp.ui.add_media"]                 = "添加媒体",
	["mp.ui.added_by"]                  = "添加者",
	["mp.ui.unknown"]                   = "未知",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "重复播放",
	["mp.ui.shuffle"]                   = "随机播放",
	["mp.ui.toggle_queue_lock"]         = "切换队列锁定",

	-- Browser controls
	["mp.ui.search_for_media"]          = "搜索媒体",
	["mp.ui.request_url"]               = "请求URL",

	-- Context menu properties
	["mp.property.pause"]               = "暂停",
	["mp.property.resume"]              = "继续",
	["mp.property.skip"]                = "跳过",
	["mp.property.seek"]                = "跳转",
	["mp.property.seek_title"]          = "媒体播放器",
	["mp.property.seek_prompt"]         = "请输入 HH:MM:SS 格式的时间（时、分、秒）：",
	["mp.property.seek_confirm"]        = "跳转",
	["mp.property.seek_cancel"]         = "取消",
	["mp.property.request_url"]         = "请求URL",
	["mp.property.copy_url"]            = "复制URL到剪贴板",
	["mp.property.fullscreen"]          = "切换全屏 (F11)",
	["mp.property.turn_on"]             = "开启",
	["mp.property.turn_off"]            = "关闭",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  媒体播放器",
	["mp.menu.fullscreen"]              = "全屏",
	["mp.menu.turn_off_all"]            = "全部关闭",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "请求的URL无效。",
	["mp.error.request_failed"]         = "请求失败：%s",
	["mp.error.audio_load_failed"]      = "无法加载媒体播放器音频 '%s'",
	["mp.error.audio_stream"]           = "接收音频流时出现问题，请重试。",
	["mp.success.url_copied"]           = "媒体URL已复制到剪贴板。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "请求的媒体不受支持；支持的服务如下：\n",
	["mp.error.queue_locked"]           = "队列已锁定，无法添加请求的媒体。",
	["mp.error.request_denied"]         = "您的媒体请求已被拒绝。",
	["mp.error.queue_full"]             = "媒体播放器队列已满。",
	["mp.error.duplicate_request"]      = "请求的媒体已在队列中",
	["mp.error.metadata_fetch"]         = "获取请求媒体的元数据时出现问题。",
	["mp.error.queue_denied"]           = "请求的媒体无法加入队列。",
	["mp.success.added_to_queue"]       = "已将 '%s' 添加到队列",
	["mp.error.no_permission"]          = "您没有权限执行此操作。",
	["mp.error.seek_past_duration"]     = "请求的跳转时间超过了媒体时长。",

	-- Settings
	["mp.settings.title"]               = "设置",
	["mp.settings.audio"]               = "音频",
	["mp.settings.3d_audio"]            = "3D空间音频",
	["mp.settings.proximity_min"]       = "最小距离",
	["mp.settings.proximity_max"]       = "最大距离",
	["mp.settings.mute_unfocused"]      = "失去焦点时静音",
})