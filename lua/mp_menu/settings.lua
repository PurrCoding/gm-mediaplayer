local L = MediaPlayer.L

-- ─────────────────────────────────────────────
-- Proximity radius visualization
-- ─────────────────────────────────────────────

local minColor = Color(0, 220, 0, 200)
local maxColor = Color(220, 0, 0, 200)
local minGlow  = Color(0, 220, 0, 40)
local maxGlow  = Color(220, 0, 0, 40)

local showProximityRadius = false

local function DrawThickCircle(pos, radius, color, width, segments)
	segments = segments or 64
	width = width or 6
	local step = (2 * math.pi) / segments

	render.SetColorMaterial()
	render.StartBeam(segments + 1)
	for i = 0, segments do
		local angle = i * step
		local p = pos + Vector(math.cos(angle) * radius, math.sin(angle) * radius, 1)
		render.AddBeam(p, width, i / segments, color)
	end
	render.EndBeam()
end

local function ProximityRadiusHook(depth, skybox, skybox3d)
	if skybox or skybox3d then return end
	if not MediaPlayer.Cvars.Audio3D:GetBool() then return end

	local minDist = MediaPlayer.Cvars.ProximityMin:GetFloat()
	local maxDist = MediaPlayer.Cvars.ProximityMax:GetFloat()

	for _, mp in pairs(MediaPlayer.List) do
		if not IsValid(mp) then continue end
		local ent = mp.Entity
		if not IsValid(ent) then continue end
		local pos = ent:GetPos()

		if minDist > 0 then
			DrawThickCircle(pos, minDist, minGlow, 20, 64)
			DrawThickCircle(pos, minDist, minColor, 6, 64)
		end
		if maxDist > 0 then
			DrawThickCircle(pos, maxDist, maxGlow, 20, 64)
			DrawThickCircle(pos, maxDist, maxColor, 6, 64)
		end
	end
end

local function SetProximityRadius(enabled)
	showProximityRadius = enabled
	if enabled then
		hook.Add("PostDrawTranslucentRenderables", "MP.Settings.ProximityRadius", ProximityRadiusHook)
	else
		hook.Remove("PostDrawTranslucentRenderables", "MP.Settings.ProximityRadius")
	end
end

-- ─────────────────────────────────────────────
-- Language display names
-- ─────────────────────────────────────────────

local LanguageNames = {
	["en"]    = "English",
	["de"]    = "Deutsch",
	["fr"]    = "Français",
	["es-ES"] = "Español",
	["it"]    = "Italiano",
	["pt-BR"] = "Português (BR)",
	["ru"]    = "Русский",
	["uk"]    = "Українська",
	["pl"]    = "Polski",
	["nl"]    = "Nederlands",
	["cs"]    = "Čeština",
	["hu"]    = "Magyar",
	["no"]    = "Norsk",
	["fi"]    = "Suomi",
	["tr"]    = "Türkçe",
	["ja"]    = "日本語",
	["ko"]    = "한국어",
	["zh-CN"] = "简体中文",
	["zh-TW"] = "繁體中文",
	["en-PT"] = "Pirate Speak",
	["tlh"]   = "Klingon (tlhIngan Hol)",
}

-- ─────────────────────────────────────────────
-- Control factory functions
-- ─────────────────────────────────────────────

local function CreateSectionLabel(parent, i18nKey)
	local label = vgui.Create("DLabel", parent)
	label:SetText(L(i18nKey))
	label:SetFont("DermaDefaultBold")
	label:SetTextColor(Color(220, 220, 220))
	label:Dock(TOP)
	label:DockMargin(0, 15, 0, 5)
	label:SizeToContents()
	return label
end

local function CreateCheckbox(parent, i18nKey, convar)
	local cb = vgui.Create("DCheckBoxLabel", parent)
	cb:SetText(L(i18nKey))

	if convar then
		cb:SetConVar(convar)
	end

	cb:Dock(TOP)
	cb:DockMargin(0, 5, 0, 0)
	cb:SizeToContents()
	return cb
end

local function CreateSlider(parent, i18nKey, convar, min, max, decimals)
	local slider = vgui.Create("DNumSlider", parent)
	slider:SetText(L(i18nKey))
	slider:SetConVar(convar)
	slider:SetMin(min)
	slider:SetMax(max)
	slider:SetDecimals(decimals or 0)
	slider:Dock(TOP)
	slider:DockMargin(0, 5, 0, 0)
	return slider
end

