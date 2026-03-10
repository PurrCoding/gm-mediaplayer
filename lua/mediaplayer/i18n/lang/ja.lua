-- Japanese / 日本語
MediaPlayer.i18n.RegisterLanguage("ja", {

	-- Idle screen
	["mp.idle.no_media"]                = "再生中のメディアはありません",
	["mp.idle.hint"]                    = "メディアプレーヤーを見ながら %s を長押しすると、キューメニューが表示されます。",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "現在再生中",
	["mp.ui.no_media"]                  = "再生中のメディアはありません",
	["mp.ui.next_up"]                   = "次の再生",
	["mp.ui.add_media"]                 = "メディアを追加",
	["mp.ui.added_by"]                  = "追加者",
	["mp.ui.unknown"]                   = "不明",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "リピート",
	["mp.ui.shuffle"]                   = "シャッフル",
	["mp.ui.toggle_queue_lock"]         = "キューロックの切り替え",

	-- Browser controls
	["mp.ui.search_for_media"]          = "メディアを検索",
	["mp.ui.request_url"]               = "URLをリクエスト",

	-- Context menu properties
	["mp.property.pause"]               = "一時停止",
	["mp.property.resume"]              = "再開",
	["mp.property.skip"]                = "スキップ",
	["mp.property.seek"]                = "シーク",
	["mp.property.seek_title"]          = "メディアプレーヤー",
	["mp.property.seek_prompt"]         = "HH:MM:SS形式で時間を入力してください（時、分、秒）:",
	["mp.property.seek_confirm"]        = "シーク",
	["mp.property.seek_cancel"]         = "キャンセル",
	["mp.property.request_url"]         = "URLをリクエスト",
	["mp.property.copy_url"]            = "URLをクリップボードにコピー",
	["mp.property.fullscreen"]          = "フルスクリーン切り替え (F11)",
	["mp.property.turn_on"]             = "オンにする",
	["mp.property.turn_off"]            = "オフにする",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  メディアプレーヤー",
	["mp.menu.fullscreen"]              = "フルスクリーン",
	["mp.menu.turn_off_all"]            = "すべてオフにする",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "リクエストされたURLは無効です。",
	["mp.error.request_failed"]         = "リクエストに失敗しました: %s",
	["mp.error.audio_load_failed"]      = "メディアプレーヤーの音声 '%s' の読み込みに失敗しました",
	["mp.error.audio_stream"]           = "オーディオストリームの受信中に問題が発生しました。もう一度お試しください。",
	["mp.success.url_copied"]           = "メディアのURLがクリップボードにコピーされました。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "リクエストされたメディアはサポートされていません。対応サービスは以下の通りです:\n",
	["mp.error.queue_locked"]           = "キューがロックされているため、リクエストされたメディアを追加できませんでした。",
	["mp.error.request_denied"]         = "メディアリクエストが拒否されました。",
	["mp.error.queue_full"]             = "メディアプレーヤーのキューがいっぱいです。",
	["mp.error.duplicate_request"]      = "リクエストされたメディアは既にキューに入っています",
	["mp.error.metadata_fetch"]         = "リクエストされたメディアのメタデータの取得中に問題が発生しました。",
	["mp.error.queue_denied"]           = "リクエストされたメディアをキューに追加できませんでした。",
	["mp.success.added_to_queue"]       = "'%s' をキューに追加しました",
	["mp.error.no_permission"]          = "この操作を行う権限がありません。",
	["mp.error.seek_past_duration"]     = "リクエストされたシーク時間がメディアの長さを超えています。",

	-- Settings
	["mp.settings.title"]               = "設定",
	["mp.settings.audio"]               = "オーディオ",
	["mp.settings.3d_audio"]            = "3D立体音響",
	["mp.settings.proximity_min"]       = "最小距離",
	["mp.settings.proximity_max"]       = "最大距離",
	["mp.settings.mute_unfocused"]      = "非アクティブ時にミュート",
})