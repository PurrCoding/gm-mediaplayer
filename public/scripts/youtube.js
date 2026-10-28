		// Get parameter from hash first, then fall back to query parameters
		function getParameter(name) {
			// Try hash parameters first
			const hash = window.location.hash.substring(1); // Remove '#'
			if (hash) {
				const hashParams = new URLSearchParams(hash);
				const hashValue = hashParams.get(name);
				if (hashValue) return hashValue;
			}

			// Fall back to query parameters for backwards compatibility
			const urlParams = new URLSearchParams(window.location.search);
			if (urlParams.get(name)) return urlParams.get(name);

			return null;
		}

		const tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		tag.onerror = function () {
			console.log("ERROR:Failed to load YouTube IFrame API");
		};
		document.head.appendChild(tag);

		let player = null;

		const defaultPlayerVars = {
			controls: 0,       // Hide native controls
			rel: 0,            // Disable related videos
			loop: 0,           // No loop
			disablekb: 1,      // Disable keyboard shortcuts
			enablejsapi: 1,    // Enable JS API for custom controls
			muted: 1,		   // Set to play muted
			cc_load_policy: 0, // Do not display subtitles automatically (overridden when ?cc=<lang>)
			iv_load_policy: 3, // Do not display video annotations
			autoplay: 1		   // Set to make it autostart
		};

		const startPaused = getParameter('paused') === '1';

		// Caption language selection. "?cc=<lang>" shows captions in that
		// language (e.g. cc=ko, cc=en); "?cc=off" or no parameter leaves them off.
		const ccRaw = getParameter('cc');
		const captionsOn = !!(ccRaw && ccRaw !== 'off' &&
			/^[a-zA-Z]{2,3}(-[a-zA-Z]{2,4})?$/.test(ccRaw));
		const ccLang = captionsOn ? ccRaw : '';
		if (captionsOn) {
			defaultPlayerVars.cc_load_policy = 1;
			defaultPlayerVars.cc_lang_pref = ccLang;
		}

		// The base player unloads the captions module on playback (see
		// onStateChange / onApiChange), so when a language is requested we have
		// to (re)load the module and select the track explicitly.
		function applyCaptions(p) {
			if (!captionsOn) return;
			try { p.loadModule('captions'); } catch (e) {}
			try { p.loadModule('cc'); } catch (e) {}
			try { p.setOption('captions', 'reload', true); } catch (e) {}
			try { p.setOption('captions', 'track', { languageCode: ccLang }); } catch (e) {}
			try { p.setOption('cc', 'track', { languageCode: ccLang }); } catch (e) {}
		}

		function onYouTubeIframeAPIReady() {
			const rawVid = getParameter('v');
			const vid = (rawVid && /^[a-zA-Z0-9_-]{11}$/.test(rawVid))
				? rawVid
				: 'dQw4w9WgXcQ';

			const startTime = Math.max(0, parseFloat(getParameter('t')) || 0);

			if (startPaused) {
				defaultPlayerVars.autoplay = 0; // don't autostart when paused
			}

			createPlayer(vid, startTime);
		}

		function createPlayer(videoId, startTime) {
			if (player && typeof player.destroy === 'function') {
				player.destroy();
				player = null;
				document.getElementById('player-container').innerHTML = '';
			}

			player = new YT.Player('player-container', {
				height: '100%',
				width: '100%',
				videoId: videoId,
				playerVars: {
					...defaultPlayerVars,
					start: Math.floor(startTime)  // YouTube API supports start parameter
				},
				host: 'https://www.youtube-nocookie.com',
				events: {
					onReady: () => {
						wrapper._ready = true;

						// Start silent — Lua will push the correct volume
						player.setVolume(0);

						// Additional seek if needed (for more precise timing)
						if (startTime > 0) {
							player.seekTo(startTime, true);
						}

						// Honor a paused start (URL param or an early pause() call)
						if (startPaused || wrapper._desiredPaused) {
							player.pauseVideo();
						}

						window.MediaPlayer = wrapper;

						// Turn captions on (if the viewer wants them)
						applyCaptions(player);

						// Signal Lua that the player is ready for volume
						console.log("READY:");
					},
					onStateChange: (e) => {
						if (e.data === YT.PlayerState.PLAYING) {
							wrapper._paused = false;
						} else if (e.data === YT.PlayerState.PAUSED ||
							e.data === YT.PlayerState.ENDED) {
							wrapper._paused = true;
						}

						// Captions get reset when playback begins. Re-apply the
						// viewer's choice on PLAYING/BUFFERING: load+select when they
						// want subtitles, unload when they don't.
						if (e.data === YT.PlayerState.PLAYING ||
							e.data === YT.PlayerState.BUFFERING) {
							if (captionsOn) {
								applyCaptions(player);
							} else {
								player.unloadModule('captions');
							}
						}
					},
					onApiChange: () => {
						// The captions module (re)loaded. Apply the viewer's choice:
						// select their language, or force it off when disabled.
						if (captionsOn) {
							applyCaptions(player);
						} else {
							try { player.unloadModule('captions'); } catch (e) {}
							try { player.unloadModule('cc'); } catch (e) {}
							try { player.setOption('captions', 'track', {}); } catch (e) {}
							try { player.setOption('cc', 'track', {}); } catch (e) {}
						}
					},
				}
			});

			const wrapper = {
				_ready: false,
				_paused: true,
				_desiredPaused: false,
				play() {
					this._desiredPaused = false;
					this._paused = false;
					if (this._ready) player.playVideo();
				},
				pause() {
					this._desiredPaused = true;
					this._paused = true;
					if (this._ready) player.pauseVideo();
				},

				get currentTime() {
					return this._ready ? player.getCurrentTime() : 0;
				},
				set currentTime(time) {
					if (this._ready) player.seekTo(time, true);
				},

				get volume() {
					return this._ready ? player.getVolume() / 100 : 1;
				},
				set volume(v) {
					if (this._ready) {
						if (player.isMuted()) {
							player.unMute();
						}

						player.setVolume(v * 100);
					}
				},

				get paused() {
					return this._paused;
				}
			};
		}

		/**
		 * Handle edge case if API already loaded
		 */
		if (window.YT && window.YT.Player && !player) {
			if (document.readyState === 'complete') {
				onYouTubeIframeAPIReady();
			} else {
				window.addEventListener('load', onYouTubeIframeAPIReady);
			}
		}

	