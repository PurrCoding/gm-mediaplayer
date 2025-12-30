SERVICE.Name 	= "Resource"
SERVICE.Id 		= "res"
SERVICE.Base 	= "browser"
SERVICE.Abstract = true

SERVICE.FileExtensions = {}

local urllib = url

local function parseURL(url)
	local success, urlinfo = pcall(urllib.parse2, url)
	if not success then return false end

	return urlinfo
end

function SERVICE:Match( url )

	local info = parseURL(url)
	if info then

		-- Reject archive.org URLs with /details/ path to prevent conflicts
		if info.host and info.host:match("archive%.org") and
		   		info.path and info.path:match("^/details/(.+)$") then
			return false
		end

		-- check supported file extensions
		local ext = info["file"] and info["file"]["ext"] or false
		if ext then
			for _, ext2 in pairs(self.FileExtensions) do
				if ext == ext2 then
					return true
				end
			end
		end
	end


	return false
end

function SERVICE:IsTimed()
	return false
end
