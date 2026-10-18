include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local PREVIEW_URL = "https://mega.nz/embed/%s"

local JS_Pause = [[
	(function() {
		var p = window.MediaPlayer;
		if (!p) return;
		try { p.pause(); } catch (e) {}
	})();
]]

local JS_Play = [[
	(function() {
		var p = window.MediaPlayer;
		if (!p) return;
		var req = p.play();
		if (req && req.catch) req.catch(function() {});
	})();
]]

local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"

local JS_Seek = [[
	if (window.MediaPlayer) {
		var seekTime = %s;
		var curTime = window.MediaPlayer.currentTime;
		var diffTime = Math.abs(curTime - seekTime);
		if (diffTime > 5) {
			window.MediaPlayer.currentTime = seekTime;
		}
	}
]]

--[[
	1. Use MEGA UI only to start the stream once
	2. Detach <video>, wipe the rest of the page (kills MEGA controls)
	3. Own play/pause/volume/seek via native HTMLMediaElement APIs
]]
local JS_Interface = [[
	(function() {
		var started = false;

		function isolate(player) {
			document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
			document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

			document.body.appendChild(player);

			var nodes = Array.prototype.slice.call(document.body.childNodes);
			for (var i = 0; i < nodes.length; i++) {
				if (nodes[i] !== player) {
					try { document.body.removeChild(nodes[i]); } catch (e) {}
				}
			}

			// Drop MEGA scripts so they cannot re-attach listeners
			var scripts = document.querySelectorAll("script");
			for (var s = 0; s < scripts.length; s++) {
				try { scripts[s].remove(); } catch (e) {}
			}

			player.style.cssText = [
				"position:fixed",
				"top:0",
				"left:0",
				"width:100%",
				"height:100%",
				"max-width:100%",
				"max-height:100%",
				"object-fit:contain",
				"background:#000",
				"z-index:9999",
				"margin:0",
				"padding:0",
				"border:none"
			].join(";");

			player.removeAttribute("controls");
			player.controls = false;

			window.MediaPlayer = player;
		}

		var checkerInterval = setInterval(function() {
			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			// First kick: one MEGA button click to start the stream
			if (player.paused && !started) {
				started = true;
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					if (btn) btn.click();
				} catch (e) {}
				// Allow a second attempt after 600ms if still paused
				setTimeout(function() {
					if (player.paused) {
						var b = document.querySelector(".play-video-button");
						if (b) { try { b.click(); } catch (e) {} }
					}
				}, 600);
				return;
			}

			if (player.paused || Number.isNaN(player.duration)) return;

			clearInterval(checkerInterval);
			isolate(player);

			// Ensure playback continues after isolation
			var req = player.play();
			if (req && req.catch) req.catch(function() {});
		}, 50);
	})();
]]

local METADATA_JS = [[
	(function() {
		var done = false;
		var started = false;
		var checkerInterval = setInterval(function() {
			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			if (player.paused && !started) {
				started = true;
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					if (btn) btn.click();
				} catch (e) {}
				return;
			}

			if (player.paused || Number.isNaN(player.duration)) return;
			if (done) return;

			clearInterval(checkerInterval);
			done = true;
			player.volume = 0;
			try { player.pause(); } catch (e) {}

			var title = document.title.replace("MEGA - ", "");
			console.log("METADATA:" + JSON.stringify({
				duration: player.duration,
				title: title
			}));
		}, 50);
	})();
]]

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		if IsValid( self.Browser ) then
			self.Browser:RunJavascript( JS_Play )
		end
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local key = self:GetMegaFileKey()
	browser:OpenURL( PREVIEW_URL:format( key or "" ) )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( JS_Interface )
	end
end

function SERVICE:Pause()
	BaseClass.Pause( self )
	if IsValid( self.Browser ) then
		self.Browser:RunJavascript( JS_Pause )
		self._Paused = true
	end
end

function SERVICE:SetVolume( volume )
	if not IsValid( self.Browser ) then return end
	self.Browser:RunJavascript( JS_Volume:format( volume ) )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end

function SERVICE:PreRequest( callback )
	local key = self:GetMegaFileKey()
	if not key then
		return callback( "Invalid MEGA URL" )
	end

	self:DHTMLPrefetch( callback, {
		url = PREVIEW_URL:format( key ),
		js = METADATA_JS,
		timeout = 20,
	} )
end

function SERVICE:OnPrefetchError( errmsg, callback )
	callback( ("MEGA Error: %s"):format( errmsg ) )
end

function SERVICE:NetWriteRequest()
	net.WriteString( self._metaTitle or "MEGA Video" )
	net.WriteUInt( math.floor( self._metaDuration or 0 ), 16 )
end
