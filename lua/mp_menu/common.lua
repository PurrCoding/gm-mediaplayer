local clamp = math.Clamp
local min = math.min

local FormatSeconds = MediaPlayerUtils.FormatSeconds

--[[--------------------------------------------
	Sidebar fonts
----------------------------------------------]]

local FontTbl = {
	font = "Roboto Medium",
	size = 21,
	weight = 400,
	antialias = true,
	extended = true
}

surface.CreateFont( "MP.MediaTitle", FontTbl )

FontTbl.font = "Roboto Medium"
FontTbl.size = 18
surface.CreateFont( "MP.MediaTime", FontTbl )

FontTbl.font = "Roboto Medium"
FontTbl.size = 18
surface.CreateFont( "MP.QueueHeader", FontTbl )

FontTbl.font = "Roboto Light"
FontTbl.size = 18
surface.CreateFont( "MP.MediaDuration", FontTbl )

FontTbl.font = "Roboto Light"
FontTbl.size = 13
surface.CreateFont( "MP.Prefix", FontTbl )

FontTbl.font = "Roboto Bold"
FontTbl.size = 16
surface.CreateFont( "MP.AddedByName", FontTbl )


--[[--------------------------------------------
	Common media player panels
----------------------------------------------]]

local color_transparent = Color(0, 0, 0, 0)
local SCROLL_SPEED = 50
local PAUSE_DURATION = 2

local MEDIA_TITLE = {}

function MEDIA_TITLE:Init()
	self.BaseClass.Init( self )
	self:SetFont( "MP.MediaTitle" )
	self:SetTextColor( color_white )

	self._scrollOffset = 0
	self._scrolling = false
	self._paused = true
	self._pauseStart = RealTime()
	self._lastText = ""
end

function MEDIA_TITLE:Think()
	local text = self:GetText()
	local w = self:GetWide()

	-- Recalculate text width when text changes
	if text ~= self._lastText then
		self._lastText = text
		surface.SetFont(self:GetFont())
		local tw = surface.GetTextSize(text)
		self._textWidth = tw
		self._scrollOffset = 0
		self._paused = true
		self._pauseStart = RealTime()
	end

	-- Check if scrolling is needed
	if not self._textWidth or self._textWidth <= w then
		self._scrolling = false
		self:SetTextColor(color_white)
		return
	end

	self._scrolling = true
	self:SetTextColor(color_transparent)

	local maxScroll = self._textWidth - w

	if self._paused then
		if RealTime() - self._pauseStart >= PAUSE_DURATION then
			self._paused = false
			-- If we were at the end, jump back to start and pause again
			if self._scrollOffset >= maxScroll then
				self._scrollOffset = 0
				self._paused = true
				self._pauseStart = RealTime()
			end
		end
	else
		self._scrollOffset = self._scrollOffset + SCROLL_SPEED * FrameTime()
		if self._scrollOffset >= maxScroll then
			self._scrollOffset = maxScroll
			self._paused = true
			self._pauseStart = RealTime()
		end
	end
end

function MEDIA_TITLE:Paint(w, h)
	if not self._scrolling then
		return
	end

	local x, y = self:LocalToScreen(0, 0)

	render.SetScissorRect(x, y, x + w, y + h, true)
	draw.SimpleText(
		self:GetText(),
		self:GetFont(),
		-self._scrollOffset,
		h / 2,
		color_white,
		nil,
		TEXT_ALIGN_CENTER
	)
	render.SetScissorRect(0, 0, 0, 0, false)
end

derma.DefineControl( "MP.MediaTitle", "", MEDIA_TITLE, "DLabel" )

local MEDIA_TIME = {}

AccessorFunc( MEDIA_TIME, "m_Media", "Media" )
AccessorFunc( MEDIA_TIME, "m_bShowCurrentTime", "ShowCurrentTime" )
AccessorFunc( MEDIA_TIME, "m_bShowDuration", "ShowDuration" )

function MEDIA_TIME:Init()

	self.TimeLbl = vgui.Create( "DLabel", self )
	self.TimeLbl:SetFont( "MP.MediaTime" )
	self.TimeLbl:SetText( "" )
	self.TimeLbl:SetTextColor( color_white )

	self.DividerLbl = vgui.Create( "DLabel", self )
	self.DividerLbl:SetText( "" )
	self.DividerLbl:SetFont( "MP.MediaDuration" )
	-- self.DividerLbl:SetTextColor( color_white )

	self.DurationLbl = vgui.Create( "DLabel", self )
	self.DurationLbl:SetText( "" )
	self.DurationLbl:SetFont( "MP.MediaDuration" )
	-- self.DurationLbl:SetTextColor( color_white )

	self:SetShowCurrentTime( false )
	self:SetShowDuration( true )

	self.NextThink = 0

