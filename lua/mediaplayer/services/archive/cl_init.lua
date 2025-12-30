include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local EMBED_URL = "https://archive.org/embed/%s?autoplay=1"

do -- Media Hook
	local JS_Interface = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.MediaPlayer = player;

				player.style = "width:100%; height: 100%;";
				document.body.style.backgroundColor = "black";
			}
		}, 50)
	]]

	function SERVICE:OnBrowserReady( browser )

		BaseClass.OnBrowserReady( self, browser )

		local parts = string.Explode(",", self:GetArchiveVideoId())
		local identifier = parts[1]

		if parts[2] then
			identifier = (parts[2] and identifier .. "/" .. parts[2])
		end

		browser:OpenURL( EMBED_URL:format(identifier) )
		browser.OnDocumentReady = function(pnl)
			browser:RunJavascript( JS_Interface )
		end

	end
end

do -- Request Override

	-- It's overkill, but hey, why not? ¯\_(ツ)_/¯
	local JS_REQUEST = [[
    (function watchForJWPlayer() {  
        let lastState = null;  
        let lastVideoSrc = null;  
        let playerDetected = false;  
        let isVideoPlaying = false;  
  
        const updateState = (hasVideo, metadata = null) => {  
            const currentVideoSrc = metadata ? metadata.source : null;  
            const stateChanged = (lastState !== hasVideo) || (lastVideoSrc !== currentVideoSrc);  
              
            if (stateChanged) {  
                lastState = hasVideo;  
                lastVideoSrc = currentVideoSrc;  
                playerDetected = hasVideo;  
                  
                if (typeof gmod !== 'undefined' && gmod.updateRequestButton) {  
                    gmod.updateRequestButton(!!hasVideo);  
                }  
                  
                if (hasVideo && metadata) {  
                    console.log("[IA-DETECT] Video detected:", JSON.stringify(metadata, null, 2));  
                } else if (!hasVideo && lastVideoSrc !== null) {  
                    console.log("[IA-DETECT] Video lost");  
                }  
            }  
        };  
  
        const checkVideoSources = () => {  
            // Method 1: JWPlayer API check - always active  
            if (typeof window.jwplayer === 'function') {  
                try {  
                    const player = window.jwplayer();  
                    if (player && player.getPlaylist) {  
                        const playlist = player.getPlaylist();  
                        if (playlist && playlist.length > 0) {  
                            const currentIndex = player.getPlaylistItem() || 0;  
                            const currentItem = playlist[currentIndex];  
                            if (currentItem && currentItem.file) {  
                                const metadata = {  
                                    detected: true,  
                                    source: currentItem.file,  
                                    method: 'jwplayer-api',  
                                    playlistIndex: currentIndex,  
                                    playlistLength: playlist.length,  
                                    title: currentItem.title || 'unknown'  
                                };  
                                return { found: true, metadata };  
                            }  
                        }  
                    }  
                } catch (e) {  
                    // Silent fail  
                }  
            }  
  
            // Method 2: Universal video element detection  
            const universalSelectors = [  
                'video',  
                'video[src]',  
                '.jwplayer video',  
                'video.jw-video',  
                '.jw-media video',  
                '[data-jwplayer-id] video'  
            ];  
  
            for (const selector of universalSelectors) {  
                const videos = document.querySelectorAll(selector);  
                for (const video of videos) {  
                    if (video.currentSrc || (playerDetected && video.readyState > 0)) {  
                        const metadata = {  
                            detected: true,  
                            source: video.currentSrc || 'jwplayer-active',  
                            method: 'dom-selector',  
                            selector: selector,  
                            readyState: video.readyState  
                        };  
                        return { found: true, metadata };  
                    }  
                }  
            }  
  
            // Only mark as not found if we never detected a player  
            return { found: playerDetected, metadata: null };  
        };  
  
        // Initial check  
        const initialResult = checkVideoSources();  
        updateState(initialResult.found, initialResult.metadata);  
  
        // Hook into JWPlayer events  
        if (typeof window.jwplayer === 'function') {  
            try {  
                const player = window.jwplayer();  
                  
                player.on('ready', () => {  
                    const result = checkVideoSources();  
                    updateState(result.found, result.metadata);  
                });  
                  
                player.on('playlistItem', () => {  
                    setTimeout(() => {  
                        const result = checkVideoSources();  
                        updateState(result.found, result.metadata);  
                    }, 300);  
                });  
  
                // Track playback state  
                player.on('play', () => {  
                    console.log("[IA-DETECT] Video playing - enabling continuous trigger");  
                    isVideoPlaying = true;  
                });  
  
                player.on('pause', () => {  
                    console.log("[IA-DETECT] Video paused");  
                    isVideoPlaying = false;  
                    const result = checkVideoSources();  
                    updateState(result.found, result.metadata);  
                });  
  
                player.on('complete', () => {  
                    console.log("[IA-DETECT] Video completed");  
                    isVideoPlaying = false;  
                    const result = checkVideoSources();  
                    updateState(result.found, result.metadata);  
                });  
            } catch (e) {  
                // Silent fail  
            }  
        }  
  
        // CRITICAL: Continuous monitoring with playback trigger  
        const monitorInterval = setInterval(() => {  
            const result = checkVideoSources();  
              
            // KEY CHANGE: If video is playing, always keep button enabled  
            if (isVideoPlaying && typeof gmod !== 'undefined' && gmod.updateRequestButton) {  
                gmod.updateRequestButton(true);  
                console.log("[IA-DETECT] Playback trigger - keeping button enabled");  
            } else {  
                updateState(result.found, result.metadata);  
            }  
        }, 1000);  
  
        // DOM observer  
        const observer = new MutationObserver(() => {  
            const result = checkVideoSources();  
            updateState(result.found, result.metadata);  
        });  
          
        observer.observe(document.body, {  
            childList: true,  
            subtree: true,  
            attributes: true,  
            attributeFilter: ['src', 'currentSrc']  
        });  
  
        console.log("[IA-DETECT] Continuous detection with playback trigger initialized");  
    })();  
	]]

	SERVICE.OverrideRequestButton = true
	function SERVICE:OnRequestReady( browser, parent )
		if not IsValid(browser) or not IsValid(parent) then return end

		browser:RunJavascript(JS_REQUEST)
		browser:AddFunction( "gmod", "updateRequestButton", function(hasVideo)
			if IsValid(parent.RequestButton) then
				parent.RequestButton:SetDisabled(not hasVideo)
			end
		end )

	end
end

do	-- Media Controls
	local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
	local JS_Volume = "if(window.MediaPlayer) MediaPlayer.volume = %s;"
	local JS_Seek = [[
		if (window.MediaPlayer) {
			var seekTime = %s;
			var curTime = window.MediaPlayer.currentTime;

			var diffTime = Math.abs(curTime - seekTime);
			if (diffTime > 5) {
				window.MediaPlayer.currentTime = seekTime
			}
		}
	]]

	function SERVICE:Pause()
		BaseClass.Pause( self )

		if IsValid(self.Browser) then
			self.Browser:RunJavascript(JS_Pause)
			self._YTPaused = true
		end

	end

	function SERVICE:SetVolume( volume )
		local js = JS_Volume:format( volume )
		self.Browser:RunJavascript(js)
	end

	function SERVICE:Sync()

		local seekTime = self:CurrentTime()
		if self:IsTimed() and seekTime > 0 then
			if not IsValid(self.Browser) then return end

			self.Browser:RunJavascript(JS_Seek:format(seekTime))
		end
	end
end