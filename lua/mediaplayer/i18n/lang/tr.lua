-- Turkish / Türkçe
MediaPlayer.i18n.RegisterLanguage("tr", {

	-- Idle screen
	["mp.idle.no_media"]                = "Kaydırma oynatılmıyor",
	["mp.idle.hint"]                    = "Sıra menüsünü açmak için medya oynatıcıya bakarken %s tuşunu basılı tutun.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "ŞU AN OYNATIYOR",
	["mp.ui.no_media"]                  = "Kaydırma oynatılmıyor",
	["mp.ui.next_up"]                   = "SIRADA",
	["mp.ui.add_media"]                 = "MEDYA EKLE",
	["mp.ui.added_by"]                  = "EKLEYEN",
	["mp.ui.unknown"]                   = "Bilinmiyor",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Tekrarla",
	["mp.ui.shuffle"]                   = "Karıştır",
	["mp.ui.toggle_queue_lock"]         = "Sıra Kilidini Aç/Kapat",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MEDYA ARA",
	["mp.ui.request_url"]               = "URL İSTE",

	-- Context menu properties
	["mp.property.pause"]               = "Duraklat",
	["mp.property.resume"]              = "Devam Et",
	["mp.property.skip"]                = "Atla",
	["mp.property.seek"]                = "İlerle",
	["mp.property.seek_title"]          = "Medya Oynatıcı",
	["mp.property.seek_prompt"]         = "SS:DD:SN biçiminde bir zaman girin (saat, dakika, saniye):",
	["mp.property.seek_confirm"]        = "İlerle",
	["mp.property.seek_cancel"]         = "İptal",
	["mp.property.request_url"]         = "URL İste",
	["mp.property.copy_url"]            = "URL'yi panoya kopyala",
	["mp.property.fullscreen"]          = "Tam Ekranı Aç/Kapat (F11)",
	["mp.property.turn_on"]             = "Aç",
	["mp.property.turn_off"]            = "Kapat",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Medya Oynatıcı",
	["mp.menu.fullscreen"]              = "Tam Ekran",
	["mp.menu.turn_off_all"]            = "Tümünü Kapat",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "İstenen URL geçersiz.",
	["mp.error.request_failed"]         = "İstek başarısız: %s",
	["mp.error.audio_load_failed"]      = "Medya oynatıcı sesi '%s' yüklenemedi",
	["mp.error.audio_stream"]           = "Ses akışı alınırken bir sorun oluştu, lütfen tekrar deneyin.",
	["mp.success.url_copied"]           = "Medya URL'si panoya kopyalandı.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "İstenen medya desteklenmiyor; kabul edilen hizmetler aşağıdaki gibidir:\n",
	["mp.error.queue_locked"]           = "Sıra kilitli olduğu için istenen medya eklenemedi.",
	["mp.error.request_denied"]         = "Medya isteğiniz reddedildi.",
	["mp.error.queue_full"]             = "Medya oynatıcı sırası dolu.",
	["mp.error.duplicate_request"]      = "İstenen medya zaten sırada",
	["mp.error.metadata_fetch"]         = "İstenen medyanın meta verileri alınırken bir sorun oluştu.",
	["mp.error.queue_denied"]           = "İstenen medya sıraya eklenemedi.",
	["mp.success.added_to_queue"]       = "'%s' sıraya eklendi",
	["mp.error.no_permission"]          = "Bunu yapmaya yetkiniz yok.",
	["mp.error.seek_past_duration"]     = "İstenen ilerleme zamanı medya süresinin sonunu aştı.",

	-- Settings
	["mp.settings.title"]               = "AYARLAR",
	["mp.settings.audio"]               = "Ses",
	["mp.settings.3d_audio"]            = "3D uzamsal ses",
	["mp.settings.proximity_min"]       = "Minimum mesafe",
	["mp.settings.proximity_max"]       = "Maksimum mesafe",
	["mp.settings.mute_unfocused"]      = "Odak dışında sessize al",
})