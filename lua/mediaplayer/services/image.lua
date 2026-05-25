SERVICE.Name 	= "Image"
SERVICE.Id 		= "img"
SERVICE.Base 	= "res"

SERVICE.FileExtensions = { "png", "jpg", "jpeg", "gif", "webp", "avif", "apng" }

DEFINE_BASECLASS( "mp_service_browser" )

if CLIENT then

	local EmbedHTML = [[
	<div style="display: flex;
			align-items: center;
			justify-content: center;
			width: 100%%;
			height: 100%%;
			margin: 0;
			padding: 0;">
		<img id="image" src="%s" style="max-width: 100%%;
				max-height: 100%%;
				object-fit: contain;
				display: block;" alt="">
		<div id="error-message" style="display: none;
				color: white;
				font-family: Arial, sans-serif;
				font-size: 16px;
				text-align: center;">
			Failed to load image
		</div>
	</div>
	<script>
		var img = document.getElementById('image');
		var errorMsg = document.getElementById('error-message');

		img.onload = function() {
			if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
				gmod.imageLoaded();
			}
		};

		img.onerror = function() {
			img.style.display = 'none';
			errorMsg.style.display = 'block';
			if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
				gmod.imageLoaded();
			}
		};

		// Fallback: if image is already loaded (cached)
		if (img.complete) {
			if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
				gmod.imageLoaded();
			}
		}
	</script>
	]]

	function SERVICE:GetHTML()
		return EmbedHTML:format( self.url )
	end

	function SERVICE:OnBrowserReady( browser )
		BaseClass.OnBrowserReady( self, browser )
		local html = self.WrapHTML( self:GetHTML() )
		browser:SetHTML( html )
	end

end