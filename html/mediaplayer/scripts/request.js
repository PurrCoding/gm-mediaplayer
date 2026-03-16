'use strict';

const services = [
	{
		id: 'yt',
		icon: 'youtube',
		url: 'https://youtube.com/',
		action: 'select',
		requiresCodec: false,
		names: {
			en: 'YouTube', ar: 'يوتيوب', zh: 'YouTube', es: 'YouTube', fr: 'YouTube', ja: 'YouTube', ko: 'YouTube', ru: 'YouTube'
		}
	},
	{
		id: 'bili',
		icon: 'bilibili',
		url: 'https://www.bilibili.com/',
		action: 'select',
		requiresCodec: false,
		names: {
			en: 'Bilibili', ar: 'بيليبيلي', zh: '哔哩哔哩', es: 'Bilibili', fr: 'Bilibili', ja: 'bilibili', ko: 'Bilibili', ru: 'Bilibili'
		}
	},
	{
		id: 'tt',
		icon: 'tiktok',
		url: 'https://tiktok.com/',
		action: 'select',
		requiresCodec: true,
		names: {
			en: 'TikTok', ar: 'تيك توك', zh: 'TikTok', es: 'TikTok', fr: 'TikTok', ja: 'TikTok', ko: 'TikTok', ru: 'TikTok'
		}
	},
	{
		id: 'twl',
		icon: 'twitch',
		url: 'https://www.twitch.tv/',
		action: 'select',
		requiresCodec: true,
		names: {
			en: 'Twitch', ar: 'تويتش', zh: 'Twitch', es: 'Twitch', fr: 'Twitch', ja: 'Twitch', ko: 'Twitch', ru: 'Twitch'
		}
	},
	{
		id: 'sc',
		icon: 'soundcloud',
		url: 'https://soundcloud.com/discover',
		action: 'select',
		requiresCodec: false,
		names: {
			en: 'SoundCloud', ar: 'ساوند كلاود', zh: 'SoundCloud', es: 'SoundCloud', fr: 'SoundCloud', ja: 'SoundCloud', ko: 'SoundCloud', ru: 'SoundCloud'
		}
	},
	{
		id: 'dm',
		icon: 'dailymotion',
		url: 'https://www.dailymotion.com/',
		action: 'select',
		requiresCodec: true,
		names: {
			en: 'Dailymotion', ar: 'ديلي موشن', zh: 'Dailymotion', es: 'Dailymotion', fr: 'Dailymotion', ja: 'Dailymotion', ko: 'Dailymotion', ru: 'Dailymotion'
		}
	},
	{
		id: 'ia',
		icon: 'archive',
		url: 'https://archive.org/details/movies',
		action: 'select',
		requiresCodec: true,
		names: {
			en: 'Internet Archive', ar: 'أرشيف الإنترنت', zh: '互联网档案馆', es: 'Archivo de Internet', fr: 'Internet Archive', ja: 'インターネットアーカイブ', ko: '인터넷 아카이브', ru: 'Интернет-архив'
		}
	},
	{
		id: 'odysee',
		icon: 'odysee',
		url: 'https://odysee.com/',
		action: 'select',
		requiresCodec: true,
		names: {
			en: 'Odysee', ar: 'Odysee', zh: 'Odysee', es: 'Odysee', fr: 'Odysee', ja: 'Odysee', ko: 'Odysee', ru: 'Odysee'
		}
	},
];

