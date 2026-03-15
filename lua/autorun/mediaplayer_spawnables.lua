local function AddMediaPlayerModel(classname, printname, model, icon, config)
	list.Set("SpawnableEntities", "mediaplayer_tv_" .. classname, {
		PrintName = printname,
		ClassName = "mediaplayer_tv",
		Category = "Media Player",
		DropToFloor = true,
		IconOverride = icon,
		KeyValues = {
			model = model
		}
	})

	list.Set("MediaPlayerModelConfigs", model, config)
end

if CLIENT then
	list.Set("ContentCategoryIcons", "Media Player", "icon16/monitor.png")
end

AddMediaPlayerModel(
	"huge_billboard",
	"Huge Billboard",
	"models/hunter/plates/plate5x8.mdl",
	"entities/mediaplayer_tv2.png",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-118.8, 189.8, 2.5),
		width = 380,
		height = 238
	}
)

AddMediaPlayerModel(
	"small_tv",
	"Small TV",
	"models/props_phx/rt_screen.mdl",
	"entities/mediaplayer_tv3.png",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(6.5, 27.9, 35.3),
		width = 56,
		height = 33
	}
)

if SERVER then
	-- Fix for media player owner not getting set on alternate model spawn
	hook.Add("PlayerSpawnedSENT", "MediaPlayer_SetOwner", function(ply, ent)
		if not ent.IsMediaPlayerEntity then return end
		ent:SetCreator(ply)

		local mediaplayer = ent:GetMediaPlayer()
		mediaplayer:SetOwner(ply)
	end)
end
