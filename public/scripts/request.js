'use strict';

var ua = navigator.userAgent || '';
  var legacyGmod = /GMod\/13/i.test(ua) && /Chrome\/86\./i.test(ua);

  window.MP_LEGACY_GMOD = legacyGmod;

  if (legacyGmod) {
    var root = document.documentElement;
    root.className += (root.className ? ' ' : '') + 'legacy-gmod';
  }

  var fa = document.createElement('link');
  fa.rel = 'stylesheet';
  fa.href = legacyGmod
    ? 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.7.2/css/all.min.css'
    : 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.3.1/css/all.min.css';
  document.head.appendChild(fa);

const services = [
	{ name: 'YouTube', icon: 'fa-brands fa-youtube', url: 'https://youtube.com/', action: 'select', requiresCodec: false, group: 'Video' },
	{ name: 'SoundCloud', icon: 'fa-brands fa-soundcloud', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: true, group: 'Audio' },
	{ name: 'Dailymotion', icon: 'fa-brands fa-dailymotion', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true, group: 'Video' },
	{ name: 'Twitch', icon: 'fa-brands fa-twitch', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true, group: 'Live' },
	{ name: 'Bilibili', icon: 'fa-brands fa-bilibili', url: 'https://www.bilibili.com/', action: 'open', requiresCodec: true, group: 'Video' },
	{ name: 'Internet Archive', icon: 'fa-brands fa-internet-archive', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true, group: 'Archive' },
<<<<<<< Updated upstream
	{ name: 'Odysee', icon: 'fa-solid fa-play', url: 'https://odysee.com/', action: 'select', requiresCodec: true, group: 'Video' }
=======
	{ name: 'VK Видео', icon: 'fa-brands fa-vk', url: 'https://vkvideo.ru/', action: 'select', requiresCodec: true, group: 'Video' },
	{ name: 'Одноклассники', icon: 'fa-brands fa-odnoklassniki', url: 'https://ok.ru/video', action: 'select', requiresCodec: true, group: 'Video' },
>>>>>>> Stashed changes
];

let hasCodecSupport = false;

const supportGroups = [
	{
		key: 'images',
		title: 'Images',
		icon: 'fa-regular fa-image',
		note: 'Direct image URLs are supported by the resource media service.',
		items: [
			['.jpg / .jpeg', 'https://example.com/poster.jpg'],
			['.png', 'https://example.com/image.png'],
			['.gif', 'https://example.com/animation.gif'],
			['.bmp', 'https://example.com/image.bmp']
		]
	},
	{
		key: 'video',
		title: 'Video',
		icon: 'fa-solid fa-video',
		note: 'WebM is handled by the regular media path. MP4, MOV and MKV use the codec-dependent path.',
		items: [
			['.webm', 'https://example.com/video.webm'],
			['.mp4', 'https://example.com/video.mp4'],
			['.mov', 'https://example.com/video.mov'],
			['.mkv', 'https://example.com/video.mkv']
		]
	},
	{
		key: 'audio',
		title: 'Audio',
		icon: 'fa-solid fa-music',
		note: 'Direct audio files are supported by the audio media service.',
		items: [
			['.mp3', 'https://example.com/audio.mp3'],
			['.wav', 'https://example.com/audio.wav'],
			['.ogg', 'https://example.com/audio.ogg'],
			['.m4a', 'https://example.com/audio.m4a'],
			['.aac', 'https://example.com/audio.aac'],
			['.flac', 'https://example.com/audio.flac']
		]
	},
	{
		key: 'streaming',
		title: 'Streaming',
		icon: 'fa-solid fa-tower-broadcast',
		note: 'HLS and DASH manifest URLs can be requested directly.',
		items: [
			['.m3u8', 'https://example.com/stream.m3u8'],
			['.mpd', 'https://example.com/manifest.mpd']
		]
	},
	{
		key: 'services',
		title: 'Supported service URLs',
		icon: 'fa-solid fa-globe',
		note: 'These share/provider URLs map to the service implementations available in Media Player.',
		items: [
			['YouTube', 'https://www.youtube.com/watch?v=VIDEO_ID'],
			['Twitch', 'https://www.twitch.tv/CHANNEL'],
			['SoundCloud', 'https://soundcloud.com/artist/track'],
			['Dailymotion', 'https://www.dailymotion.com/video/VIDEO_ID'],
			['Bilibili', 'https://www.bilibili.com/video/VIDEO_ID'],
			['Odysee', 'https://odysee.com/@channel:1/video:1'],
			['Archive.org', 'https://archive.org/details/ITEM_ID'],
<<<<<<< Updated upstream
			['Google Drive', 'https://drive.google.com/file/d/FILE_ID/view']
=======
			['VK Video', 'https://vkvideo.ru/video-VIDEO_ID'],
			['VK Live', 'https://vkvideo.ru/live-OWNER_ID'],
			['Одноклассники', 'https://ok.ru/video/VIDEO_ID'],
			['Google Drive', 'https://drive.google.com/file/d/FILE_ID/view'],
			['MEGA', 'https://mega.nz/file/FILE_ID#KEY']
>>>>>>> Stashed changes
		]
	}
];

