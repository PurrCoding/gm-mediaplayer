// public/scripts/request.js
'use strict';

const services = [
	{ id: 'yt', name: 'YouTube', icon: 'youtube', url: 'https://youtube.com/', action: 'select', requiresCodec: false },
	{ id: 'bili', name: 'Bilibili', icon: 'bilibili', url: 'https://www.bilibili.com/', action: 'select', requiresCodec: false },
	{ id: 'tt', name: 'TikTok', icon: 'tiktok', url: 'https://tiktok.com/', action: 'select', requiresCodec: true },
	{ id: 'twl', name: 'Twitch', icon: 'twitch', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true },
	{ id: 'sc', name: 'SoundCloud', icon: 'soundcloud', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: false },
	{ id: 'dm', name: 'Dailymotion', icon: 'dailymotion', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true },
	{ id: 'ia', name: 'Internet Archive', icon: 'archive', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true },
	{ id: 'odysee', name: 'Odysee', icon: 'odysee', url: 'https://odysee.com/', action: 'select', requiresCodec: true },
];

let hasCodecSupport = false;
let supportedServiceIds = null;

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

async function initializeServices() {
	const grid = document.getElementById('services-grid');
	if (!grid) return;

	grid.innerHTML = '';

	const codecCheck = await checkCodecSupport();

	services
		.filter(isServiceSupported)
		.forEach((service) => {
			const card = document.createElement('div');
			card.className = 'service-card';
			card.dataset.href = service.url;
			card.dataset.action = service.action;
			card.dataset.serviceName = service.name;
			card.dataset.serviceId = service.id;

			const isDisabled = service.requiresCodec && !codecCheck.hasCodecSupport;

			if (isDisabled) {
				card.classList.add('service-disabled');
				card.addEventListener('click', (e) => {
					e.preventDefault();
					showCodecPopup(service.name);
				});
			} else {
				card.addEventListener('click', () => selectService(card));
				card.addEventListener('mouseenter', hoverService);
			}

			card.innerHTML = `
				<div class="service-card-inner">
					<div class="service-icon logo-${service.icon}"></div>
					<div class="service-name">${service.name}</div>
					${isDisabled ? `<div class="disabled-overlay">${MP_I18N.t("request.codec_overlay")}</div>` : ''}
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

	if (url.length === 0) return;

	statusIndicator.classList.remove('hidden');
	statusText.textContent = MP_I18N.t('request.status_sent');
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

document.addEventListener('DOMContentLoaded', () => {
	MP_I18N.initFromHash();
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
