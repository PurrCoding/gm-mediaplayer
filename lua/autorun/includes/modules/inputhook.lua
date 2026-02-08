local IsValid = IsValid
local pairs = pairs
local istable = istable
local IsGameUIVisible = gui.IsGameUIVisible
local IsConsoleVisible = gui.IsConsoleVisible

_G.inputhook = {}

local KeyCallbacks = {}

-- Internal hook handler
local function OnPlayerButtonDown(ply, button)

	if IsGameUIVisible() or IsConsoleVisible() then return end

	-- Only process for local player on client
	if ply ~= LocalPlayer() then return end

	local callbacks = KeyCallbacks[button]
	if not callbacks then return end

	for name, callback in pairs(callbacks) do
		if istable(name) then
			if IsValid(name) then
				callback(name, button)
			else
				callbacks[name] = nil
			end
		else
			callback(button)
		end
	end
end
hook.Add("PlayerButtonDown", "InputHookSystem", OnPlayerButtonDown)

---
-- Adds a callback to be dispatched when a key is pressed.
--
-- @param key       KEY_ enum or IN_ button enum
-- @param name      Unique identifier or a valid object
-- @param callback  Callback function
--
function inputhook.Add(key, name, callback)
	if not (key and callback) then return end

	KeyCallbacks[key] = KeyCallbacks[key] or {}
	KeyCallbacks[key][name] = callback
end

function inputhook.AddKeyPress(key, name, callback)
	inputhook.Add(key, name, callback)
end

function inputhook.AddKeyRelease(key, name, callback)
	-- Note: PlayerButtonUp would be needed for release events
	-- For now, maintain compatibility by treating as press
	inputhook.Add(key, name, callback)
end

---
-- Removes a registered key callback.
--
-- @param key   KEY_ enum
-- @param name  Unique identifier or a valid object
--
function inputhook.Remove(key, name)
	if not KeyCallbacks[key] then return end
	KeyCallbacks[key][name] = nil
end