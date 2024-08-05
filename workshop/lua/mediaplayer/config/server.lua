--[[----------------------------------------------------------------------------
	The Media Player server configuration contains API keys used for requesting
	metadata for various services. All keys provided with the addon should not
	be used elsewhere as to respect data usage limits.
------------------------------------------------------------------------------]]
MediaPlayer.SetConfig({

	--[[------------------------------------------------------------------------
		Google's Data API is used for YouTube and GoogleDrive requests. To
		get your own API key, read through the following guide:
		https://developers.google.com/youtube/v3/getting-started#intro
	--------------------------------------------------------------------------]]
	google = {
		["api_key"] = "AIzaSyAjSwUHzyoxhfQZmiSqoIBQpawm2ucF11E",
		["referrer"] = "https://mediaplayer.pixeltailgames.com/"
	},

	--[[------------------------------------------------------------------------
		Twitch Developer Application

		To register your own application, see the following webpage:
		https://dev.twitch.tv/docs/v5/guides/using-the-twitch-api
	--------------------------------------------------------------------------]]
	twitch = {
		client_id = "cg1n8y5akizthcctygugthfq94tsg3"
	}

})
