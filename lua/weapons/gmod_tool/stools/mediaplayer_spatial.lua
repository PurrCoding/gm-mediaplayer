TOOL.Category = "Media Player"
TOOL.Name = "#tool.mediaplayer_spatial.name"
TOOL.Command = nil
TOOL.ConfigName = ""

-- Bridge tool header strings from i18n into GMod's language system
if CLIENT then
	language.Add( "tool.mediaplayer_spatial.name", MediaPlayer.L("mp.tool.spatial.name") )
	language.Add( "tool.mediaplayer_spatial.desc", MediaPlayer.L("mp.tool.spatial.desc") )
	language.Add( "tool.mediaplayer_spatial.0", MediaPlayer.L("mp.tool.spatial.usage") )
end

local WORLD_MATCH_RADIUS = 96

local function IsUsableTarget( tr )
	if not tr or not tr.Hit then
		return false
	end

	local ent = tr.Entity
	if not IsValid(ent) or ent:IsWorld() then
		return false
	end

	if ent:IsPlayer() or ent:IsNPC() then return false end
	if ent:IsRagdoll() then return false end
	if ent.IsMediaPlayerEntity then return false end

	return true
end

if SERVER then
	local function CanControlAnchor( ply, anchor )
		if not ( IsValid(ply) and IsValid(anchor) ) then return false end
		if anchor:GetClass() ~= "mediaplayer_spatial_anchor" then return false end

		local mp = anchor:GetMediaPlayer()
		return IsValid(mp) and mp:IsPlayerPrivileged( ply )
	end

	local function FindExistingAnchor( ply, tr )
		local hitPos = tr.HitPos
		local target = ( IsValid(tr.Entity) and not tr.Entity:IsWorld() ) and tr.Entity or nil

		for _, anchor in ipairs( ents.FindByClass("mediaplayer_spatial_anchor") ) do
			if not CanControlAnchor( ply, anchor ) then
				continue
			end

			local parent = anchor:GetParent()

			if IsValid(target) then
				if parent == target then
					return anchor
				end
			elseif not IsValid(parent) and anchor:GetPos():DistToSqr( hitPos ) <= ( WORLD_MATCH_RADIUS * WORLD_MATCH_RADIUS ) then
				return anchor
			end
		end

		return nil
	end

	local function CreateAnchor( ply, tr )
		local anchor = ents.Create( "mediaplayer_spatial_anchor" )
		if not IsValid(anchor) then
			return nil
		end

		local target = ( IsValid(tr.Entity) and not tr.Entity:IsWorld() ) and tr.Entity or nil
		local pos = IsValid(target) and target:GetPos() or tr.HitPos

		anchor:SetPos( pos )
		anchor:SetAngles( Angle(0, 0, 0) )
		anchor:SetCreator( ply )
		anchor:Spawn()
		anchor:Activate()

		local mp = anchor:GetMediaPlayer()
		if IsValid(mp) then
			mp:SetOwner( ply )
			mp:AddListener( ply )
		end

		if IsValid(target) then
			anchor:SetParent( target )
			target:DeleteOnRemove( anchor )
		end

		undo.Create( MediaPlayer.L("mp.tool.spatial.undo") )
			undo.SetPlayer( ply )
			undo.AddEntity( anchor )
		undo.Finish()

		cleanup.Add( ply, "mediaplayer_spatial_anchor", anchor )

		return anchor
	end

	function TOOL:LeftClick( tr )
		if not IsUsableTarget( tr ) then return false end

		local ply = self:GetOwner()
		local anchor = FindExistingAnchor( ply, tr )

		if IsValid(anchor) then
			return false
		end

		anchor = CreateAnchor( ply, tr )
		if IsValid( anchor ) then
			ply:ChatPrint( MediaPlayer.L("mp.tool.spatial.hint_press_c") )
			return true
		end

		return false
	end

	function TOOL:RightClick( tr )
		if not IsUsableTarget( tr ) then return false end

		local anchor = FindExistingAnchor( self:GetOwner(), tr )
		if not IsValid(anchor) then
			return false
		end

		anchor:Remove()
		return true
	end
else -- CLIENT
	function TOOL:LeftClick( tr )
		return IsUsableTarget( tr )
	end

	function TOOL:RightClick( tr )
		return IsUsableTarget( tr )
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

	local HALO_COLOR = Color( 0, 180, 255, 255 )
	local LABEL_COLOR = Color( 255, 255, 255, 255 )
	local LABEL_BG = Color( 0, 0, 0, 200 )

	local cachedFrame = 0
	local cachedHalos = {}
	local cachedLabels = {}

	local function UpdateTargets()
		local frame = FrameNumber()
		if frame == cachedFrame then return end
		cachedFrame = frame

		local ply = LocalPlayer()
		local plyPos = ply:GetPos()
		local cvar = GetConVar( "mediaplayer_spatial_hear_radius" )
		local radius = cvar and cvar:GetFloat() or 1800
		local radiusSqr = radius * radius

		local halos = {}
		local labels = {}

		for _, anchor in ipairs( ents.FindByClass( "mediaplayer_spatial_anchor" ) ) do
			if not IsValid( anchor ) then continue end

			local parent = anchor:GetParent()

			if IsValid( parent ) then
				local pos = parent:GetPos()
				if plyPos:DistToSqr( pos ) <= radiusSqr then
					halos[#halos + 1] = parent
					labels[#labels + 1] = pos + Vector( 0, 0, parent:OBBMaxs().z + 15 )
				end
			else
				local pos = anchor:GetPos()
				if plyPos:DistToSqr( pos ) <= radiusSqr then
					labels[#labels + 1] = pos + Vector( 0, 0, 15 )
				end
			end
		end

		cachedHalos = halos
		cachedLabels = labels
	end

	local function SpatialToolHalo()
		UpdateTargets()

		if #cachedHalos > 0 then
			halo.Add( cachedHalos, HALO_COLOR, 3, 3, 3 )
		end
	end

	local function SpatialToolLabels( depth, skybox, skybox3d )
		if skybox or skybox3d then return end

		UpdateTargets()

		if #cachedLabels == 0 then return end

		local billboardAng = Angle( 0, EyeAngles().y - 90, 90 )
		local text = MediaPlayer.L( "mp.tool.spatial.label" )

		for i = 1, #cachedLabels do
			cam_Start3D2D( cachedLabels[i], billboardAng, 0.15 )
				surface_SetFont( "DermaLarge" )
				local tw, th = surface_GetTextSize( text )
				surface_SetDrawColor( LABEL_BG )
				surface_DrawRect( -tw / 2 - 8, -th / 2 - 4, tw + 16, th + 8 )
				draw_SimpleText( text, "DermaLarge", 0, 0, LABEL_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			cam_End3D2D()
		end
	end

	function TOOL:Deploy()
		hook.Add( "PreDrawHalos", "MP.SpatialTool.Halo", SpatialToolHalo )
		hook.Add( "PostDrawTranslucentRenderables", "MP.SpatialTool.Labels", SpatialToolLabels )
	end

	function TOOL:Holster()
		hook.Remove( "PreDrawHalos", "MP.SpatialTool.Halo" )
		hook.Remove( "PostDrawTranslucentRenderables", "MP.SpatialTool.Labels" )
	end
end

function TOOL.BuildCPanel( panel )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_place") )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_remove") )
	panel:Help( "" )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_sidebar") )
end