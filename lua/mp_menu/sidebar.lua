-- lua/mp_menu/sidebar.lua

include "icons.lua"
include "common.lua"
include "sidebar_tabs.lua"
include "volume_control.lua"
include "playback.lua"
include "queue.lua"
include "horizontal_list.lua"
include "settings.lua"


--[[--------------------------------------------
	Sidebar root panel
----------------------------------------------]]

local PANEL = {}

local SLIDE_DURATION = 0.15
local SLIDE_EASE = -1


function PANEL:Init()
	self:SetName( "MediaPlayerSidebar" )
	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBorderEnabled( false )
	self:SetZPos( -99 )
	self:SetSize( 385, 580 )

	self.Tabs = vgui.Create( "MP.SidebarTabs", self )
	self.Tabs:Dock( FILL )

	local curplaytab = vgui.Create( "MP.CurrentlyPlayingTab" )
	self.Tabs:AddSheet( MediaPlayer.L("mp.ui.currently_playing"), curplaytab, nil, false, false )

	local settingstab = vgui.Create("MP.SettingsTab")
	self.Tabs:AddSheet(MediaPlayer.L("mp.settings.title"), settingstab, nil, false, false)

	self.VolumeControls = vgui.Create( "MP.VolumeControl", self )
	self.VolumeControls:Dock( BOTTOM )
	self.VolumeControls:SetHeight( 48 )

	self:InvalidateLayout( true )

	-- Start off-screen and slide in
	self._sliding = true
	local targetX, targetY = self:GetPos()
	self:SetPos( -self:GetWide(), targetY )
	self:MoveTo( targetX, targetY, SLIDE_DURATION, 0, SLIDE_EASE, function()
		self._sliding = false
	end)
end

function PANEL:Paint(w, h)

	surface.SetDrawColor( 0, 0, 0, 140 )
	surface.DrawRect( 0, 0, w, h )

end

function PANEL:PerformLayout()
	if not self._sliding then
		self:CenterVertical()
		self:AlignLeft( 10 )
	end
	self.Tabs:SizeToContentWidth()
end

function PANEL:SlideOut( callback )
	self._sliding = true
	local _, y = self:GetPos()
	self:MoveTo( -self:GetWide(), y, SLIDE_DURATION, 0, SLIDE_EASE, function()
		if callback then callback() end
	end)
end

local MP_SIDEBAR = vgui.RegisterTable( PANEL, "EditablePanel" )


--[[--------------------------------------------
	Sidebar presenter (transaction-based state machine)

	States: CLOSED, OPENING, OPEN, CLOSING

	Each transition gets a unique transaction ID. Stale animation
	callbacks compare their captured ID against the current one and
	no-op if they don't match. This eliminates every race condition
	that could leave the sidebar stuck.
----------------------------------------------]]

local SidebarPresenter = {
	hooks = {},
	_state = "CLOSED",       -- CLOSED | OPENING | OPEN | CLOSING
	_transactionId = 0,      -- monotonically increasing; invalidates stale callbacks
	_pendingShow = nil,       -- queued mp argument if Show is requested during CLOSING
}

AccessorFunc( SidebarPresenter, "m_Media", "Media" )

function SidebarPresenter:RegisterHook( hookname, callback )

	table.insert( self.hooks, hookname )

	hook.Add( hookname, "MP.SidebarPresenter", function(...)
		if MediaPlayer.DEBUG then
			print("MP.EVENTS.UI", hookname)
			PrintTable({...})
		end

		return callback(...)
	end )

end

function SidebarPresenter:SetupEvents()

	local mp = self:GetMedia()

	self:RegisterHook( MP.EVENTS.UI.OPEN_REQUEST_MENU, function()
		-- No timer.Simple — the state machine handles re-entrant calls safely
		MediaPlayer.OpenRequestMenu( mp )
		SidebarPresenter:HideSidebar()
	end )

	self:RegisterHook( MP.EVENTS.UI.REMOVE_MEDIA, function( media )
		if not media then return end
		MediaPlayer.RequestRemove( mp, media:UniqueID() )
	end )

	self:RegisterHook( MP.EVENTS.UI.SKIP_MEDIA, function()
		MediaPlayer.Skip( mp )
	end )

	self:RegisterHook( MP.EVENTS.UI.TOGGLE_LOCK, function()
		MediaPlayer.RequestLock( mp )
	end )

	self:RegisterHook( MP.EVENTS.UI.TOGGLE_PAUSE, function()
		MediaPlayer.Pause( mp )
	end )

	self:RegisterHook( MP.EVENTS.UI.TOGGLE_REPEAT, function()
		MediaPlayer.RequestRepeat( mp )
	end )

	self:RegisterHook( MP.EVENTS.UI.TOGGLE_SHUFFLE, function()
		MediaPlayer.RequestShuffle( mp )
	end )

	self:RegisterHook( MP.EVENTS.UI.SEEK, function( seekTime )
		MediaPlayer.Seek( mp, seekTime )
	end )

	self:RegisterHook( MP.EVENTS.UI.PRIVILEGED_PLAYER, function()
		local ply = LocalPlayer()
		return mp:IsPlayerPrivileged(ply)
	end )

