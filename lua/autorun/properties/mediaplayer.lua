--[[
	Adds a media player property.
	Blue icons correspond to admin actions.
--]]

local mp_order = 3200

local function AddMediaPlayerProperty(name, config)
	-- Assign incrementing order ID
	config.Order = mp_order
	mp_order = mp_order + 1

	properties.Add(name, config)
end

-- Validates the entity/player and enforces the CanProperty gamemode hook.
local function IsMediaPlayer(self, ent, ply)
	return IsValid(ent) and IsValid(ply) and
		IsValid(ent:GetMediaPlayer()) and
		gamemode.Call("CanProperty", ply, self.InternalName, ent)
end

local function HasMediaPlayerPrivilege(self, ent, ply, privilege)
	return IsMediaPlayer(self, ent, ply) and
		(ent:GetOwner() == ply or MediaPlayer.PlayerHasAnyPrivilege(ply, privilege))
end

local function HasMedia(mediaplayer)
	return mediaplayer:GetPlayerState() >= MP_STATE_PLAYING
end

AddMediaPlayerProperty("mp-pause", {
	MenuLabel = MediaPlayer.L("mp.property.pause"),
	MenuIcon = "icon16/control_pause_blue.png",

	Filter = function(self, ent, ply)
		if not IsMediaPlayer(self, ent, ply) then return end
		return ent:GetMediaPlayer():GetPlayerState() == MP_STATE_PLAYING
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
		MediaPlayer.Pause(ent)
	end
})

AddMediaPlayerProperty("mp-resume", {
	MenuLabel = MediaPlayer.L("mp.property.resume"),
	MenuIcon = "icon16/control_play_blue.png",

	Filter = function(self, ent, ply)
		if not IsMediaPlayer(self, ent, ply) then return end
		return ent:GetMediaPlayer():GetPlayerState() == MP_STATE_PAUSED
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
		MediaPlayer.Pause(ent)
	end
})

AddMediaPlayerProperty("mp-skip", {
	MenuLabel = MediaPlayer.L("mp.property.skip"),
	MenuIcon = "icon16/control_end_blue.png",

	Filter = function(self, ent, ply)
		if not HasMediaPlayerPrivilege(self, ent, ply, "MediaPlayer_Skip") then return end
		return HasMedia(ent:GetMediaPlayer())
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
		MediaPlayer.Skip(ent)
	end
})

AddMediaPlayerProperty("mp-seek", {
	MenuLabel = MediaPlayer.L("mp.property.seek"),
	MenuIcon = "icon16/control_fastforward_blue.png",

	Filter = function(self, ent, ply)
		if not HasMediaPlayerPrivilege(self, ent, ply, "MediaPlayer_Seek") then return end
		return HasMedia(ent:GetMediaPlayer())
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end

		Derma_StringRequest(
			MediaPlayer.L("mp.property.seek_title"),
			MediaPlayer.L("mp.property.seek_prompt"),
			"", -- Default text
			function(time)
				if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
				MediaPlayer.Seek(ent, time)
			end,
			function() end,
			MediaPlayer.L("mp.property.seek_confirm"),
			MediaPlayer.L("mp.property.seek_cancel")
		)
	end
})

AddMediaPlayerProperty("mp-request-url", {
	MenuLabel = MediaPlayer.L("mp.property.request_url"),
	MenuIcon = "icon16/link_add.png",

	Filter = function(self, ent, ply)
		return IsMediaPlayer(self, ent, ply)
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
		MediaPlayer.OpenRequestMenu(ent)
	end
})

AddMediaPlayerProperty("mp-copy-url", {
	MenuLabel = MediaPlayer.L("mp.property.copy_url"),
	MenuIcon = "icon16/paste_plain.png",

	Filter = function(self, ent, ply)
		if not IsMediaPlayer(self, ent, ply) then return end
		return HasMedia(ent:GetMediaPlayer())
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end

		local mp = ent:GetMediaPlayer()
		local media = mp and mp:CurrentMedia()
		if not IsValid(media) then return end

		SetClipboardText(media:Url())
		MediaPlayer.ChatSuccess(MediaPlayer.L("mp.success.url_copied"))
	end
})

AddMediaPlayerProperty("mp-fullscreen", {
	MenuLabel = MediaPlayer.L("mp.property.fullscreen"),
	MenuIcon = "icon16/arrow_out.png",

	Filter = function(self, ent, ply)
		return IsMediaPlayer(self, ent, ply)
	end,

	Action = function(self, ent)
		if not (IsValid(ent) and IsValid(ent:GetMediaPlayer())) then return end
		MediaPlayer.ToggleFullscreen(ent:GetMediaPlayer())
	end
})

AddMediaPlayerProperty("mp-enable", {
	MenuLabel = MediaPlayer.L("mp.property.turn_on"),
	MenuIcon = "icon16/lightbulb.png",

	Filter = function(self, ent, ply)
		return IsValid(ent) and IsValid(ply) and
			ent.IsMediaPlayerEntity and
			not IsValid(ent:GetMediaPlayer()) and
			gamemode.Call("CanProperty", ply, self.InternalName, ent)
	end,

	Action = function(self, ent)
		if not IsValid(ent) then return end
		MediaPlayer.RequestListen(ent)
	end
})

AddMediaPlayerProperty("mp-disable", {
	MenuLabel = MediaPlayer.L("mp.property.turn_off"),
	MenuIcon = "icon16/lightbulb_off.png",

	Filter = function(self, ent, ply)
		return IsValid(ent) and IsValid(ply) and
			ent.IsMediaPlayerEntity and
			IsValid(ent:GetMediaPlayer()) and
			gamemode.Call("CanProperty", ply, self.InternalName, ent)
	end,

	Action = function(self, ent)
		if not IsValid(ent) then return end
		MediaPlayer.RequestListen(ent)
	end
})
