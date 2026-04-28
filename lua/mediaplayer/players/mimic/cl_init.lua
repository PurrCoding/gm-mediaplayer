include "shared.lua"

DEFINE_BASECLASS( "mp_entity" )

local MEDIAPLAYER = MEDIAPLAYER

local print = print
local IsValid = IsValid
local cam = cam
local Start3D2D = cam.Start3D2D
local End3D2D = cam.End3D2D
local RealTime = RealTime
local LocalPlayer = LocalPlayer
local CursorVisible = vgui.CursorVisible

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local SetFont = surface.SetFont
local GetTextSize = surface.GetTextSize
local SimpleText = draw.SimpleText
local RoundedBox = draw.RoundedBox
local PushModelMatrix = cam.PushModelMatrix
local PopModelMatrix = cam.PopModelMatrix
local Matrix = Matrix
local Vector = Vector
local math_min = math.min
local math_max = math.max

local MAX_DRAW_DISTANCE_SQR = 2500 * 2500
local InfoDisplayTime = 3
local InfoFadeTime = 1

local RenderScale = 0.1

-- Mimic states
local MIMIC_STATE_NO_SOURCE    = 0
local MIMIC_STATE_NO_CLIENT_MP = 1
local MIMIC_STATE_NO_MEDIA     = 2
local MIMIC_STATE_ACTIVE       = 3

-- Colors
local colorBg       = Color( 20, 20, 25, 255 )
local colorTitle     = Color( 255, 200, 60, 255 )
local colorSubtext   = Color( 180, 180, 190, 255 )
local colorDotRed    = Color( 220, 60, 60, 255 )
local colorDotYellow = Color( 255, 200, 60, 255 )
local colorDotGreen  = Color( 80, 220, 120, 255 )
local colorOverlayBg = Color( 0, 0, 0, 120 )
local colorOverlayTx = Color( 255, 255, 255, 180 )

-- Layout constants (in "virtual" text-space pixels, scaled to fit)
local LinePadding = 24
local EdgePadding = 50
local DotRadius   = 8

---
-- Resolve the current mimic state and return (state, media).
--
local function ResolveMimicState( self )
	local sourceId = self._SourceMPId
	if not sourceId then
		return MIMIC_STATE_NO_SOURCE, nil
	end

	local sourceMP = MediaPlayer.GetById( sourceId )
	if not sourceMP or not sourceMP:IsValid() then
		return MIMIC_STATE_NO_CLIENT_MP, nil
	end

	local media = sourceMP:GetMedia()
	if not IsValid( media ) then
		return MIMIC_STATE_NO_MEDIA, nil
	end

	return MIMIC_STATE_ACTIVE, media
end

---
-- Update state and track transitions.
--
local function UpdateMimicState( self )
	local state, media = ResolveMimicState( self )

	if state ~= self._mimicState then
		self._mimicStatePrev = self._mimicState
		self._mimicState = state
		self._mimicStateChanged = RealTime()
	end

	return state, media
end

---
-- Get the status text lines and dot color for a given state.
--
local function GetStatusInfo( state )
	if state == MIMIC_STATE_NO_SOURCE then
		return "MIMIC", "No source linked", "Use the Mimic tool to link a source.", colorDotRed
	elseif state == MIMIC_STATE_NO_CLIENT_MP then
		return "MIMIC", "Waiting for source...", "The source player is currently unavailable.", colorDotYellow
	elseif state == MIMIC_STATE_NO_MEDIA then
		return "MIMIC", "Source idle", "No media is playing on the source.", colorDotYellow
	end
	return "MIMIC", "", "", colorDotGreen
end

