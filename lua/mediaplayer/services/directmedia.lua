SERVICE.Name  = "Direct Media"
SERVICE.Id    = "dm5"
SERVICE.Base  = "res"

SERVICE.PrefetchMetadata = true

SERVICE.FileExtensions = {
	"webm", "mp4", "mov", "mkv", "avi", "flv", "wmv", "m4v", "3gp", "ogv", "ts", "m2ts",
	"m3u8", "mpd",
	"png", "jpg", "jpeg", "gif", "webp", "avif", "apng", "bmp", "tiff", "tif", "ico", "svg"
}

DEFINE_BASECLASS( "mp_service_browser" )

local VideoMimeTypes = {
	webm = "video/webm",
	mp4  = "video/mp4",
	mov  = "video/quicktime",
	mkv  = "video/x-matroska",
	avi  = "video/x-msvideo",
	flv  = "video/x-flv",
	wmv  = "video/x-ms-wmv",
	m4v  = "video/mp4",
	["3gp"] = "video/3gpp",
	ogv  = "video/ogg",
	ts   = "video/mp2t",
	m2ts = "video/mp2t",
	m3u8 = "application/x-mpegURL",
	mpd  = "application/dash+xml"
}

local function IsStreamingFormat( ext )
	ext = string.lower( ext or "" )
	return ext == "m3u8" or ext == "mpd"
end

function SERVICE:IsTimed()
	if self._istimed == nil then
		self._istimed = self:Duration() > 0
	end
	return self._istimed
end