const translations = {
	en: {
		languageLabel: 'Language / اللغة / 中文 / 日本語',
		documentTitle: 'Media Player - Request Media',
		popupTitle: 'GModPatchTool Required',
		popupDescription: 'requires GModPatchTool to function properly.',
		instructionsTitle: 'To enable this service:',
		instruction1: 'Download and apply GModPatchTool',
		instruction2: 'Restart Garry\'s Mod completely',
		instruction3: 'Return to Media Player and try again',
		cancel: 'Cancel',
		getTool: 'Get GModPatchTool',
		urlTitle: 'Or paste a direct URL',
		urlPlaceholder: 'Paste your video URL here...',
		request: 'Request',
		supportedFormats: 'Supports common share links from supported services, images (JPG, PNG, GIF), video files (MP4, MOV, MKV, WebM), audio files (MP3, WAV, OGG), also Google Drive links',
		checkingUrl: 'Checking URL...',
		requestSent: 'Request sent!',
		codecRequired: 'Codec Required'
	},
	ar: {
		languageLabel: 'اللغة / Language / 中文 / 日本語',
		documentTitle: 'مشغل الوسائط - طلب وسائط',
		popupTitle: 'مطلوب GModPatchTool',
		popupDescription: 'يتطلب GModPatchTool ليعمل بشكل صحيح.',
		instructionsTitle: 'لتفعيل هذه الخدمة:',
		instruction1: 'نزّل GModPatchTool ثم طبّقه',
		instruction2: 'أعد تشغيل Garry\'s Mod بالكامل',
		instruction3: 'ارجع إلى مشغل الوسائط وحاول مرة أخرى',
		cancel: 'إلغاء',
		getTool: 'احصل على GModPatchTool',
		urlTitle: 'أو الصق رابطًا مباشرًا',
		urlPlaceholder: 'الصق رابط الفيديو هنا...',
		request: 'إرسال',
		supportedFormats: 'يدعم روابط المشاركة الشائعة من الخدمات المدعومة، والصور (JPG, PNG, GIF)، وملفات الفيديو (MP4, MOV, MKV, WebM)، وملفات الصوت (MP3, WAV, OGG)، وكذلك روابط Google Drive',
		checkingUrl: 'جارٍ التحقق من الرابط...',
		requestSent: 'تم إرسال الطلب!',
		codecRequired: 'الترميز مطلوب'
	},
	zh: {
		languageLabel: '语言 / Language / العربية / 日本語',
		documentTitle: '媒体播放器 - 请求媒体',
		popupTitle: '需要 GModPatchTool',
		popupDescription: '需要 GModPatchTool 才能正常运行。',
		instructionsTitle: '启用此服务的方法：',
		instruction1: '下载并应用 GModPatchTool',
		instruction2: '完全重启 Garry\'s Mod',
		instruction3: '返回媒体播放器并重试',
		cancel: '取消',
		getTool: '获取 GModPatchTool',
		urlTitle: '或者粘贴直接链接',
		urlPlaceholder: '在这里粘贴你的视频链接……',
		request: '请求',
		supportedFormats: '支持来自已支持服务的常见分享链接、图片（JPG、PNG、GIF）、视频文件（MP4、MOV、MKV、WebM）、音频文件（MP3、WAV、OGG），以及 Google Drive 链接',
		checkingUrl: '正在检查链接……',
		requestSent: '请求已发送！',
		codecRequired: '需要编解码器'
	},
	es: {
		languageLabel: 'Idioma / Language / 中文 / العربية',
		documentTitle: 'Reproductor multimedia - Solicitar contenido',
		popupTitle: 'Se requiere GModPatchTool',
		popupDescription: 'requiere GModPatchTool para funcionar correctamente.',
		instructionsTitle: 'Para habilitar este servicio:',
		instruction1: 'Descarga y aplica GModPatchTool',
		instruction2: 'Reinicia Garry\'s Mod por completo',
		instruction3: 'Vuelve al reproductor multimedia e inténtalo de nuevo',
		cancel: 'Cancelar',
		getTool: 'Obtener GModPatchTool',
		urlTitle: 'O pega una URL directa',
		urlPlaceholder: 'Pega aquí la URL de tu video...',
		request: 'Solicitar',
		supportedFormats: 'Admite enlaces compartidos comunes de servicios compatibles, imágenes (JPG, PNG, GIF), archivos de video (MP4, MOV, MKV, WebM), archivos de audio (MP3, WAV, OGG) y también enlaces de Google Drive',
		checkingUrl: 'Comprobando URL...',
		requestSent: '¡Solicitud enviada!',
		codecRequired: 'Códec requerido'
	},
	fr: {
		languageLabel: 'Langue / Language / 中文 / العربية',
		documentTitle: 'Lecteur multimédia - Demander un média',
		popupTitle: 'GModPatchTool requis',
		popupDescription: 'nécessite GModPatchTool pour fonctionner correctement.',
		instructionsTitle: 'Pour activer ce service :',
		instruction1: 'Téléchargez et appliquez GModPatchTool',
		instruction2: 'Redémarrez complètement Garry\'s Mod',
		instruction3: 'Revenez au lecteur multimédia et réessayez',
		cancel: 'Annuler',
		getTool: 'Obtenir GModPatchTool',
		urlTitle: 'Ou collez une URL directe',
		urlPlaceholder: 'Collez l\'URL de votre vidéo ici...',
		request: 'Demander',
		supportedFormats: 'Prend en charge les liens de partage courants des services pris en charge, les images (JPG, PNG, GIF), les fichiers vidéo (MP4, MOV, MKV, WebM), les fichiers audio (MP3, WAV, OGG), ainsi que les liens Google Drive',
		checkingUrl: 'Vérification de l\'URL...',
		requestSent: 'Demande envoyée !',
		codecRequired: 'Codec requis'
	},
	ja: {
		languageLabel: '言語 / Language / 中文 / العربية',
		documentTitle: 'メディアプレイヤー - メディアをリクエスト',
		popupTitle: 'GModPatchTool が必要です',
		popupDescription: 'を正しく使用するには GModPatchTool が必要です。',
		instructionsTitle: 'このサービスを有効にするには：',
		instruction1: 'GModPatchTool をダウンロードして適用する',
		instruction2: 'Garry\'s Mod を完全に再起動する',
		instruction3: 'メディアプレイヤーに戻ってもう一度試す',
		cancel: 'キャンセル',
		getTool: 'GModPatchTool を入手',
		urlTitle: 'または直接 URL を貼り付け',
		urlPlaceholder: 'ここに動画 URL を貼り付けてください...',
		request: 'リクエスト',
		supportedFormats: '対応サービスの一般的な共有リンク、画像（JPG、PNG、GIF）、動画ファイル（MP4、MOV、MKV、WebM）、音声ファイル（MP3、WAV、OGG）、Google Drive リンクに対応しています',
		checkingUrl: 'URL を確認中...',
		requestSent: 'リクエストを送信しました！',
		codecRequired: 'コーデックが必要'
	},
	ko: {
		languageLabel: '언어 / Language / 中文 / العربية',
		documentTitle: '미디어 플레이어 - 미디어 요청',
		popupTitle: 'GModPatchTool 필요',
		popupDescription: '이 서비스를 제대로 사용하려면 GModPatchTool이 필요합니다.',
		instructionsTitle: '이 서비스를 활성화하려면:',
		instruction1: 'GModPatchTool을 다운로드하고 적용하세요',
		instruction2: 'Garry\'s Mod를 완전히 다시 시작하세요',
		instruction3: '미디어 플레이어로 돌아와 다시 시도하세요',
		cancel: '취소',
		getTool: 'GModPatchTool 받기',
		urlTitle: '또는 직접 URL 붙여넣기',
		urlPlaceholder: '여기에 비디오 URL을 붙여넣으세요...',
		request: '요청',
		supportedFormats: '지원되는 서비스의 일반적인 공유 링크, 이미지(JPG, PNG, GIF), 비디오 파일(MP4, MOV, MKV, WebM), 오디오 파일(MP3, WAV, OGG), Google Drive 링크를 지원합니다',
		checkingUrl: 'URL 확인 중...',
		requestSent: '요청이 전송되었습니다!',
		codecRequired: '코덱 필요'
	},
	ru: {
		languageLabel: 'Язык / Language / 中文 / العربية',
		documentTitle: 'Медиаплеер - Запросить медиа',
		popupTitle: 'Требуется GModPatchTool',
		popupDescription: 'требует GModPatchTool для корректной работы.',
		instructionsTitle: 'Чтобы включить этот сервис:',
		instruction1: 'Скачайте и примените GModPatchTool',
		instruction2: 'Полностью перезапустите Garry\'s Mod',
		instruction3: 'Вернитесь в медиаплеер и попробуйте снова',
		cancel: 'Отмена',
		getTool: 'Получить GModPatchTool',
		urlTitle: 'Или вставьте прямую ссылку',
		urlPlaceholder: 'Вставьте сюда ссылку на видео...',
		request: 'Запросить',
		supportedFormats: 'Поддерживаются обычные ссылки на поддерживаемые сервисы, изображения (JPG, PNG, GIF), видеофайлы (MP4, MOV, MKV, WebM), аудиофайлы (MP3, WAV, OGG), а также ссылки Google Drive',
		checkingUrl: 'Проверка URL...',
		requestSent: 'Запрос отправлен!',
		codecRequired: 'Требуется кодек'
	}
};

