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

local function BuildPlayerHTML( streamUrl )
	return [[
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="margin:0;background:#000;overflow:hidden">
<video id="cinema-player" src="]] .. streamUrl .. [[" autoplay controls preload="metadata" style="width:100%;height:100%"></video>
<script>
(function() {
	var video = document.getElementById("cinema-player");
	video.addEventListener("loadedmetadata", function() {
		window.MediaPlayer = video;
	});
})();
</script>
</body>
</html>
]]
end

local METADATA_HTML = [[
<!DOCTYPE html>
<html><head><meta charset="utf-8"></head><body>
<video id="metadata-video" src="{@src}" preload="metadata" style="display:none"></video>
<script>
(function() {
	var video = document.getElementById("metadata-video");
	video.onloadedmetadata = function() {
		console.log("METADATA:" + JSON.stringify({
			duration: video.duration || 0,
			title: "Jellyfin Video"
		}));
	};
	video.onerror = function() {
		console.log("ERROR:" + (video.error ? video.error.code : 5));
	};
})();
</script>
</body></html>
]]

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local streamUrl = self:GetJellyfinStreamUrl()
	if not streamUrl then return end

	browser:SetHTML( BuildPlayerHTML( streamUrl ) )
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
	local streamUrl = self:GetJellyfinStreamUrl()
	if not streamUrl then
		return callback( "Invalid Jellyfin URL" )
	end

	local html = METADATA_HTML:Replace( "{@src}", streamUrl )
	self:DHTMLPrefetch( callback, {
		html = html,
		timeout = 15,
	} )
end

function SERVICE:OnPrefetchError( errmsg, callback )
	callback( ("Jellyfin Error: %s"):format( errmsg ) )
end

function SERVICE:NetWriteRequest()
	net.WriteString( self._metaTitle or "Jellyfin Video" )
	net.WriteUInt( math.floor( self._metaDuration or 0 ), 16 )
end
