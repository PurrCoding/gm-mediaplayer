include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play  = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = "if(window.MediaPlayer){MediaPlayer.volume=%s;MediaPlayer.muted=false;}"
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
(function () {
	function findVideo(win) {
		try {
			if (!win || !win.document) return null;
			var v = win.document.querySelector('video');
			if (v) return v;
			var frames = win.document.getElementsByTagName('iframe');
			for (var i = 0; i < frames.length; i++) {
				try {
					var child = frames[i].contentWindow;
					var vv = findVideo(child);
					if (vv) return vv;
				} catch (e) {}
			}
		} catch (e) {}
		return null;
	}

	var tries = 0;
	var checkerInterval = setInterval(function () {
		tries++;

		var player = findVideo(window);
		if (player) {
			clearInterval(checkerInterval);
			window.MediaPlayer = player;

			try { window.MediaPlayer.muted = false; } catch (e) {}
			try {
				if (window.MediaPlayer.paused) {
					var p = window.MediaPlayer.play();
					if (p && p.catch) p.catch(function () {});
				}
			} catch (e) {}
			return;
		}

		if (tries > 400) {
			clearInterval(checkerInterval);
			console.log('[MediaPlayer] Bilibili: failed to detect <video> element');
		}
	}, 50);
})();
]]

function SERVICE:GetURL()
	if self.urlinfo and self.urlinfo.host == "player.bilibili.com" and self.urlinfo.path == "/player.html" then
		return self.url
	end

	local bvid = self:GetBilibiliBVID()
	local aid = self:GetBilibiliAID()
	local page = self:GetBilibiliPage() or 1
	local curTime = math.max( math.floor(self:CurrentTime()), 0 )

	local params = {
		string.format( "p=%d", page ),
		"danmaku=0",
		"autoplay=1"
	}

	if curTime > 0 then
		table.insert( params, string.format( "t=%d", curTime ) )
	end

	if bvid then
		table.insert( params, 1, string.format( "bvid=%s", bvid ) )
		return "https://player.bilibili.com/player.html?" .. table.concat( params, "&" )
	end

	if aid then
		table.insert( params, 1, string.format( "aid=%s", aid ) )
		return "https://player.bilibili.com/player.html?" .. table.concat( params, "&" )
	end

	return self.url
end

function SERVICE:OnBrowserReady( browser )
	if self._BiliPaused then
		self.Browser:RunJavascript( JS_Play )
		self._BiliPaused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	browser:OpenURL( url )
	browser.OnDocumentReady = function( pnl )
		browser:QueueJavascript( JS_Interface )
	end
end

function SERVICE:SetVolume( volume )
	if IsValid( self.Browser ) then
		self.Browser:RunJavascript( JS_Volume:format( volume ) )
	end
end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid( self.Browser ) then
		self.Browser:RunJavascript( JS_Pause )
		self._BiliPaused = true
	end
end

function SERVICE:Play()
	BaseClass.Play( self )

	if IsValid( self.Browser ) then
		self:OnBrowserReady( self.Browser )
	end
end

function SERVICE:Seek( time )
	BaseClass.Seek( self, time )

	if IsValid( self.Browser ) then
		self.Browser:RunJavascript( JS_Seek:format( time ) )
	end
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end