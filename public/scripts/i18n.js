'use strict';

const MP_I18N = {
	_languages: {},
	_currentLang: 'en',

	registerLanguage(code, strings) {
		this._languages[code] = strings;
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

	initFromHash() {
		const hash = window.location.hash;
		const match = hash.match(/lang=([a-zA-Z\-]+)/);
		if (match) {
			this.setLanguage(match[1]);
		}
	}
};