const rtlLanguages = new Set(['ar']);
let hasCodecSupport = false;
let supportedServiceIds = null;
let currentLanguage = 'en';

function checkCodecSupport() {
	return new Promise((resolve) => {
		const video = document.createElement('video');
		const support = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === 'probably';
		hasCodecSupport = support;
		resolve({ hasCodecSupport: support });
	});
}

function normalizeServiceIDs(ids) {
	if (!ids) return null;
	if (Array.isArray(ids)) {
		return new Set(ids.map((id) => String(id).trim()).filter(Boolean));
	}
	return new Set(String(ids).split(',').map((id) => id.trim()).filter(Boolean));
}

function isServiceSupported(service) {
	if (!supportedServiceIds || supportedServiceIds.size === 0) {
		return true;
	}
	return supportedServiceIds.has(service.id);
}

function getTranslation(language) {
	return translations[language] || translations.en;
}

function getServiceName(service, language = currentLanguage) {
	return service.names?.[language] || service.names?.en || service.id;
}

async function initializeServices() {
	const grid = document.getElementById('services-grid');
	if (!grid) return;

	grid.innerHTML = '';
	const codecCheck = await checkCodecSupport();
	const t = getTranslation(currentLanguage);

	services
		.filter(isServiceSupported)
		.forEach((service) => {
			const card = document.createElement('div');
			card.className = 'service-card';
			card.dataset.href = service.url;
			card.dataset.action = service.action;
			card.dataset.serviceName = getServiceName(service);
			card.dataset.serviceId = service.id;

			const isDisabled = service.requiresCodec && !codecCheck.hasCodecSupport;

			if (isDisabled) {
				card.classList.add('service-disabled');
				card.addEventListener('click', (e) => {
					e.preventDefault();
					showCodecPopup(getServiceName(service));
				});
			} else {
				card.addEventListener('click', () => selectService(card));
				card.addEventListener('mouseenter', hoverService);
			}

			card.innerHTML = `
				<div class="service-card-inner">
					<div class="service-icon logo-${service.icon}"></div>
					<div class="service-name">${getServiceName(service)}</div>
					${isDisabled ? `<div class="disabled-overlay">${t.codecRequired}</div>` : ''}
				</div>
			`;

			grid.appendChild(card);
		});
}

