DEFINE_BASECLASS( "mp_service_base" )

SERVICE.Name 	= "Browser Base"
SERVICE.Id 		= "browser"
SERVICE.Abstract = true

if CLIENT then

	function SERVICE:GetBrowser()
		return self.Browser
	end

	function SERVICE:OnBrowserReady( browser )
		local resolution = MediaPlayer.Resolution()
		local w = resolution * 16 / 9
		local h = resolution
		local mp = nil

		if IsValid(self.Entity) then
			-- normalize resolution to the entity screen size
			local config = self.Entity:GetMediaPlayerConfig()
			local entwidth = config.width or w
			local entheight = config.height or resolution
			w = resolution * (entwidth / entheight)
			mp = self.Entity:GetMediaPlayer()
		end

		MediaPlayer.SetBrowserSize( browser, w, h, mp )

		-- Implement this in a child service
	end

	function SERVICE:SetVolume( volume )
		-- Implement this in a child service
	end

	function SERVICE:Volume( volume )
		local origVolume = volume

		volume = BaseClass.Volume( self, volume )

		if origVolume and IsValid( self.Browser ) then
			self:SetVolume( volume )
		end

		return volume
	end

	function SERVICE:Play()

		BaseClass.Play( self )

		if self.Browser and IsValid(self.Browser) then
			self:HookBrowserReady( self.Browser )
			self:OnBrowserReady( self.Browser )
		else

			self._promise = browserpool.get(function( panel )

				if not panel then
					return
				end

				if self._promise then
					self._promise = nil
				end

				self.Browser = panel
				self:HookBrowserReady( panel )
				self:OnBrowserReady( panel )

			end)
		end

	end

	function SERVICE:HookBrowserReady( browser )
		if browser._mpReadyHooked then return end
		browser._mpReadyHooked = true

		local svc = self
		local origConsoleMessage = browser.ConsoleMessage

		function browser:ConsoleMessage( ... )
			local args = { ... }
			local msg = args[1]

			if isstring(msg) and msg:StartWith("READY:") then
				if IsValid(svc.Entity) then
					local mp = svc.Entity:GetMediaPlayer()
					if mp then
						mp._cachedVolume = nil
					end
				end
			end

			if origConsoleMessage then
				return origConsoleMessage(self, ...)
			end
		end
	end

--[[---------------------------------------------------------
		DHTML Metadata Prefetch Helper

		Creates a temporary DHTML panel, routes ConsoleMessage
		events to OnPrefetchMetadata / OnPrefetchError, and
		handles automatic panel cleanup.

		opts.url     - URL to open (mutually exclusive with html)
		opts.html    - HTML string to set
		opts.js      - JS to inject on OnDocumentReady
		opts.timeout - seconds before auto-cleanup (default 10)
	-----------------------------------------------------------]]

	function SERVICE:DHTMLPrefetch( callback, opts )
		local svc = self
		local timeout = opts.timeout or 10

		local panel = vgui.Create("DHTML")
		panel:SetSize(500, 500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		function panel:ConsoleMessage( msg )
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))
				if not metadata then
					svc:OnPrefetchError("Failed to parse metadata JSON", callback)
					panel:Remove()
					return
				end

				svc:OnPrefetchMetadata(metadata, callback)
				panel:Remove()
				return
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)
				svc:OnPrefetchError(errmsg, callback)
				panel:Remove()
				return
			end
		end

		if opts.js then
			function panel:OnDocumentReady( url )
				if IsValid(panel) then
					panel:QueueJavascript(opts.js)
				end
			end
		end

		if opts.url then
			panel:OpenURL(opts.url)
		elseif opts.html then
			panel:SetHTML(opts.html)
		end

		timer.Simple(timeout, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end)

		return panel
	end

	--- Default metadata handler. Override in child services for
	--- service-specific fields (e.g. isLive).
	function SERVICE:OnPrefetchMetadata( metadata, callback )
		self._metaTitle = metadata.title
		self._metaDuration = metadata.duration
		callback()
	end

	--- Default error handler. Override in child services to
	--- prefix service name or customize the error message.
	function SERVICE:OnPrefetchError( errmsg, callback )
		callback(errmsg)
	end

	function SERVICE:Stop()
		BaseClass.Stop( self )

		if self._promise then
			self._promise:Cancel("Service has been stopped")
			self._promise = nil
		end

		if self.Browser then
			browserpool.release( self.Browser )
			self.Browser = nil
		end
	end

	local StartHtml = [[
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="utf-8">
		<title>Media Player</title>
		<style type="text/css">
		html, body {
			margin: 0;
			padding: 0;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}

		* { box-sizing: border-box }

		body {
			background-color: #282828;
			color: #cecece;
		}
		</style>
	</head>
	<body>
	]]

	local EndHtml = [[
	</body>
	</html>
	]]

	function SERVICE.WrapHTML( html )
		return table.concat({ StartHtml, html, EndHtml })
	end

	local JS_InjectScript = [[
(function () {
	var script = document.createElement('script');
	script.type = 'text/javascript';
	script.src = '%s';
	document.getElementsByTagName('head')[0].appendChild(script);
}());]]

	function SERVICE:InjectScript( uri )
		self.Browser:QueueJavascript( JS_InjectScript:format( uri ) )
	end

	function SERVICE:OnMousePressed( x, y )
		self.Browser:InjectMouseClick( x, y )
	end

	local SCROLL_MULTIPLIER = -80
	function SERVICE:OnMouseWheeled( scrollDelta )
		self.Browser:Scroll( scrollDelta * SCROLL_MULTIPLIER )
	end

	--[[---------------------------------------------------------
		Draw 3D2D
	-----------------------------------------------------------]]

	local IsValid = IsValid
	local SetDrawColor = surface.SetDrawColor
	local DrawRect = surface.DrawRect
	local DrawHTMLPanel = MediaPlayerUtils.DrawHTMLPanel

	function SERVICE:Draw( w, h )

		if IsValid(self.Browser) then
			SetDrawColor( 0, 0, 0, 255 )
			DrawRect( 0, 0, w, h )
			DrawHTMLPanel( self.Browser, w, h )
		end

	end

end
