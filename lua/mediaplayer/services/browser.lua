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
		browser._origConsoleMessage = origConsoleMessage  -- save for setupPanel restore

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
		local callbackFired = false
		local requestHostname = MediaPlayer.ChromeError
			and MediaPlayer.ChromeError.ExtractHostname(opts.url)

		local function safeCallback( err )
			if callbackFired then return end
			callbackFired = true
			callback( err )
		end

		local panel = vgui.Create("DHTML")
		panel:SetSize(500, 500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		--- Shared error handler for all chrome-error paths
		local function onChromeError( responseText, errorCode )
			svc:OnPrefetchError(responseText, safeCallback)
			if IsValid(panel) then panel:Remove() end
		end

		function panel:ConsoleMessage( msg )
			if callbackFired then return end

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))
				if not metadata then
					svc:OnPrefetchError("Failed to parse metadata JSON", safeCallback)
					panel:Remove()
					return
				end

				svc:OnPrefetchMetadata(metadata, safeCallback)
				panel:Remove()
				return
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)
				svc:OnPrefetchError(errmsg, safeCallback)
				panel:Remove()
				return
			end

			-- Handle CHROME_ERROR: and HEARTBEAT: via centralized helper
			if MediaPlayer.ChromeError then
				MediaPlayer.ChromeError.HandleConsoleMessage(msg, requestHostname, onChromeError)
			end
		end

		function panel:OnDocumentReady( url )
			if callbackFired then return end

			-- Detect chrome-error pages via centralized helper
			if MediaPlayer.ChromeError then
				local handled = MediaPlayer.ChromeError.HandleDocumentReady(panel, url, {
					hostname = requestHostname,
					onError = onChromeError,
				})

				if handled then return end
			end

			-- Normal page loaded — inject error monitoring JS
			if IsValid(panel) and MediaPlayer.ChromeError then
				panel:QueueJavascript(MediaPlayer.ChromeError.MONITOR_JS)
			end

			-- Inject custom JS if provided (e.g. TikTok, Google Drive metadata extraction)
			if opts.js and IsValid(panel) then
				panel:QueueJavascript(opts.js)
			end
		end

		if opts.url then
			panel:OpenURL(opts.url)
		elseif opts.html then
			panel:SetHTML(opts.html)
		end

		-- Continuous heartbeat: poll for chrome-error pages via JS→Lua bridge
		local timerName = "mp_prefetch_" .. tostring(panel)
		timer.Create(timerName, 1, 0, function()
			if not IsValid(panel) or callbackFired then
				timer.Remove(timerName)
				return
			end

			if MediaPlayer.ChromeError then
				panel:RunJavascript(MediaPlayer.ChromeError.HEARTBEAT_JS)
			end
		end)

		-- Timeout: clean up and report error if callback was never fired
		timer.Simple(timeout, function()
			timer.Remove(timerName)

			if IsValid(panel) then
				panel:Remove()
			end

			if not callbackFired then
				if MediaPlayer.ChromeError then
					MediaPlayer.ChromeError.ShowError("Request timed out", "TIMEOUT", requestHostname)
				end
				svc:OnPrefetchError("Request timed out", safeCallback)
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