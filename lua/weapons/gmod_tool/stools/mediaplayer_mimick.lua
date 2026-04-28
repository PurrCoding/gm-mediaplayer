TOOL.Category = "Media Player"
TOOL.Name = "#tool.mediaplayer_mimick.name"
TOOL.Command = nil
TOOL.ConfigName = ""

if CLIENT then
	language.Add( "tool.mediaplayer_mimick.name", MediaPlayer.L("mp.tool.mimick.name") )
	language.Add( "tool.mediaplayer_mimick.desc", MediaPlayer.L("mp.tool.mimick.desc") )
	language.Add( "tool.mediaplayer_mimick.0", MediaPlayer.L("mp.tool.mimick.usage") )
end

---
-- Checks if the trace hit a valid media player entity (not spatial, not world).
--
local function IsMediaPlayerTarget( tr )
	if not tr or not tr.Hit then return false end

	local ent = tr.Entity
	if not IsValid( ent ) or ent:IsWorld() then return false end
	if not ent.IsMediaPlayerEntity then return false end

	-- Reject spatial anchors
	if ent:GetClass() == "mediaplayer_spatial_anchor" then return false end

	return true
end

if SERVER then

	---
	-- Left click = COPY (select source media player to mirror from).
	--
	function TOOL:LeftClick( tr )
		if not IsMediaPlayerTarget( tr ) then return false end

		local ply = self:GetOwner()
		local ent = tr.Entity
		local mp = ent:GetMediaPlayer()

		if not mp or not mp:IsValid() then return false end

		-- Reject spatial type
		if mp:GetType() == "spatial" then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_spatial") )
			return false
		end

		-- Reject mimick type as source — must copy from a real player
		if mp:GetType() == "mimick" then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_mimick_source") )
			return false
		end

		-- Store the source entity and its MP ID
		ply:SetNWInt( "MimickTool_SourceEnt", ent:EntIndex() )
		ply:SetNWString( "MimickTool_SourceMPId", mp:GetId() )
		ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.source_copied") )

		return true
	end

	---
	-- Right click = PASTE (apply mimick to the targeted entity).
	-- Can be used on multiple entities without re-selecting the source.
	--
	function TOOL:RightClick( tr )
		if not IsMediaPlayerTarget( tr ) then return false end

		local ply = self:GetOwner()
		local ent = tr.Entity

		-- Check we have a source copied
		local sourceMPId = ply:GetNWString( "MimickTool_SourceMPId", "" )
		local sourceEntIndex = ply:GetNWInt( "MimickTool_SourceEnt", 0 )

		if sourceMPId == "" or sourceEntIndex == 0 then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_no_source") )
			return false
		end

		-- Validate source still exists
		local sourceEnt = Entity( sourceEntIndex )
		if not IsValid( sourceEnt ) then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_source_gone") )
			return false
		end

		local sourceMP = sourceEnt:GetMediaPlayer()
		if not sourceMP or not sourceMP:IsValid() then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_source_gone") )
			return false
		end

		-- Can't mimick onto the same entity
		if ent == sourceEnt then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_same") )
			return false
		end

		local mp = ent:GetMediaPlayer()
		if not mp or not mp:IsValid() then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_not_mp") )
			return false
		end

		-- Reject spatial
		if mp:GetType() == "spatial" then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_spatial") )
			return false
		end

		-- NEW: Reject if target is already serving its own content
		if mp:GetPlayerState() >= MP_STATE_PLAYING or not mp:IsQueueEmpty() then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_has_content") )
			return false
		end

		-- Already a mimick linked to the same source?
		if mp:GetType() == "mimick" and mp:GetSourceId() == sourceMPId then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_already_linked") )
			return false
		end

		-- Save old state for undo/restore
		local oldType = mp:GetType()
		local oldSnapshot = mp:GetSnapshot()
		local oldListeners = table.Copy( mp:GetListeners() )

		-- Remove old media player
		mp:Remove()

		-- Install mimick
		ent:InstallMediaPlayer( "mimick" )
		local newMP = ent:GetMediaPlayer()

		if not newMP then
			-- Fallback: restore original
			ent:InstallMediaPlayer( oldType )
			local restored = ent:GetMediaPlayer()
			if restored then
				restored:RestoreSnapshot( oldSnapshot )
				restored:SetListeners( oldListeners )
			end
			return false
		end

		newMP:SetSourceId( sourceMPId )
		newMP:AddListener( ply )

		-- Store old state on entity for restore
		ent._mimickOldType = oldType
		ent._mimickOldSnapshot = oldSnapshot

		undo.Create( MediaPlayer.L("mp.tool.mimick.undo") )
			undo.SetPlayer( ply )
			undo.AddFunction( function( tab, ent )
				if not IsValid( ent ) then return end
				local m = ent:GetMediaPlayer()
				if not m or m:GetType() ~= "mimick" then return end

				local oType = ent._mimickOldType or "entity"
				local oSnap = ent._mimickOldSnapshot

				m:Remove()
				ent:InstallMediaPlayer( oType )

				local r = ent:GetMediaPlayer()
				if r and oSnap then
					r:RestoreSnapshot( oSnap )
				end
			end, ent )
		undo.Finish()

		ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.pasted") )
		return true
	end

	---
	-- Reload (R) = REMOVE mimick from the targeted entity and restore original.
	--
	function TOOL:Reload( tr )
		if not IsMediaPlayerTarget( tr ) then return false end

		local ply = self:GetOwner()
		local ent = tr.Entity
		local mp = ent:GetMediaPlayer()

		if not mp or not mp:IsValid() or mp:GetType() ~= "mimick" then
			ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.error_not_mimick") )
			return false
		end

		-- Restore original player type
		local oldType = ent._mimickOldType or "entity"
		local oldSnapshot = ent._mimickOldSnapshot

		mp:Remove()
		ent:InstallMediaPlayer( oldType )

		if oldSnapshot then
			local restored = ent:GetMediaPlayer()
			if restored then
				restored:RestoreSnapshot( oldSnapshot )
			end
		end

		ent._mimickOldType = nil
		ent._mimickOldSnapshot = nil

		ply:ChatPrint( MediaPlayer.L("mp.tool.mimick.removed") )
		return true
	end

	function TOOL:Holster()
		-- NWInt/NWString source selection intentionally persists across
		-- tool switches so you can paste onto multiple targets.
	end

