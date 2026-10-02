'use strict';

const MP_I18N = {
	_languages: {},
	_currentLang: 'en',
	_supportedLanguages: [
		'en', 'de', 'fr', 'es-es', 'it', 'pt-br', 'ru', 'uk', 'pl', 'nl',
		'sv-se', 'da', 'nb', 'fi', 'tr', 'ja', 'ko', 'zh-cn', 'zh-tw', 'en-pt'
	],

	registerLanguage(code, strings) {
		this._languages[code] = strings;
	},

	async loadLanguage(lang) {
		const code = this._supportedLanguages.includes(lang) ? lang : 'en';

		if (this._languages[code]) {
			this.setLanguage(code);
			return;
		}

		await new Promise((resolve, reject) => {
			const script = document.createElement('script');
			script.src = `./scripts/translations/${code}.js`;
			script.onload = resolve;
			script.onerror = reject;
			document.head.appendChild(script);
		});

		this.setLanguage(code);
	},

	setLanguage(lang) {
		if (this._languages[lang]) {
			this._currentLang = lang;
		} else {
			this._currentLang = 'en';
		}
		this.applyTranslations();
	},

	t(key) {
		const lang = this._languages[this._currentLang];
		if (lang && lang[key]) return lang[key];

		const fallback = this._languages['en'];
		if (fallback && fallback[key]) return fallback[key];

		return key;
	},

	applyTranslations() {
		document.querySelectorAll('[data-i18n]').forEach(el => {
			const key = el.getAttribute('data-i18n');
			el.textContent = this.t(key);
		});
		document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
			const key = el.getAttribute('data-i18n-placeholder');
			el.placeholder = this.t(key);
		});
	},

	async initFromHash() {
		const hash = window.location.hash;
		const match = hash.match(/lang=([a-zA-Z\-]+)/);
		const lang = match ? match[1].toLowerCase() : 'en';

		try {
			await this.loadLanguage(lang);
		} catch {
			if (lang !== 'en') await this.loadLanguage('en');
			else this.applyTranslations();
		}
	}
};
