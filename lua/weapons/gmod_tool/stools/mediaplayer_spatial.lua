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

	if IsValid(tr.Entity) and tr.Entity:GetClass() == "mediaplayer_spatial_anchor" then
		return false
	end

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

		undo.Create( "Spatial Media Source" )
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

		return IsValid( CreateAnchor( ply, tr ) )
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
else
	function TOOL:LeftClick( tr )
		return IsUsableTarget( tr )
	end

	function TOOL:RightClick( tr )
		return IsUsableTarget( tr )
	end
end

function TOOL.BuildCPanel( panel )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_place") )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_remove") )
	panel:Help( "" )
	panel:Help( MediaPlayer.L("mp.tool.spatial.help_sidebar") )
end