include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local PREVIEW_URL = "https://mega.nz/embed/%s"

--[[
	MEGA play/pause is driven only by .play-video-button (toggle).
	Native video.paused is the source of truth afterwards.
]]
local JS_Pause = [[
	(function() {
		window.__mpWantPlay = false;
		var p = window.MediaPlayer;
		if (!p || p.paused) return;

		var btn = document.querySelector(".play-video-button");
		if (btn) {
			try { btn.click(); } catch (e) {}
		}

		// Retry a few times until video.paused is true
		var ticks = 0;
		if (window.__mpPauseWatch) clearInterval(window.__mpPauseWatch);
		window.__mpPauseWatch = setInterval(function() {
			if (window.__mpWantPlay) {
				clearInterval(window.__mpPauseWatch);
				return;
			}
			var ply = window.MediaPlayer;
			if (!ply || ply.paused) {
				clearInterval(window.__mpPauseWatch);
				return;
			}
			var b = document.querySelector(".play-video-button");
			if (b) { try { b.click(); } catch (e) {} }
			if (++ticks >= 20) clearInterval(window.__mpPauseWatch);
		}, 100);
	})();
]]

local JS_Play = [[
	(function() {
		window.__mpWantPlay = true;
		if (window.__mpPauseWatch) {
			clearInterval(window.__mpPauseWatch);
			window.__mpPauseWatch = null;
		}

		var p = window.MediaPlayer;
		if (!p || !p.paused) return;

		var btn = document.querySelector(".play-video-button");
		if (btn) {
			try { btn.click(); } catch (e) {}
		}

		var ticks = 0;
		if (window.__mpPlayWatch) clearInterval(window.__mpPlayWatch);
		window.__mpPlayWatch = setInterval(function() {
			if (!window.__mpWantPlay) {
				clearInterval(window.__mpPlayWatch);
				return;
			}
			var ply = window.MediaPlayer;
			if (!ply || !ply.paused) {
				clearInterval(window.__mpPlayWatch);
				return;
			}
			var b = document.querySelector(".play-video-button");
			if (b) { try { b.click(); } catch (e) {} }
			if (++ticks >= 20) clearInterval(window.__mpPlayWatch);
		}, 100);
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

		var checkerInterval = setInterval(function() {
			if (!window.__mpWantPlay) return;

			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			// Autoplay: click MEGA play button until video.paused === false
			if (player.paused) {
				if (btn) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						btn.click();
					} catch (e) {}
				}
				return;
			}

			if (Number.isNaN(player.duration)) return;

			clearInterval(checkerInterval);
			window.MediaPlayer = player;
		}, 50);
	})();
]]

local METADATA_JS = [[
	(function() {
		var done = false;
		var checkerInterval = setInterval(function() {
			var btn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			if (player.paused) {
				if (btn) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						btn.click();
					} catch (e) {}
				}
				return;
			}

			if (Number.isNaN(player.duration)) return;
			if (done) return;

			clearInterval(checkerInterval);
			done = true;
			player.volume = 0;

			// Pause for metadata scrape via same toggle button
			if (btn) {
				try { btn.click(); } catch (e) {}
			}

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
