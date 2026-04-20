MediaPlayer.Services = {}

function MediaPlayer.RegisterService( service )

	local base

	if service.Base then
		base = MediaPlayer.Services[service.Base]
	elseif MediaPlayer.Services.base then
		base = MediaPlayer.Services.base
	end

	-- Inherit base service
	setmetatable( service, { __index = base } )

	-- Clear existing baseclass to avoid Lua refresh table.Merge errors
	local classname = "mp_service_" .. service.Id
	local _, BaseClassTable = debug.getupvalue(baseclass.Get, 1)
	if BaseClassTable[classname] then
		BaseClassTable[classname] = nil
	end

	-- Create base class for service
	baseclass.Set( classname, service )

	-- Store service
	MediaPlayer.Services[ service.Id ] = service

	if MediaPlayer.DEBUG then
		print( "MediaPlayer.RegisterService", service.Name )
	end

end

function MediaPlayer.GetValidServiceNames( whitelist )
	local tbl = {}

	for _, service in pairs(MediaPlayer.Services) do
		if not rawget(service, "Abstract") then
			if whitelist then
				if table.HasValue( whitelist, service.Id ) then
					table.insert( tbl, service.Name )
				end
			else
				table.insert( tbl, service.Name )
			end
		end
	end

	return tbl
end

function MediaPlayer.GetSupportedServiceIDs()
	local tbl = {}

	for _, service in pairs(MediaPlayer.Services) do
		if not rawget(service, "Abstract") then
			table.insert( tbl, service.Id )
		end
	end

	return tbl
end

function MediaPlayer.ValidUrl( url )

	for id, service in pairs(MediaPlayer.Services) do
		if service:Match( url ) then
			return true
		end
	end

	return false

end

function MediaPlayer.GetServiceByUrl( url )

	local service

	for id, s in pairs(MediaPlayer.Services) do
		if s:Match( url ) then
			service = s
			break
		end
	end

	return service

end

function MediaPlayer.GetMediaForUrl( url, webpageFallback )

	local service

	for id, s in pairs(MediaPlayer.Services) do
		if s:Match( url ) then
			service = s
			break
		end
	end

	if not service then
		if webpageFallback then
			service = MediaPlayer.Services.www
		else
			service = MediaPlayer.Services.base
		end
	end

	return service:New( url )

end

-- Load services
do
	local path = "services/"

	local fullpath = "mediaplayer/" .. path

	local services = {
		"base", -- MUST LOAD FIRST!

		-- Browser
		"browser", -- base
		"youtube",
		"bilibili",
		"soundcloud",
		"twitch",
		"dailymotion",
		"archive",
		"gdrive",
		"tiktok",
		"odysee",

		-- HTML Resources
		"resource", -- base
		"image",
		"html5_video",
		"webpage",

		-- IGModAudioChannel
		"audiofile",
	}

	for _, name in ipairs(services) do
		local clfile = path .. name .. "/cl_init.lua"
		local svfile = path .. name .. "/init.lua"
		local shfile = fullpath .. name .. ".lua"

		if file.Exists(shfile, "LUA") then
			clfile = shfile
			svfile = shfile
		end

		SERVICE = {}

		if SERVER then
			AddCSLuaFile(clfile)
			include(svfile)
		else
			include(clfile)
		end

		MediaPlayer.RegisterService( SERVICE )
		SERVICE = nil
	end
end
