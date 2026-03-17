TOOL.Category = "Media Player"
TOOL.Name = "#tool.mediaplayer_spatial.name"
TOOL.Command = nil
TOOL.ConfigName = ""

local function L( key, fallback )
	if not CLIENT then
		return fallback or key
	end

	local phrase = language.GetPhrase( key )

	if not phrase or phrase == key then
		return fallback or key
	end

	return phrase
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

	local function OpenAnchorRequest( ply, anchor )
		if not ( IsValid(ply) and IsValid(anchor) ) then return end
		MediaPlayer.OpenSpatialRequestFor( ply, anchor )
	end

	function TOOL:LeftClick( tr )
		if not IsUsableTarget( tr ) then return false end
		if CLIENT then return true end

		local ply = self:GetOwner()
		local anchor = FindExistingAnchor( ply, tr )

		if not IsValid(anchor) then
			anchor = CreateAnchor( ply, tr )
		end

		if not IsValid(anchor) then
			return false
		end

		OpenAnchorRequest( ply, anchor )
		return true
	end

	function TOOL:RightClick( tr )
		if not IsUsableTarget( tr ) then return false end
		if CLIENT then return true end

		local anchor = FindExistingAnchor( self:GetOwner(), tr )
		if not IsValid(anchor) then
			return false
		end

		anchor:Remove()
		return true
	end

	function TOOL:Reload( tr )
		if not IsUsableTarget( tr ) then return false end
		if CLIENT then return true end

		local anchor = FindExistingAnchor( self:GetOwner(), tr )
		if not IsValid(anchor) then
			return false
		end

		OpenAnchorRequest( self:GetOwner(), anchor )
		return true
	end
else
	function TOOL:LeftClick( tr )
		return IsUsableTarget( tr )
	end

	function TOOL:RightClick( tr )
		return IsUsableTarget( tr )
	end

	function TOOL:Reload( tr )
		return IsUsableTarget( tr )
	end
end

function TOOL.BuildCPanel( panel )
	panel:Help( L( "tool.mediaplayer_spatial.help_target", "Left click a prop, player, or NPC to make the audio follow it, or left click the world to pin the sound in place." ) )
	panel:Help( L( "tool.mediaplayer_spatial.help_popup", "The popup uses the normal MediaPlayer request browser. Set loop forever or choose how many extra loops to queue." ) )
	panel:Help( L( "tool.mediaplayer_spatial.help_remove", "Right click removes the matching spatial source. Reload reopens the request popup for an existing source." ) )

	panel:Help( " " )
	panel:Help( L( "tool.mediaplayer_spatial.section.client", "Client settings" ) )
	panel:Help( L( "tool.mediaplayer_spatial.section.client_desc", "These settings only affect your local game client." ) )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.debug", "Debug logging" ), "mediaplayer_debug" )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.resolution", "Browser resolution" ), "mediaplayer_resolution", 64, 2160, 0 )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.audio3d", "Enable 3D audio" ), "mediaplayer_3daudio" )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.volume", "Volume" ), "mediaplayer_volume", 0, 1, 2 )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.mute_unfocused", "Mute when Garry's Mod is unfocused" ), "mediaplayer_mute_unfocused" )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.draw_thumbnails", "Draw thumbnails" ), "mediaplayer_draw_thumbnails" )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.proximity_min", "Proximity minimum" ), "mediaplayer_proximity_min", 0, 25000, 0 )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.proximity_max", "Proximity maximum" ), "mediaplayer_proximity_max", 0, 50000, 0 )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.fullscreen", "Fullscreen (deprecated; unused)" ), "mediaplayer_fullscreen" )

	panel:Help( " " )
	panel:Help( L( "tool.mediaplayer_spatial.section.advanced", "Advanced settings" ) )
	panel:Help( L( "tool.mediaplayer_spatial.section.advanced_desc", "For debugging and legacy behavior." ) )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.js_console_filter", "JS console filter" ), "js_console_filter", 0, 1, 0 )
	panel:Help( L( "tool.mediaplayer_spatial.cvar.js_console_filter_desc", "0 = all HTML console messages, 1 = none." ) )

	panel:Help( " " )
	panel:Help( L( "tool.mediaplayer_spatial.section.shared", "Shared and server settings" ) )
	panel:Help( L( "tool.mediaplayer_spatial.section.shared_desc", "These settings may require admin privileges on multiplayer servers." ) )
	panel:CheckBox( L( "tool.mediaplayer_spatial.cvar.allow_webpages", "Allow webpage requests" ), "mediaplayer_allow_webpages" )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.queue_limit", "Queue limit" ), "mediaplayer_queue_limit", 1, 1024, 0 )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.hear_radius", "Spatial hear radius" ), "mediaplayer_spatial_hear_radius", 64, 50000, 0 )
	panel:NumSlider( L( "tool.mediaplayer_spatial.cvar.max_repeat_count", "Maximum extra loop count" ), "mediaplayer_spatial_max_repeat_count", 0, 1024, 0 )
end
