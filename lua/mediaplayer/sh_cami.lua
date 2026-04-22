-- CAMI (Common Admin Mod Interface) integration for MediaPlayer
-- Provides granular privilege control via admin mods (ULX, SAM, ServerGuard, etc.)

local privileges = {
	{
		Name = "MediaPlayer_Admin",
		MinAccess = "admin",
		Description = "Full admin control over any media player (skip, seek, pause, remove, repeat, shuffle, lock, bypass whitelist)"
	},
	{
		Name = "MediaPlayer_Skip",
		MinAccess = "admin",
		Description = "Skip the currently playing media on any media player"
	},
	{
		Name = "MediaPlayer_Seek",
		MinAccess = "admin",
		Description = "Seek within the currently playing media on any media player"
	},
	{
		Name = "MediaPlayer_Remove",
		MinAccess = "admin",
		Description = "Remove any queued media from any media player (not just own)"
	},
	{
		Name = "MediaPlayer_QueueControl",
		MinAccess = "admin",
		Description = "Toggle repeat, shuffle, and lock on any media player"
	},
	{
		Name = "MediaPlayer_BypassWhitelist",
		MinAccess = "admin",
		Description = "Bypass media player service whitelist restrictions"
	},
}

-- Register all privileges if CAMI is available
if CAMI then
	for _, priv in ipairs(privileges) do
		CAMI.RegisterPrivilege(priv)
	end
end

---
-- Check if a player has a specific CAMI privilege.
-- Falls back to ply:IsAdmin() if CAMI is not available.
--
-- @param ply       Player entity
-- @param privilege String privilege name
-- @return boolean
--
function MediaPlayer.PlayerHasPrivilege(ply, privilege)
	if not IsValid(ply) then return false end
	if not CAMI then return ply:IsAdmin() end

	local hasAccess = false
	CAMI.PlayerHasAccess(ply, privilege, function(b)
		hasAccess = b
	end)
	return hasAccess
end

---
-- Check if a player has MediaPlayer_Admin OR a specific granular privilege.
-- This is the recommended way to check granular permissions.
--
-- @param ply       Player entity
-- @param privilege String specific privilege name (e.g. "MediaPlayer_Skip")
-- @return boolean
--
function MediaPlayer.PlayerHasAnyPrivilege(ply, privilege)
	return MediaPlayer.PlayerHasPrivilege(ply, "MediaPlayer_Admin") or
		   MediaPlayer.PlayerHasPrivilege(ply, privilege)
end

---
-- Check if a player has ANY media player CAMI privilege.
-- Used for client-side UI gating — shows controls to anyone with elevated permissions.
-- Server-side Request* functions still enforce specific granular checks.
--
-- @param ply Player entity
-- @return boolean
--
function MediaPlayer.PlayerHasAnyMediaPrivilege(ply)
	if not IsValid(ply) then return false end
	if not CAMI then return ply:IsAdmin() end

	-- Check the catch-all admin privilege first
	if MediaPlayer.PlayerHasPrivilege(ply, "MediaPlayer_Admin") then return true end

	-- Check each granular privilege
	local granularPrivileges = {
		"MediaPlayer_Skip",
		"MediaPlayer_Seek",
		"MediaPlayer_Remove",
		"MediaPlayer_QueueControl",
		"MediaPlayer_BypassWhitelist",
	}

	for _, priv in ipairs(granularPrivileges) do
		if MediaPlayer.PlayerHasPrivilege(ply, priv) then
			return true
		end
	end

	return false
end