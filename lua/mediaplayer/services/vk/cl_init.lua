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

local JS_FIND_VIDEO = [[
	function findVideo(root) {
		if (!root) return null;

		var container = root.querySelector && root.querySelector("div.video-container.s-t");
		if (container) {
			var inContainer = container.querySelector("video");
			if (inContainer) return inContainer;
			if (container.shadowRoot) {
				var v = findVideo(container.shadowRoot);
				if (v) return v;
			}
		}

		var vid = root.querySelector && root.querySelector("video");
		if (vid) return vid;

		var rootContainer = root.querySelector && root.querySelector(".shadow-root-container");
		if (rootContainer && rootContainer.shadowRoot) {
			var v2 = findVideo(rootContainer.shadowRoot);
			if (v2) return v2;
		}

		var all = root.querySelectorAll ? root.querySelectorAll("*") : [];
		for (var i = 0; i < all.length; i++) {
			var el = all[i];
			if (el.shadowRoot) {
				var v3 = findVideo(el.shadowRoot);
				if (v3) return v3;
			}
		}
		return null;
	}
]]

local JS_Interface = [[
	(function() {
		]] .. JS_FIND_VIDEO .. [[

		var checkerInterval = setInterval(function() {
			var player = findVideo(document);
			if (!player) return;

			if (player.paused) { try { player.play(); } catch (e) {} }

			if (!player.paused && player.readyState >= 3) {
				if (player.muted) { player.muted = false; }

				clearInterval(checkerInterval);

				window.MediaPlayer = player;
				document.body.style.backgroundColor = "black";

				player.addEventListener("seeking", function() {
					if (!player.paused) { player.pause(); }
					var onProgress = function() {
						if (player.paused && player.readyState >= 3) {
							player.removeEventListener("progress", onProgress);
							player.play();
						}
					};
					player.addEventListener("progress", onProgress);
				});
			}
		}, 50);
	})();
]]

-- Title: use document.title / <title> from the page header entirely
local METADATA_JS = [[
	(function() {
		]] .. JS_FIND_VIDEO .. [[

		function pageTitle() {
			var t = (document.title || "").trim();
			if (t) return t;
			var el = document.querySelector("head title");
			if (el) {
				var text = (el.textContent || el.innerText || "").trim();
				if (text) return text;
			}
			return "VK Video";
		}

		var checkerInterval = setInterval(function() {
			var player = findVideo(document);
			if (!player) return;

			clearInterval(checkerInterval);
			if (window.metaevent_set) return;

			player.muted = true;

			var finish = function() {
				if (window.metaevent_set) return;
				window.metaevent_set = true;

				console.log("METADATA:" + JSON.stringify({
					title: pageTitle(),
					duration: player.duration || 0
				}));
			};

			if (player.readyState >= 1 && !isNaN(player.duration)) {
				finish();
			} else {
				player.addEventListener("loadedmetadata", finish);
				player.addEventListener("error", function() {
					console.log("ERROR:" + (player.error ? player.error.code : 5));
				});
				setTimeout(function() {
					if (!window.metaevent_set) finish();
				}, 8000);
			}
		}, 50);
	})();
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
		timeout = 25,
	} )
end

function SERVICE:OnPrefetchError( errmsg, callback )
	callback( ("VK Error: %s"):format( errmsg ) )
end

function SERVICE:NetWriteRequest()
	net.WriteString( self._metaTitle or "VK Video" )
	net.WriteUInt( math.floor( self._metaDuration or 0 ), 16 )
end