local function CreateLanguageDropdown(parent, i18nKey, settingsPanel)
	local label = vgui.Create("DLabel", parent)
	label:SetText(L(i18nKey))
	label:SetTextColor(Color(200, 200, 200))
	label:Dock(TOP)
	label:DockMargin(0, 10, 0, 3)
	label:SizeToContents()

	local combo = vgui.Create("DComboBox", parent)
	combo:SetTall(25)
	combo:Dock(TOP)
	combo:DockMargin(0, 0, 0, 0)

	combo:AddChoice("Auto (System)", "", false)

	local langs = MediaPlayer.i18n.GetAvailableLanguages()
	local currentOverride = MediaPlayer.Cvars.LanguageOverride:GetString()

	for _, code in ipairs(langs) do
		local displayName = LanguageNames[code] or code
		local isSelected = (code == currentOverride)
		combo:AddChoice(displayName, code, isSelected)
	end

	if currentOverride == "" then
		combo:ChooseOptionID(1)
	end

	combo.OnSelect = function(_, _, _, data)
		RunConsoleCommand("mediaplayer_language", data)
		if IsValid(settingsPanel) then
			timer.Simple(0.1, function()
				if IsValid(settingsPanel) then
					settingsPanel:BuildContent()
				end
			end)
		end
	end
	return combo
end

local function CreateDisabledDropdown(parent, text, options)
	local label = vgui.Create("DLabel", parent)
	label:SetText(text)
	label:SetTextColor(Color(150, 150, 150, 150))
	label:Dock(TOP)
	label:DockMargin(0, 20, 0, 3)
	label:SizeToContents()

	local combo = vgui.Create("DComboBox", parent)
	combo:SetTall(25)
	combo:Dock(TOP)
	combo:DockMargin(0, 0, 0, 0)
	combo:SetValue(options[1] or "Off")
	for _, opt in ipairs(options) do
		combo:AddChoice(opt)
	end
	combo:SetEnabled(false)
	combo.OnSelect = function() combo:SetValue(options[1] or "Off") end

	return combo
end

-- ─────────────────────────────────────────────
-- Settings tab panel
-- ─────────────────────────────────────────────

local bgcolor = Color(7, 21, 33)

local PANEL = {}

function PANEL:Init()
	self:DockPadding(0, 0, 0, 0)
	self:BuildContent()
end

function PANEL:BuildContent()
	self:Clear()

	local scroll = vgui.Create("DScrollPanel", self)
	scroll:Dock(FILL)
	scroll:DockMargin(10, 10, 10, 10)

	-- Audio section
	CreateSectionLabel(scroll, "mp.settings.audio")
	CreateCheckbox(scroll, "mp.settings.3d_audio", "mediaplayer_3daudio")
	CreateCheckbox(scroll, "mp.settings.mute_unfocused", "mediaplayer_mute_unfocused")

	local proxMin = CreateSlider(scroll, "mp.settings.proximity_min", "mediaplayer_proximity_min", 0, 5000, 0)
	local proxMax = CreateSlider(scroll, "mp.settings.proximity_max", "mediaplayer_proximity_max", 0, 5000, 0)

	local clampingProxy = false

	proxMin.OnValueChanged = function(_, val)
		if clampingProxy then return end
		local max = MediaPlayer.Cvars.ProximityMax:GetFloat()
		if val >= max then
			clampingProxy = true
			proxMin:SetValue(math.max(0, max - 1))
			clampingProxy = false
		end
	end

	proxMax.OnValueChanged = function(_, val)
		if clampingProxy then return end
		local min = MediaPlayer.Cvars.ProximityMin:GetFloat()
		if val <= min then
			clampingProxy = true
			proxMax:SetValue(math.min(5000, min + 1))
			clampingProxy = false
		end
	end

	local radiusToggle = CreateCheckbox(scroll, "mp.settings.show_radius", nil)
	radiusToggle:SetValue(showProximityRadius)
	radiusToggle.OnChange = function(_, checked)
		SetProximityRadius(checked)
	end

	-- Language section
	CreateSectionLabel(scroll, "mp.settings.language")
	CreateLanguageDropdown(scroll, "mp.settings.language", self)

	-- Subtitles (placeholder)
	CreateDisabledDropdown(scroll, "Subtitles — Soon™?", {
		"Off",
		"English — Soon™",
		"German — Soon™",
		"Japanese — Soon™",
		"Klingon — Soon™",
	})
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(bgcolor)
	surface.DrawRect(0, 0, w, h)
end

derma.DefineControl("MP.SettingsTab", "", PANEL, "Panel")