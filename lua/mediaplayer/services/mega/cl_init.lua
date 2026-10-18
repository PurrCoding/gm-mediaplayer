include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local PREVIEW_URL = "https://mega.nz/embed/%s"

--[[
	.play-video-button is a toggle — click at most once per intent,
	then verify native video.paused. Never spam-click.
]]
local JS_Pause = [[
	(function() {
		window.__mpWantPlay = false;
		var p = window.MediaPlayer;
		if (!p || p.paused) return;
		if (window.__mpToggleBusy) return;

		var btn = document.querySelector(".play-video-button");
		if (!btn) return;

		window.__mpToggleBusy = true;
		try { btn.click(); } catch (e) {}

		// One delayed retry only if still playing
		setTimeout(function() {
			window.__mpToggleBusy = false;
			if (window.__mpWantPlay) return;
			var ply = window.MediaPlayer;
			if (!ply || ply.paused) return;
			var b = document.querySelector(".play-video-button");
			if (!b) return;
			window.__mpToggleBusy = true;
			try { b.click(); } catch (e) {}
			setTimeout(function() { window.__mpToggleBusy = false; }, 400);
		}, 400);
	})();
]]

local JS_Play = [[
	(function() {
		window.__mpWantPlay = true;
		var p = window.MediaPlayer;
		if (!p || !p.paused) return;
		if (window.__mpToggleBusy) return;

		var btn = document.querySelector(".play-video-button");
		if (!btn) return;

		window.__mpToggleBusy = true;
		try { btn.click(); } catch (e) {}

		setTimeout(function() {
			window.__mpToggleBusy = false;
			if (!window.__mpWantPlay) return;
			var ply = window.MediaPlayer;
			if (!ply || !ply.paused) return;
			var b = document.querySelector(".play-video-button");
			if (!b) return;
			window.__mpToggleBusy = true;
			try { b.click(); } catch (e) {}
			setTimeout(function() { window.__mpToggleBusy = false; }, 400);
		}, 400);
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

local JS_Interface = [[
	(function() {
		window.__mpWantPlay = true;
		window.__mpToggleBusy = false;

		var checkerInterval = setInterval(function() {
			if (!window.__mpWantPlay) return;

			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			// Already playing → bind once
			if (!player.paused && !Number.isNaN(player.duration)) {
				clearInterval(checkerInterval);
				window.MediaPlayer = player;
				return;
			}

			// Autoplay: single click, wait for video.paused === false
			if (player.paused && btn && !window.__mpToggleBusy) {
				window.__mpToggleBusy = true;
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					btn.click();
				} catch (e) {}
				setTimeout(function() { window.__mpToggleBusy = false; }, 500);
			}
		}, 50);
	})();
]]

local METADATA_JS = [[
	(function() {
		var done = false;
		var busy = false;
		var checkerInterval = setInterval(function() {
			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			if (!player.paused && !Number.isNaN(player.duration)) {
				if (done) return;
				clearInterval(checkerInterval);
				done = true;
				player.volume = 0;

				// Single pause click for quiet metadata scrape
				if (btn) {
					try { btn.click(); } catch (e) {}
				}

				var title = document.title.replace("MEGA - ", "");
				console.log("METADATA:" + JSON.stringify({
					duration: player.duration,
					title: title
				}));
				return;
			}

			if (player.paused && btn && !busy) {
				busy = true;
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					btn.click();
				} catch (e) {}
				setTimeout(function() { busy = false; }, 500);
			}
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