if CLIENT then

	local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"
	local JS_Play  = "if(window.MediaPlayer) MediaPlayer.play();"
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

	local VideoEmbedHTML = [[
		<video id="player" autoplay style="width: 100%%; height: 100%%;"></video>

		<!-- Audio-only indicator -->
		<div id="audio-indicator" style="position: absolute; top: 50%%; left: 50%%; transform: translate(-50%%, -50%%); display: none; flex-direction: column; align-items: center; justify-content: center; color: white; font-family: Arial, sans-serif; font-size: 24px; text-align: center; text-shadow: 2px 2px 4px rgba(0,0,0,0.8);">
			<div style="font-size: 64px; margin-bottom: 20px;">♪</div>
			<div>Audio Only Stream</div>
			<div style="font-size: 14px; margin-top: 10px; opacity: 0.7;">(No 3D audio support)</div>
		</div>

		<!-- Error message display -->
		<div id="error-display" style="position: absolute; top: 50%%; left: 50%%; transform: translate(-50%%, -50%%); display: none; flex-direction: column; align-items: center; justify-content: center; color: white; font-family: Arial, sans-serif; font-size: 18px; text-align: center; text-shadow: 2px 2px 4px rgba(0,0,0,0.8); max-width: 80%%;">
			<div style="font-size: 48px; margin-bottom: 15px;">⚠</div>
			<div id="error-text">Error loading media</div>
		</div>

		<script>
			(function() {
				var video = document.getElementById('player');
				var audioIndicator = document.getElementById('audio-indicator');
				var errorDisplay = document.getElementById('error-display');
				var errorText = document.getElementById('error-text');
				var videoSrc = '%s';
				var isHLS = videoSrc.includes('.m3u8');
				var isDASH = videoSrc.includes('.mpd');

				function showError(message) {
					errorText.textContent = message;
					errorDisplay.style.display = 'flex';
					video.style.display = 'none';
					audioIndicator.style.display = 'none';
				}

				function hideError() {
					errorDisplay.style.display = 'none';
				}

				function loadScript(src, callback) {
					var script = document.createElement('script');
					script.src = src;
					script.onload = callback;
					script.onerror = function() {
						showError('Failed to load required library');
					};
					document.head.appendChild(script);
				}

				function checkAudioOnly() {
					if (video.videoWidth === 0 || video.videoHeight === 0) {
						audioIndicator.style.display = 'flex';
						video.style.display = 'none';
					} else {
						audioIndicator.style.display = 'none';
						video.style.display = 'block';
					}
				}

				function detectVOD() {
					if (video.duration !== Infinity && video.duration > 0) {
						console.log('[DirectMedia] VOD detected, duration: ' + video.duration);
					} else {
						console.log('[DirectMedia] Live stream detected');
					}
				}

				function initPlayer() {
					hideError();

					if (isHLS && typeof Hls !== 'undefined' && Hls.isSupported()) {
						var hls = new Hls({
							debug: false,
							enableWorker: true,
							lowLatencyMode: true,
							backBufferLength: 90
						});
						hls.loadSource(videoSrc);
						hls.attachMedia(video);
						hls.on(Hls.Events.MANIFEST_PARSED, function() {
							video.play();
							video.addEventListener('loadedmetadata', function() {
								checkAudioOnly();
								detectVOD();
							});
						});
						hls.on(Hls.Events.ERROR, function(event, data) {
							if (data.fatal) {
								switch (data.type) {
									case Hls.ErrorTypes.NETWORK_ERROR:
										console.log('[DirectMedia] HLS Network error: ' + data.details);
										showError('Network error - Failed to load stream');
										break;
									case Hls.ErrorTypes.MEDIA_ERROR:
										console.log('[DirectMedia] HLS Media error: ' + data.details);
										if (!hls.recoverMediaError()) {
											showError('Media error - Codec not supported. You may need GModPatchTool');
										}
										break;
									default:
										console.log('[DirectMedia] HLS Fatal error: ' + data.details);
										showError('Fatal error: ' + data.details);
										hls.destroy();
										break;
								}
							}
						});
					} else if (isDASH && typeof dashjs !== 'undefined') {
						var player = dashjs.MediaPlayer().create();
						player.initialize(video, videoSrc, true);
						player.on(dashjs.MediaPlayer.events.STREAM_INITIALIZED, function() {
							video.play();
							video.addEventListener('loadedmetadata', function() {
								checkAudioOnly();
								detectVOD();
							});
						});
						player.on(dashjs.MediaPlayer.events.ERROR, function(event) {
							console.log('[DirectMedia] DASH error: ' + event.error);
							showError('DASH error: ' + event.error);
						});
					} else if (video.canPlayType('application/vnd.apple.mpegurl')) {
						video.src = videoSrc;
						video.addEventListener('loadedmetadata', function() {
							video.play();
							checkAudioOnly();
							detectVOD();
						});
					} else {
						video.src = videoSrc;
						video.addEventListener('loadedmetadata', checkAudioOnly);
					}

					var checkerInterval = setInterval(function() {
						if (!!video) {
							if (video.paused) { video.play(); }
							if (video.paused === false && video.readyState >= 2) {
								clearInterval(checkerInterval);
								window.MediaPlayer = video;
								video.style = "width:100%%; height: 100%%;";
							}
						}
					}, 50);
				}

				if (isHLS) {
					loadScript('https://cdn.jsdelivr.net/npm/hls.js@latest', function() {
						if (typeof Hls === 'undefined') {
							showError('HLS not supported in this browser');
							return;
						}
						initPlayer();
					});
				} else if (isDASH) {
					loadScript('https://cdn.dashjs.org/latest/dash.all.min.js', function() {
						if (typeof dashjs === 'undefined') {
							showError('DASH not supported in this browser');
							return;
						}
						initPlayer();
					});
				} else {
					initPlayer();
				}

				video.addEventListener('error', function(e) {
					var error = video.error;
					var errorMsg = '';
					if (error) {
						switch(error.code) {
							case error.MEDIA_ERR_ABORTED:
								errorMsg = 'Playback aborted';
								break;
							case error.MEDIA_ERR_NETWORK:
								errorMsg = 'Network error - Failed to load media';
								break;
							case error.MEDIA_ERR_DECODE:
								errorMsg = 'Codec not supported - You may need GModPatchTool';
								break;
							case error.MEDIA_ERR_SRC_NOT_SUPPORTED:
								errorMsg = 'Format not supported - You may need GModPatchTool';
								break;
							default:
								errorMsg = 'Unknown error (code: ' + error.code + ')';
						}
					}
					console.error('[DirectMedia] Video error: ' + errorMsg);
					showError(errorMsg);
				});
			})();
		</script>
	]]

	local ImageEmbedHTML = [[
		<div style="display: flex; align-items: center; justify-content: center; width: 100%%; height: 100%%; margin: 0; padding: 0;">
			<img id="image" src="%s" style="max-width: 100%%; max-height: 100%%; object-fit: contain; display: block;" alt="">
			<div id="error-message" style="display: none; color: white; font-family: Arial, sans-serif; font-size: 16px; text-align: center;">
				Failed to load image
			</div>
		</div>
		<script>
			(function() {
				var img = document.getElementById('image');
				var errorMsg = document.getElementById('error-message');

				img.onload = function() {
					if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
						gmod.imageLoaded();
					}
				};

				img.onerror = function() {
					img.style.display = 'none';
					errorMsg.style.display = 'block';
					if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
						gmod.imageLoaded();
					}
				};

				if (img.complete) {
					if (typeof gmod !== 'undefined' && gmod.imageLoaded) {
						gmod.imageLoaded();
					}
				}
			})();
		</script>
	]]

	function SERVICE:GetHTML()
		local url = self.url
		local path = self.urlinfo.path
		local ext = path and path:match("[^/]+%.(%S+)$") or ""

		if VideoMimeTypes[ext] then
			return VideoEmbedHTML:format(url)
		else
			return ImageEmbedHTML:format(url)
		end
	end

	function SERVICE:OnBrowserReady( browser )
		if self._Paused then
			self.Browser:RunJavascript( JS_Play )
			self._Paused = nil
			return
		end

		BaseClass.OnBrowserReady( self, browser )

		local html = self.WrapHTML( self:GetHTML() )
		browser:SetHTML( html )
	end

	function SERVICE:Pause()
		BaseClass.Pause( self )
		if IsValid(self.Browser) then
			self.Browser:RunJavascript(JS_Pause)
		end
	end

	function SERVICE:SetVolume( volume )
		if not IsValid(self.Browser) then return end
		local js = JS_Volume:format( volume )
		self.Browser:RunJavascript(js)
	end

	function SERVICE:Sync()
		local seekTime = self:CurrentTime()
		if IsValid(self.Browser) and self:IsTimed() and seekTime > 0 then
			self.Browser:RunJavascript(JS_Seek:format(seekTime))
		end
	end

	function SERVICE:IsMouseInputEnabled()
		return IsValid( self.Browser )
	end

	function SERVICE:PreRequest( callback )
		local path = self.urlinfo.path
		local ext = path and path:match("[^/]+%.(%S+)$") or ""

		if IsStreamingFormat(ext) then
			self._metaDuration = 0
			self._isStreaming = true
			callback()
		elseif VideoMimeTypes[ext] then
			MediaPlayerUtils.GatherVideoDuration( self.url, function(success, response)
				if success then
					self._metaDuration = response
					self._isStreaming = false
					callback()
					return
				end
				callback(response)
			end )
		else
			self._metaDuration = 0
			callback()
		end
	end

	function SERVICE:NetWriteRequest()
		net.WriteUInt( self._metaDuration or 0, 16 )
		net.WriteBool( self._isStreaming or false )
	end

end

if SERVER then
	function SERVICE:GetMetadata( callback )
		local cached, found = self:GetCachedMetadata()
		if found then
			callback(cached)
			return
		end

		local metadata = {}
		local path = self.urlinfo.path
		local ext = path and path:match("[^/]+%.(%S+)$") or ""

		if not VideoMimeTypes[ext] then
			local filename = path and string.match(path, "([^/]+)%.%w-$")
			metadata.title = filename or self.url
		else
			metadata.title = self.url
		end

		metadata.duration = self._metaDuration or 0

		self:SetMetadata(metadata, true)
		MediaPlayer.Metadata:Save(self)

		callback(self._metadata)
	end

	function SERVICE:NetReadRequest()
		if not self.PrefetchMetadata then return end
		self._metaDuration = net.ReadUInt( 16 )
		self._isStreaming = net.ReadBool()
	end
end