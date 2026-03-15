-- Must be loaded before any other mediaplayer file.
-- Defines addon identity for conflict detection with other forks/reuploads.
--
-- NOTE: CURRENT_VERSION is automatically updated by GitHub Actions.
-- Do not edit it manually. See .github/workflows/version-bump.yml

MEDIAPLAYER_VERSION = MEDIAPLAYER_VERSION or {}

local CURRENT_VERSION = "2026.3.15.1"
local CURRENT_SOURCE = "PurrCoding"

local function ParseVersion(str)
	local parts = {}
	for num in str:gmatch("(%d+)") do
		table.insert(parts, tonumber(num) or 0)
	end
	while #parts < 4 do
		table.insert(parts, 0)
	end
	return parts
end

local function IsNewerVersion(a, b)
	local va = ParseVersion(a)
	local vb = ParseVersion(b)
	for i = 1, 4 do
		if (va[i] or 0) > (vb[i] or 0) then return true end
		if (va[i] or 0) < (vb[i] or 0) then return false end
	end
	return false
end

local function PrintConflictWarning(existingSource, existingVersion)
	local sep = string.rep("=", 60)
	local msg = sep .. "\n"
	msg = msg .. "[MediaPlayer] ADDON CONFLICT DETECTED!\n"
	msg = msg .. sep .. "\n"
	msg = msg .. "Another copy of Media Player is already loaded:\n"
	msg = msg .. "  Loaded:  " .. tostring(existingSource) .. " v" .. tostring(existingVersion) .. "\n"
	msg = msg .. "  Current: " .. CURRENT_SOURCE .. " v" .. CURRENT_VERSION .. "\n"
	msg = msg .. "\n"
	msg = msg .. "Having multiple copies of Media Player installed WILL cause\n"
	msg = msg .. "errors and broken functionality. Please unsubscribe from all\n"
	msg = msg .. "other Media Player addons on the Steam Workshop.\n"
	msg = msg .. sep .. "\n"
	MsgC(Color(255, 100, 100), msg)
end

--- Check whether this addon should load or yield to an already-loaded copy.
-- @return shouldLoad boolean
-- @return reason string|nil
function MEDIAPLAYER_VERSION.Check()
	if not MediaPlayer or not MediaPlayer._source then
		return true, nil
	end

	local existingSource = MediaPlayer._source
	local existingVersion = MediaPlayer._version or "0.0.0.0"

	-- Same source, same version — Lua refresh scenario, allow it
	if existingSource == CURRENT_SOURCE and existingVersion == CURRENT_VERSION then
		return true, nil
	end

	-- Different source — conflict with another fork
	if existingSource ~= CURRENT_SOURCE then
		PrintConflictWarning(existingSource, existingVersion)

		if IsNewerVersion(CURRENT_VERSION, existingVersion) then
			MsgC(Color(100, 255, 100), "[MediaPlayer] " .. CURRENT_SOURCE .. " v" .. CURRENT_VERSION .. " is newer — replacing " .. existingSource .. " v" .. existingVersion .. "\n")
			return true, "replacing_older"
		else
			MsgC(Color(255, 200, 100), "[MediaPlayer] " .. CURRENT_SOURCE .. " v" .. CURRENT_VERSION .. " is NOT newer — skipping load. " .. existingSource .. " v" .. existingVersion .. " will remain active.\n")
			return false, "older_version"
		end
	end

	-- Same source, different version (e.g., manual update in progress)
	if IsNewerVersion(CURRENT_VERSION, existingVersion) then
		return true, "upgrading"
	else
		return false, "already_loaded_newer"
	end
end

--- Stamp the addon's identity onto the MediaPlayer global table.
function MEDIAPLAYER_VERSION.Apply()
	MediaPlayer = MediaPlayer or {}
	MediaPlayer._version = CURRENT_VERSION
	MediaPlayer._source = CURRENT_SOURCE
end

function MEDIAPLAYER_VERSION.GetVersion()
	return CURRENT_VERSION
end

function MEDIAPLAYER_VERSION.GetSource()
	return CURRENT_SOURCE
end