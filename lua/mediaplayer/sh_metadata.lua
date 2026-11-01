--[[---------------------------------------------------------
	Media Player Metadata

	All media metadata is cached in an SQLite table for quick
	lookup and to prevent unnecessary network requests.
-----------------------------------------------------------]]

MediaPlayer.Metadata = {}

---
-- Default metadata table name
-- @type String
--
local TableName = "mediaplayer_metadata"

---
-- SQLite table struct
-- @type String
--
local TableStruct = [[
CREATE TABLE IF NOT EXISTS mediaplayer_metadata (
	id              VARCHAR(48) PRIMARY KEY,
	title           VARCHAR(128),
	duration        INTEGER NOT NULL DEFAULT 0,
	thumbnail       VARCHAR(512) NOT NULL DEFAULT '',
	extra           VARCHAR(2048),
	request_count   INTEGER NOT NULL DEFAULT 1,
	last_request    INTEGER NOT NULL DEFAULT 0,
	last_updated    INTEGER NOT NULL DEFAULT 0,
	expired         BOOLEAN NOT NULL DEFAULT 0
)]]

---
-- Maximum cache age before it expires; currently one week in seconds.
-- @type Number
--
local MaxCacheAge = 604800

---
-- Query the metadata table for the given media object's metadata.
-- If the metadata is older than one week, it is ignored and replaced upon
-- saving.
--
-- @param media     Media service object.
-- @return table    Cached metadata results.
--
function MediaPlayer.Metadata:Query( media )
	local id = media:UniqueID()
	if not id then return end

	local query = "SELECT * FROM mediaplayer_metadata WHERE id = ?"
	local results = sql.QueryTyped(query, id)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.Metadata.Query")
		print(query)
	end

	if results == false then
		ErrorNoHalt("MediaPlayer.Metadata.Query: SQL error: " .. tostring(sql.LastError()) .. "\n")
		return nil
	end

	local result = results[1]
	if not result then return nil end

	-- Media metadata has been marked as out-of-date
	if tonumber(result.expired) == 1 then
		return nil
	end

	local lastUpdated = tonumber(result.last_updated) or 0
	if os.time() - lastUpdated > MaxCacheAge then
		-- Set metadata entry as expired
		query = "UPDATE mediaplayer_metadata SET expired = 1 WHERE id = ?"
		local updateResult = sql.QueryTyped(query, id)

		if updateResult == false then
			ErrorNoHalt("MediaPlayer.Metadata.Query: Failed to mark entry as expired: " .. tostring(sql.LastError()) .. "\n")
		end

		if MediaPlayer.DEBUG then
			print("MediaPlayer.Metadata.Query: Setting entry as expired")
			print(query)
		end

		return nil
	end

	return result
end

---
-- Save or update the given media object into the metadata table.
--
-- @param media     Media service object.
-- @return table    SQL query results.
--
function MediaPlayer.Metadata:Save( media )
	local id = media:UniqueID()
	if not id then return end

	local query = "SELECT expired FROM mediaplayer_metadata WHERE id = ?"
	local results = sql.QueryTyped(query, id)

	if results == false then
		ErrorNoHalt("MediaPlayer.Metadata.Save: Failed to check existing entry: " .. tostring(sql.LastError()) .. "\n")
		return false
	end

	local now = os.time()
	local existing = results[1]

	if existing then
		if MediaPlayer.DEBUG then
			print("MediaPlayer.Metadata.Save Results:")
			PrintTable(results)
		end

		if tonumber(existing.expired) == 1 then
			-- Update possible new metadata
			local extra = (media._metadata and media._metadata.extra) or {}
			query = [[
UPDATE mediaplayer_metadata
SET request_count = request_count + 1,
	title = ?,
	duration = ?,
	extra = ?,
	last_request = ?,
	last_updated = ?,
	expired = 0
WHERE id = ?]]
			results = sql.QueryTyped(
				query,
				media:Title(),
				media:Duration() or 0,
				util.TableToJSON(extra),
				now,
				now,
				id
			)
		else
			query = [[
UPDATE mediaplayer_metadata
SET request_count = request_count + 1, last_request = ?
WHERE id = ?]]
			results = sql.QueryTyped(query, now, id)
		end
	else
		-- Insert a new metadata entry
		local extra = (media._metadata and media._metadata.extra) or {}
		query = [[
INSERT INTO mediaplayer_metadata
	(id, title, duration, extra, last_request, last_updated)
VALUES (?, ?, ?, ?, ?, ?)]]
		results = sql.QueryTyped(
			query,
			id,
			media:Title(),
			media:Duration() or 0,
			util.TableToJSON(extra),
			now,
			now
		)
	end

	if MediaPlayer.DEBUG then
		print("MediaPlayer.Metadata.Save")
		print(query)
		if istable(results) then
			PrintTable(results)
		else
			print(results)
		end
	end

	if results == false then
		ErrorNoHalt("MediaPlayer.Metadata.Save: There was an error executing the SQL query: " .. tostring(sql.LastError()) .. "\n")
	end

	return results
end

-- Create the SQLite table if it doesn't exist.
local createResult = sql.QueryTyped(TableStruct)
if createResult == false then
	ErrorNoHalt("MediaPlayer.Metadata: Failed to create metadata table: " .. tostring(sql.LastError()) .. "\n")
end

-- Keep the legacy thumbnail column available for the original Media Player.
-- Redux no longer stores thumbnails, but older versions still expect this column.
local columns = sql.QueryTyped("PRAGMA table_info(mediaplayer_metadata)")
local hasThumbnail = false

if columns == false then
	ErrorNoHalt("MediaPlayer.Metadata: Failed to inspect metadata table: " .. tostring(sql.LastError()) .. "\n")
elseif istable(columns) then
	for _, column in ipairs(columns) do
		if column.name == "thumbnail" then
			hasThumbnail = true
			break
		end
	end
end

if columns ~= false and not hasThumbnail then
	local migrationResult = sql.QueryTyped([[
ALTER TABLE mediaplayer_metadata
ADD COLUMN thumbnail VARCHAR(512) NOT NULL DEFAULT '']])

	if migrationResult == false then
		ErrorNoHalt("MediaPlayer.Metadata: Failed to add legacy thumbnail column: " .. tostring(sql.LastError()) .. "\n")
	end
end

if SERVER then
	---
	-- Truncates (clears) all rows from the metadata cache table.
	-- Useful for forcing a full re-fetch of all media metadata.
	--
	-- @return boolean  True on success, false on failure.
	--
	function MediaPlayer.Metadata:Truncate()
		local query = "DELETE FROM mediaplayer_metadata"
		if MediaPlayer.DEBUG then
			print("MediaPlayer.Metadata.Truncate")
			print(query)
		end

		local result = sql.QueryTyped(query)
		if result == false then
			ErrorNoHalt("MediaPlayer.Metadata.Truncate: SQL error: " .. tostring(sql.LastError()) .. "\n")
			return false
		end

		return true
	end
end