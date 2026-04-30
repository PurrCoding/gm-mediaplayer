-- Hungarian / Magyar
MediaPlayer.i18n.RegisterLanguage("hu", {

	-- Idle screen
	["mp.idle.no_media"]                = "Nincs lejátszott média",
	["mp.idle.hint"]                    = "Tartsd lenyomva a %s gombot, miközben a médialejátszóra nézel, hogy megjelenjen a sorkezelő menü.",
	["mp.idle.press_e"]                 = "Nyomd meg az E-t a nézés megkezdéséhez",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "JELENLEG JÁTSZOTT",
	["mp.ui.no_media"]                  = "Nincs lejátszott média",
	["mp.ui.next_up"]                   = "KÖVETKEZŐ",
	["mp.ui.add_media"]                 = "MÉDIA HOZZÁADÁSA",
	["mp.ui.added_by"]                  = "HOZZÁADTA",
	["mp.ui.unknown"]                   = "Ismeretlen",

	-- Voteskip
	["mp.voteskip.already_voted"]       = "Már szavaztál a kihagyásra.",
	["mp.voteskip.vote_cast"]           = "Szavazás: %d/%d szavazat (még %d szükséges)",
	["mp.voteskip.passed"]              = "Szavazás elfogadva! Kihagyás...",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Ismétlés",
	["mp.ui.shuffle"]                   = "Keverés",
	["mp.ui.toggle_queue_lock"]         = "Sorzár ki/be",

	-- Browser controls
	["mp.ui.search_for_media"]          = "MÉDIA KERESÉSE",
	["mp.ui.request_url"]               = "URL KÉRÉSE",

	-- Context menu properties
	["mp.property.pause"]               = "Szünet",
	["mp.property.resume"]              = "Folytatás",
	["mp.property.skip"]                = "Kihagyás",
	["mp.property.seek"]                = "Tekerés",
	["mp.property.seek_title"]          = "Médialejátszó",
	["mp.property.seek_prompt"]         = "Adj meg egy időt ÓÓ:PP:MM formátumban (óra, perc, másodperc):",
	["mp.property.seek_confirm"]        = "Tekerés",
	["mp.property.seek_cancel"]         = "Mégse",
	["mp.property.request_url"]         = "URL kérése",
	["mp.property.copy_url"]            = "URL másolása a vágólapra",
	["mp.property.fullscreen"]          = "Teljes képernyő váltása (F11)",
	["mp.property.turn_on"]             = "Bekapcsolás",
	["mp.property.turn_off"]            = "Kikapcsolás",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Médialejátszó",
	["mp.menu.fullscreen"]              = "Teljes képernyő",
	["mp.menu.turn_off_all"]            = "Összes kikapcsolása",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "A kért URL érvénytelen volt.",
	["mp.error.request_failed"]         = "A kérés sikertelen: %s",
	["mp.error.audio_load_failed"]      = "Nem sikerült betölteni a(z) '%s' hangot",
	["mp.error.audio_stream"]           = "Hiba történt a hangfolyam fogadásakor, kérjük próbáld újra.",
	["mp.success.url_copied"]           = "A média URL-je a vágólapra másolva.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "A kért média nem támogatott; az elfogadott szolgáltatások a következők:\n",
	["mp.error.queue_locked"]           = "A kért média nem adható hozzá, mert a sor zárolva van.",
	["mp.error.request_denied"]         = "A médiakérésed elutasítva.",
	["mp.error.queue_full"]             = "A médialejátszó sora megtelt.",
	["mp.error.duplicate_request"]      = "A kért média már a sorban van",
	["mp.error.metadata_fetch"]         = "Hiba történt a kért média metaadatainak lekérésekor.",
	["mp.error.queue_denied"]           = "A kért média nem állítható sorba.",
	["mp.error.media_url_failed"]       = "Nem sikerült feldolgozni a média URL-jét.",
	["mp.error.request_error"]          = "[Kérési hiba] %s",
	["mp.success.added_to_queue"]       = "'%s' hozzáadva a sorhoz",
	["mp.error.no_permission"]          = "Nincs jogosultságod ehhez.",
	["mp.error.seek_past_duration"]     = "A kért tekerési idő meghaladja a média időtartamát.",

	-- Settings
	["mp.settings.title"]               = "BEÁLLÍTÁSOK",
	["mp.settings.audio"]               = "Hang",
	["mp.settings.3d_audio"]            = "3D térhang",
	["mp.settings.proximity_min"]       = "Közelségi minimális távolság",
	["mp.settings.proximity_max"]       = "Közelségi maximális távolság",
	["mp.settings.proximity_units"]     = "%s egység",
	["mp.settings.mute_unfocused"]      = "Némítás ha nincs fókuszban",
	["mp.settings.show_radius"]         = "Közelségi sugár megjelenítése",
	["mp.settings.subtitles"]           = "Feliratok",
	["mp.settings.subtitles_off"]       = "Ki",

	-- Rendering fallbacks
	["mp.ui.unsupported_media"]         = "Nem támogatott médiatípus",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Térbeli médialejátszó",
	["mp.tool.spatial.label"]           = "Térbeli média",
	["mp.tool.spatial.desc"]            = "Rögzítsd a MediaPlayer hangját a világhoz, vagy kövesd vele egy entitást.",
	["mp.tool.spatial.usage"]           = "Bal kattintás: térbeli forrás elhelyezése. Jobb kattintás: eltávolítás.",
	["mp.tool.spatial.help_place"]      = "Kattints bal gombbal egy propra, játékosra vagy NPC-re térbeli hangforrás csatolásához. Kattints a világra a rögzítéshez.",
	["mp.tool.spatial.help_remove"]     = "Kattints jobb gombbal egy célpontra a térbeli forrás eltávolításához.",
	["mp.tool.spatial.help_sidebar"]    = "Média kéréséhez vagy lejátszás vezérléséhez nézz az objektumra és tartsd lenyomva a C-t az oldalsáv megnyitásához — ugyanúgy működik, mint bármely más médialejátszó.",
	["mp.tool.spatial.hint_press_c"]    = "Térbeli médiaforrás elhelyezve! Tartsd lenyomva a C-t, miközben az objektumra nézel, az oldalsáv megnyitásához és média kéréséhez.",
	["mp.tool.spatial.undo"]            = "Térbeli médiaforrás",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Nincs jogosultságod ennek a térbeli médiaforrásnak a vezérléséhez.",

	-- Mimic tool
	["mp.tool.mimic.name"]              = "Tükör médialejátszó",
	["mp.tool.mimic.desc"]              = "Tükrözd egy másik médialejátszó videokimenetét egy második képernyőre.",
	["mp.tool.mimic.usage"]             = "Bal kattintás: forrás másolása. Jobb kattintás: beillesztés célpontra. Újratöltés (R): tükör eltávolítása.",
	["mp.tool.mimic.help_copy"]         = "Kattints bal gombbal egy médialejátszóra, hogy videoforrásként másold.",
	["mp.tool.mimic.help_paste"]        = "Kattints jobb gombbal más médialejátszókra a beillesztéshez — tükrözni fogják a forrást. Több képernyőre is beilleszthetsz.",
	["mp.tool.mimic.help_remove"]       = "Nyomd meg az Újratöltés (R) gombot egy tükör lejátszón az eltávolításához és az eredeti visszaállításához.",
	["mp.tool.mimic.source_copied"]     = "Forrás másolva! Kattints jobb gombbal más médialejátszókra a beillesztéshez.",
	["mp.tool.mimic.pasted"]            = "Tükör alkalmazva! Ez a képernyő most a forrást tükrözi.",
	["mp.tool.mimic.removed"]           = "Tükör eltávolítva. Entitás visszaállítva.",
	["mp.tool.mimic.undo"]              = "Tükör médialejátszó",
	["mp.tool.mimic.error_not_mp"]      = "Ennek az entitásnak nincs médialejátszója.",
	["mp.tool.mimic.error_spatial"]     = "Térbeli médialejátszó nem tükrözhető.",
	["mp.tool.mimic.error_same"]        = "A forrás és a célpont nem lehet ugyanaz az entitás.",
	["mp.tool.mimic.error_no_source"]   = "Még nincs forrás másolva. Először kattints bal gombbal egy médialejátszóra.",
	["mp.tool.mimic.error_source_gone"] = "A másolt forrás már nem létezik. Kattints bal gombbal egy új forrásra.",
	["mp.tool.mimic.error_mimic_source"] = "Tükör lejátszóról nem lehet másolni. Másold az eredeti forrásból.",
	["mp.tool.mimic.error_already_linked"] = "Ez az entitás már tükrözi azt a forrást.",
	["mp.tool.mimic.error_not_mimic"]   = "Ez az entitás nem tükör lejátszó.",
	["mp.tool.mimic.error_has_content"] = "Nem tükrözhető olyan médialejátszó, amely saját tartalmat játszik le. Először állítsd le vagy töröld a médiáját.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Böngésző limit elérve",
	["mp.error.browser_limit_detail"]   = "Minden böngészőhely foglalt (%d/%d aktív).",
	["mp.error.browser_limit_note"]     = "Várakozás egy szabad helyre. Ez nem hiba.",
})