--
-- Centralized CEF/Chrome error detection and reporting.
--
-- Provides a shared lookup table, error resolution, and display
-- functions used by both DMediaPlayerHTML and DHTMLPrefetch.
--

MediaPlayer.ChromeError = {}

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

--- Display a chrome error to the user.
-- Simple response text goes to chat. Detailed info goes to console.
-- @param responseText string Human-readable error message
-- @param errorCode string Raw Chromium error code
-- @param hostname string|nil The hostname that failed to load
function MediaPlayer.ChromeError.ShowError( responseText, errorCode, hostname )
	local message = tostring(errorCode) .. ": " .. tostring(responseText)
	MediaPlayer.ChatError(message)

	-- Detailed console print with hostname
	print("[Media Player] Chrome error: " .. tostring(errorCode) .. " on " .. tostring(hostname))
end

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