---
-- Draw the mimic status screen, scaled to fit the given w x h area.
-- Uses a model matrix to uniformly shrink text so it's always readable.
--
local function DrawMimicStatus( self, w, h, state )
	-- Background
	SetDrawColor( colorBg )
	DrawRect( 0, 0, w, h )

	local title, line1, line2, dotColor = GetStatusInfo( state )

	-- Pulsing dot alpha
	local pulse = math.abs( math.sin( RealTime() * 2 ) )
	local dotAlpha = 120 + pulse * 135
	local dotCol = Color( dotColor.r, dotColor.g, dotColor.b, dotAlpha )

	-- Measure all text lines at native font size
	SetFont( "MediaTitle" )
	local tw_title, th_title = GetTextSize( title )
	local tw_line1, th_line1 = GetTextSize( line1 )
	local tw_line2, th_line2 = GetTextSize( line2 )

	-- Total text block dimensions (dot sits left of title)
	local dotSpace = DotRadius * 2 + 12
	local titleRowW = dotSpace + tw_title
	local maxTextW = math_max( titleRowW, tw_line1, tw_line2, 1 )
	local totalH = th_title + LinePadding + th_line1 + LinePadding + th_line2

	-- Compute uniform scale factor so text fits within the screen with padding
	local availW = w - EdgePadding * 2
	local availH = h - EdgePadding * 2
	local scale = math_min( 1, availW / maxTextW, availH / totalH )

	-- Apply scale via matrix (multiply with current 3D2D matrix)
	local mat = Matrix()
	mat:Translate( Vector( w / 2, h / 2, 0 ) )
	mat:Scale( Vector( scale, scale, 1 ) )
	mat:Translate( Vector( -w / 2, -h / 2, 0 ) )
	PushModelMatrix( mat, true )

	-- Vertical start: center the text block
	local startY = h / 2 - totalH / 2

	-- Title row: dot + "MIMIC"
	local titleCenterX = w / 2
	local titleRowStartX = titleCenterX - titleRowW / 2

	-- Draw pulsing dot
	local dotX = titleRowStartX + DotRadius
	local dotY = startY + th_title / 2
	RoundedBox( DotRadius, dotX - DotRadius, dotY - DotRadius, DotRadius * 2, DotRadius * 2, dotCol )

	-- Draw title text
	SimpleText( title, "MediaTitle",
		titleRowStartX + dotSpace, startY + th_title / 2,
		colorTitle, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	-- Line 1 (main status)
	SimpleText( line1, "MediaTitle",
		titleCenterX, startY + th_title + LinePadding + th_line1 / 2,
		colorSubtext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	-- Line 2 (hint)
	SimpleText( line2, "MediaTitle",
		titleCenterX, startY + th_title + LinePadding + th_line1 + LinePadding + th_line2 / 2,
		colorSubtext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	PopModelMatrix()
end

---
-- Override idle screen to show mimic-specific status.
--
function MEDIAPLAYER:DrawIdlescreen( w, h )
	local state = UpdateMimicState( self )
	DrawMimicStatus( self, w, h, state )
end

function MEDIAPLAYER:NetReadUpdate()
	local entIndex = net.ReadUInt( 16 )
	local sourceId = net.ReadString()

	if sourceId ~= "" then
		self._SourceMPId = sourceId
	end

	local ent = Entity( entIndex )
	local mpEnt = self.Entity

	if ent ~= mpEnt then
		if IsValid( ent ) and ent ~= NULL then
			ent:InstallMediaPlayer( self )
		else
			self._EntIndex = entIndex
		end
	end
end

function MEDIAPLAYER:SetMedia( media )
	-- no-op: mimic has no media of its own
end

---
-- Main 3D draw — mirrors the source player's media onto this entity's screen.
--
function MEDIAPLAYER:Draw( bDrawingDepth, bDrawingSkybox )
	local ent = self.Entity

	if self._isFullscreen then
		if self._hudPaintFired then
			self._hudPaintFired = false
			return
		end
	end

	if not IsValid( ent ) or ( ent.IsDormant and ent:IsDormant() ) then
		return
	end

	if LocalPlayer():EyePos():DistToSqr( ent:GetPos() ) > MAX_DRAW_DISTANCE_SQR then
		return
	end

	local state, media = UpdateMimicState( self )
	local w, h, pos, ang = self:GetOrientation()
	if not w then return end

	local rw, rh = w / RenderScale, h / RenderScale

	if state == MIMIC_STATE_ACTIVE and IsValid( media ) and media.Draw then
		Start3D2D( pos, ang, RenderScale )
			media:Draw( rw, rh )
		End3D2D()
	else
		Start3D2D( pos, ang, RenderScale )
			DrawMimicStatus( self, rw, rh, state )
		End3D2D()
	end
end

---
-- Fullscreen draw — mirrors the source player's media fullscreen.
--
function MEDIAPLAYER:DrawFullscreen()
	if not self._isFullscreen then return end

	self._hudPaintFired = true

	local w, h = ScrW(), ScrH()
	local state, media = UpdateMimicState( self )

	if state == MIMIC_STATE_ACTIVE and IsValid( media ) and media.Draw then
		media:Draw( w, h )
	else
		DrawMimicStatus( self, w, h, state )
	end
end

function MEDIAPLAYER:OnMousePressed( x, y )
	-- no-op
end

function MEDIAPLAYER:OnMouseWheeled( scrollDelta )
	-- no-op
end