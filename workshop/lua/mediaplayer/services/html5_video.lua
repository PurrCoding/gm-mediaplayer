SERVICE.Name	= "HTML5 Video"
SERVICE.Id		= "h5v"
SERVICE.Base	= "res"

SERVICE.FileExtensions = {
	"webm",
	"mp4",
}

DEFINE_BASECLASS( "mp_service_base" )

if CLIENT then

	local MimeTypes = {
		webm = "video/webm",
		mp4 = "video/mp4",
	}

	local EmbedHTML = [[
		<video id="player" autoplay loop style="
				width: 100%%;
				height: 100%%;">
			<source src="%s" type="%s">
		</video>
	]]

	local JS_Volume = [[(function () {
		var elem = document.getElementById('player');
		if (elem) {
			elem.volume = % s;
		}
	}());]]

	function SERVICE:GetHTML()
		local url = self.url

		local path = self.urlinfo.path
		local ext = path:match("[^/]+%.(%S+)$")

		local mime = MimeTypes[ext]

		return EmbedHTML:format(url, mime)
	end

	function SERVICE:Volume( volume )
		local origVolume = volume

		volume = BaseClass.Volume( self, volume )

		if origVolume and IsValid( self.Browser ) then
			self.Browser:RunJavascript(JS_Volume:format(volume))
		end
	end

end