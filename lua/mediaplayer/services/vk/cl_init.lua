include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local EMBED_URL = "https://vkvideo.ru/video_ext.php?oid=-%s&id=%s&autoplay=1"

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

local JS_Interface = [[
	var checkerInterval = setInterval(function() {
		var player = document.getElementsByTagName("video")[0];
		if (!!player) {
			if (player.paused) { player.play(); }
			if (!player.paused && player.readyState === 4) {
				if (player.muted) { player.muted = false; }
				clearInterval(checkerInterval);
				window.MediaPlayer = player;
				document.body.style.backgroundColor = "black";
			}
		}
	}, 50);
]]

local METADATA_JS = [[
	var checkerInterval = setInterval(function() {
		var player = document.getElementsByTagName("video")[0];
		if (typeof (player) != "undefined") {
			player.muted = true;
			clearInterval(checkerInterval);
			if (window.metaevent_set) { return; }

			var titleEl = document.getElementsByClassName("videoplayer_title_link _clickable")[0];
			var title = titleEl ? titleEl.innerText : "VK Video";

			player.addEventListener("loadedmetadata", function() {
				window.metaevent_set = true;
				var thumbEl = document.getElementsByClassName("videoplayer_thumb")[0];
				var thumb = "";
				if (thumbEl && thumbEl.style.backgroundImage) {
					thumb = thumbEl.style.backgroundImage.slice(4, -1).replace(/["']/g, "");
				}
				console.log("METADATA:" + JSON.stringify({
					title: title,
					thumbnail: thumb,
					duration: player.duration || 0
				}));
			});
			player.addEventListener("error", function() {
				console.log("ERROR:" + (player.error ? player.error.code : 5));
			});
		}
	}, 50);
]]

function SERVICE:GetEmbedURL()
	local oid, id = self:GetVKEmbedParts()
	if not oid or not id then return nil end
	return EMBED_URL:format( oid, id )
end

function SERVICE:OnBrowserReady( browser )
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local url = self:GetEmbedURL()
	if not url then return end

	local curTime = self:CurrentTime()
	if self:IsTimed() and curTime > 3 then
		url = url .. "&t=" .. math.Round( curTime )
	end

	browser:OpenURL( url )
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
	local url = self:GetEmbedURL()
	if not url then
		return callback( "Invalid VK URL" )
	end

	self:DHTMLPrefetch( callback, {
		url = url,
		js = METADATA_JS,
		timeout = 15,
	} )
end

function SERVICE:OnPrefetchError( errmsg, callback )
	callback( ("VK Error: %s"):format( errmsg ) )
end

function SERVICE:NetWriteRequest()
	net.WriteString( self._metaTitle or "VK Video" )
	net.WriteUInt( math.floor( self._metaDuration or 0 ), 16 )
end