function getElement(selector) { return document.querySelector(selector); }

function gmodAvailable(name) {
	return typeof gmod !== 'undefined' && typeof gmod[name] === 'function';
}

function playUISound(click) {
	if (gmodAvailable('clickSound')) {
		gmod.clickSound(click);
	}
}

function checkCodecSupport() {
	const support = document.createElement("video").canPlayType('video/mp4; codecs="avc1.42E01E, mp4a.40.2"');
	hasCodecSupport = support === "probably" || support === "maybe";
	return hasCodecSupport;
}

function showToast(message, type = 'success') {
	const toast = getElement('#toast');
	getElement('#toast-text').textContent = message;
	getElement('#toast-icon').className = type === 'error'
		? 'fa-solid fa-circle-exclamation'
		: 'fa-solid fa-circle-check';
	toast.classList.remove('hidden');
	window.clearTimeout(showToast.timer);
	showToast.timer = window.setTimeout(() => toast.classList.add('hidden'), 2200);
}

function renderSupportContent() {
	const root = getElement('#support-content');
	root.innerHTML = supportGroups.map(group => `
		<section class="support-group">
			<div class="support-group-title">
				<span class="support-group-icon"><i class="${group.icon}" aria-hidden="true"></i></span>
				<div><h3>${MP_I18N.t('request.support_' + group.key)}</h3><p>${MP_I18N.t('request.support_' + group.key + '_note')}</p></div>
			</div>
			<div class="support-items">
				${group.items.map(([label, example]) => `
					<button type="button" class="support-item" data-copy="${example}" title="${MP_I18N.t('request.copy_example')}">
						<span class="support-label">${label}</span>
						<code>${example}</code>
						<i class="fa-regular fa-copy" aria-hidden="true"></i>
					</button>
				`).join('')}
			</div>
		</section>
	`).join('');

	root.querySelectorAll('[data-copy]').forEach(button => {
		button.addEventListener('click', async () => {
			const value = button.dataset.copy;
			try {
				await navigator.clipboard.writeText(value);
				showToast(MP_I18N.t('request.copy_success'));
			} catch {
				getElement('#urlinput').value = value;
				getElement('#clear-btn').classList.remove('hidden');
				closeSupportPopup();
				getElement('#urlinput').focus();
			}
		});
	});
}