function showCodecPopup(serviceName) {
	const popup = document.getElementById('codec-popup');
	const serviceNameElement = document.getElementById('service-name-popup');

	serviceNameElement.textContent = serviceName;
	popup.classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeCodecPopup() {
	const popup = document.getElementById('codec-popup');
	popup.classList.add('hidden');
	document.body.style.overflow = '';
}

function openCodecInstructions() {
	const url = 'https://www.solsticegamestudios.com/fixmedia/';

	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(url);
	} else {
		window.open(url, '_blank');
	}
	closeCodecPopup();
}

function selectService(elem) {
	if (elem.classList.contains('service-disabled')) {
		return;
	}

	playUISound(true);

	const href = elem.dataset.href;
	const action = elem.dataset.action;

	if (action === 'open') {
		openService(elem);
	} else {
		window.location.href = href;
	}
}

function openService(elem) {
	const href = elem.dataset.href;
	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(href);
	} else {
		window.open(href, '_blank');
	}
}

function requestUrl() {
	const elem = document.getElementById('urlinput');
	const url = elem.value.trim();
	const statusIndicator = document.getElementById('status-indicator');
	const statusText = document.getElementById('status-text');
	const submitBtn = document.getElementById('submit-btn');
	const t = getTranslation(currentLanguage);

	if (url.length === 0) return;

	statusIndicator.classList.remove('hidden');
	statusText.textContent = t.requestSent;
	submitBtn.disabled = true;

	setTimeout(() => {
		statusIndicator.classList.add('hidden');
		submitBtn.disabled = false;
	}, 2000);

	if (typeof gmod !== 'undefined' && gmod.requestUrl) {
		gmod.requestUrl(url);
	}
}

function onUrlKeyDown(event) {
	const key = event.keyCode || event.which;
	if (key === 13) {
		requestUrl();
	}
}

function playUISound(click) {
	if (typeof gmod !== 'undefined') {
		if (click) {
			console.log('PLAY: garrysmod/ui_click.wav');
		} else {
			console.log('PLAY: garrysmod/ui_hover.wav');
		}
	}
}

function hoverService() {
	playUISound(false);
}

function initializeUrlInput() {
	const urlInput = document.getElementById('urlinput');
	if (urlInput) {
		urlInput.addEventListener('keydown', onUrlKeyDown);
	}
}

function initializeAutoInput() {
	const urlInput = document.getElementById('urlinput');
	if (!urlInput) return;

	document.addEventListener('keydown', (event) => {
		if (
			document.activeElement === urlInput ||
			event.ctrlKey || event.metaKey || event.altKey ||
			event.key === 'Tab' || event.key === 'Escape'
		) {
			return;
		}

		urlInput.focus();
	});
}

