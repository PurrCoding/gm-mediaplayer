if SERVER then
	include "players/components/vote.lua"
	include "players/components/voteskip.lua"
end

--[[---------------------------------------------------------
	Media Player Types
-----------------------------------------------------------]]

MediaPlayer.Type = {}

local setmetatable = setmetatable
local pairs = pairs
local pcall = pcall
local tostring = tostring
local ErrorNoHalt = ErrorNoHalt
local Msg = Msg
local print = print
local next = next
local timer = timer
local table_insert = table.insert

local function setBaseClass( name, tbl )
	local classname = "mp_" .. name

	if MediaPlayer.Type[name] ~= nil then
		if MediaPlayer.DEBUG then
			Msg("Media player type '" .. name .. "' is already registered. ")
			Msg("Clearing baseclass...\n")
		end

		-- HACK: removes registered baseclass if it already exists to avoid Lua
		-- refresh table.Merge errors...
		local _, BaseClassTable = debug.getupvalue(baseclass.Get, 1)
		BaseClassTable[classname] = nil
	end

	baseclass.Set( classname, tbl )
end

---
-- Registers a media player type.
--
-- @param tbl	Media player type table.
--
function MediaPlayer.Register( tbl )

	local name = tbl.Name

	if not name then
		ErrorNoHalt("MediaPlayer.Register - Must include name property\n")
		debug.Trace()
		return
	end

	name = name:lower() -- always use lowercase names
	tbl.Name = name
	tbl.__index = tbl

	-- Set base meta table
	local base = tbl.Base or "base"
	if base and name ~= "base" then
		base = base:lower()

		if not MediaPlayer.Type[base] then
			ErrorNoHalt("MediaPlayer.Register - Invalid base name: " .. base .. "\n")
			debug.Trace()
			return
		end

		base = MediaPlayer.Type[base]

		setmetatable(tbl, {
			__index = base,
			__tostring = base.__tostring
		})
	end

	-- Store media player type as a base class
	setBaseClass( name, tbl )

	-- Save player type
	MediaPlayer.Type[name] = tbl

	if MediaPlayer.DEBUG then
		Msg( "MediaPlayer.Register\t" .. name .. "\n" )
	end

end

function MediaPlayer.IsValidType( type )
	return MediaPlayer.Type[type] ~= nil
end

-- Load players
do
	local path = "players/"
	local players = {
		"base", -- MUST LOAD FIRST!
		"entity",
		"spatial"
	}

	for _, player in ipairs(players) do
		local clfile = path .. player .. "/cl_init.lua"
		local svfile = path .. player .. "/init.lua"

		MEDIAPLAYER = {}

		if SERVER then
			AddCSLuaFile(clfile)
			include(svfile)
		else
			include(clfile)
		end

		MediaPlayer.Register( MEDIAPLAYER )
		MEDIAPLAYER = nil
	end
end


--[[---------------------------------------------------------
	Media Player Helpers
-----------------------------------------------------------]]

MediaPlayer.List = MediaPlayer.List or {}
MediaPlayer._count = MediaPlayer._count or 0

---
-- Creates a media player object.
--
-- @param id		Media player ID.
-- @param type?		Media player type (defaults to 'base').
-- @return table	Media player object.
--
function MediaPlayer.Create( id, type )
	-- Inherit media player type
	local PlayerType = MediaPlayer.Type[type]
	PlayerType = PlayerType or MediaPlayer.Type.base

	-- Create media player object
	local mp = setmetatable( {}, { __index = PlayerType } )

	-- Assign unique ID
	if id then
		mp.id = id
	elseif SERVER then
		MediaPlayer._count = MediaPlayer._count + 1
		mp.id = MediaPlayer._count
	else
		mp.id = -1
	end

	mp:Init()

	-- Add to media player list
	MediaPlayer.List[mp.id] = mp

	-- Start the think timer if this is the first media player
	StartThinkTimer()

	if MediaPlayer.DEBUG then
		print( "Created Media Player", mp, mp.Name, type )
	end

	return mp
end

---
-- Destroys the given media player object.
--
-- @param table		Media player object.
--
function MediaPlayer.Destroy( mp )
	MediaPlayer.List[mp.id] = nil

	-- Stop the think timer if no media players remain
	if next(MediaPlayer.List) == nil then
		StopThinkTimer()
	end

	if MediaPlayer.DEBUG then
		print( "Destroyed Media Player '" .. tostring(mp.id) .. "'" )
	end
end

---
-- Gets the media player associated with the given ID.
--
-- @param id		Media player ID.
-- @return table 	Media player object.
--
function MediaPlayer.GetById( id )
	local mp = MediaPlayer.List[id]
	if mp then
		return mp
	else
		-- Since entity indexes can change, let's iterate the list just to
		-- be sure...
		for _, mp in pairs(MediaPlayer.List) do
			if mp:GetId() == id then
				return mp
			end
		end
	end