function showSupportPopup() {
	renderSupportContent();
	getElement('#support-modal').classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeSupportPopup() {
	getElement('#support-modal').classList.add('hidden');
	document.body.style.overflow = '';
}

function openService(url) {
	if (gmodAvailable('openUrl')) {
		gmod.openUrl(url);
		return;
	}
	window.open(url, '_blank');
}

function isValidURL(value) {
	try { new URL(value); return true; } catch { return /^https?:\/\//.test(value) || /^www\./.test(value) || (value.includes('.') && value.length > 5); }
}

function requestUrl() {
	const input = getElement('#urlinput');
	const url = input.value.trim();

	if (!url) {
		showToast(MP_I18N.t('request.url_empty'), 'error');
		input.focus();
		return;
	}

	if (!isValidURL(url)) {
		showToast(MP_I18N.t('request.url_invalid'), 'error');
		input.focus();
		return;
	}

	if (!gmodAvailable('requestUrl')) {
		showToast(MP_I18N.t('request.bridge_unavailable'), 'error');
		return;
	}

	const button = getElement('#submit-btn');
	button.disabled = true;
	playUISound(true);
	gmod.requestUrl(url);
	showToast(MP_I18N.t('request.status_sent'));
	window.setTimeout(() => {
		button.disabled = false;
	}, 900);
}

function selectService(service) {
	playUISound(true);

	if (service.action === 'open') {
		openService(service.url);
		return;
	}

	window.location.href = service.url;
}

function renderServices() {
	const grid = getElement('#services-grid');
	grid.innerHTML = '';

	services.forEach(service => {
		const disabled = service.requiresCodec && !hasCodecSupport;
		const card = document.createElement('button');
		card.type = 'button';
		card.className = 'service-card' + (disabled ? ' disabled' : '') + (service.requiresCodec ? ' codec-required' : '');
		card.setAttribute('aria-disabled', disabled ? 'true' : 'false');
		card.dataset.serviceName = service.name;

		const icon = document.createElement('span');
		icon.className = 'service-icon';

		const iconElement = document.createElement('i');
		iconElement.className = service.icon;
		iconElement.setAttribute('aria-hidden', 'true');
		icon.appendChild(iconElement);

		const meta = document.createElement('span');
		meta.className = 'service-meta';

		const text = document.createElement('span');
		const name = document.createElement('span');
		name.className = 'service-name';
		name.textContent = service.name;
		text.appendChild(name);

		const action = document.createElement('span');
		action.className = 'service-arrow';
		if (!disabled) {
			const arrow = document.createElement('i');
			arrow.className = 'fa-solid fa-arrow-up-right-from-square';
			arrow.setAttribute('aria-hidden', 'true');
			action.appendChild(arrow);
		}

		meta.append(text, action);
		card.append(icon, meta);

		card.addEventListener('mouseenter', () => playUISound(false));
		card.addEventListener('click', () => {
			if (!disabled) selectService(service);
		});

		grid.appendChild(card);
	});
}

async function initialize() {
	bindRequestUI();
	checkCodecSupport();
	renderServices();

	try {
		if (typeof MP_I18N !== 'undefined' && MP_I18N.initFromHash) {
			await MP_I18N.initFromHash();
		}
	} catch (error) {
		console.warn('Media Player translations unavailable:', error);
	}

	renderServices();
	renderSupportContent();
}

function bindRequestUI() {
	getElement('#submit-btn').addEventListener('click', requestUrl);
	getElement('#urlinput').addEventListener('keydown', event => {
		if (event.key === 'Enter') {
			event.preventDefault();
			requestUrl();
		}
	});
	getElement('#urlinput').addEventListener('input', event => {
		getElement('#clear-btn').classList.toggle('hidden', !event.target.value);
	});
	getElement('#clear-btn').addEventListener('click', () => {
		getElement('#urlinput').value = '';
		getElement('#clear-btn').classList.add('hidden');
		getElement('#urlinput').focus();
	});
	getElement('#support-info-btn').addEventListener('click', showSupportPopup);

	document.querySelectorAll('[data-action="close-support"]').forEach(el => {
		el.addEventListener('click', closeSupportPopup);
	});

	document.addEventListener('keydown', event => {
		if (event.key === 'Escape') {
			closeSupportPopup();
			return;
		}
		if (
			document.activeElement !== getElement('#urlinput') &&
			!event.ctrlKey && !event.metaKey && !event.altKey &&
			event.key.length === 1
		) {
			getElement('#urlinput').focus();
		}
	});
}

document.addEventListener('DOMContentLoaded', initialize);

window.requestUrl = requestUrl;
window.showSupportPopup = showSupportPopup;
window.closeSupportPopup = closeSupportPopup;
window.selectService = selectService;
window.openService = openService;
window.hoverService = playUISound;