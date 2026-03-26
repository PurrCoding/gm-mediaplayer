--
-- Centralized CEF/Chrome error detection and reporting.
--
-- Provides a shared lookup table, error resolution, display
-- functions, and detection helpers used by both DMediaPlayerHTML
-- and DHTMLPrefetch.
--

MediaPlayer.ChromeError = {}

local DEBOUNCE_TIME = 10
local _lastShown = {}

local ChromeErrorMessages = {
	-- DNS errors
	["ERR_NAME_NOT_RESOLVED"]        = "DNS lookup failed — site may be blocked or unreachable",
	["DNS_PROBE_FINISHED_NXDOMAIN"]  = "Domain does not exist — site may be blocked or the URL is wrong",
	["DNS_PROBE_FINISHED_NO_INTERNET"] = "DNS probe finished — no internet connection",
	["DNS_PROBE_FINISHED_BAD_CONFIG"]  = "DNS probe finished — bad network/DNS configuration",
	["DNS_PROBE_STARTED"]            = "DNS probe started — DNS resolution is failing",
	["ERR_DNS_MALFORMED_RESPONSE"]   = "Malformed DNS response from server",
	["ERR_DNS_SERVER_FAILED"]        = "DNS server returned an error",
	["ERR_DNS_TIMED_OUT"]            = "DNS lookup timed out",
	["ERR_DNS_CACHE_MISS"]           = "DNS cache miss",
	["ERR_DNS_SORT_ERROR"]           = "DNS address sorting error",
	["ERR_DNS_SECURE_RESOLVER_HOSTNAME_RESOLUTION_FAILED"] = "Secure DNS resolver hostname could not be resolved",

	-- Connection errors
	["ERR_CONNECTION_REFUSED"]       = "Connection refused by server",
	["ERR_CONNECTION_TIMED_OUT"]     = "Connection timed out",
	["ERR_CONNECTION_RESET"]         = "Connection reset — possible network filtering or DPI block",
	["ERR_CONNECTION_CLOSED"]        = "Connection closed unexpectedly",
	["ERR_INTERNET_DISCONNECTED"]    = "No internet connection",
	["ERR_ADDRESS_UNREACHABLE"]      = "Address unreachable",
	["ERR_NETWORK_CHANGED"]          = "Network changed during request",

	-- SSL/TLS errors
	["ERR_SSL_PROTOCOL_ERROR"]       = "SSL/TLS handshake failed",
	["ERR_CERT_AUTHORITY_INVALID"]   = "Invalid certificate authority",
	["ERR_CERT_COMMON_NAME_INVALID"] = "Certificate name mismatch",
	["ERR_CERT_DATE_INVALID"]        = "Certificate has expired",

	-- Blocking/filtering errors
	["ERR_BLOCKED_BY_RESPONSE"]      = "Blocked by server response",
	["ERR_BLOCKED_BY_CLIENT"]        = "Blocked by client",

	-- General errors
	["ERR_ABORTED"]                  = "Request aborted",
	["ERR_TIMED_OUT"]               = "Request timed out",
	["ERR_TOO_MANY_REDIRECTS"]       = "Too many redirects",
	["ERR_EMPTY_RESPONSE"]           = "Server sent an empty response",
	["ERR_HTTP2_PROTOCOL_ERROR"]     = "HTTP/2 protocol error",
	["ERR_TUNNEL_CONNECTION_FAILED"] = "Proxy tunnel connection failed",
}

--- Resolve an error code to a human-readable message.
-- @param errorCode string The Chromium error code (e.g. "ERR_NAME_NOT_RESOLVED")
-- @return string The human-readable message, or "Network error" if unknown
function MediaPlayer.ChromeError.Resolve( errorCode )
	if not isstring(errorCode) or errorCode == "" or errorCode == "UNKNOWN" then
		return "Network error"
	end
	return ChromeErrorMessages[errorCode] or "Network error"
end

--- Extract hostname from a URL string.
-- @param url string
-- @return string|nil
function MediaPlayer.ChromeError.ExtractHostname( url )
	if not isstring(url) then return nil end
	return url:match("https?://([^/]+)")
end

--- Display a chrome error to the user with 10-second per-message debounce.
-- Chat message is suppressed if the same error code + hostname was shown
-- within the last DEBOUNCE_TIME seconds. Console always prints.
-- @param responseText string Human-readable error message
-- @param errorCode string Raw Chromium error code
-- @param hostname string|nil The hostname that failed to load
function MediaPlayer.ChromeError.ShowError( responseText, errorCode, hostname )
	local consoleMsg = "[Media Player] Chrome error: " .. tostring(errorCode) .. " on " .. tostring(hostname)
	print(consoleMsg)

	-- Debounce: suppress duplicate chat messages within DEBOUNCE_TIME
	local key = tostring(errorCode) .. ":" .. tostring(hostname or "")
	local now = RealTime()

	if _lastShown[key] and (now - _lastShown[key]) < DEBOUNCE_TIME then
		return
	end

	_lastShown[key] = now

	local message = tostring(errorCode) .. ": " .. tostring(responseText)
	MediaPlayer.ChatError(message)
