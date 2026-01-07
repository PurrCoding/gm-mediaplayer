include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local EMBED_PARAM = "?controls=1&fullscreen_button=0&play_button=0&volume_control=0&timestamp=0&loop=0&description=0&music_info=0&rel=0"
local EMBED_URL = "https://www.tiktok.com/embed/v3/%s" .. EMBED_PARAM

local JS_Interface = [[  
    (async function() {  
        let cookieClicked = false;  
        let playerReady = false;  
        const startTime = Date.now();  
  
        const observePlayer = () => {  
            return new Promise((resolve) => {  
                const observer = new MutationObserver(async (mutations, obs) => {  
                    const player = document.querySelector("video");  
  
                    if (player && !playerReady) {  
                        // Handle cookie banner first  
                        const banner = document.querySelector("tiktok-cookie-banner");  
                        if (banner && !cookieClicked) {  
                            const buttons = banner.shadowRoot?.querySelectorAll(".tiktok-cookie-banner .button-wrapper button");  
                            if (buttons?.[0]) {  
                                buttons[0].click();  
                                cookieClicked = true;  
                                return;  
                            }  
                            cookieClicked = true;  
                        }  
  
                        // Wait for video to be ready  
                        if (player.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) {  
                            playerReady = true;  
                            obs.disconnect();  
  
                            // Setup video controls  
                            player.setAttribute('controls', '');  
  
                            // Click to enable audio context  
                            player.click();  
                              
                            // Start playback  
                            player.play().catch(error => {  
                                console.log("Play failed, trying again:", error);  
                                // Retry after a short delay  
                                setTimeout(() => {  
                                    player.click();  
                                    player.play();  
                                }, 100);  
                            });  
  
                            window.MediaPlayer = player;  
                            resolve(player);  
                        }  
                    } else if (Date.now() - startTime > 10000 && !playerReady) {  
                        obs.disconnect();  
                        console.log("Video player not found or not ready");  
                        resolve(null);  
                    }  
                });  
  
                observer.observe(document.body, {  
                    childList: true,  
                    subtree: true,  
                    attributes: true,  
                    attributeFilter: ['readyState']  
                });  
            });  
        };  
  
        await observePlayer();  
    })();  
]]

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._MediaPaused then
		self.Browser:RunJavascript( [[
			if(window.MediaPlayer) {
				MediaPlayer.play()
			}
		]] )

		self._MediaPaused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local mediaID = self:GetMediaID()
	local url = EMBED_URL:format(mediaID)

	browser:OpenURL(url)
	browser.OnDocumentReady = function(pnl)
		browser:QueueJavascript( JS_Interface )
	end

end

do -- Player Controls
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
			self._MediaPaused = true
		end

	end

	function SERVICE:SetVolume( volume )
		local js = JS_Volume:format( volume )
		self.Browser:RunJavascript(js)
	end

	function SERVICE:Sync()

		local seekTime = self:CurrentTime()
		if IsValid(self.Browser) and self:IsTimed() and seekTime > 0 then
			self.Browser:RunJavascript(JS_Seek:format(seekTime))
		end
	end
end

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end

do	-- Metadata Prefech
	local METADATA_JS = [[
		setTimeout(function(){
			(async () => {
				var contentID = "{@contentID}"
				var videosrc = document.querySelector(`[href$=\"${contentID}\"]`)

				if (!videosrc) {
					videosrc = { href: `https://www.tiktok.com/@unknown/video/${contentID}` };
				}

				try {
					const response = await fetch(`https://www.tiktok.com/oembed?url=${videosrc.href}`)
					const json = await response.json()

					// Check if video is embeddable
					if (json.error || !json.html) {
						console.log("ERROR:Video is not embeddable or private")
						return;
					}

					var player = document.getElementsByTagName("VIDEO")[0]
					if (!!player) {
						// Wait for metadata to load with timeout
						var attempts = 0;
						var maxAttempts = 10; // 5 seconds

						var checkDuration = setInterval(function() {
							attempts++;

							if (player.duration && player.duration > 0 && !isNaN(player.duration)) {
								clearInterval(checkDuration);

								var title = json.title.length == 0 && `@${json.author_name} (${contentID})` || json.title.substr(0, 75) + " ..."
								var metadata = {
									duration: Math.round(player.duration),
									title: title
								}

								console.log("METADATA:" + JSON.stringify(metadata))
							} else if (attempts >= maxAttempts) {
								clearInterval(checkDuration);
								console.log("ERROR:Video duration cannot be detected after timeout")
							}
						}, 500);
					} else {
						console.log("ERROR:Video player not found - may not be embeddable")
					}
				} catch (error) {
					console.log("ERROR:Failed to fetch video metadata - " + error.message)
				}
			})()
		}, 500)
	]]

	function SERVICE:PreRequest( callback )

		local mediaID = self:GetMediaID()

		local panel = vgui.Create("DHTML")
		panel:SetSize(500,500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		svc = self
		function panel:ConsoleMessage(msg)

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback(errmsg)
				panel:Remove()
				return
			end

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				svc._metaTitle = metadata.title
				svc._metaDuration = metadata.duration
				callback()
				panel:Remove()
			end
		end

		local js = METADATA_JS
		js = js:Replace("{@contentID}", mediaID)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(js)
			end
		end

		panel:OpenURL(EMBED_URL:format(mediaID))

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )
	end

	function SERVICE:NetWriteRequest()
		if self._metaTitle then net.WriteString( self._metaTitle ) end
		if self._metaDuration then net.WriteUInt( self._metaDuration, 16 ) end
	end
end
