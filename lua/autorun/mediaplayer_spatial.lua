if SERVER then
	AddCSLuaFile()
	util.AddNetworkString( "MEDIAPLAYER.SpatialOpenRequest" )
	util.AddNetworkString( "MEDIAPLAYER.SpatialRequestMedia" )

	function MediaPlayer.OpenSpatialRequestFor( ply, anchor )
		if not ( IsValid(ply) and IsValid(anchor) ) then return end
		if anchor:GetClass() ~= "mediaplayer_spatial_anchor" then return end

		local mp = anchor:GetMediaPlayer()
		if IsValid(mp) then
			if not mp:HasListener(ply) then
				mp:AddListener( ply )
			else
				mp:BroadcastUpdate( ply )
			end
		end

		net.Start( "MEDIAPLAYER.SpatialOpenRequest" )
			net.WriteUInt( anchor:EntIndex(), 16 )
			net.WriteString( anchor:GetMediaPlayerID() or "" )
		net.Send( ply )
	end

	net.Receive( "MEDIAPLAYER.SpatialRequestMedia", function( len, ply )
		local anchor = net.ReadEntity()
		local url = net.ReadString()
		local loopForever = net.ReadBool()
		local loopCount = net.ReadUInt( 16 )

		if not ( IsValid(anchor) and anchor:GetClass() == "mediaplayer_spatial_anchor" ) then
			return
		end

		local mp = anchor:GetMediaPlayer()
		if not IsValid(mp) or mp:GetType() ~= "spatial" then
			return
		end

		if not mp:IsPlayerPrivileged(ply) then
			mp:NotifyPlayer( ply, "You don't have permission to control this spatial media source." )
			return
		end

		local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()

		if not MediaPlayer.ValidUrl( url ) and not allowWebpage then
			mp:NotifyPlayer( ply, "The requested URL was invalid." )
			return
		end

		local media = MediaPlayer.GetMediaForUrl( url, allowWebpage )
		media:NetReadRequest()

		mp:RequestSpatialMedia( media, ply, loopForever, loopCount )
	end )

	return
end

local function SpatialPhrase( key, fallback, ... )
	local phrase = language.GetPhrase( key )

	if not phrase or phrase == key then
		phrase = fallback or key
	end

	if select( "#", ... ) > 0 then
		return string.format( phrase, ... )
	end

	return phrase
end

local LastLoopForever = false
local LastLoopCount = 0

function MediaPlayer.RequestSpatial( anchor, url, loopForever, loopCount )
	if not IsValid(anchor) then
		LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_anchor_missing", "The selected spatial media anchor no longer exists." ) )
		return false
	end

	url = string.Trim( tostring(url or "") )
	if url == "" then
		LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_empty_url", "Please enter a media URL first." ) )
		return false
	end

	local allowWebpage = MediaPlayer.Cvars.AllowWebpages:GetBool()

	if not MediaPlayer.ValidUrl( url ) and not allowWebpage then
		LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_invalid_url", "The requested URL was invalid." ) )
		return false
	end

	local media = MediaPlayer.GetMediaForUrl( url, allowWebpage )

	local function request( err )
		if err then
			LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_request_failed", "Request failed: %s", err ) )
			return
		end

		if not IsValid(anchor) then
			LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_anchor_missing", "The selected spatial media anchor no longer exists." ) )
			return
		end

		LastLoopForever = tobool(loopForever)
		LastLoopCount = math.max( 0, math.floor( tonumber(loopCount) or 0 ) )

		net.Start( "MEDIAPLAYER.SpatialRequestMedia" )
			net.WriteEntity( anchor )
			net.WriteString( url )
			net.WriteBool( LastLoopForever )
			net.WriteUInt( math.Clamp( LastLoopCount, 0, 65535 ), 16 )
			media:NetWriteRequest()
		net.SendToServer()

		if MediaPlayer.DEBUG then
			print( "MEDIAPLAYER.SpatialRequestMedia sent to server", url )
		end
	end

	if media.PrefetchMetadata and isfunction(media.PreRequest) then
		media:PreRequest( request )
	else
		request()
	end

	return true
end

local function EnsureSpatialMediaPlayer( anchor, mpId )
	if not IsValid(anchor) then return nil end

	local mp = anchor:GetMediaPlayer()
	if IsValid(mp) then return mp end

	mpId = mpId or anchor:GetMediaPlayerID()
	if not mpId or mpId == "" then return nil end

	mp = MediaPlayer.GetById( mpId )

	if not mp then
		mp = MediaPlayer.Create( mpId, "spatial" )
	end

	if anchor._mp ~= mp then
		anchor:InstallMediaPlayer( mp, mpId )
	end

	return mp