end

function MEDIA_TIME:SetMedia( media )
	self.m_Media = media

	if media then
		self.DurationLbl:SetText( FormatSeconds( media:Duration() ) )
		self:UpdateDivider()
	end
end

function MEDIA_TIME:UpdateDivider()
	local text = (self.m_bShowCurrentTime and self.m_bShowDuration) and "/" or ""
	self.DividerLbl:SetText( text )
end

function MEDIA_TIME:SetListenForSeekEvents( listen )
	if listen and not self._listening then
		hook.Add( MP.EVENTS.UI.START_SEEKING, self, function(_, pnl) self:OnStartSeeking(pnl) end )
		hook.Add( MP.EVENTS.UI.STOP_SEEKING, self, function() self:OnStopSeeking() end )
	elseif not listen and self._listening then
		self:StopListeningForSeekEvents()
	end

	self._listening = listen
end

function MEDIA_TIME:StopListeningForSeekEvents()
	hook.Remove( MP.EVENTS.UI.START_SEEKING, self )
	hook.Remove( MP.EVENTS.UI.STOP_SEEKING, self )
end

function MEDIA_TIME:OnStartSeeking( seekbarPnl )
	self._seekbar = seekbarPnl
end

function MEDIA_TIME:OnStopSeeking()
	self._seekbar = nil
end

function MEDIA_TIME:OnRemove()
	if self._listening then
		self:StopListeningForSeekEvents()
	end
end

function MEDIA_TIME:Think()

	local rt = RealTime()

	if self.NextThink > rt then return end

	if self.m_Media then

		if self.m_bShowCurrentTime then
			local mediaTime
			local duration = self.m_Media:Duration()

			if self._seekbar then
				local progress = self._seekbar.m_fSlideX or 0
				mediaTime = progress * duration
			else
				mediaTime = self.m_Media:CurrentTime()
			end

			mediaTime = clamp(mediaTime, 0, duration)
			self.TimeLbl:SetText( FormatSeconds( mediaTime ) )
			self:UpdateDivider()
		end

	else

		self.TimeLbl:SetText( "" )
		self.DividerLbl:SetText( "" )
		self.DurationLbl:SetText( "" )

	end

	self:InvalidateLayout(true)

	self.NextThink = rt + 0.1

end

function MEDIA_TIME:PerformLayout()

	self.TimeLbl:SizeToContents()
	self.DividerLbl:SizeToContents()
	self.DurationLbl:SizeToContents()

	self.TimeLbl:CenterVertical()
	self.TimeLbl:AlignLeft( 0 )

	self.DividerLbl:CenterVertical()
	self.DividerLbl:MoveRightOf( self.TimeLbl )

	self.DurationLbl:CenterVertical()
	self.DurationLbl:MoveRightOf( self.DividerLbl )

	local totalwidth = self.DurationLbl:GetPos() + self.DurationLbl:GetWide()
	self:SetWide( totalwidth )

end

derma.DefineControl( "MP.MediaTime", "", MEDIA_TIME, "Panel" )


local ADDED_BY = {}

ADDED_BY.Height = 21
ADDED_BY.NameOffset = 4

function ADDED_BY:Init()

	self.PrefixLbl = vgui.Create( "DLabel", self )
	self.PrefixLbl:SetFont( "MP.Prefix" )
	self.PrefixLbl:SetText( MediaPlayer.L("mp.ui.added_by") )
	self.PrefixLbl:SetTextColor( color_white )
	self.PrefixLbl:SetContentAlignment( 8 )

	self.NameLbl = vgui.Create( "DLabel", self )
	self.NameLbl:SetFont( "MP.AddedByName" )
	self.NameLbl:SetText( MediaPlayer.L("mp.ui.unknown") )
	self.NameLbl:SetTextColor( color_white )
	self.NameLbl:SetContentAlignment( 8 )

end

function ADDED_BY:SetPlayer( ply, name, steamId )
	self.NameLbl:SetText( name )
	self.NameLbl:SetTooltip( steamId )
end

function ADDED_BY:SetMaxWidth( width )
	self.maxWidth = width
	self:InvalidateLayout(true)
end

