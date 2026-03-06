-- French / Français
MediaPlayer.i18n.RegisterLanguage("fr", {

	-- Idle screen
	["mp.idle.no_media"]                = "Aucun média en cours",
	["mp.idle.hint"]                    = "Maintenez %s en regardant le lecteur multimédia pour afficher le menu de la file d'attente.",

	-- Sidebar UI
	["mp.ui.currently_playing"]         = "EN COURS DE LECTURE",
	["mp.ui.no_media"]                  = "Aucun média en cours",
	["mp.ui.next_up"]                   = "À SUIVRE",
	["mp.ui.add_media"]                 = "AJOUTER UN MÉDIA",
	["mp.ui.added_by"]                  = "AJOUTÉ PAR",
	["mp.ui.unknown"]                   = "Inconnu",

	-- Playback control tooltips
	["mp.ui.repeat"]                    = "Répéter",
	["mp.ui.shuffle"]                   = "Aléatoire",
	["mp.ui.toggle_queue_lock"]         = "Verrouiller/Déverrouiller la file",

	-- Browser controls
	["mp.ui.search_for_media"]          = "RECHERCHER UN MÉDIA",
	["mp.ui.request_url"]               = "DEMANDER UNE URL",

	-- Context menu properties
	["mp.property.pause"]               = "Pause",
	["mp.property.resume"]              = "Reprendre",
	["mp.property.skip"]                = "Passer",
	["mp.property.seek"]                = "Avancer",
	["mp.property.seek_title"]          = "Lecteur multimédia",
	["mp.property.seek_prompt"]         = "Entrez un temps au format HH:MM:SS (heures, minutes, secondes) :",
	["mp.property.seek_confirm"]        = "Avancer",
	["mp.property.seek_cancel"]         = "Annuler",
	["mp.property.request_url"]         = "Demander une URL",
	["mp.property.copy_url"]            = "Copier l'URL dans le presse-papiers",
	["mp.property.fullscreen"]          = "Plein écran (F11)",
	["mp.property.turn_on"]             = "Activer",
	["mp.property.turn_off"]            = "Désactiver",

	-- Top menu bar
	["mp.menu.title"]                   = "▶  Lecteur multimédia",
	["mp.menu.fullscreen"]              = "Plein écran",
	["mp.menu.turn_off_all"]            = "Tout désactiver",

	-- Client-side chat notifications
	["mp.error.invalid_url"]            = "L'URL demandée est invalide.",
	["mp.error.request_failed"]         = "Échec de la requête : %s",
	["mp.error.audio_load_failed"]      = "Impossible de charger l'audio '%s'",
	["mp.error.audio_stream"]           = "Un problème est survenu lors de la réception du flux audio, veuillez réessayer.",
	["mp.success.url_copied"]           = "L'URL du média a été copiée dans le presse-papiers.",

	-- Server notifications
	["mp.error.service_whitelist"]      = "Le média demandé n'est pas pris en charge ; les services acceptés sont les suivants :\n",
	["mp.error.queue_locked"]           = "Le média n'a pas pu être ajouté car la file d'attente est verrouillée.",
	["mp.error.request_denied"]         = "Votre demande de média a été refusée.",
	["mp.error.queue_full"]             = "La file d'attente du lecteur est pleine.",
	["mp.error.duplicate_request"]      = "Le média demandé est déjà dans la file d'attente",
	["mp.error.metadata_fetch"]         = "Un problème est survenu lors de la récupération des métadonnées du média.",
	["mp.error.queue_denied"]           = "Le média demandé n'a pas pu être mis en file d'attente.",
	["mp.success.added_to_queue"]       = "'%s' ajouté à la file d'attente",
	["mp.error.no_permission"]          = "Vous n'avez pas la permission de faire cela.",
	["mp.error.seek_past_duration"]     = "Le temps de recherche demandé dépasse la durée du média.",
})