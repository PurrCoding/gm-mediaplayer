local L = MediaPlayer.L

-- ─────────────────────────────────────────────
-- Proximity radius visualization
-- ─────────────────────────────────────────────

local minColor = Color(0, 220, 0, 200)
local maxColor = Color(220, 0, 0, 200)
local minGlow  = Color(0, 220, 0, 40)
local maxGlow  = Color(220, 0, 0, 40)
local playerColor       = Color(0, 0, 0, 220)
local playerGlow        = Color(0, 0, 0, 60)
local playerTextColor   = Color(255, 255, 255, 255)
local playerTextBgColor = Color(0, 0, 0, 180)

local showProximityRadius = false

-- Localized math/render/engine functions for render hot loops
local math_pi = math.pi
local math_cos = math.cos
local math_sin = math.sin
local math_Round = math.Round
local render_SetColorMaterial = render.SetColorMaterial
local render_StartBeam = render.StartBeam
local render_AddBeam = render.AddBeam
local render_EndBeam = render.EndBeam
local Vector = Vector
local Angle = Angle
local EyeAngles = EyeAngles
local LocalPlayer = LocalPlayer
local IsValid = IsValid
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local function DrawThickCircle(pos, radius, color, width, segments)
	segments = segments or 64
	width = width or 6
	local step = (2 * math_pi) / segments

	render_SetColorMaterial()
	render_StartBeam(segments + 1)
	for i = 0, segments do
		local angle = i * step
		local p = pos + Vector(math_cos(angle) * radius, math_sin(angle) * radius, 1)
		render_AddBeam(p, width, i / segments, color)
	end
	render_EndBeam()
end

local function ProximityRadiusHook(depth, skybox, skybox3d)
	if skybox or skybox3d then return end
	if not MediaPlayer.Cvars.Audio3D:GetBool() then return end

	local minDist = MediaPlayer.Cvars.ProximityMin:GetFloat()
	local maxDist = MediaPlayer.Cvars.ProximityMax:GetFloat()
	local ply = LocalPlayer()
	local plyPos = ply:GetPos()

	for _, mp in pairs(MediaPlayer.List) do
		if not IsValid(mp) then continue end
		local ent = mp.Entity
		if not IsValid(ent) then continue end
		local pos = ent:GetPos()

		if minDist > 0 then
			DrawThickCircle(pos, minDist, minColor, 6, 64)
		end
		if maxDist > 0 then
			DrawThickCircle(pos, maxDist, maxColor, 6, 64)
		end

		-- Player distance circle + text
		local distance = plyPos:Distance(pos)

		DrawThickCircle(pos, distance, playerColor, 4, 64)

		-- Direction from entity to player (flattened to XY plane)
		local dir = (plyPos - pos)
		dir.z = 0
		local len = dir:Length()
		if len > 0 then
			dir = dir / len
		else
			dir = Vector(1, 0, 0)
		end

		-- Position text INWARD from the circle edge (toward entity center)
		-- so the player sees it in front of them, not inside them
		local textPos = pos + dir * (distance - 100) + Vector(0, 0, 50)

		local billboardAng = Angle(0, EyeAngles().y - 90, 90)

		cam_Start3D2D(textPos, billboardAng, 0.25)
			local text = math_Round(distance) .. " units"
			surface_SetFont("DermaLarge")
			local tw, th = surface_GetTextSize(text)
			surface_SetDrawColor(playerTextBgColor)
			surface_DrawRect(-tw / 2 - 6, -th / 2 - 4, tw + 12, th + 8)
			draw_SimpleText(text, "DermaLarge", 0, 0, playerTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam_End3D2D()
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