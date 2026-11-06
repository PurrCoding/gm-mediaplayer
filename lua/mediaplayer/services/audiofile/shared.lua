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

local urllib = url

SERVICE.Name 	= "Audio file"
SERVICE.Id 		= "af"

SERVICE.PrefetchMetadata = true

local SupportedEncodings = {
	"([^/]+%.mp3)",    -- mp3
	"([^/]+%.wav)", -- wav
	"([^/]+%.ogg)"  -- ogg
}

function SERVICE:Match( url )
	url = string.lower(url or "")

	-- check supported encodings
	for _, encoding in pairs(SupportedEncodings) do
		if url:find(encoding) then
			return true
		end
	end

	return false
end
