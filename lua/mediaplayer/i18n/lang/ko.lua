-- Korean / 한국어
MediaPlayer.i18n.RegisterLanguage("ko", {

	-- Idle screen
	["mp.idle.no_media"]                = "재생 중인 미디어 없음",
	["mp.idle.hint"]                    = "미디어 플레이어를 바라보며 %s 키를 길게 누르면 대기열 메뉴가 표시됩니다.",
	["mp.idle.press_e"]                 = "E 키를 눌러 시청 시작",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "현재 재생 중",
	["mp.ui.no_media"]                  = "재생 중인 미디어 없음",
	["mp.ui.next_up"]                   = "다음 재생",
	["mp.ui.add_media"]                 = "미디어 추가",
	["mp.ui.added_by"]                  = "추가한 사람",
	["mp.ui.unknown"]                   = "알 수 없음",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "이미 건너뛰기에 투표하셨습니다.",
	["mp.voteskip.vote_cast"]           = "투표 건너뛰기: %d/%d 표 (%d 표 더 필요)",
	["mp.voteskip.passed"]              = "투표 건너뛰기 통과! 건너뛰는 중...",

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
	["mp.error.audio_load_failed"]      = "오디오 '%s' 로드에 실패했습니다",
	["mp.error.audio_stream"]           = "오디오 스트림 수신 중 문제가 발생했습니다. 다시 시도해 주세요.",
	["mp.success.url_copied"]           = "미디어 URL이 클립보드에 복사되었습니다.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "요청한 미디어는 지원되지 않습니다. 허용된 서비스는 다음과 같습니다:\n",
	["mp.error.queue_locked"]           = "대기열이 잠겨 있어 미디어를 추가할 수 없습니다.",
	["mp.error.request_denied"]         = "미디어 요청이 거부되었습니다.",
	["mp.error.queue_full"]             = "미디어 플레이어 대기열이 가득 찼습니다.",
	["mp.error.duplicate_request"]      = "요청한 미디어가 이미 대기열에 있습니다",
	["mp.error.metadata_fetch"]         = "요청한 미디어의 메타데이터를 가져오는 중 문제가 발생했습니다.",
	["mp.error.queue_denied"]           = "요청한 미디어를 대기열에 추가할 수 없습니다.",
	["mp.error.media_url_failed"]       = "미디어 URL을 처리하지 못했습니다.",
	["mp.error.request_error"]          = "[요청 오류] %s",
	["mp.success.added_to_queue"]       = "'%s'이(가) 대기열에 추가되었습니다",
	["mp.error.no_permission"]          = "해당 작업을 수행할 권한이 없습니다.",
	["mp.error.seek_past_duration"]     = "요청한 탐색 시간이 미디어 길이를 초과합니다.",

	-- Settings
	["mp.settings.title"]               = "설정",
	["mp.settings.audio"]               = "오디오",
	["mp.settings.3d_audio"]            = "3D 공간 오디오",
	["mp.settings.proximity_min"]       = "근접 최소 거리",
	["mp.settings.proximity_max"]       = "근접 최대 거리",
	["mp.settings.proximity_units"]     = "%s 유닛",
	["mp.settings.mute_unfocused"]      = "비활성 시 음소거",
	["mp.settings.show_radius"]         = "근접 반경 표시",
	["mp.settings.subtitles"]           = "자막",
	["mp.settings.subtitles_off"]       = "끄기",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "지원되지 않는 미디어 유형",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "공간 미디어 플레이어",
	["mp.tool.spatial.label"]           = "공간 미디어",
	["mp.tool.spatial.desc"]            = "MediaPlayer 오디오를 월드에 고정하거나 엔티티를 따라가게 합니다.",
	["mp.tool.spatial.usage"]           = "좌클릭: 공간 소스 배치. 우클릭: 제거.",
	["mp.tool.spatial.help_place"]      = "프롭, 플레이어 또는 NPC를 좌클릭하여 공간 오디오 소스를 부착합니다. 월드를 클릭하면 해당 위치에 고정됩니다.",
	["mp.tool.spatial.help_remove"]     = "대상을 우클릭하여 공간 소스를 제거합니다.",
	["mp.tool.spatial.help_sidebar"]    = "미디어를 요청하거나 재생을 제어하려면 오브젝트를 바라보며 C를 길게 눌러 사이드바를 엽니다 — 다른 미디어 플레이어와 동일하게 작동합니다.",
	["mp.tool.spatial.hint_press_c"]    = "공간 미디어 소스가 배치되었습니다! 오브젝트를 바라보며 C를 길게 눌러 사이드바를 열고 미디어를 요청하세요.",
	["mp.tool.spatial.undo"]            = "공간 미디어 소스",

	-- Spatial player
	["mp.spatial.no_permission"]        = "이 공간 미디어 소스를 제어할 권한이 없습니다.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "미믹 미디어 플레이어",
	["mp.tool.mimic.desc"]              = "다른 미디어 플레이어의 비디오 출력을 두 번째 화면에 미러링합니다.",
	["mp.tool.mimic.usage"]             = "좌클릭: 소스 복사. 우클릭: 대상에 붙여넣기. 재장전 (R): 미믹 제거.",
	["mp.tool.mimic.help_copy"]         = "미디어 플레이어를 좌클릭하여 비디오 소스로 복사합니다.",
	["mp.tool.mimic.help_paste"]        = "다른 미디어 플레이어를 우클릭하여 붙여넣기 — 소스를 미러링합니다. 여러 화면에 붙여넣을 수 있습니다.",
	["mp.tool.mimic.help_remove"]       = "미믹 플레이어에서 재장전 (R)을 눌러 제거하고 원본을 복원합니다.",
	["mp.tool.mimic.source_copied"]     = "소스가 복사되었습니다! 다른 미디어 플레이어를 우클릭하여 붙여넣으세요.",
	["mp.tool.mimic.pasted"]            = "미믹 적용! 이 화면은 이제 소스를 미러링합니다.",
	["mp.tool.mimic.removed"]           = "미믹이 제거되었습니다. 엔티티가 복원되었습니다.",
	["mp.tool.mimic.undo"]              = "미믹 미디어 플레이어",
	["mp.tool.mimic.error_not_mp"]      = "이 엔티티에는 미디어 플레이어가 없습니다.",
	["mp.tool.mimic.error_spatial"]     = "공간 미디어 플레이어는 미믹할 수 없습니다.",
	["mp.tool.mimic.error_same"]        = "소스와 대상은 같은 엔티티일 수 없습니다.",
	["mp.tool.mimic.error_no_source"]   = "아직 소스가 복사되지 않았습니다. 먼저 미디어 플레이어를 좌클릭하세요.",
	["mp.tool.mimic.error_source_gone"] = "복사한 소스가 더 이상 존재하지 않습니다. 새 소스를 좌클릭하세요.",
	["mp.tool.mimic.error_mimic_source"] = "미믹 플레이어에서는 복사할 수 없습니다. 원본 소스에서 복사하세요.",
	["mp.tool.mimic.error_already_linked"] = "이 엔티티는 이미 해당 소스를 미러링하고 있습니다.",
	["mp.tool.mimic.error_not_mimic"]   = "이 엔티티는 미믹 플레이어가 아닙니다.",
	["mp.tool.mimic.error_has_content"] = "자체 콘텐츠를 제공 중인 미디어 플레이어는 미믹할 수 없습니다. 먼저 미디어를 중지하거나 지우세요.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "브라우저 한도 도달",
	["mp.error.browser_limit_detail"]   = "모든 브라우저 슬롯이 사용 중입니다 (%d/%d 활성).",
	["mp.error.browser_limit_note"]     = "슬롯이 비워지기를 기다리는 중입니다. 이것은 버그가 아닙니다.",
})