end

--[[---------------------------------------------------------
	Detection helpers

	These encapsulate the repeated chrome-error detection
	patterns so consumers don't duplicate the logic.
-----------------------------------------------------------]]

--- Handle a console message that may be a chrome error signal.
-- Parses CHROME_ERROR: and HEARTBEAT: prefixes.
--
-- @param msg string The console message
-- @param hostname string|nil Hostname for error reporting
-- @param onError function(responseText, errorCode)|nil Called when an error is confirmed
-- @return boolean True if the message was handled (caller should return early)
function MediaPlayer.ChromeError.HandleConsoleMessage( msg, hostname, onError )
	if not isstring(msg) then return false end

	-- CHROME_ERROR: — extracted from the error page DOM by EXTRACT_JS
	if msg:StartWith("CHROME_ERROR:") then
		local errorCode = msg:sub(14)
		local responseText = MediaPlayer.ChromeError.Resolve(errorCode)
		MediaPlayer.ChromeError.ShowError(responseText, errorCode, hostname)

		if onError then
			onError(responseText, errorCode)
		end

		return true
	end

	-- HEARTBEAT: — continuous poll from HEARTBEAT_JS
	if msg:StartWith("HEARTBEAT:") then
		local payload = msg:sub(11)
		local url, code = payload:match("^(.-)%|(.*)$")

		if isstring(url) and url:StartWith("chrome-error://") then
			local errorCode = (code and code ~= "") and code or "UNKNOWN"
			local responseText = MediaPlayer.ChromeError.Resolve(errorCode)
			MediaPlayer.ChromeError.ShowError(responseText, errorCode, hostname)

			if onError then
				onError(responseText, errorCode)
			end

			return true
		end

		-- Heartbeat with a normal URL — not an error
		return true
	end

	return false
end

--- Handle OnDocumentReady for chrome-error detection.
-- If the URL is a chrome-error:// page, injects EXTRACT_JS and sets up
-- a fallback timer. Marks panel._chromeErrorHandled when resolved.
--
-- @param panel Panel The DHTML panel
-- @param url string The document URL
-- @param opts table {
--   hostname = string|nil,       -- hostname for error reporting
--   onError  = function(responseText, errorCode)|nil, -- called on confirmed error
-- }
-- @return boolean True if the URL was a chrome-error page (caller should return early)
function MediaPlayer.ChromeError.HandleDocumentReady( panel, url, opts )
	if not isstring(url) or not url:StartWith("chrome-error://") then
		return false
	end

	opts = opts or {}
	local hostname = opts.hostname

	-- Try to extract the error code from the DOM
	timer.Simple(0.5, function()
		if IsValid(panel) and not panel._chromeErrorHandled then
			panel:RunJavascript(MediaPlayer.ChromeError.EXTRACT_JS)
		end
	end)

	-- Fallback if JS injection is blocked on chrome-error pages
	timer.Simple(2, function()
		if IsValid(panel) and not panel._chromeErrorHandled then
			panel._chromeErrorHandled = true

			local responseText = "Page failed to load (network error)"
			MediaPlayer.ChromeError.ShowError(responseText, "UNKNOWN", hostname)

			if opts.onError then
				opts.onError(responseText, "UNKNOWN")
			end
		end
	end)

	return true
end

--[[---------------------------------------------------------
	Injected JavaScript snippets
-----------------------------------------------------------]]

-- JS: extract error code from chrome error page DOM
MediaPlayer.ChromeError.EXTRACT_JS = [[(function() {
	var el = document.querySelector('.error-code');
	var code = el ? el.textContent.trim() : 'UNKNOWN';
	console.log('CHROME_ERROR:' + code);
})();]]

-- JS: monitor sub-resource load failures on normal pages
MediaPlayer.ChromeError.MONITOR_JS = [[(function() {
	window.addEventListener('error', function(e) {
		if (e.target && e.target.tagName) {
			var tag = e.target.tagName.toLowerCase();
			if (tag === 'script' || tag === 'iframe' || tag === 'link') {
				var src = e.target.src || e.target.href || 'unknown';
				console.log('ERROR:Failed to load ' + tag + ': ' + src);
			}
		}
	}, true);

	window.addEventListener('unhandledrejection', function(e) {
		console.log('ERROR:Unhandled promise rejection: ' + (e.reason || 'unknown'));
	});
})();]]

-- JS: heartbeat that reports URL + error code back to Lua
MediaPlayer.ChromeError.HEARTBEAT_JS = [[(function() {
	var url = window.location.href;
	var code = '';
	if (url.indexOf('chrome-error://') === 0) {
		var el = document.querySelector('.error-code');
		code = el ? el.textContent.trim() : '';
	}
	console.log('HEARTBEAT:' + url + '|' + code);
})();]]