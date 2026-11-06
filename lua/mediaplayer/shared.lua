--[[
  Media Player Redux
  Copyright (c) 2014–2026 GMod Media Player authors

  Originally created by Samuel Maddock
  (https://github.com/samuelmaddock/gm-mediaplayer)

  This file is part of the Media Player Redux project
  (https://github.com/PurrCoding/gm-mediaplayer)

  Licensed under the MIT License.
  See LICENSE.md in the project root for the full license text.
  The copyright notice and this permission notice must be retained
  in all copies or substantial portions of the Software.
]]

MediaPlayer = MediaPlayer or {}
MP = MediaPlayer

include "utils.lua"
include "sh_cvars.lua"
include "i18n/sh_i18n.lua"

--[[---------------------------------------------------------
	Config

	Store service API keys, etc.
-----------------------------------------------------------]]

MediaPlayer.config = {}

---
-- Apply configuration values to the mediaplayer config.
--
-- @param config	Table with configuration values.
--
function MediaPlayer.SetConfig( config )
	table.Merge( MediaPlayer.config, config )
end

---
-- Method for easily grabbing config value without checking that each fragment
-- exists.
--
-- @param key	e.g. "json.key.fragments"
--
function MediaPlayer.GetConfigValue( key )
	local value = MediaPlayerUtils.TableLookup( MediaPlayer.config, key )

	if value == nil then
		ErrorNoHalt("WARNING: MediaPlayer config value not found for key `" .. tostring(key) .. "`\n")
	end

	return value
end

if SERVER then
	AddCSLuaFile "config/client.lua"
else
	include "config/client.lua"
end


--[[---------------------------------------------------------
	Shared includes
-----------------------------------------------------------]]

include "sh_events.lua"
include "sh_mediaplayer.lua"
include "sh_services.lua"
include "sh_history.lua"
include "sh_metadata.lua"
include "sh_cami.lua"

hook.Add("Initialize", "InitMediaPlayer", function()
	hook.Run("InitMediaPlayer", MediaPlayer)
end)