function requestSupportedServices() {
	if (typeof gmod !== 'undefined' && gmod.getServices) {
		gmod.getServices();
	}
}

function setServices(ids) {
	supportedServiceIds = normalizeServiceIDs(ids);
	initializeServices();
}

function setTextContent(id, value) {
	const element = document.getElementById(id);
	if (element) {
		element.textContent = value;
	}
}

function applyTranslations(language) {
	const t = getTranslation(language);
	currentLanguage = translations[language] ? language : 'en';
	const finalTranslation = getTranslation(currentLanguage);
	const html = document.documentElement;

	html.lang = currentLanguage;
	html.dir = rtlLanguages.has(currentLanguage) ? 'rtl' : 'ltr';
	document.title = finalTranslation.documentTitle;

	setTextContent('popup-title', finalTranslation.popupTitle);
	setTextContent('popup-description', finalTranslation.popupDescription);
	setTextContent('instructions-title', finalTranslation.instructionsTitle);
	setTextContent('instruction-step-1', finalTranslation.instruction1);
	setTextContent('instruction-step-2', finalTranslation.instruction2);
	setTextContent('instruction-step-3', finalTranslation.instruction3);
	setTextContent('popup-cancel', finalTranslation.cancel);
	setTextContent('popup-get-tool', finalTranslation.getTool);
	setTextContent('url-title', finalTranslation.urlTitle);
	setTextContent('submit-btn-text', finalTranslation.request);
	setTextContent('supported-formats-text', finalTranslation.supportedFormats);
	setTextContent('status-text', finalTranslation.checkingUrl);

	const urlInput = document.getElementById('urlinput');
	if (urlInput) {
		urlInput.placeholder = finalTranslation.urlPlaceholder;
	}

	const buttonText = document.querySelector('.language-button-text');
	if (buttonText) {
		buttonText.textContent = finalTranslation.languageLabel;
	}

	document.querySelectorAll('.language-option').forEach((option) => {
		option.classList.toggle('active', option.dataset.language === currentLanguage);
	});

	localStorage.setItem('mediaPlayerLanguage', currentLanguage);
	initializeServices();
}

function detectInitialLanguage() {
	const savedLanguage = localStorage.getItem('mediaPlayerLanguage');
	if (savedLanguage && translations[savedLanguage]) {
		return savedLanguage;
	}

	const browserLanguage = (navigator.language || 'en').toLowerCase();
	const baseLanguage = browserLanguage.split('-')[0];
	return translations[baseLanguage] ? baseLanguage : 'en';
}

function toggleLanguageDropdown(forceOpen) {
	const dropdown = document.getElementById('language-dropdown');
	const button = document.getElementById('language-button');
	if (!dropdown || !button) return;

	const shouldOpen = typeof forceOpen === 'boolean' ? forceOpen : dropdown.classList.contains('hidden');
	dropdown.classList.toggle('hidden', !shouldOpen);
	button.setAttribute('aria-expanded', shouldOpen ? 'true' : 'false');
}

function initializeLanguageSwitcher() {
	const button = document.getElementById('language-button');
	const dropdown = document.getElementById('language-dropdown');
	const switcher = document.getElementById('language-switcher');
	if (!button || !dropdown || !switcher) return;

	button.addEventListener('click', (event) => {
		event.stopPropagation();
		toggleLanguageDropdown();
	});

	dropdown.querySelectorAll('.language-option').forEach((option) => {
		option.addEventListener('click', (event) => {
			event.stopPropagation();
			applyTranslations(option.dataset.language);
			toggleLanguageDropdown(false);
		});
	});

	document.addEventListener('click', (event) => {
		if (!switcher.contains(event.target)) {
			toggleLanguageDropdown(false);
		}
	});

	document.addEventListener('keydown', (event) => {
		if (event.key === 'Escape') {
			toggleLanguageDropdown(false);
		}
	});
}

document.addEventListener('DOMContentLoaded', () => {
	initializeLanguageSwitcher();
	applyTranslations(detectInitialLanguage());
	initializeServices();
	initializeUrlInput();
	initializeAutoInput();
	requestSupportedServices();
});

window.requestUrl = requestUrl;
window.selectService = selectService;
window.openService = openService;
window.hoverService = hoverService;
window.setServices = setServices;
window.closeCodecPopup = closeCodecPopup;
window.openCodecInstructions = openCodecInstructions;
