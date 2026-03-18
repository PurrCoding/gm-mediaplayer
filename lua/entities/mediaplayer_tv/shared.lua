AddCSLuaFile()

DEFINE_BASECLASS( "mediaplayer_base" )

ENT.PrintName 		= "Big Screen TV"
ENT.Author 			= "Samuel Maddock"
ENT.Instructions 	= "Right click on the TV to see available Media Player options. Alternatively, press E on the TV to turn it on."
ENT.Category 		= "Media Player"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.Spawnable = true

ENT.Model = Model( "models/gmod_tower/suitetv_large.mdl" )

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle(-90, 90, 0),
	offset = Vector(6, 59.49, 103.65),
	width = 119,
	height = 69
} )

function ENT:SetupDataTables()
	BaseClass.SetupDataTables( self )
end

if SERVER then

	function ENT:SetupMediaPlayer( mp )
		mp:on("mediaChanged", function(media) self:OnMediaChanged(media) end)
	end

	function ENT:OnMediaChanged( media )
		-- empty
	end

else -- CLIENT

	local draw_SimpleText = draw.SimpleText
	local surface_SetDrawColor = surface.SetDrawColor
	local surface_SetMaterial = surface.SetMaterial
	local surface_DrawTexturedRect = surface.DrawTexturedRect
	local surface_SetFont = surface.SetFont
	local surface_GetTextSize = surface.GetTextSize
	local math_max = math.max
	local Start3D2D = cam.Start3D2D
	local End3D2D = cam.End3D2D

	local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
	local color_white = color_white

	local StaticMaterial = Material( "mediaplayer/static" )
	local TextScale = 700
	local TextPadding = 40

	function ENT:Draw()
		self:DrawModel()

		local mp = self:GetMediaPlayer()

		if not mp then
			self:DrawMediaPlayerOff()
		end
	end

	function ENT:DrawMediaPlayerOff()
		local w, h, pos, ang = self:GetMediaPlayerPosition()

		Start3D2D( pos, ang, 1 )
			surface_SetDrawColor( color_white )
			surface_SetMaterial( StaticMaterial )
			surface_DrawTexturedRect( 0, 0, w, h )
		End3D2D()

		local info = MediaPlayer.L("mp.idle.press_e")

		surface_SetFont( "MediaTitle" )
		local textW = surface_GetTextSize( info )
		local effectiveScale = math_max( TextScale, textW + TextPadding * 2 )

		local scale = w / effectiveScale
		Start3D2D( pos, ang, scale )
			local tw, th = w / scale, h / scale
			draw_SimpleText( info, "MediaTitle",
				tw / 2, th / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		End3D2D()
	end

end
