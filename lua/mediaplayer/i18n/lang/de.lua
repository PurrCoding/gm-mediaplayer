-- German / Deutsch
MediaPlayer.i18n.RegisterLanguage("de", {

	-- Idle screen
	["mp.idle.no_media"]                = "Keine Wiedergabe",
	["mp.idle.hint"]                    = "Halte %s gedrückt, während du auf den Mediaplayer schaust, um das Warteschlangenmenü zu öffnen.",
	["mp.idle.press_e"]                 = "Drücke E, um mit dem Zuschauen zu beginnen",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "AKTUELLE WIEDERGABE",
	["mp.ui.no_media"]                  = "Keine Wiedergabe",
	["mp.ui.next_up"]                   = "ALS NÄCHSTES",
	["mp.ui.add_media"]                 = "MEDIEN HINZUFÜGEN",
	["mp.ui.added_by"]                  = "HINZUGEFÜGT VON",
	["mp.ui.unknown"]                   = "Unbekannt",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Wiederholen",
	["mp.ui.shuffle"]                   = "Zufallswiedergabe",
	["mp.ui.toggle_queue_lock"]         = "Warteschlangensperre umschalten",

	-- Browser controls
	["mp.ui.search_for_media"]          = "NACH MEDIEN SUCHEN",
	["mp.ui.request_url"]               = "URL ANFRAGEN",

	-- Context menu properties
	["mp.property.pause"]               = "Pause",
	["mp.property.resume"]              = "Fortsetzen",
	["mp.property.skip"]                = "Überspringen",
	["mp.property.seek"]                = "Spulen",
	["mp.property.seek_title"]          = "Mediaplayer",
	["mp.property.seek_prompt"]         = "Gib eine Zeit im Format HH:MM:SS ein (Stunden, Minuten, Sekunden):",
	["mp.property.seek_confirm"]        = "Spulen",
	["mp.property.seek_cancel"]         = "Abbrechen",
	["mp.property.request_url"]         = "URL anfragen",
	["mp.property.copy_url"]            = "URL in die Zwischenablage kopieren",
	["mp.property.fullscreen"]          = "Vollbild umschalten (F11)",
	["mp.property.turn_on"]             = "Einschalten",
	["mp.property.turn_off"]            = "Ausschalten",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Mediaplayer",
	["mp.menu.fullscreen"]              = "Vollbild",
	["mp.menu.turn_off_all"]            = "Alle ausschalten",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "Die angeforderte URL war ungültig.",
	["mp.error.request_failed"]         = "Anfrage fehlgeschlagen: %s",
	["mp.error.audio_load_failed"]      = "Audio '%s' konnte nicht geladen werden",
	["mp.error.audio_stream"]           = "Es gab ein Problem beim Empfang des Audio-Streams, bitte versuche es erneut.",
	["mp.success.url_copied"]           = "Die Medien-URL wurde in die Zwischenablage kopiert.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Das angeforderte Medium wird nicht unterstützt; akzeptierte Dienste sind:\n",
	["mp.error.queue_locked"]           = "Das angeforderte Medium konnte nicht hinzugefügt werden, da die Warteschlange gesperrt ist.",
	["mp.error.request_denied"]         = "Deine Medienanfrage wurde abgelehnt.",
	["mp.error.queue_full"]             = "Die Wiedergabeliste ist voll.",
	["mp.error.duplicate_request"]      = "Das angeforderte Medium befindet sich bereits in der Warteschlange.",
	["mp.error.metadata_fetch"]         = "Beim Abrufen der Metadaten des angeforderten Mediums ist ein Problem aufgetreten.",
	["mp.error.queue_denied"]           = "Das angeforderte Medium konnte nicht zur Warteschlange hinzugefügt werden.",
	["mp.error.media_url_failed"]       = "Die Medien-URL konnte nicht verarbeitet werden.",
	["mp.error.request_error"]          = "[Anfragefehler] %s",
	["mp.success.added_to_queue"]       = "'%s' zur Warteschlange hinzugefügt",
	["mp.error.no_permission"]          = "Du hast keine Berechtigung dazu.",
	["mp.error.seek_past_duration"]     = "Die angeforderte Sprungzeit liegt nach dem Ende der Mediendauer.",

	-- Settings
	["mp.settings.title"]               = "EINSTELLUNGEN",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "3D-Raumklang",
	["mp.settings.proximity_min"]       = "Mindestentfernung",
	["mp.settings.proximity_max"]       = "Höchstentfernung",
	["mp.settings.proximity_units"]     = "%s Einheiten",
	["mp.settings.mute_unfocused"]      = "Stumm wenn nicht fokussiert",
	["mp.settings.language"]            = "Sprache",
	["mp.settings.language_auto"]       = "Automatisch (System)",
	["mp.settings.show_radius"]         = "Näherungsradius anzeigen",
	["mp.settings.subtitles"]           = "Untertitel",
	["mp.settings.subtitles_off"]       = "Aus",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Räumlicher Mediaplayer",
	["mp.tool.spatial.label"]           = "Räumliche Medien",
	["mp.tool.spatial.desc"]            = "Hefte MediaPlayer-Audio an die Welt oder lasse es einer Entität folgen.",
	["mp.tool.spatial.usage"]           = "Linksklick: räumliche Quelle platzieren. Rechtsklick: entfernen.",
	["mp.tool.spatial.help_place"]      = "Klicke mit links auf ein Prop, einen Spieler oder NPC, um eine räumliche Audioquelle anzuheften. Klicke auf die Welt, um sie an Ort und Stelle zu fixieren.",
	["mp.tool.spatial.help_remove"]     = "Klicke mit rechts auf ein Ziel, um dessen räumliche Quelle zu entfernen.",
	["mp.tool.spatial.help_sidebar"]    = "Um Medien anzufordern oder die Wiedergabe zu steuern, schaue auf das Objekt und halte C gedrückt, um die Seitenleiste zu öffnen — sie funktioniert wie jeder andere Mediaplayer.",
	["mp.tool.spatial.hint_press_c"]    = "Räumliche Medienquelle platziert! Halte C gedrückt und schaue auf das Objekt, um die Seitenleiste zu öffnen und Medien anzufordern.",
	["mp.tool.spatial.undo"]            = "Räumliche Medienquelle",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Du hast keine Berechtigung, diese räumliche Medienquelle zu steuern.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Browser-Limit erreicht",
	["mp.error.browser_limit_detail"]   = "Alle Browser-Slots sind belegt (%d/%d aktiv).",
	["mp.error.browser_limit_note"]     = "Warte auf einen freien Slot. Dies ist kein Fehler.",
})