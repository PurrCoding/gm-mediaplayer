-- Japanese / 日本語
MediaPlayer.i18n.RegisterLanguage("ja", {

	-- Idle screen
	["mp.idle.no_media"]                = "メディア再生なし",
	["mp.idle.hint"]                    = "メディアプレイヤーを見ながら %s を長押しすると、キューメニューが表示されます。",
	["mp.idle.press_e"]                 = "Eキーを押して視聴を開始",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "再生中",
	["mp.ui.no_media"]                  = "メディア再生なし",
	["mp.ui.next_up"]                   = "次の再生",
	["mp.ui.add_media"]                 = "メディアを追加",
	["mp.ui.added_by"]                  = "追加者",
	["mp.ui.unknown"]                   = "不明",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "すでにスキップに投票済みです。",
	["mp.voteskip.vote_cast"]           = "投票スキップ: %d/%d 票（あと %d 票必要）",
	["mp.voteskip.passed"]              = "投票スキップ成立！スキップしています...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "リピート",
	["mp.ui.shuffle"]                   = "シャッフル",
	["mp.ui.toggle_queue_lock"]         = "キューロック切替",

	-- Browser controls
	["mp.ui.search_for_media"]          = "メディアを検索",
	["mp.ui.request_url"]               = "URLをリクエスト",

	-- Context menu properties
	["mp.property.pause"]               = "一時停止",
	["mp.property.resume"]              = "再開",
	["mp.property.skip"]                = "スキップ",
	["mp.property.seek"]                = "シーク",
	["mp.property.seek_title"]          = "メディアプレイヤー",
	["mp.property.seek_prompt"]         = "HH:MM:SS形式で時間を入力してください（時、分、秒）：",
	["mp.property.seek_confirm"]        = "シーク",
	["mp.property.seek_cancel"]         = "キャンセル",
	["mp.property.request_url"]         = "URLをリクエスト",
	["mp.property.copy_url"]            = "URLをクリップボードにコピー",
	["mp.property.fullscreen"]          = "フルスクリーン切替 (F11)",
	["mp.property.turn_on"]             = "オンにする",
	["mp.property.turn_off"]            = "オフにする",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  メディアプレイヤー",
	["mp.menu.fullscreen"]              = "フルスクリーン",
	["mp.menu.turn_off_all"]            = "すべてオフ",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "リクエストされたURLは無効でした。",
	["mp.error.request_failed"]         = "リクエスト失敗: %s",
	["mp.error.audio_load_failed"]      = "オーディオ '%s' の読み込みに失敗しました",
	["mp.error.audio_stream"]           = "オーディオストリームの受信中に問題が発生しました。もう一度お試しください。",
	["mp.success.url_copied"]           = "メディアURLがクリップボードにコピーされました。",

	-- Server notifications
	["mp.error.service_whitelist"]      = "リクエストされたメディアはサポートされていません。対応サービスは以下の通りです：\n",
	["mp.error.queue_locked"]           = "キューがロックされているため、メディアを追加できませんでした。",
	["mp.error.request_denied"]         = "メディアリクエストが拒否されました。",
	["mp.error.queue_full"]             = "メディアプレイヤーのキューがいっぱいです。",
	["mp.error.duplicate_request"]      = "リクエストされたメディアは既にキューにあります",
	["mp.error.metadata_fetch"]         = "リクエストされたメディアのメタデータ取得中に問題が発生しました。",
	["mp.error.queue_denied"]           = "リクエストされたメディアをキューに追加できませんでした。",
	["mp.error.media_url_failed"]       = "メディアURLの処理に失敗しました。",
	["mp.error.request_error"]          = "[リクエストエラー] %s",
	["mp.success.added_to_queue"]       = "'%s' をキューに追加しました",
	["mp.error.no_permission"]          = "その操作を行う権限がありません。",
	["mp.error.seek_past_duration"]     = "リクエストされたシーク時間がメディアの長さを超えています。",

	-- Settings
	["mp.settings.title"]               = "設定",
	["mp.settings.audio"]               = "オーディオ",
	["mp.settings.3d_audio"]            = "3D空間オーディオ",
	["mp.settings.proximity_min"]       = "近接最小距離",
	["mp.settings.proximity_max"]       = "近接最大距離",
	["mp.settings.proximity_units"]     = "%s ユニット",
	["mp.settings.mute_unfocused"]      = "非アクティブ時にミュート",
	["mp.settings.show_radius"]         = "近接半径を表示",
	["mp.settings.subtitles"]           = "字幕",
	["mp.settings.subtitles_off"]       = "オフ",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "サポートされていないメディアタイプ",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "空間メディアプレイヤー",
	["mp.tool.spatial.label"]           = "空間メディア",
	["mp.tool.spatial.desc"]            = "MediaPlayerのオーディオをワールドに固定するか、エンティティに追従させます。",
	["mp.tool.spatial.usage"]           = "左クリック：空間ソースを配置。右クリック：削除。",
	["mp.tool.spatial.help_place"]      = "プロップ、プレイヤー、またはNPCを左クリックして空間オーディオソースを取り付けます。ワールドをクリックするとその場に固定します。",
	["mp.tool.spatial.help_remove"]     = "ターゲットを右クリックして空間ソースを削除します。",
	["mp.tool.spatial.help_sidebar"]    = "メディアをリクエストしたり再生を制御するには、オブジェクトを見ながらCを長押ししてサイドバーを開きます — 他のメディアプレイヤーと同じように動作します。",
	["mp.tool.spatial.hint_press_c"]    = "空間メディアソースを配置しました！オブジェクトを見ながらCを長押ししてサイドバーを開き、メディアをリクエストしてください。",
	["mp.tool.spatial.undo"]            = "空間メディアソース",

	-- Spatial player
	["mp.spatial.no_permission"]        = "この空間メディアソースを制御する権限がありません。",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "ミミックメディアプレイヤー",
	["mp.tool.mimic.desc"]              = "別のメディアプレイヤーの映像出力を2番目のスクリーンにミラーリングします。",
	["mp.tool.mimic.usage"]             = "左クリック：ソースをコピー。右クリック：ターゲットに貼り付け。リロード (R)：ミミックを削除。",
	["mp.tool.mimic.help_copy"]         = "メディアプレイヤーを左クリックして映像ソースとしてコピーします。",
	["mp.tool.mimic.help_paste"]        = "他のメディアプレイヤーを右クリックして貼り付け — ソースをミラーリングします。複数のスクリーンに貼り付けできます。",
	["mp.tool.mimic.help_remove"]       = "ミミックプレイヤーでリロード (R) を押すと削除してオリジナルに戻します。",
	["mp.tool.mimic.source_copied"]     = "ソースをコピーしました！他のメディアプレイヤーを右クリックして貼り付けてください。",
	["mp.tool.mimic.pasted"]            = "ミミック適用！このスクリーンはソースをミラーリングしています。",
	["mp.tool.mimic.removed"]           = "ミミックを削除しました。エンティティを復元しました。",
	["mp.tool.mimic.undo"]              = "ミミックメディアプレイヤー",
	["mp.tool.mimic.error_not_mp"]      = "このエンティティにはメディアプレイヤーがありません。",
	["mp.tool.mimic.error_spatial"]     = "空間メディアプレイヤーはミミックできません。",
	["mp.tool.mimic.error_same"]        = "ソースとターゲットは同じエンティティにできません。",
	["mp.tool.mimic.error_no_source"]   = "まだソースがコピーされていません。先にメディアプレイヤーを左クリックしてください。",
	["mp.tool.mimic.error_source_gone"] = "コピーしたソースはもう存在しません。新しいソースを左クリックしてください。",
	["mp.tool.mimic.error_mimic_source"] = "ミミックプレイヤーからはコピーできません。オリジナルのソースからコピーしてください。",
	["mp.tool.mimic.error_already_linked"] = "このエンティティは既にそのソースをミラーリングしています。",
	["mp.tool.mimic.error_not_mimic"]   = "このエンティティはミミックプレイヤーではありません。",
	["mp.tool.mimic.error_has_content"] = "独自のコンテンツを配信中のメディアプレイヤーはミミックできません。先にメディアを停止またはクリアしてください。",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "ブラウザの上限に達しました",
	["mp.error.browser_limit_detail"]   = "すべてのブラウザスロットが使用中です（%d/%d アクティブ）。",
	["mp.error.browser_limit_note"]     = "スロットが空くのを待っています。これはバグではありません。",
})