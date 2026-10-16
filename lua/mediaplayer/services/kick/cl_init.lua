include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"

local JS_Volume = [[
	if (window.MediaPlayer) {
		var v = %s;
		if (v > 0) { window.MediaPlayer.muted = false; }
		window.MediaPlayer.volume = v;
	}
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

local JS_Interface = [[
	(async () => {
		var checkerInterval = setInterval(function() {
			var matureWarn = document.querySelector("button[data-test=\"mature\"]");
			if (!!matureWarn) {
				matureWarn.click();
				matureWarn.remove();
			}

			var player = document.getElementById("video-player");
			if (!!player) {
				clearInterval(checkerInterval);

				player.muted = false;
				try { player.play(); } catch (e) {}

				document.body.appendChild(player);
				var main = document.querySelector("div[class^=\"group/main\"]");
				if (main) { main.remove(); }
				document.body.style.backgroundColor = "black";

				window.MediaPlayer = player;

				var unmuteTries = 0;
				var unmuteTimer = setInterval(function() {
					if (!window.MediaPlayer || unmuteTries > 10) {
						clearInterval(unmuteTimer);
						return;
					}
					window.MediaPlayer.muted = false;
					unmuteTries++;
				}, 200);
			}
		}, 50);
	})();
]]

function SERVICE:GetPageURL()
	local data = self:GetKickData()
	return ("https://kick.com/%s"):format( data or "" )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	browser:OpenURL( self:GetPageURL() )
	browser.OnDocumentReady = function()
		browser:QueueJavascript( JS_Interface )
		timer.Simple( 1.0, function()
			if IsValid( self.Browser ) then
				self:SetVolume( self:Volume() )
			end
		end )
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
