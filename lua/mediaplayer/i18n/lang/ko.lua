-- Korean / 한국어
MediaPlayer.i18n.RegisterLanguage("ko", {

	-- Idle screen
	["mp.idle.no_media"]                = "재생 중인 미디어 없음",
	["mp.idle.hint"]                    = "미디어 플레이어를 보면서 %s 키를 길게 누르면 대기열 메뉴가 나타납니다.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "현재 재생 중",
	["mp.ui.no_media"]                  = "재생 중인 미디어 없음",
	["mp.ui.next_up"]                   = "다음 재생",
	["mp.ui.add_media"]                 = "미디어 추가",
	["mp.ui.added_by"]                  = "추가한 사람",
	["mp.ui.unknown"]                   = "알 수 없음",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "반복",
	["mp.ui.shuffle"]                   = "셔플",
	["mp.ui.toggle_queue_lock"]         = "대기열 잠금 전환",

	-- Browser controls
	["mp.ui.search_for_media"]          = "미디어 검색",
	["mp.ui.request_url"]               = "URL 요청",

	-- Context menu properties
	["mp.property.pause"]               = "일시정지",
	["mp.property.resume"]              = "재개",
	["mp.property.skip"]                = "건너뛰기",
	["mp.property.seek"]                = "탐색",
	["mp.property.seek_title"]          = "미디어 플레이어",
	["mp.property.seek_prompt"]         = "HH:MM:SS 형식으로 시간을 입력하세요 (시, 분, 초):",
	["mp.property.seek_confirm"]        = "탐색",
	["mp.property.seek_cancel"]         = "취소",
	["mp.property.request_url"]         = "URL 요청",
	["mp.property.copy_url"]            = "URL을 클립보드에 복사",
	["mp.property.fullscreen"]          = "전체 화면 전환 (F11)",
	["mp.property.turn_on"]             = "켜기",
	["mp.property.turn_off"]            = "끄기",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  미디어 플레이어",
	["mp.menu.fullscreen"]              = "전체 화면",
	["mp.menu.turn_off_all"]            = "모두 끄기",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "요청한 URL이 유효하지 않습니다.",
	["mp.error.request_failed"]         = "요청 실패: %s",
	["mp.error.audio_load_failed"]      = "미디어 플레이어 오디오 '%s'을(를) 로드하지 못했습니다",
	["mp.error.audio_stream"]           = "오디오 스트림을 수신하는 중 문제가 발생했습니다. 다시 시도해 주세요.",
	["mp.success.url_copied"]           = "미디어 URL이 클립보드에 복사되었습니다.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "요청한 미디어는 지원되지 않습니다. 허용된 서비스는 다음과 같습니다:\n",
	["mp.error.queue_locked"]           = "대기열이 잠겨 있어 요청한 미디어를 추가할 수 없습니다.",
	["mp.error.request_denied"]         = "미디어 요청이 거부되었습니다.",
	["mp.error.queue_full"]             = "미디어 플레이어 대기열이 가득 찼습니다.",
	["mp.error.duplicate_request"]      = "요청한 미디어가 이미 대기열에 있습니다",
	["mp.error.metadata_fetch"]         = "요청한 미디어의 메타데이터를 가져오는 중 문제가 발생했습니다.",
	["mp.error.queue_denied"]           = "요청한 미디어를 대기열에 추가할 수 없습니다.",
	["mp.success.added_to_queue"]       = "'%s'이(가) 대기열에 추가되었습니다",
	["mp.error.no_permission"]          = "해당 작업을 수행할 권한이 없습니다.",
	["mp.error.seek_past_duration"]     = "요청한 탐색 시간이 미디어 재생 시간을 초과했습니다.",

	-- Settings
	["mp.settings.title"]               = "설정",
	["mp.settings.audio"]               = "오디오",
	["mp.settings.3d_audio"]            = "3D 공간 오디오",
	["mp.settings.proximity_min"]       = "최소 거리",
	["mp.settings.proximity_max"]       = "최대 거리",
	["mp.settings.mute_unfocused"]      = "비활성 시 음소거",
})