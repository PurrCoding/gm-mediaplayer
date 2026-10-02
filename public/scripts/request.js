'use strict';

var services = [
	{ name: 'YouTube', icon: 'fa-brands fa-youtube', url: 'https://youtube.com/', action: 'select', requiresCodec: false, group: 'Video' },
	{ name: 'SoundCloud', icon: 'fa-brands fa-soundcloud', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: false, group: 'Audio' },
	{ name: 'Dailymotion', icon: 'fa-brands fa-dailymotion', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true, group: 'Video' },
	{ name: 'Twitch', icon: 'fa-brands fa-twitch', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true, group: 'Live' },
	{ name: 'Bilibili', icon: 'fa-brands fa-bilibili', url: 'https://www.bilibili.com/', action: 'open', requiresCodec: true, group: 'Video' },
	{ name: 'Internet Archive', icon: 'fa-brands fa-internet-archive', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true, group: 'Archive' },
	{ name: 'Odysee', icon: 'fa-solid fa-play', url: 'https://odysee.com/', action: 'select', requiresCodec: true, group: 'Video' }
];

var hasCodecSupport = false;

var supportGroups = [
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
			['Google Drive', 'https://drive.google.com/file/d/FILE_ID/view']
		]
	}
];

function el(selector) { return document.querySelector(selector); }

function gmodAvailable(name) {
	return typeof gmod !== 'undefined' && typeof gmod[name] === 'function';
}

function playUISound(click) {
	if (gmodAvailable('clickSound')) {
		gmod.clickSound(click);
	}
}

function checkCodecSupport() {
	var video = document.createElement('video');
	hasCodecSupport = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === 'probably';
	return hasCodecSupport;
}

