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

--[[----------------------------------------------------------------------------
	Media Player client configuration
------------------------------------------------------------------------------]]

--[[
Note to developers: Although this fork is (unofficially) actively maintained by PurrCoding, 
you can of course use your own domain or Github Pages at your own risk. You will have to push updates yourself.

Special note to workshop uploaders: Adding more media players to the workshop will only lead to more complications. 
	Everyone is welcome to participate in this PurrCoding fork instead.
]]--

local baseUrl = "https://gm-mediaplayer.purrcoding.com/"

MediaPlayer.SetConfig({

	---
	-- HTML content
	--
	html = {

		---
		-- Base URL where HTML content is located.
		-- @type String
		--
		base_url = baseUrl

	},

	---
	-- Request menu
	--
	request = {

		---
		-- URL of the request menu.
		-- @type String
		--
		url = baseUrl .. "request.html"

	},

	---
	-- YoutTube player
	--
	youtube = {

		---
		-- URL where the YouTube player is located.
		-- @type String
		--
		url = baseUrl .. "youtube.html",
		url_meta = baseUrl .. "youtube_meta.html",
	}

})
