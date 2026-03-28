-- French / Français
MediaPlayer.i18n.RegisterLanguage("fr", {

	-- Idle screen
	["mp.idle.no_media"]                = "Aucun média en lecture",
	["mp.idle.hint"]                    = "Maintenez %s en regardant le lecteur multimédia pour afficher le menu de file d'attente.",
	["mp.idle.press_e"]                 = "Appuyez sur E pour commencer à regarder",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "EN COURS DE LECTURE",
	["mp.ui.no_media"]                  = "Aucun média en lecture",
	["mp.ui.next_up"]                   = "SUIVANT",
	["mp.ui.add_media"]                 = "AJOUTER UN MÉDIA",
	["mp.ui.added_by"]                  = "AJOUTÉ PAR",
	["mp.ui.unknown"]                   = "Inconnu",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Répéter",
	["mp.ui.shuffle"]                   = "Aléatoire",
	["mp.ui.toggle_queue_lock"]         = "Verrouiller/déverrouiller la file d'attente",

	-- Browser controls
	["mp.ui.search_for_media"]          = "RECHERCHER DES MÉDIAS",
	["mp.ui.request_url"]               = "DEMANDER UNE URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pause",
	["mp.property.resume"]              = "Reprendre",
	["mp.property.skip"]                = "Passer",
	["mp.property.seek"]                = "Rechercher",
	["mp.property.seek_title"]          = "Lecteur multimédia",
	["mp.property.seek_prompt"]         = "Entrez un temps au format HH:MM:SS (heures, minutes, secondes) :",
	["mp.property.seek_confirm"]        = "Rechercher",
	["mp.property.seek_cancel"]         = "Annuler",
	["mp.property.request_url"]         = "Demander une URL",
	["mp.property.copy_url"]            = "Copier l'URL dans le presse-papiers",
	["mp.property.fullscreen"]          = "Basculer en plein écran (F11)",
	["mp.property.turn_on"]             = "Allumer",
	["mp.property.turn_off"]            = "Éteindre",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Lecteur multimédia",
	["mp.menu.fullscreen"]              = "Plein écran",
	["mp.menu.turn_off_all"]            = "Tout éteindre",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "L'URL demandée n'était pas valide.",
	["mp.error.request_failed"]         = "Échec de la demande : %s",
	["mp.error.audio_load_failed"]      = "Impossible de charger l'audio '%s'",
	["mp.error.audio_stream"]           = "Un problème est survenu lors de la réception du flux audio, veuillez réessayer.",
	["mp.success.url_copied"]           = "L'URL du média a été copiée dans le presse-papiers.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Le média demandé n'est pas pris en charge ; les services acceptés sont les suivants :\n",
	["mp.error.queue_locked"]           = "Le média n'a pas pu être ajouté car la file d'attente est verrouillée.",
	["mp.error.request_denied"]         = "Votre demande de média a été refusée.",
	["mp.error.queue_full"]             = "La file d'attente du lecteur multimédia est pleine.",
	["mp.error.duplicate_request"]      = "Le média demandé est déjà dans la file d'attente",
	["mp.error.metadata_fetch"]         = "Un problème est survenu lors de la récupération des métadonnées du média demandé.",
	["mp.error.queue_denied"]           = "Le média demandé n'a pas pu être mis en file d'attente.",
	["mp.error.media_url_failed"]       = "Impossible de traiter l'URL du média.",
	["mp.error.request_error"]          = "[Erreur de demande] %s",
	["mp.success.added_to_queue"]       = "'%s' ajouté à la file d'attente",
	["mp.error.no_permission"]          = "Vous n'avez pas la permission de faire cela.",
	["mp.error.seek_past_duration"]     = "Le temps de recherche demandé dépasse la durée du média.",

	-- Settings
	["mp.settings.title"]               = "PARAMÈTRES",
	["mp.settings.audio"]               = "Audio",
	["mp.settings.3d_audio"]            = "Audio spatial 3D",
	["mp.settings.proximity_min"]       = "Distance minimale de proximité",
	["mp.settings.proximity_max"]       = "Distance maximale de proximité",
	["mp.settings.proximity_units"]     = "%s unités",
	["mp.settings.mute_unfocused"]      = "Couper le son en arrière-plan",
	["mp.settings.language"]            = "Langue",
	["mp.settings.language_auto"]       = "Automatique (système)",
	["mp.settings.show_radius"]         = "Afficher le rayon de proximité",
	["mp.settings.subtitles"]           = "Sous-titres",
	["mp.settings.subtitles_off"]       = "Désactivé",

	-- Spatial tool
	["mp.tool.spatial.name"]            = "Lecteur multimédia spatial",
	["mp.tool.spatial.label"]           = "Média spatial",
	["mp.tool.spatial.desc"]            = "Épinglez l'audio MediaPlayer au monde ou faites-le suivre une entité.",
	["mp.tool.spatial.usage"]           = "Clic gauche : placer une source spatiale. Clic droit : supprimer.",
	["mp.tool.spatial.help_place"]      = "Cliquez gauche sur un prop, joueur ou NPC pour y attacher une source audio spatiale. Cliquez sur le monde pour l'épingler sur place.",
	["mp.tool.spatial.help_remove"]     = "Cliquez droit sur une cible pour supprimer sa source spatiale.",
	["mp.tool.spatial.help_sidebar"]    = "Pour demander des médias ou contrôler la lecture, regardez l'objet et maintenez C pour ouvrir la barre latérale — elle fonctionne comme tout autre lecteur multimédia.",
	["mp.tool.spatial.hint_press_c"]    = "Source de média spatial placée ! Maintenez C en regardant l'objet pour ouvrir la barre latérale et demander des médias.",
	["mp.tool.spatial.undo"]            = "Source de média spatial",

	-- Spatial player
	["mp.spatial.no_permission"]        = "Vous n'avez pas la permission de contrôler cette source de média spatial.",

	-- Browser pool
	["mp.error.browser_limit_title"]    = "Limite de navigateurs atteinte",
	["mp.error.browser_limit_detail"]   = "Tous les emplacements sont utilisés (%d/%d actifs).",
	["mp.error.browser_limit_note"]     = "En attente d'un emplacement libre. Ce n'est pas un bug.",
})