end

function SidebarPresenter:ClearEvents()

	for _, hookname in ipairs(self.hooks) do
		hook.Remove( hookname, "MP.SidebarPresenter" )
	end

	self.hooks = {}

end

--- Immediately destroy the current panel with no animation.
--- Used internally when replacing a sidebar that is still opening/open.
function SidebarPresenter:_ForceRemovePanel()
	timer.Remove( "MP.SidebarPresenter.OpenTx" )

	if IsValid( self.Sidebar ) then
		self.Sidebar:Remove()
	end

	self.Sidebar = nil
	self._state = "CLOSED"
end

function SidebarPresenter:ShowSidebar( mp )

	self:SetMedia( mp )

	-- If we're in the middle of closing, queue this show for after the close finishes
	if self._state == "CLOSING" then
		self._pendingShow = mp
		return
	end

	-- If a sidebar is already open or opening, force-remove it immediately
	-- so we don't have two panels alive at the same time
	if self._state == "OPEN" or self._state == "OPENING" then
		self:ClearEvents()
		self:_ForceRemovePanel()
	end

	-- Start a new transaction
	self._transactionId = self._transactionId + 1
	local txId = self._transactionId

	self._state = "OPENING"
	self._pendingShow = nil

	self:SetupEvents()

	-- Can be used to extend sidebar functionality
	hook.Run( MP.EVENTS.UI.SETUP_SIDEBAR, self, mp )

	local sidebar = vgui.CreateFromTable( MP_SIDEBAR )
	sidebar:MakePopup()
	sidebar:SetMouseInputEnabled( true )

	hook.Run( MP.EVENTS.UI.MEDIA_PLAYER_CHANGED, mp )

	self.Sidebar = sidebar

	-- Mark as OPEN after the slide-in animation completes
	timer.Create( "MP.SidebarPresenter.OpenTx", SLIDE_DURATION + 0.01, 1, function()
		if self._transactionId == txId and self._state == "OPENING" then
			self._state = "OPEN"
		end
	end )

end

function SidebarPresenter:HideSidebar()

	-- Nothing to do if already closed or already closing
	if self._state == "CLOSED" or self._state == "CLOSING" then
		return
	end

	-- Cancel any queued show
	self._pendingShow = nil

	-- Remove the open-transition timer if it's still running
	timer.Remove( "MP.SidebarPresenter.OpenTx" )

	-- Unhook all events immediately
	self:ClearEvents()

	-- Start a new transaction
	self._transactionId = self._transactionId + 1
	local txId = self._transactionId

	-- If the panel reference is already dead, just clean up
	if not IsValid( self.Sidebar ) then
		self.Sidebar = nil
		self._state = "CLOSED"
		return
	end

	self._state = "CLOSING"

	-- Capture the panel in a LOCAL variable so the callback can never
	-- accidentally target a panel that was created after this call.
	local oldSidebar = self.Sidebar
	self.Sidebar = nil  -- Nil the reference immediately

	oldSidebar:SlideOut( function()
		-- If a newer transaction has started since we began closing,
		-- just make sure the old panel is gone and bail out.
		if self._transactionId ~= txId then
			if IsValid( oldSidebar ) then
				oldSidebar:Remove()
			end
			return
		end

		if IsValid( oldSidebar ) then
			oldSidebar:Remove()
		end

		self._state = "CLOSED"

		-- If a show was queued while we were closing, execute it now
		if self._pendingShow then
			local queuedMp = self._pendingShow
			self._pendingShow = nil
			self:ShowSidebar( queuedMp )
		end
	end )

end


--[[--------------------------------------------
	MediaPlayer library sidebar helpers
----------------------------------------------]]

function MediaPlayer.ShowSidebar( mp )

	--
	-- Find a valid media player to use for the sidebar
	--

	-- First check if we're looking at a media player
	if not mp then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) then
			mp = MediaPlayer.GetByObject( ent )
		end
	end

	-- Else, maybe the gamemode handles this some other way (location system, etc.)
	if not mp then
		mp = hook.Run( "GetMediaPlayer" )
	end

	-- If we still can't find a media player, give up..
	if not IsValid(mp) then return end

	SidebarPresenter:ShowSidebar( mp )

end

function MediaPlayer.HideSidebar()

	timer.Remove( "MP.SidebarPresenter.OpenTx" )
	SidebarPresenter:HideSidebar()

end

hook.Add( "OnContextMenuOpen", "MP.ShowSidebar", function()
	MediaPlayer.ShowSidebar()
end )
hook.Add( "OnContextMenuClose", "MP.HideSidebar", function()
	MediaPlayer.HideSidebar()
end )