function ADDED_BY:PerformLayout()

	local name = self.NameLbl:GetText()
	if name == "" then
		self:SetSize( 0, self.Height )
		return
	end

	self.PrefixLbl:SizeToContents()
	self.NameLbl:SizeToContents()

	local pw = self.PrefixLbl:GetWide()
	local nw = self.NameLbl:GetWide()
	local w = pw + nw + self.NameOffset

	if self.maxWidth then
		w = min( w, self.maxWidth )

		-- Clips name label to the maximum width; looks kind of bad since the
		-- ellipsis start too early for some reason.
		-- nw = math.max( 0, w - self.NameOffset - pw )
		-- self.NameLbl:SetWide( nw )
	end

	self:SetSize( w, self.Height )

	self.PrefixLbl:AlignLeft( 0 )
	self.NameLbl:MoveRightOf( self.PrefixLbl, self.NameOffset )

	-- align text baselines
	self.PrefixLbl:AlignBottom( 3 )
	self.NameLbl:AlignBottom( 3 )

end

derma.DefineControl( "MP.AddedBy", "", ADDED_BY, "Panel" )

--[[--------------------------------------------
	Sidebar buttons
----------------------------------------------]]

local BTN_ALPHA_HIGHLIGHTED = 255
local BTN_ALPHA_NORMAL = 84 -- 33% opacity

local SIDEBAR_BTN = {
	Width = 21
}

AccessorFunc( SIDEBAR_BTN, "m_Media", "Media" )
AccessorFunc( SIDEBAR_BTN, "m_bHighlighted", "Highlighted" )
AccessorFunc( SIDEBAR_BTN, "m_HighlightColor", "HighlightColor" )

function SIDEBAR_BTN:Init()
	self:SetSize( self.Width, self.Width )
	self:SetAlpha( BTN_ALPHA_NORMAL )
end

function SIDEBAR_BTN:Think()
	if self.m_bHighlighted or self:IsHovered() and not self.m_bDisabled then
		self:SetAlpha( BTN_ALPHA_HIGHLIGHTED )
	elseif self.m_HighlightColor then
		self:SetColor( self.m_HighlightColor )
		self:SetAlpha( BTN_ALPHA_HIGHLIGHTED )
	else
		self:SetAlpha( BTN_ALPHA_NORMAL )
	end
end

-- function SIDEBAR_BTN:Paint(w,h)
-- 	surface.SetDrawColor(255,0,0)
-- 	surface.DrawRect(0,0,w,h)
-- end

derma.DefineControl( "MP.SidebarButton", "", SIDEBAR_BTN, "DIconButton" )


local SIDEBAR_TOGGLE_BTN = {
	m_EnabledColor = color_white
}

AccessorFunc( SIDEBAR_TOGGLE_BTN, "m_bEnabled", "Enabled" )
AccessorFunc( SIDEBAR_TOGGLE_BTN, "m_EnabledColor", "EnabledColor" )

function SIDEBAR_TOGGLE_BTN:Think()
	if self.m_bEnabled then
		self:SetColor( self.m_EnabledColor )
		self:SetAlpha( BTN_ALPHA_HIGHLIGHTED )
	elseif self.m_bHighlighted or self:IsHovered() and not self.m_bDisabled then
		self:SetAlpha( BTN_ALPHA_HIGHLIGHTED )
	elseif self.m_HighlightColor then
		self:SetColor( self.m_HighlightColor )
		self:SetAlpha( BTN_ALPHA_HIGHLIGHTED )
	else
		self:SetAlpha( BTN_ALPHA_NORMAL )
	end
end

function SIDEBAR_TOGGLE_BTN:DoClick()
	local enabled = not self:GetEnabled()
	self:SetEnabled( enabled )

	if not enabled then
		self:SetColor( color_white )
	end
end

derma.DefineControl( "MP.SidebarToggleButton", "", SIDEBAR_TOGGLE_BTN, "MP.SidebarButton" )

local REMOVE_BTN = {}

function REMOVE_BTN:Init()
	self.BaseClass.Init( self )
	self:SetIcon( "mp-delete" )
end

function REMOVE_BTN:DoClick()
	hook.Run( MP.EVENTS.UI.REMOVE_MEDIA, self.m_Media )
end

derma.DefineControl( "MP.RemoveButton", "", REMOVE_BTN, "MP.SidebarButton" )


local SKIP_BTN = {}

function SKIP_BTN:Init()
	self.BaseClass.Init( self )
	self:SetIcon( "mp-skip" )
end

function SKIP_BTN:DoClick()
	hook.Run( MP.EVENTS.UI.SKIP_MEDIA )
end

derma.DefineControl( "MP.SkipButton", "", SKIP_BTN, "MP.SidebarButton" )