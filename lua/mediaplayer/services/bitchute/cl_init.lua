include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
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

-- BitChute embed has no autoplay: click play, then bind <video> as MediaPlayer.
local JS_Interface = [[
	var checkerInterval = setInterval(function() {
		var btn = document.querySelector(".vjs-big-play-button")
			|| document.querySelector("button.vjs-play-control")
			|| document.querySelector(".vjs-play-control");
		if (btn) {
			try { btn.click(); } catch (e) {}
		}

		var player = document.querySelector("video");
		if (!player) return;

		if (player.paused) {
			try { player.play(); } catch (e) {}
			return;
		}

		if (player.readyState < 2) return;

		clearInterval(checkerInterval);

		document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
		document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
		document.body.appendChild(player);

		var children = Array.prototype.slice.call(document.body.childNodes);
		for (var i = 0; i < children.length; i++) {
			if (children[i] !== player) {
				try { document.body.removeChild(children[i]); } catch (e) {}
			}
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
		if (player.muted) { player.muted = false; }

		window.MediaPlayer = player;
	}, 50);
]]

function SERVICE:GetURL()
	local videoId = self:GetBitChuteVideoId()
	return ("https://www.bitchute.com/embed/%s"):format( videoId )
end

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()

	browser:OpenURL( url )
	browser.OnDocumentReady = function( pnl )
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
	local js = JS_Volume:format( volume )
	self.Browser:RunJavascript( js )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end
