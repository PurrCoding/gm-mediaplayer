local Color = Color
local RealTime = RealTime
local math = math
local string = string

-- Localized library functions (avoid per-frame table lookups)
local math_Clamp = math.Clamp
local math_Round = math.Round

local SetFont = surface.SetFont
local GetTextSize = surface.GetTextSize
local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect

local SimpleText = draw.SimpleText
local RoundedBox = draw.RoundedBox

local CursorVisible = vgui.CursorVisible

local DrawHTMLPanel = MediaPlayerUtils.DrawHTMLPanel
local FormatSeconds = MediaPlayerUtils.FormatSeconds

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_TOP    = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local TEXT_ALIGN_LEFT   = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT  = TEXT_ALIGN_RIGHT

local TextPaddingX = 12
local TextPaddingY = 12

local TextBoxPaddingX = 8
local TextBoxPaddingY = 2

-- Fadeout timing
local InfoDisplayTime = 3  -- seconds before fade starts
local InfoFadeTime = 1     -- seconds to fade out

-- Pre-allocated fade colors (mutated per-frame to avoid allocations)
local FadeWhite  = Color(255, 255, 255, 255)
local FadeTextBg = Color(0, 0, 0, 200)
local FadeBarBg  = Color(0, 0, 0, 200)
local FadeBarFg  = Color(255, 255, 255, 255)

local UTF8SubLastCharPattern = "[^\128-\191][\128-\191]*$"
local OverflowString = "..."
local string_gsub = string.gsub

--
-- Limits a rendered string's width based on a maximum width.
-- Results are cached using nested table lookups to avoid per-frame string allocation.
--
local _restrictCache = {}
local _restrictCacheSize = 0
local MAX_RESTRICT_CACHE = 64

local function RestrictStringWidth( text, font, w )
	local fontCache = _restrictCache[font]
	if fontCache then
		local widthCache = fontCache[w]
		if widthCache then
			local cached = widthCache[text]
			if cached then return cached end
		end
	end

	SetFont( font )
	local curwidth = GetTextSize( text )
	local overflow = false

	while curwidth > w do
		if not overflow then
			overflow = true
		end

		text = string_gsub(text, UTF8SubLastCharPattern, "")
		curwidth = GetTextSize( text .. OverflowString )
	end

	local result = overflow and (text .. OverflowString) or text

	if _restrictCacheSize >= MAX_RESTRICT_CACHE then
		_restrictCache = {}
		_restrictCacheSize = 0
	end

	if not _restrictCache[font] then
		_restrictCache[font] = {}
	end
	if not _restrictCache[font][w] then
		_restrictCache[font][w] = {}
	end
	_restrictCache[font][w][text] = result
	_restrictCacheSize = _restrictCacheSize + 1

	return result
end

function MEDIAPLAYER:DrawHTML( browser, w, h )
	SetDrawColor( 0, 0, 0, 255 )
	DrawRect( 0, 0, w, h )
	DrawHTMLPanel( browser, w, h )
end

function MEDIAPLAYER:DrawMediaInfo( media, w, h )

	local elapsed = RealTime() - self._LastMediaUpdate
	local alpha

	if CursorVisible() then
		alpha = 1
	elseif elapsed <= InfoDisplayTime then
		alpha = 1
	elseif elapsed <= InfoDisplayTime + InfoFadeTime then
		alpha = 1 - ((elapsed - InfoDisplayTime) / InfoFadeTime)
	else
		return
	end

	-- Update pre-allocated fade colors
	local a255 = alpha * 255
	local aBg  = alpha * 200

	FadeWhite.a  = a255
	FadeTextBg.a = aBg
	FadeBarBg.a  = aBg
	FadeBarFg.a  = a255

	-- Title background + text
	local titleStr = RestrictStringWidth( media:Title(), "MediaTitle",
		w - (TextPaddingX * 2 + TextBoxPaddingX * 2) )

	SetFont( "MediaTitle" )
	local tw, th = GetTextSize( titleStr )
	SetDrawColor( FadeTextBg )
	DrawRect( TextPaddingX, TextPaddingY,
		tw + TextBoxPaddingX * 2,
		th + TextBoxPaddingY * 2 )

	SimpleText( titleStr, "MediaTitle",
		TextPaddingX + TextBoxPaddingX,
		TextPaddingY + TextBoxPaddingY,
		FadeWhite )

	-- Track bar
	if media:IsTimed() then

		local duration = media:Duration()
		if not duration or duration <= 0 then return end
		local curTime = media:CurrentTime()
		local percent = math_Clamp( curTime / duration, 0, 1 )

		local bh = math_Round(h * 1 / 32)

		RoundedBox( 0, 0, h - bh, w, bh, FadeBarBg )
		RoundedBox( 0, 0, h - bh, w * percent, bh, FadeBarFg )

		local timeY = h - bh - TextPaddingY * 2

		-- Current time
		local curTimeStr = FormatSeconds(math_Clamp(math_Round(curTime), 0, duration))

		SetFont( "MediaTitle" )
		local ctw, cth = GetTextSize( curTimeStr )
		SetDrawColor( FadeTextBg )
		DrawRect( TextPaddingX, timeY - cth - TextBoxPaddingY * 2,
			ctw + TextBoxPaddingX * 2,
			cth + TextBoxPaddingY * 2 )

		SimpleText( curTimeStr, "MediaTitle",
			TextPaddingX + TextBoxPaddingX,
			timeY - TextBoxPaddingY,
			FadeWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

		-- Duration
		local durationStr = FormatSeconds( duration )
		local dw, dh = GetTextSize( durationStr )
		SetDrawColor( FadeTextBg )
		DrawRect( w - TextPaddingX - dw - TextBoxPaddingX * 2,
			timeY - dh - TextBoxPaddingY * 2,
			dw + TextBoxPaddingX * 2,
			dh + TextBoxPaddingY * 2 )

		SimpleText( durationStr, "MediaTitle",
			w - TextPaddingX - TextBoxPaddingX,
			timeY - TextBoxPaddingY,
			FadeWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

	end

end