end

---
-- Gets all active media players.
--
-- @return table	Array of all active media players.
--
function MediaPlayer.GetAll()
	local tbl = {}

	for _, mp in pairs( MediaPlayer.List ) do
		table_insert( tbl, mp )
	end

	return tbl
end

---
-- Gets the media player associated with the given object.
--
-- @param obj Any object.
--
function MediaPlayer.GetByObject( obj )
	local mp = nil

	if isentity(obj) then
		if obj.IsMediaPlayerEntity then
			mp = obj:GetMediaPlayer()
		else
			-- Check children for parented media player entities
			-- (e.g. spatial anchors parented to props)
			for _, child in ipairs(obj:GetChildren()) do
				if child.IsMediaPlayerEntity then
					mp = child:GetMediaPlayer()
					if mp then break end
				end
			end
		end
	elseif istable(obj) and obj.IsMediaPlayer then
		mp = obj
	elseif isstring(obj) then
		mp = MediaPlayer.GetById(obj)
	end

	return mp
end


--[[---------------------------------------------------------
	Media Player Think Loop
-----------------------------------------------------------]]

MediaPlayer.ThinkInterval = 0.2 -- seconds

local MAX_RECREATE_ATTEMPTS = 3
local RECREATE_COOLDOWN = 30 -- seconds; reset attempt counter after stable operation

local function RecreateMediaPlayer( mp )
	local attempts = mp._recreateAttempts or 0
	local lastError = mp._lastRecreateTime or 0

	-- Reset attempt counter if the player has been stable for a while
	if (RealTime() - lastError) > RECREATE_COOLDOWN then
		attempts = 0
	end

	attempts = attempts + 1

	if attempts > MAX_RECREATE_ATTEMPTS then
		ErrorNoHalt("MediaPlayer '" .. tostring(mp:GetId()) .. "' exceeded max recreation attempts, removing.\n")
		mp:Remove()
		return
	end

	-- Try to save state before destruction
	local snapshot, listeners
	local snapshotOk = pcall(function()
		snapshot = mp:GetSnapshot()
		if SERVER and mp.GetListeners then
			listeners = table.Copy(mp:GetListeners())
		end
	end)

	if not snapshotOk then
		ErrorNoHalt("MediaPlayer '" .. tostring(mp:GetId()) .. "' failed to snapshot, removing.\n")
		mp:Remove()
		return
	end

	local mpId = mp:GetId()
	local mpType = mp:GetType()
	local ent = mp.GetEntity and mp:GetEntity()

	mp:Remove()

	-- Recreate: entity-based types reinstall via the entity,
	-- base types create directly
	local newMp
	if IsValid(ent) then
		ent:InstallMediaPlayer(mpType)
		newMp = ent._mp
	else
		newMp = MediaPlayer.Create(mpId, mpType)
	end

	if newMp then
		newMp._recreateAttempts = attempts
		newMp._lastRecreateTime = RealTime()

		if snapshot then
			local restoreOk, restoreErr = pcall(newMp.RestoreSnapshot, newMp, snapshot)
			if not restoreOk then
				ErrorNoHalt("MediaPlayer '" .. tostring(mpId) .. "' failed to restore snapshot: " .. tostring(restoreErr) .. "\n")
			end
		end

		if SERVER and listeners then
			newMp:SetListeners(listeners)
		end

		ErrorNoHalt("MediaPlayer '" .. tostring(mpId) .. "' recreated (attempt " .. attempts .. "/" .. MAX_RECREATE_ATTEMPTS .. ")\n")
	end
end

local function MediaPlayerThink()
	local toRecreate = nil

	for id, mp in pairs( MediaPlayer.List ) do
		local succ, err = pcall(mp.Think, mp)
		if not succ then
			ErrorNoHalt(err .. "\n")
			toRecreate = toRecreate or {}
			toRecreate[#toRecreate + 1] = mp
		end
	end

	if toRecreate then
		for _, mp in ipairs(toRecreate) do
			RecreateMediaPlayer(mp)
		end
	end
end

function StartThinkTimer()
	if not timer.Exists("MediaPlayerThink") then
		timer.Create("MediaPlayerThink", MediaPlayer.ThinkInterval, 0, MediaPlayerThink)
	end
end

function StopThinkTimer()
	if timer.Exists("MediaPlayerThink") then
		timer.Remove("MediaPlayerThink")
	end
end

-- On load/refresh: start timer only if media players already exist
if next(MediaPlayer.List) ~= nil then
	StartThinkTimer()
else
	StopThinkTimer()
end