function showToast(message, type = 'success') {
	var toast = el('#toast');
	el('#toast-text').textContent = message;
	el('#toast-icon').className = type === 'error'
		? 'fa-solid fa-circle-exclamation'
		: 'fa-solid fa-circle-check';
	toast.classList.remove('hidden');
	window.clearTimeout(showToast.timer);
	showToast.timer = window.setTimeout(() function () { toast.classList.add('hidden'), 2200);
}

function renderSupportContent() {
	if (typeof MP_I18N === 'undefined') return;
	var root = el('#support-content');
	root.innerHTML = supportGroups.map(group function () { `
		<section class="support-group">
			<div class="support-group-title">
				<span class="support-group-icon"><i class="${group.icon}" aria-hidden="true"></i></span>
				<div><h3>${MP_I18N.t('request.support_' + group.key)}</h3><p>${MP_I18N.t('request.support_' + group.key + '_note')}</p></div>
			</div>
			<div class="support-items">
				${group.items.map(([label, example]) function () { `
					<button type="button" class="support-item" data-copy="${example}" title="Copy example">
						<span class="support-label">${label}</span>
						<code>${example}</code>
						<i class="fa-regular fa-copy" aria-hidden="true"></i>
					</button>
				`).join('')}
			</div>
		</section>
	`).join('');

	root.querySelectorAll('[data-copy]').forEach(button function () { {
		button.addEventListener('click', async () function () { {
			var value = button.dataset.copy;
			try {
				await (window.MP_COPY_TEXT ? window.MP_COPY_TEXT(value) : navigator.clipboard.writeText(value));
				showToast(MP_I18N.t('request.copy_success'));
			} catch {
				el('#urlinput').value = value;
				el('#clear-btn').classList.remove('hidden');
				closeSupportPopup();
				el('#urlinput').focus();
			}
		});
	});
}

function showSupportPopup() {
	renderSupportContent();
	el('#support-modal').classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeSupportPopup() {
	el('#support-modal').classList.add('hidden');
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
	var input = el('#urlinput');
	var url = input.value.trim();

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

	var button = el('#submit-btn');
	button.disabled = true;
	playUISound(true);
	gmod.requestUrl(url);
	showToast(MP_I18N.t('request.status_sent'));
	window.setTimeout(() function () { {
		button.disabled = false;
	}, 900);
}

function showCodecPopup(service) {
	el('#service-name-popup').textContent = service.name;
	el('#codec-popup').classList.remove('hidden');
	document.body.style.overflow = 'hidden';
}

function closeCodecPopup() {
	el('#codec-popup').classList.add('hidden');
	document.body.style.overflow = '';
}

function openCodecInstructions() {
	if (gmodAvailable('openUrl')) {
		gmod.openUrl('https://www.solsticegamestudios.com/fixmedia/');
	} else {
		showToast(MP_I18N.t('request.overlay_unavailable'), 'error');
	}
	closeCodecPopup();
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
	var grid = el('#services-grid');
	grid.innerHTML = '';

	services.forEach(service function () { {
		var disabled = service.requiresCodec && !hasCodecSupport;
		var card = document.createElement('button');
		card.type = 'button';
		card.className = 'service-card' + (disabled ? ' disabled' : '');
		card.setAttribute('aria-disabled', disabled ? 'true' : 'false');
		card.dataset.serviceName = service.name;

		var icon = document.createElement('span');
		icon.className = 'service-icon';

		var iconElement = document.createElement('i');
		iconElement.className = service.icon;
		iconElement.setAttribute('aria-hidden', 'true');
		icon.appendChild(iconElement);

		var meta = document.createElement('span');
		meta.className = 'service-meta';

		var text = document.createElement('span');
		var name = document.createElement('span');
		name.className = 'service-name';
		name.textContent = service.name;
		text.appendChild(name);

		if (disabled) {
			var sub = document.createElement('span');
			sub.className = 'service-sub';
			sub.textContent = MP_I18N.t('request.codec_overlay');
			text.appendChild(sub);
		}

		var action = document.createElement('span');
		action.className = disabled ? 'badge' : 'service-arrow';
		action.textContent = disabled ? MP_I18N.t('request.codec_overlay') : '';
		if (!disabled) {
			var arrow = document.createElement('i');
			arrow.className = 'fa-solid fa-arrow-up-right-from-square';
			arrow.setAttribute('aria-hidden', 'true');
			action.appendChild(arrow);
		}

		meta.append(text, action);
		card.append(icon, meta);

		card.addEventListener('mouseenter', () function () { playUISound(false));
		card.addEventListener('click', () function () { {
			if (disabled) {
				showCodecPopup(service);
				return;
			}
			selectService(service);
		});

		grid.appendChild(card);
	});
}

function initialize() {
	bindRequestUI();
	try {
		MP_I18N.initFromHash();
	} catch (error) {
		console.warn('Media Player translations unavailable:', error);
	}
	checkCodecSupport();
	renderServices();

	function bindRequestUI() {
	el('#submit-btn').addEventListener('click', requestUrl);
	el('#urlinput').addEventListener('keydown', event function () { {
		if (event.key === 'Enter') {
			event.preventDefault();
			requestUrl();
		}
	});
	el('#urlinput').addEventListener('input', event function () { {
		el('#clear-btn').classList.toggle('hidden', !event.target.value);
	});
	el('#clear-btn').addEventListener('click', () function () { {
		el('#urlinput').value = '';
		el('#clear-btn').classList.add('hidden');
		el('#urlinput').focus();
	});
	el('#support-info-btn').addEventListener('click', showSupportPopup);

	document.querySelectorAll('[data-action="close-support"]').forEach(el function () { {
		el.addEventListener('click', closeSupportPopup);
	});
	document.querySelectorAll('[data-action="close-codec"]').forEach(el function () { {
		el.addEventListener('click', closeCodecPopup);
	});
	var instructions = el('[data-action="codec-instructions"]');
	if (instructions) instructions.addEventListener('click', openCodecInstructions);

	document.addEventListener('keydown', event function () { {
		if (event.key === 'Escape') {
			closeCodecPopup();
			closeSupportPopup();
			return;
		}
		if (
			document.activeElement !== el('#urlinput') &&
			!event.ctrlKey && !event.metaKey && !event.altKey &&
			event.key.length === 1
		) {
			el('#urlinput').focus();
		}
	});
	}

}

document.addEventListener('DOMContentLoaded', initialize);

window.requestUrl = requestUrl;
window.showSupportPopup = showSupportPopup;
window.closeSupportPopup = closeSupportPopup;
window.selectService = selectService;
window.openService = openService;
window.hoverService = playUISound;