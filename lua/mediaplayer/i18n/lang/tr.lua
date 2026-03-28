-- Turkish / Türkçe
MediaPlayer.i18n.RegisterLanguage("tr", {

	-- Idle screen
	["mp.idle.no_media"]                = "Oynatılan medya yok",
	["mp.idle.hint"]                    = "Sıra menüsünü açmak için medya oynatıcıya bakarken %s tuşunu basılı tutun.",
	["mp.idle.press_e"]                 = "İzlemeye başlamak için E'ye basın",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "ŞU AN OYNATIYOR",
	["mp.ui.no_media"]                  = "Oynatılan medya yok",
	["mp.ui.next_up"]                   = "SIRADA",
	["mp.ui.add_media"]                 = "MEDYA EKLE",
	["mp.ui.added_by"]                  = "EKLEYEN",
	["mp.ui.unknown"]                   = "Bilinmiyor",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Tekrarla",
	["mp.ui.shuffle"]                   = "Karıştır",
	["mp.ui.toggle_queue_lock"]         = "Sıra kilidini aç/kapat",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MEDYA ARA",
	["mp.ui.request_url"]               = "URL İSTE",

	-- Context menu properties
	["mp.property.pause"]               = "Duraklat",
	["mp.property.resume"]              = "Devam et",
	["mp.property.skip"]                = "Atla",
	["mp.property.seek"]                = "İlerle",
	["mp.property.seek_title"]          = "Medya Oynatıcı",
	["mp.property.seek_prompt"]         = "SS:DD:SN biçiminde bir zaman girin (saat, dakika, saniye):",
	["mp.property.seek_confirm"]        = "İlerle",
	["mp.property.seek_cancel"]         = "İptal",
	["mp.property.request_url"]         = "URL iste",
	["mp.property.copy_url"]            = "URL'yi panoya kopyala",
	["mp.property.fullscreen"]          = "Tam ekranı aç/kapat (F11)",
	["mp.property.turn_on"]             = "Aç",
	["mp.property.turn_off"]            = "Kapat",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Medya Oynatıcı",
	["mp.menu.fullscreen"]              = "Tam ekran",
	["mp.menu.turn_off_all"]            = "Tümünü kapat",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "İstenen URL geçersizdi.",
	["mp.error.request_failed"]         = "İstek başarısız: %s",
	["mp.error.audio_load_failed"]      = "'%s' sesi yüklenemedi",
	["mp.error.audio_stream"]           = "Ses akışı alınırken bir sorun oluştu, lütfen tekrar deneyin.",
	["mp.success.url_copied"]           = "Medya URL'si panoya kopyalandı.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "İstenen medya desteklenmiyor; kabul edilen hizmetler şunlardır:\n",
	["mp.error.queue_locked"]           = "Sıra kilitli olduğu için medya eklenemedi.",
	["mp.error.request_denied"]         = "Medya isteğiniz reddedildi.",
	["mp.error.queue_full"]             = "Medya oynatıcı sırası dolu.",
	["mp.error.duplicate_request"]      = "İstenen medya zaten sırada",
	["mp.error.metadata_fetch"]         = "İstenen medyanın meta verileri alınırken bir sorun oluştu.",
	["mp.error.queue_denied"]           = "İstenen medya sıraya eklenemedi.",
	["mp.error.media_url_failed"]       = "Medya URL'si işlenemedi.",
	["mp.error.request_error"]          = "[İstek Hatası] %s",
	["mp.success.added_to_queue"]       = "'%s' sıraya eklendi",
	["mp.error.no_permission"]          = "Bunu yapmaya yetkiniz yok.",
	["mp.error.seek_past_duration"]     = "İstenen ilerleme zamanı medya süresini aşıyor.",

	-- Settings
	["mp.settings.title"]               = "AYARLAR",
	["mp.settings.audio"]               = "Ses",
	["mp.settings.3d_audio"]            = "3D uzamsal ses",
	["mp.settings.proximity_min"]       = "Yakınlık minimum mesafesi",
	["mp.settings.proximity_max"]       = "Yakınlık maksimum mesafesi",
	["mp.settings.proximity_units"]     = "%s birim",
	["mp.settings.mute_unfocused"]      = "Odak dışındayken sessize al",
	["mp.settings.language"]            = "Dil",
	["mp.settings.language_auto"]       = "Otomatik (sistem)",
	["mp.settings.show_radius"]         = "Yakınlık yarıçapını göster",
	["mp.settings.subtitles"]           = "Altyazılar",
	["mp.settings.subtitles_off"]       = "Kapalı",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Uzamsal Medya Oynatıcı",
	["mp.tool.spatial.label"]           = "Uzamsal Medya",
	["mp.tool.spatial.desc"]            = "MediaPlayer sesini dünyaya sabitleyin veya bir varlığı takip ettirin.",
	["mp.tool.spatial.usage"]           = "Sol tık: uzamsal kaynak yerleştir. Sağ tık: kaldır.",
	["mp.tool.spatial.help_place"]      = "Bir nesne, oyuncu veya NPC'ye sol tıklayarak uzamsal ses kaynağı ekleyin. Dünyaya tıklayarak yerinde sabitleyin.",
	["mp.tool.spatial.help_remove"]     = "Bir hedefe sağ tıklayarak uzamsal kaynağını kaldırın.",
	["mp.tool.spatial.help_sidebar"]    = "Medya istemek veya oynatmayı kontrol etmek için nesneye bakarak C tuşunu basılı tutun — diğer medya oynatıcılarla aynı şekilde çalışır.",
	["mp.tool.spatial.hint_press_c"]    = "Uzamsal medya kaynağı yerleştirildi! Kenar çubuğunu açmak ve medya istemek için nesneye bakarken C tuşunu basılı tutun.",
	["mp.tool.spatial.undo"]            = "Uzamsal medya kaynağı",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Bu uzamsal medya kaynağını kontrol etme yetkiniz yok.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Tarayıcı limitine ulaşıldı",
	["mp.error.browser_limit_detail"]   = "Tüm tarayıcı yuvaları kullanımda (%d/%d aktif).",
	["mp.error.browser_limit_note"]     = "Bir yuvanın boşalması bekleniyor. Bu bir hata değildir.",
})