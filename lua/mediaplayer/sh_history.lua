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

--[[---------------------------------------------------------
	Media Player History
-----------------------------------------------------------]]

MediaPlayer.History = {}

---
-- SQLite table struct
-- @type String
--
local TableStruct = [[
CREATE TABLE IF NOT EXISTS mediaplayer_history (
	id              INTEGER PRIMARY KEY AUTOINCREMENT,
	mediaid         VARCHAR(48),
	url             VARCHAR(512),
	player_name     VARCHAR(32),
	steamid         VARCHAR(32),
	time            DATETIME DEFAULT CURRENT_TIMESTAMP
)]]

---
-- Default number of results to return
-- @type Integer
--
local DefaultResultLimit = 100

---
-- Log the given media as a request.
--
-- @param media     Media service object.
-- @return table    SQL query results.
--
function MediaPlayer.History:LogRequest( media )
	local id = media:UniqueID()
	if not id then return end

	local ply = media:GetOwner()
	if not IsValid(ply) then return end

	local query = [[
INSERT INTO mediaplayer_history
	(mediaid, url, player_name, steamid)
VALUES (?, ?, ?, ?)]]
	local result = sql.QueryTyped(
		query,
		id,
		media:Url(),
		ply:Nick(),
		ply:SteamID64() or "-1"
	)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.History.LogRequest")
		print(query)
		if istable(result) then
			PrintTable(result)
		else
			print(result)
		end
	end

	if result == false then
		ErrorNoHalt("MediaPlayer.History.LogRequest: SQL error: " .. tostring(sql.LastError()) .. "\n")
	end

	return result
end

function MediaPlayer.History:GetRequestsByPlayer( ply, limit )
	if not isnumber(limit) then
		limit = DefaultResultLimit
	else
		limit = math.floor(limit)
	end

	local query = [[
SELECT
	H.*,
	M.title,
	COALESCE(M.thumbnail, '') AS thumbnail,
	M.duration
FROM mediaplayer_history AS H
JOIN mediaplayer_metadata AS M
	ON M.id = H.mediaid
WHERE H.steamid = ?
LIMIT ?]]
	local result = sql.QueryTyped(query, ply:SteamID64() or "-1", limit)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.History.GetRequestsByPlayer", ply, limit)
		print(query)
		if istable(result) then
			PrintTable(result)
		else
			print(result)
		end
	end

	if result == false then
		ErrorNoHalt("MediaPlayer.History.GetRequestsByPlayer: SQL error: " .. tostring(sql.LastError()) .. "\n")
	end

	return result
end

-- Create the SQLite table if it doesn't exist.
local createResult = sql.QueryTyped(TableStruct)
if createResult == false then
	ErrorNoHalt("MediaPlayer.History: Failed to create history table: " .. tostring(sql.LastError()) .. "\n")
end