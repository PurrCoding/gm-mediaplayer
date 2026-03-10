local SETTINGS_TAB = {}

SETTINGS_TAB.BgColor = Color(7, 21, 33)

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

local minColor = Color(0, 220, 0, 200)
local maxColor = Color(220, 0, 0, 200)
local minGlow  = Color(0, 220, 0, 40)
local maxGlow  = Color(220, 0, 0, 40)

function SETTINGS_TAB:Init()
	local scroll = vgui.Create("DScrollPanel", self)
	scroll:Dock(FILL)
	scroll:DockMargin(10, 10, 10, 10)

	-- Section: Audio
	local audioHeader = vgui.Create("DLabel", scroll)
	audioHeader:SetFont("MP.QueueHeader")
	audioHeader:SetText(MediaPlayer.L("mp.settings.audio"))
	audioHeader:SetTextColor(color_white)
	audioHeader:Dock(TOP)
	audioHeader:DockMargin(0, 5, 0, 5)
	audioHeader:SizeToContents()

	local audio3d = vgui.Create("DCheckBoxLabel", scroll)
	audio3d:SetText(MediaPlayer.L("mp.settings.3d_audio"))
	audio3d:SetTextColor(color_white)
	audio3d:SetConVar("mediaplayer_3daudio")
	audio3d:Dock(TOP)
	audio3d:DockMargin(0, 5, 0, 0)
	audio3d:SizeToContents()

	local proxMin = vgui.Create("DNumSlider", scroll)
	proxMin:SetText(MediaPlayer.L("mp.settings.proximity_min"))
	proxMin:SetMin(0)
	proxMin:SetMax(7500)
	proxMin:SetDecimals(0)
	proxMin:SetConVar("mediaplayer_proximity_min")
	proxMin:Dock(TOP)
	proxMin:DockMargin(0, 5, 0, 0)

	local proxMax = vgui.Create("DNumSlider", scroll)
	proxMax:SetText(MediaPlayer.L("mp.settings.proximity_max"))
	proxMax:SetMin(0)
	proxMax:SetMax(7500)
	proxMax:SetDecimals(0)
	proxMax:SetConVar("mediaplayer_proximity_max")
	proxMax:Dock(TOP)
	proxMax:DockMargin(0, 5, 0, 0)

	local muteUnfocused = vgui.Create("DCheckBoxLabel", scroll)
	muteUnfocused:SetText(MediaPlayer.L("mp.settings.mute_unfocused"))
	muteUnfocused:SetTextColor(color_white)
	muteUnfocused:SetConVar("mediaplayer_mute_unfocused")
	muteUnfocused:Dock(TOP)
	muteUnfocused:DockMargin(0, 10, 0, 0)
	muteUnfocused:SizeToContents()

	do
		local subtitleLabel = vgui.Create("DLabel", scroll)
		subtitleLabel:SetText("Subtitles — Soon™?")
		subtitleLabel:SetTextColor(Color(150, 150, 150, 150))
		subtitleLabel:Dock(TOP)
		subtitleLabel:DockMargin(0, 20, 0, 5)
		subtitleLabel:SizeToContents()

		local subtitleCombo = vgui.Create("DComboBox", scroll)
		subtitleCombo:SetTall(25)
		subtitleCombo:Dock(TOP)
		subtitleCombo:DockMargin(0, 0, 0, 0)
		subtitleCombo:SetValue("Off")
		subtitleCombo:AddChoice("Off")
		subtitleCombo:AddChoice("English — Soon™")
		subtitleCombo:AddChoice("German — Soon™")
		subtitleCombo:AddChoice("Japanese — Soon™")
		subtitleCombo:AddChoice("Klingon — Soon™")
		subtitleCombo:SetEnabled(true)
		subtitleCombo.OnSelect = function() subtitleCombo:SetValue("Off") end
	end

	-- Clamp min so it can't go above current max
	proxMin.OnValueChanged = function(_, val)
		local max = MediaPlayer.Cvars.ProximityMax:GetFloat()
		if val >= max then
			proxMin:SetValue(max - 1)
		end
	end

	-- Clamp max so it can't go below current min
	proxMax.OnValueChanged = function(_, val)
		local min = MediaPlayer.Cvars.ProximityMin:GetFloat()
		if val <= min then
			proxMax:SetValue(min + 1)
		end
	end

	local settingsPanel = self

	hook.Add("PostDrawTranslucentRenderables", "MP.Settings.ProximityRadius", function(depth, skybox, skybox3d)
		if skybox or skybox3d then return end
		if not IsValid(settingsPanel) or not settingsPanel:IsVisible() then return end
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
	end)
end

function SETTINGS_TAB:Paint(w, h)
	surface.SetDrawColor(self.BgColor)
	surface.DrawRect(0, 0, w, h)
end

function SETTINGS_TAB:OnRemove()
	hook.Remove("PostDrawTranslucentRenderables", "MP.Settings.ProximityRadius")
end

derma.DefineControl("MP.SettingsTab", "", SETTINGS_TAB, "Panel")