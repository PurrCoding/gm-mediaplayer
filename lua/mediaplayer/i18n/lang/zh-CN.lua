-- Simplified Chinese / 简体中文
MediaPlayer.i18n.RegisterLanguage("zh-cn", {

	-- Idle screen
	["mp.idle.no_media"]                = "没有正在播放的媒体",
	["mp.idle.hint"]                    = "看着媒体播放器时按住 %s 以显示队列菜单。",
	["mp.idle.press_e"]                 = "按 E 开始观看",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "正在播放",
	["mp.ui.no_media"]                  = "没有正在播放的媒体",
	["mp.ui.next_up"]                   = "接下来",
	["mp.ui.add_media"]                 = "添加媒体",
	["mp.ui.added_by"]                  = "添加者",
	["mp.ui.unknown"]                   = "未知",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "您已经投过跳过票了。",
	["mp.voteskip.vote_cast"]           = "投票跳过：%d/%d 票（还需 %d 票）",
	["mp.voteskip.passed"]              = "投票跳过通过！正在跳过...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "重复",
	["mp.ui.shuffle"]                   = "随机播放",
	["mp.ui.toggle_queue_lock"]         = "切换队列锁定",

	-- Browser controls
	["mp.ui.search_for_media"]          = "搜索媒体",
	["mp.ui.request_url"]               = "请求 URL",

	-- Context menu properties
	["mp.property.pause"]               = "暂停",
	["mp.property.resume"]              = "继续",
	["mp.property.skip"]                = "跳过",
	["mp.property.seek"]                = "跳转",
	["mp.property.seek_title"]          = "媒体播放器",
	["mp.property.seek_prompt"]         = "请输入 HH:MM:SS 格式的时间（时、分、秒）：",
	["mp.property.seek_confirm"]        = "跳转",
	["mp.property.seek_cancel"]         = "取消",
	["mp.property.request_url"]         = "请求 URL",
	["mp.property.copy_url"]            = "复制 URL 到剪贴板",
	["mp.property.fullscreen"]          = "切换全屏 (F11)",
	["mp.property.turn_on"]             = "开启",
	["mp.property.turn_off"]            = "关闭",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  媒体播放器",
	["mp.menu.fullscreen"]              = "全屏",
	["mp.menu.turn_off_all"]            = "全部关闭",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "请求的 URL 无效。",
	["mp.error.request_failed"]         = "请求失败：%s",
	["mp.error.audio_load_failed"]      = "无法加载音频 '%s'",
	["mp.error.audio_stream"]           = "接收音频流时出现问题，请重试。",
	["mp.success.url_copied"]           = "媒体 URL 已复制到剪贴板。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "请求的媒体不受支持；允许的服务如下：\n",
	["mp.error.queue_locked"]           = "队列已锁定，无法添加媒体。",
	["mp.error.request_denied"]         = "您的媒体请求已被拒绝。",
	["mp.error.queue_full"]             = "媒体播放器队列已满。",
	["mp.error.duplicate_request"]      = "请求的媒体已在队列中",
	["mp.error.metadata_fetch"]         = "获取请求媒体的元数据时出现问题。",
	["mp.error.queue_denied"]           = "请求的媒体无法加入队列。",
	["mp.error.media_url_failed"]       = "无法处理媒体 URL。",
	["mp.error.request_error"]          = "[请求错误] %s",
	["mp.success.added_to_queue"]       = "'%s' 已添加到队列",
	["mp.error.no_permission"]          = "您没有权限执行此操作。",
	["mp.error.seek_past_duration"]     = "请求的跳转时间超过了媒体时长。",

	-- Settings
	["mp.settings.title"]               = "设置",
	["mp.settings.audio"]               = "音频",
	["mp.settings.3d_audio"]            = "3D 空间音频",
	["mp.settings.proximity_min"]       = "最小接近距离",
	["mp.settings.proximity_max"]       = "最大接近距离",
	["mp.settings.proximity_units"]     = "%s 单位",
	["mp.settings.mute_unfocused"]      = "失去焦点时静音",
	["mp.settings.show_radius"]         = "显示接近半径",
	["mp.settings.subtitles"]           = "字幕",
	["mp.settings.subtitles_off"]       = "关闭",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "不支持的媒体类型",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "空间媒体播放器",
	["mp.tool.spatial.label"]           = "空间媒体",
	["mp.tool.spatial.desc"]            = "将 MediaPlayer 音频固定到世界中或让其跟随实体。",
	["mp.tool.spatial.usage"]           = "左键点击：放置空间源。右键点击：移除。",
	["mp.tool.spatial.help_place"]      = "左键点击道具、玩家或 NPC 以附加空间音频源。左键点击世界以将其固定在原地。",
	["mp.tool.spatial.help_remove"]     = "右键点击目标以移除其空间源。",
	["mp.tool.spatial.help_sidebar"]    = "要请求媒体或控制播放，请看着物体并按住 C 打开侧边栏——它的使用方式与其他媒体播放器相同。",
	["mp.tool.spatial.hint_press_c"]    = "空间媒体源已放置！看着物体并按住 C 打开侧边栏以请求媒体。",
	["mp.tool.spatial.undo"]            = "空间媒体源",

	-- Spatial player
	["mp.spatial.no_permission"]        = "您没有权限控制此空间媒体源。",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "镜像媒体播放器",
	["mp.tool.mimic.desc"]              = "将另一个媒体播放器的视频输出镜像到第二个屏幕。",
	["mp.tool.mimic.usage"]             = "左键点击：复制源。右键点击：粘贴到目标。重新装填 (R)：移除镜像。",
	["mp.tool.mimic.help_copy"]         = "左键点击一个媒体播放器将其复制为视频源。",
	["mp.tool.mimic.help_paste"]        = "右键点击其他媒体播放器进行粘贴——它们将镜像源。可以粘贴到多个屏幕。",
	["mp.tool.mimic.help_remove"]       = "在镜像播放器上按重新装填 (R) 以移除并恢复原始状态。",
	["mp.tool.mimic.source_copied"]     = "源已复制！右键点击其他媒体播放器进行粘贴。",
	["mp.tool.mimic.pasted"]            = "镜像已应用！此屏幕现在镜像源。",
	["mp.tool.mimic.removed"]           = "镜像已移除。实体已恢复正常。",
	["mp.tool.mimic.undo"]              = "镜像媒体播放器",
	["mp.tool.mimic.error_not_mp"]      = "此实体没有媒体播放器。",
	["mp.tool.mimic.error_spatial"]     = "无法镜像空间媒体播放器。",
	["mp.tool.mimic.error_same"]        = "源和目标不能是同一个实体。",
	["mp.tool.mimic.error_no_source"]   = "尚未复制源。请先左键点击一个媒体播放器。",
	["mp.tool.mimic.error_source_gone"] = "复制的源已不存在。请左键点击一个新的源。",
	["mp.tool.mimic.error_mimic_source"] = "无法从镜像播放器复制。请从原始源复制。",
	["mp.tool.mimic.error_already_linked"] = "此实体已在镜像该源。",
	["mp.tool.mimic.error_not_mimic"]   = "此实体不是镜像播放器。",
	["mp.tool.mimic.error_has_content"] = "无法镜像正在播放自身内容的媒体播放器。请先停止或清除其媒体。",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "已达浏览器上限",
	["mp.error.browser_limit_detail"]   = "所有浏览器槽位均在使用中（%d/%d 活跃）。",
	["mp.error.browser_limit_note"]     = "正在等待槽位释放。这不是一个错误。",
})