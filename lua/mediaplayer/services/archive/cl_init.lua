include"shared.lua"
DEFINE_BASECLASS("mp_service_browser")
local EMBED_URL = "https://archive.org/embed/%s?autoplay=1"
do
	-- Media Hook
	local JS_Interface = [[
		(function() {

			// Recursively search for a <video> element, including inside Shadow DOM
			function findVideo(root) {
				if (!root) return null;

				// Direct video element
				let vid = root.querySelector && root.querySelector("video");
				if (vid) return vid;

				// Handle archive.org <play-av> shadow DOM
				let playAv = root.querySelector && root.querySelector("play-av");
				if (playAv && playAv.shadowRoot) {
					let v = findVideo(playAv.shadowRoot);
					if (v) return v;
				}

				// Traverse all elements and check for nested shadow roots
				let all = root.querySelectorAll ? root.querySelectorAll("*") : [];
				for (let el of all) {
					if (el.shadowRoot) {
						let v = findVideo(el.shadowRoot);
						if (v) return v;
					}
				}

				return null;
			}

			// Poll until video element is available and ready
			var checkerInterval = setInterval(function() {
				var player = findVideo(document);

				if (player && player.readyState >= 2) {
					clearInterval(checkerInterval);

					// Expose player globally for Lua controls
					window.MediaPlayer = player;

					// Force fullscreen-like layout
					player.style.width = "100%";
					player.style.height = "100%";
					document.body.style.backgroundColor = "black";

					console.log("[IA-FIX] Video detected:", player.currentSrc);
				}
			}, 100);

		})();
	]]
	function SERVICE:OnBrowserReady(browser)
		BaseClass.OnBrowserReady(self, browser)
		local parts = string.Explode(",", self:GetArchiveVideoId())
		local identifier = parts[1]
		if parts[2] then identifier = parts[2] and identifier .. "/" .. parts[2] end
		browser:OpenURL(EMBED_URL:format(identifier))
		browser.OnDocumentReady = function(pnl) browser:RunJavascript(JS_Interface) end
	end
end

do
	-- Request Override
	-- It's overkill, but hey, why not? ¯\_(ツ)_/¯
	local JS_REQUEST = [[
	(function watchForJWPlayer() {

		let lastState = null;
		let lastVideoSrc = null;
		let playerDetected = false;
		let isVideoPlaying = false;

		// --- Deep Shadow DOM video search (supports play-av and nested players)
		function findVideoDeep(root) {
			if (!root) return null;

			let vid = root.querySelector && root.querySelector("video");
			if (vid && (vid.currentSrc || vid.readyState > 0)) return vid;

			let all = root.querySelectorAll ? root.querySelectorAll("*") : [];
			for (let el of all) {
				if (el.shadowRoot) {
					let v = findVideoDeep(el.shadowRoot);
					if (v) return v;
				}
			}
			return null;
		}

		// --- Update UI state
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

		// --- Core detection logic
		const checkVideoSources = () => {

			// Method 0: Deep Shadow DOM scan (NEW - covers play-av)
			const deepVideo = findVideoDeep(document);
			if (deepVideo) {
				return {
					found: true,
					metadata: {
						detected: true,
						source: deepVideo.currentSrc,
						method: 'deep-shadow-scan',
						readyState: deepVideo.readyState
					}
				};
			}

			// Method 1: JWPlayer API
			if (typeof window.jwplayer === 'function') {
				try {
					const player = window.jwplayer();
					if (player && player.getPlaylist) {
						const playlist = player.getPlaylist();
						if (playlist && playlist.length > 0) {
							const currentIndex = player.getPlaylistItem() || 0;
							const currentItem = playlist[currentIndex];
							if (currentItem && currentItem.file) {
								return {
									found: true,
									metadata: {
										detected: true,
										source: currentItem.file,
										method: 'jwplayer-api',
										playlistIndex: currentIndex,
										playlistLength: playlist.length,
										title: currentItem.title || 'unknown'
									}
								};
							}
						}
					}
				} catch (e) {
					// silent fail
				}
			}

			// Method 2: Standard DOM selectors
			const selectors = [
				'video',
				'video[src]',
				'.jwplayer video',
				'video.jw-video',
				'.jw-media video',
				'[data-jwplayer-id] video'
			];

			for (const selector of selectors) {
				const videos = document.querySelectorAll(selector);
				for (const video of videos) {
					if (video.currentSrc || (playerDetected && video.readyState > 0)) {
						return {
							found: true,
							metadata: {
								detected: true,
								source: video.currentSrc || 'jwplayer-active',
								method: 'dom-selector',
								selector: selector,
								readyState: video.readyState
							}
						};
					}
				}
			}

			// fallback: keep previous state if player was already detected
			return { found: playerDetected, metadata: null };
		};

		// --- Initial detection
		const initialResult = checkVideoSources();
		updateState(initialResult.found, initialResult.metadata);

		// --- JWPlayer event hooks (if present)
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

				player.on('play', () => {
					console.log("[IA-DETECT] Video playing");
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
				// silent fail
			}
		}

		// --- Continuous monitoring
		const monitorInterval = setInterval(() => {
			const result = checkVideoSources();

			// keep button enabled while actively playing
			if (isVideoPlaying && typeof gmod !== 'undefined' && gmod.updateRequestButton) {
				gmod.updateRequestButton(true);
			} else {
				updateState(result.found, result.metadata);
			}
		}, 1000);

		// --- DOM observer for dynamic changes
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

		console.log("[IA-DETECT] Shadow DOM + JWPlayer detection initialized");

	})();
	]]

	SERVICE.OverrideRequestButton = true
	function SERVICE:OnRequestBrowserReady(browser, parent)
		if not IsValid(browser) or not IsValid(parent) then return end
		browser:RunJavascript(JS_REQUEST)
		browser:AddFunction("gmod", "updateRequestButton", function(hasVideo) if IsValid(parent.RequestButton) then parent.RequestButton:SetDisabled(not hasVideo) end end)
	end
end

do
	-- Media Controls
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
		BaseClass.Pause(self)
		if IsValid(self.Browser) then
			self.Browser:RunJavascript(JS_Pause)
			self._Paused = true
		end
	end

	function SERVICE:SetVolume(volume)
		if not IsValid(self.Browser) then return end
		local js = JS_Volume:format(volume)
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