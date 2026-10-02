'use strict';

const services = [
	{ name: 'YouTube', icon: 'youtube.png', url: 'https://youtube.com/', action: 'select', requiresCodec: false },
	{ name: 'Bilibili', icon: 'bilibili.svg', url: 'https://www.bilibili.com/', action: 'open', requiresCodec: true },
	{ name: 'Twitch', icon: 'twitch.svg', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true },
	{ name: 'SoundCloud', icon: 'soundcloud.svg', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: false },
	{ name: 'Dailymotion', icon: 'dailymotion.png', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true },
	{ name: 'Internet Archive', icon: 'archive.svg', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true },
	{ name: 'Odysee', icon: 'odysee.svg', url: 'https://odysee.com/', action: 'select', requiresCodec: true }
];

let hasCodecSupport = false;

const $ = (selector) => document.querySelector(selector);

function gmodAvailable(name) {
	return typeof gmod !== 'undefined' && typeof gmod[name] === 'function';
}

function playUISound(click) {
	if (gmodAvailable('clickSound')) {
		gmod.clickSound(click);
	}
}

function checkCodecSupport() {
	const video = document.createElement('video');
	hasCodecSupport = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === 'probably';
	return hasCodecSupport;
}

function showToast(message, type = 'success') {
	const toast = $('#toast');
	$('#toast-text').textContent = message;
	$('#toast-icon').textContent = type === 'error' ? '!' : '✓';
	toast.classList.toggle('error', type === 'error');
	toast.classList.remove('hidden');
	window.clearTimeout(showToast.timer);
	showToast.timer = window.setTimeout(() => toast.classList.add('hidden'), 2400);
}

function openService(url) {
	if (!gmodAvailable('openUrl')) {
		showToast('Steam Overlay is unavailable.', 'error');
		return;
	}
	gmod.openUrl(url);
}

function navigateToService(url) {
	window.location.href = url;
}

function requestUrl() {
	const input = $('#urlinput');
	const url = input.value.trim();

	if (!url) {
		showToast(MP_I18N.t('request.url_empty'), 'error');
		input.focus();
		return;
	}

	try {
		const parsed = new URL(url);
		if (!['http:', 'https:'].includes(parsed.protocol)) {
			throw new Error('Unsupported protocol');
		}
	} catch {
		showToast(MP_I18N.t('request.url_invalid'), 'error');
		input.focus();
		return;
	}

	if (!gmodAvailable('requestUrl')) {
		showToast(MP_I18N.t('request.bridge_unavailable'), 'error');
		return;
	}

	const button = $('#submit-btn');
	button.disabled = true;
	playUISound(true);
	gmod.requestUrl(url);
	showToast(MP_I18N.t('request.status_sent'));
	window.setTimeout(() => {
		button.disabled = false;
	}, 900);
}

function showCodecPopup(serviceName) {
	$('#service-name-popup').textContent = serviceName;
	$('#codec-popup').classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeCodecPopup() {
	$('#codec-popup').classList.add('hidden');
	document.body.style.overflow = '';
}

function openCodecInstructions() {
	openService('https://www.solsticegamestudios.com/fixmedia/');
	closeCodecPopup();
}

function selectService(service) {
	playUISound(true);

	if (service.action === 'open') {
		openService(service.url);
		return;
	}

	navigateToService(service.url);
}

function renderServices() {
	const grid = $('#services-grid');
	grid.textContent = '';

	services.forEach((service) => {
		const disabled = service.requiresCodec && !hasCodecSupport;
		const card = document.createElement('button');
		card.type = 'button';
		card.className = 'service-card' + (disabled ? ' disabled' : '');
		card.disabled = disabled;
		card.setAttribute('aria-label', service.name);

		const icon = document.createElement('span');
		icon.className = 'service-icon';

		const image = document.createElement('img');
		image.src = './images/' + service.icon;
		image.alt = '';
		image.loading = 'lazy';
		icon.appendChild(image);

		const meta = document.createElement('span');
		meta.className = 'service-meta';

		const name = document.createElement('span');
		name.className = 'service-name';
		name.textContent = service.name;

		const textWrap = document.createElement('span');
		textWrap.append(name);

		if (disabled) {
			const details = document.createElement('span');
			details.className = 'service-sub';
			details.textContent = MP_I18N.t('request.codec_overlay');
			textWrap.append(details);
		}

		meta.append(textWrap);

		const action = document.createElement('span');
		action.className = disabled ? 'badge' : 'service-arrow';
		action.textContent = disabled ? MP_I18N.t('request.codec_overlay') : '↗';
		meta.append(action);

		card.append(icon, meta);
		card.addEventListener('mouseenter', () => playUISound(false));
		card.addEventListener('click', () => {
			if (disabled) {
				showCodecPopup(service.name);
				return;
			}
			selectService(service);
		});

		grid.appendChild(card);
	});
}

function initializeInput() {
	const input = $('#urlinput');
	const clearButton = $('#clear-btn');

	input.addEventListener('input', () => {
		clearButton.classList.toggle('hidden', input.value.length === 0);
	});

	input.addEventListener('keydown', (event) => {
		if (event.key === 'Enter') {
			event.preventDefault();
			requestUrl();
		}
	});

	clearButton.addEventListener('click', () => {
		input.value = '';
		clearButton.classList.add('hidden');
		input.focus();
	});
}

function initializeModal() {
	document.querySelectorAll('[data-action="close-codec"]').forEach((element) => {
		element.addEventListener('click', closeCodecPopup);
	});

	const instructionsButton = document.querySelector('[data-action="codec-instructions"]');
	if (instructionsButton) {
		instructionsButton.addEventListener('click', openCodecInstructions);
	}
}

function initialize() {
	MP_I18N.initFromHash();
	checkCodecSupport();
	renderServices();
	initializeInput();
	initializeModal();
	$('#submit-btn').addEventListener('click', requestUrl);
}

document.addEventListener('DOMContentLoaded', initialize);

window.requestUrl = requestUrl;
window.selectService = selectService;
window.openService = openService;
