include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local PREVIEW_URL = "https://mega.nz/embed/%s"

local JS_Pause = [[
	if (window.MediaPlayer) {
		try { window.MediaPlayer.pause(); } catch (e) {}
	}
]]
local JS_Play = [[
	if (window.MediaPlayer) {
		try { window.MediaPlayer.play(); } catch (e) {}
	}
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
	Start playback via MEGA UI once, bind the real #video element, then
	STOP the interval. Leaving it running re-clicks play while paused.
]]
local JS_Interface = [[
	(function() {
		var checkerInterval = setInterval(function() {
			var plybtn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			// Skip ads / wrong video nodes
			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			// Kick MEGA's own play button once if still idle
			if (plybtn && player.paused) {
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					plybtn.click();
					player.play();
				} catch (e) {}
				return;
			}

			if (player.paused || Number.isNaN(player.duration)) return;

			// Bound — never auto-click again
			clearInterval(checkerInterval);
			window.MediaPlayer = player;
		}, 50);
	})();
]]

local METADATA_JS = [[
	(function() {
		var done = false;
		var checkerInterval = setInterval(function() {
			var plybtn = document.querySelector(".play-video-button");
			var player = document.getElementsByTagName("video")[0];

			if (!player) return;

			if (!player.id || player.id !== "video") {
				try { player.currentTime = 9999; } catch (e) {}
				return;
			}

			if (plybtn && player.paused) {
				try {
					player.setAttribute("webkit-playsinline", "webkit-playsinline");
					plybtn.click();
					player.play();
				} catch (e) {}
				return;
			}

			if (player.paused || Number.isNaN(player.duration)) return;
			if (done) return;

			clearInterval(checkerInterval);
			done = true;
			player.volume = 0;

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