else -- CLIENT

	function TOOL:LeftClick( tr )
		return IsMediaPlayerTarget( tr )
	end

	function TOOL:RightClick( tr )
		return IsMediaPlayerTarget( tr )
	end

	function TOOL:Reload( tr )
		return IsMediaPlayerTarget( tr )
	end

	-- Localized rendering functions
	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local surface_SetFont = surface.SetFont
	local surface_GetTextSize = surface.GetTextSize
	local surface_SetDrawColor = surface.SetDrawColor
	local surface_DrawRect = surface.DrawRect
	local draw_SimpleText = draw.SimpleText
	local EyeAngles = EyeAngles
	local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

	local HALO_SOURCE_COLOR = Color( 0, 200, 0, 255 )
	local HALO_MIMICK_COLOR = Color( 255, 140, 0, 255 )
	local LABEL_COLOR = Color( 255, 255, 255, 255 )
	local LABEL_BG = Color( 0, 0, 0, 200 )

	local cachedFrame = 0
	local cachedSourceHalos = {}
	local cachedMimickHalos = {}
	local cachedLabels = {}

	local function UpdateTargets()
		local frame = FrameNumber()
		if frame == cachedFrame then return end
		cachedFrame = frame

		local ply = LocalPlayer()
		local plyPos = ply:GetPos()
		local radiusSqr = 2500 * 2500

		local sourceHalos = {}
		local mimickHalos = {}
		local labels = {}

		-- Highlight the currently copied source entity
		local sourceEntIndex = ply:GetNWInt( "MimickTool_SourceEnt", 0 )
		if sourceEntIndex > 0 then
			local sourceEnt = Entity( sourceEntIndex )
			if IsValid( sourceEnt ) and plyPos:DistToSqr( sourceEnt:GetPos() ) <= radiusSqr then
				sourceHalos[#sourceHalos + 1] = sourceEnt
				labels[#labels + 1] = {
					pos = sourceEnt:GetPos() + Vector( 0, 0, sourceEnt:OBBMaxs().z + 15 ),
					text = "SOURCE"
				}
			end
		end

		-- Highlight all mimick players
		for _, mp in pairs( MediaPlayer.List ) do
			if mp:GetType() == "mimick" and mp.GetEntity then
				local ent = mp:GetEntity()
				if IsValid( ent ) and plyPos:DistToSqr( ent:GetPos() ) <= radiusSqr then
					mimickHalos[#mimickHalos + 1] = ent
					labels[#labels + 1] = {
						pos = ent:GetPos() + Vector( 0, 0, ent:OBBMaxs().z + 15 ),
						text = "MIMICK"
					}
				end
			end
		end

		cachedSourceHalos = sourceHalos
		cachedMimickHalos = mimickHalos
		cachedLabels = labels
	end

	local function MimickToolHalo()
		UpdateTargets()

		if #cachedSourceHalos > 0 then
			halo.Add( cachedSourceHalos, HALO_SOURCE_COLOR, 3, 3, 3 )
		end
		if #cachedMimickHalos > 0 then
			halo.Add( cachedMimickHalos, HALO_MIMICK_COLOR, 3, 3, 3 )
		end
	end

	local function MimickToolLabels( depth, skybox, skybox3d )
		if skybox or skybox3d then return end

		UpdateTargets()

		if #cachedLabels == 0 then return end

		local billboardAng = Angle( 0, EyeAngles().y - 90, 90 )

		for i = 1, #cachedLabels do
			local info = cachedLabels[i]
			cam_Start3D2D( info.pos, billboardAng, 0.15 )
				surface_SetFont( "DermaLarge" )
				local tw, th = surface_GetTextSize( info.text )
				surface_SetDrawColor( LABEL_BG )
				surface_DrawRect( -tw / 2 - 8, -th / 2 - 4, tw + 16, th + 8 )
				draw_SimpleText( info.text, "DermaLarge", 0, 0, LABEL_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			cam_End3D2D()
		end
	end

	function TOOL:Think()
		if not self._hooksActive then
			hook.Add( "PreDrawHalos", "MP.MimickTool.Halo", MimickToolHalo )
			hook.Add( "PostDrawTranslucentRenderables", "MP.MimickTool.Labels", MimickToolLabels )
			self._hooksActive = true
		end
	end

	function TOOL:Deploy()
		hook.Add( "PreDrawHalos", "MP.MimickTool.Halo", MimickToolHalo )
		hook.Add( "PostDrawTranslucentRenderables", "MP.MimickTool.Labels", MimickToolLabels )
		self._hooksActive = true
	end

	function TOOL:Holster()
		hook.Remove( "PreDrawHalos", "MP.MimickTool.Halo" )
		hook.Remove( "PostDrawTranslucentRenderables", "MP.MimickTool.Labels" )
		self._hooksActive = false
	end
end

function TOOL.BuildCPanel( panel )
	panel:Help( MediaPlayer.L("mp.tool.mimick.help_copy") )
	panel:Help( MediaPlayer.L("mp.tool.mimick.help_paste") )
	panel:Help( "" )
	panel:Help( MediaPlayer.L("mp.tool.mimick.help_remove") )
end