end

local PANEL = {}
PANEL.HistoryWidth = 300
PANEL.BackgroundColor = Color(22, 22, 22)

AccessorFunc( PANEL, "m_MediaPlayer", "MediaPlayer" )
AccessorFunc( PANEL, "m_AnchorEntity", "AnchorEntity" )

function PANEL:Init()
	self:SetPaintBackgroundEnabled( true )
	self:SetFocusTopLevel( true )

	local w = math.Clamp( ScrW() - 100, 800, 1152 + self.HistoryWidth )
	local h = ScrH()
	if h > 800 then
		h = h * 3 / 4
	elseif h > 600 then
		h = h * 7 / 8
	end
	self:SetSize( w, h )

	self.CloseButton = vgui.Create( "DIconButton", self )
	self.CloseButton:SetSize( 32, 32 )
	self.CloseButton:SetIcon( "mp-close" )
	self.CloseButton:SetColor( Color( 250, 250, 250, 200 ) )
	self.CloseButton:SetZPos( 5 )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function()
		self:Close()
	end

	self.BrowserContainer = vgui.Create( "DPanel", self )
	self.BrowserContainer:Dock( FILL )

	self.Footer = vgui.Create( "DPanel", self )
	self.Footer:Dock( BOTTOM )
	self.Footer:SetTall( 64 )
	self.Footer:DockPadding( 12, 10, 12, 10 )
	self.Footer.Paint = function( pnl, w, h )
		surface.SetDrawColor( 28, 28, 28, 255 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.LoopForever = vgui.Create( "DCheckBoxLabel", self.Footer )
	self.LoopForever:Dock( LEFT )
	self.LoopForever:SetWide( 150 )
	self.LoopForever:SetText( SpatialPhrase( "mediaplayer.spatial.loop_forever", "Loop forever" ) )
	self.LoopForever:SizeToContents()
	self.LoopForever:DockMargin( 0, 0, 18, 0 )
	self.LoopForever.OnChange = function( _, value )
		if IsValid(self.LoopCount) then
			self.LoopCount:SetEnabled( not value )
		end
	end

	self.LoopCountLabel = vgui.Create( "DLabel", self.Footer )
	self.LoopCountLabel:Dock( LEFT )
	self.LoopCountLabel:SetText( SpatialPhrase( "mediaplayer.spatial.extra_loops", "Extra loops" ) )
	self.LoopCountLabel:SetTextColor( color_white )
	self.LoopCountLabel:SizeToContents()
	self.LoopCountLabel:DockMargin( 0, 2, 8, 0 )

	self.LoopCount = vgui.Create( "DNumberWang", self.Footer )
	self.LoopCount:Dock( LEFT )
	self.LoopCount:SetWide( 64 )
	self.LoopCount:SetMinMax( 0, 99 )
	self.LoopCount:SetDecimals( 0 )
	self.LoopCount:SetValue( 0 )

	self.FooterHint = vgui.Create( "DLabel", self.Footer )
	self.FooterHint:Dock( FILL )
	self.FooterHint:SetText( SpatialPhrase( "mediaplayer.spatial.footer_hint", "The link uses the normal MediaPlayer request page. Finite loops are counted after the first play." ) )
	self.FooterHint:SetTextColor( Color( 200, 200, 200 ) )
	self.FooterHint:DockMargin( 16, 2, 0, 0 )
	self.FooterHint:SetWrap( true )
	self.FooterHint:SetAutoStretchVertical( true )

	self.Browser = vgui.Create( "DMediaPlayerHTML", self.BrowserContainer )
	self.Browser:Dock( FILL )

	self.Browser:AddFunction( "gmod", "requestUrl", function (url)
		self:SubmitSpatialRequest( url )
	end )

	self.Browser:AddFunction( "gmod", "openUrl", function (url)
		gui.OpenURL( url )
	end )

	self.Browser:AddFunction( "gmod", "getServices", function ()
		local mp = self:GetMediaPlayer()

		if mp then
			self:SendServices( mp )
		end
	end )

	local requestUrl = MediaPlayer.GetConfigValue( "request.url" )
	self.Browser:OpenURL( requestUrl )

	self.Controls = vgui.Create( "MPHTMLControls", self.BrowserContainer )
	self.Controls:Dock( TOP )
	self.Controls:DockPadding( 0, 0, 32, 0 )
	self.Controls:SetHTML( self.Browser )
	self.Controls.BorderSize = 0
	self.Controls.RequestButton.DoClick = function()
		self:SubmitSpatialRequest( self.Browser:GetURL() )
	end

	hook.Add( "GUIMousePressed", self, self.OnGUIMousePressed )
	hook.Add( "VGUIMousePressed", self.Browser, self.OnVGUIMousePressed )
end

local function GetServiceIDs( mp )
	local serviceIDs = mp:GetSupportedServiceIDs()
	return table.concat( serviceIDs, "," )
end

function PANEL:SendServices( mp )
	local js = "if (typeof window.setServices === 'function') { setServices('%s'); }"
	js = js:format( GetServiceIDs(mp) )

	self.Browser:RunJavascript( js )
	self.Browser:QueueJavascript( js )
end

function PANEL:SetMediaPlayer( mp )
	self.m_MediaPlayer = mp
	self:SendServices( mp )
end

function PANEL:SetAnchorEntity( anchor )
	self.m_AnchorEntity = anchor

	local loopForever = LastLoopForever
	local loopCount = LastLoopCount

	if IsValid(anchor) then
		loopForever = anchor:GetLoopForever()
		loopCount = anchor:GetLoopCount()
	end

	self.LoopForever:SetChecked( loopForever )
	self.LoopCount:SetValue( math.max( 0, loopCount or 0 ) )
	self.LoopCount:SetEnabled( not loopForever )
end

function PANEL:SubmitSpatialRequest( url )
	local anchor = self:GetAnchorEntity()
	if not IsValid(anchor) then
		LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_anchor_missing", "The selected spatial media anchor no longer exists." ) )
		self:Close()
		return
	end

	local loopForever = self.LoopForever:GetChecked()
	local loopCount = math.max( 0, math.floor( tonumber(self.LoopCount:GetValue()) or 0 ) )

	if loopForever then
		loopCount = 0
	end

	if MediaPlayer.RequestSpatial( anchor, url, loopForever, loopCount ) then
		self:Close()
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( self.BackgroundColor )
	surface.DrawRect( 0, 0, w, h )
	return true
end

function PANEL:OnRemove()
	hook.Remove( "GUIMousePressed", self )
	hook.Remove( "VGUIMousePressed", self.Browser )
end

function PANEL:Close()
	if IsValid(self.Browser) then
		self.Browser:Remove()
	end

	self:OnClose()
	self:Remove()
end

function PANEL:OnClose()
end

function PANEL:CheckClose()
	local x, y = self:CursorPos()

	if not (gui.IsGameUIVisible() or gui.IsConsoleVisible()) and
		( x < 0 or x > self:GetWide() or y < 0 or y > self:GetTall() ) then
		self:Close()
	end
end

function PANEL:PerformLayout( w, h )
	self.CloseButton:SetPos( w - 36, 2 )
end

function PANEL:OnGUIMousePressed( key )
	if key == MOUSE_LEFT then
		self:CheckClose()
	end
end

function PANEL:OnVGUIMousePressed( pnl, key )
	if not IsValid(pnl) then return end

	if key == MOUSE_4 then
		pnl:RunJavascript( "history.back();" )
	end

	if key == MOUSE_5 then
		pnl:RunJavascript( "history.forward();" )
	end
end

vgui.Register( "MPSpatialRequestFrame", PANEL, "EditablePanel" )

function MediaPlayer.OpenSpatialRequestMenu( anchor, mpId )
	if IsValid(MediaPlayer._SpatialRequestMenu) then
		MediaPlayer._SpatialRequestMenu:Close()
	end

	local mp = EnsureSpatialMediaPlayer( anchor, mpId )
	if not mp then
		Error( "MediaPlayer.OpenSpatialRequestMenu: Invalid spatial media player.\n" )
		return
	end

	local req = vgui.Create( "MPSpatialRequestFrame" )
	req:SetMediaPlayer( mp )
	req:SetAnchorEntity( anchor )
	req:MakePopup()
	req:Center()

	req.OnClose = function()
		MediaPlayer._SpatialRequestMenu = nil
	end

	MediaPlayer._SpatialRequestMenu = req
end

net.Receive( "MEDIAPLAYER.SpatialOpenRequest", function()
	local entIndex = net.ReadUInt( 16 )
	local mpId = net.ReadString()

	local function tryOpen( attemptsLeft )
		local anchor = Entity( entIndex )
		if IsValid(anchor) and anchor:GetClass() == "mediaplayer_spatial_anchor" then
			MediaPlayer.OpenSpatialRequestMenu( anchor, mpId )
			return
		end

		if attemptsLeft <= 0 then
			LocalPlayer():ChatPrint( SpatialPhrase( "mediaplayer.spatial.error_anchor_network", "Could not open the spatial media request window because the anchor did not finish networking in time." ) )
			return
		end

		timer.Simple( 0.1, function()
			tryOpen( attemptsLeft - 1 )
		end )
	end

	tryOpen( 20 )
end )
