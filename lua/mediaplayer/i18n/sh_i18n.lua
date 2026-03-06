--
-- Internationalization module for Media Player.
-- Automatically discovers and loads all language files from the lang/ directory.
-- Language codes match GMod's gmod_language convar (e.g. "en", "de").
--
-- Usage:
--   MediaPlayer.L("mp.ui.no_media")
--   MediaPlayer.L("mp.error.request_failed", errMsg)
--

MediaPlayer.i18n = MediaPlayer.i18n or {}
MediaPlayer.i18n._languages = {}
MediaPlayer.i18n._fallback = "en"

---
-- Register a language dictionary.
--
-- @param langCode string  Two-letter language code matching gmod_language (e.g. "en", "de")
-- @param translations table  Key-value table of translation strings
--
function MediaPlayer.i18n.RegisterLanguage(langCode, translations)
	local existing = MediaPlayer.i18n._languages[langCode]

	if existing then
		table.Merge(existing, translations)
	else
		MediaPlayer.i18n._languages[langCode] = translations
	end

	if MediaPlayer.DEBUG then
		local count = table.Count(MediaPlayer.i18n._languages[langCode])
		print("MediaPlayer.i18n: Registered language '" .. langCode .. "' (" .. count .. " keys)")
	end
end

---
-- Get the current language code.
-- On the client, reads the gmod_language convar directly.
-- On the server, returns the fallback language.
--
-- @return string  Two-letter language code
--
function MediaPlayer.i18n.GetLanguage()
	if CLIENT then
		local cvar = GetConVar("gmod_language")
		return cvar and cvar:GetString() or MediaPlayer.i18n._fallback
	end

	return MediaPlayer.i18n._fallback
end

---
-- Check if a language is available.
--
-- @param langCode string
-- @return boolean
--
function MediaPlayer.i18n.HasLanguage(langCode)
	return MediaPlayer.i18n._languages[langCode] ~= nil
end

---
-- Get a list of all registered language codes.
--
-- @return table  Array of language code strings
--
function MediaPlayer.i18n.GetAvailableLanguages()
	local langs = {}

	for code in pairs(MediaPlayer.i18n._languages) do
		table.insert(langs, code)
	end

	table.sort(langs)
	return langs
end

---
-- Translate a key into the current language.
-- Falls back to English if the key is not found.
-- Falls back to the raw key if not found in any language.
-- Supports string.format style arguments.
--
-- @param key string  Translation key (e.g. "mp.ui.no_media")
-- @param ... any     Optional format arguments
-- @return string     Translated (and optionally formatted) string
--
function MediaPlayer.L(key, ...)
	local lang = MediaPlayer.i18n.GetLanguage()
	local dict = MediaPlayer.i18n._languages[lang]
	local str = dict and dict[key]

	-- Fallback to default language
	if not str and lang ~= MediaPlayer.i18n._fallback then
		local fallbackDict = MediaPlayer.i18n._languages[MediaPlayer.i18n._fallback]
		str = fallbackDict and fallbackDict[key]
	end

	-- Fallback to the raw key
	if not str then
		if MediaPlayer.DEBUG then
			print("MediaPlayer.i18n: Missing translation for key '" .. key .. "' in language '" .. lang .. "'")
		end
		str = key
	end

	-- Apply format arguments if provided
	local args = { ... }
	if #args > 0 then
		local ok, formatted = pcall(string.format, str, unpack(args))
		if ok then
			return formatted
		else
			ErrorNoHalt("MediaPlayer.i18n: Format error for key '" .. key .. "': " .. formatted .. "\n")
			return str
		end
	end

	return str
end

--[[---------------------------------------------------------
	Auto-load language files
-----------------------------------------------------------]]

local langPath = "mediaplayer/i18n/lang/"
local files = file.Find(langPath .. "*.lua", "LUA")

if files then
	table.sort(files)

	for _, f in ipairs(files) do
		if SERVER then
			AddCSLuaFile(langPath .. f)
		end

		include(langPath .. f)
	end

	if MediaPlayer.DEBUG then
		print("MediaPlayer.i18n: Loaded " .. #files .. " language file(s)")
	end
else
	ErrorNoHalt("MediaPlayer.i18n: No language files found in " .. langPath .. "\n")
end