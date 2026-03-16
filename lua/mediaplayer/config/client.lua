--[[----------------------------------------------------------------------------
	Media Player client configuration
------------------------------------------------------------------------------]]

--[[
Note to developers: Although this fork is (unofficially) actively maintained by PurrCoding, 
you can of course use your own domain or Github Pages at your own risk. You will have to push updates yourself.

Special note to workshop uploaders: Adding more media players to the workshop will only lead to more complications. 
	Everyone is welcome to participate in this PurrCoding fork instead.
]]--

local baseUrl = "https://mediaplayer.purrcoding.com/"

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
		url = "https://enhanced-radio-player-sheepylord.netlify.app/"

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
