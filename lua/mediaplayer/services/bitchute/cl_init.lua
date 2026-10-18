include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Volume = [[
(function(){
	var v = %s;
	window.__mpVolume = v;
	var p = window.MediaPlayer;
	if (!p) return;
	if (v > 0) { p.muted = false; }
	p.volume = v;
})();
]]
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
	BitChute embed has no autoplay: click .vjs-big-play-button, then isolate
	<video> onto a full-bleed black stage (same idea as Rumble/Kick).
]]
local JS_Interface = [[
(function(){
	window.__mpVolume = {@volume};

	function clickPlay() {
		var btn = document.querySelector(".vjs-big-play-button")
			|| document.querySelector("button.vjs-play-control")
			|| document.querySelector(".vjs-play-control");
		if (btn) { try { btn.click(); } catch (e) {} }
		var v = document.querySelector("video");
		if (v && v.paused) { try { v.play(); } catch (e) {} }
	}

	function isolate(player) {
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
	}

	var checker = setInterval(function() {
		clickPlay();
		var player = document.querySelector("video");
		if (!player) return;
		if (player.paused) {
			try { player.play(); } catch (e) {}
			return;
		}
		if (player.readyState < 2) return;

		clearInterval(checker);
		isolate(player);
		window.MediaPlayer = player;

		var v = (typeof window.__mpVolume === "number") ? window.__mpVolume : 0.15;
		try {
			if (v > 0) player.muted = false;
			player.volume = v;
		} catch (e) {}

		player.addEventListener("play", function() {
			var vv = window.__mpVolume;
			if (vv > 0 && player.muted) player.muted = false;
			try { player.volume = vv; } catch (e) {}
		});

		console.log("READY:");
	}, 80);

	setTimeout(function() { clearInterval(checker); }, 15000);
})();
]]

function SERVICE:GetURL()
	local id = self:GetBitChuteVideoId()
	return ("https://www.bitchute.com/embed/%s"):format( id or "" )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		self:SetVolume( self:Volume() )
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetURL()
	local vol = math.Clamp( tonumber( self:Volume() ) or 0.15, 0, 1 )
	local interface = JS_Interface:Replace( "{@volume}", string.format( "%.4f", vol ) )

	browser:OpenURL( url )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( interface )
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
	volume = tonumber( volume ) or 0
	self.Browser:RunJavascript( JS_Volume:format( volume ) )
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if IsValid( self.Browser ) and self:IsTimed() and seekTime > 0 then
		self.Browser:RunJavascript( JS_Seek:format( seekTime ) )
	end
end
