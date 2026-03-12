include "shared.lua"

DEFINE_BASECLASS( "mp_service_browser" )

local JS_Pause = [[
	if(window.MediaPlayer) {
		MediaPlayer.pause()
		mp_paused = true
	}
]]
local JS_Play = [[
	if(window.MediaPlayer) {
		MediaPlayer.play();
		mp_paused = false
	}
]]
local JS_Volume = [[
	if (window.MediaPlayer) {
		MediaPlayer.volume = %s;
	}
]]

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

do -- Request browser extensions

	local JS_REQUEST = [[
		// YouTube Adblock (https://github.com/Vendicated/Vencord/blob/main/src/plugins/youtubeAdblock.desktop/adguard.js - #d199603)
		const hiddenCSS=["#__ffYoutube1","#__ffYoutube2","#__ffYoutube3","#__ffYoutube4","#feed-pyv-container","#feedmodule-PRO","#homepage-chrome-side-promo","#merch-shelf","#offer-module",'#pla-shelf > ytd-pla-shelf-renderer[class="style-scope ytd-watch"]',"#pla-shelf","#premium-yva","#promo-info","#promo-list","#promotion-shelf","#related > ytd-watch-next-secondary-results-renderer > #items > ytd-compact-promoted-video-renderer.ytd-watch-next-secondary-results-renderer","#search-pva","#shelf-pyv-container","#video-masthead","#watch-branded-actions","#watch-buy-urls","#watch-channel-brand-div","#watch7-branded-banner","#YtKevlarVisibilityIdentifier","#YtSparklesVisibilityIdentifier",".carousel-offer-url-container",".companion-ad-container",".GoogleActiveViewElement",'.list-view[style="margin: 14px 0pt;"]',".promoted-sparkles-text-search-root-container",".promoted-sparkles-text-search-root-container",".searchView.list-view",".sparkles-light-cta",".watch-extra-info-column",".watch-extra-info-right",".ytd-action-companion-ad-renderer",".ytd-banner-promo-renderer",".ytd-compact-promoted-video-renderer",".ytd-companion-slot-renderer",".ytd-display-ad-renderer",".ytd-in-feed-ad-layout-renderer",".ytd-merch-shelf-renderer",".ytd-promoted-sparkles-text-search-renderer",".ytd-promoted-sparkles-web-renderer",".ytd-search-refinement-card-renderer",".ytd-statement-banner-renderer",".ytd-video-masthead-ad-advertiser-info-renderer",".ytd-video-masthead-ad-primary-video-renderer","ytd-ad-slot-renderer","ytd-in-feed-ad-layout-renderer","ytd-rich-item-renderer.ytd-rich-grid-renderer:has(> #content > ytd-ad-slot-renderer)","ytmusic-mealbar-promo-renderer"];function observeFunction(mutations,observer){var isInIframe=window!==window.top,isMusicPage=location.hostname==="music.youtube.com",isPlayerPage=location.pathname.startsWith("/watch"),isEmbedPage=location.pathname.startsWith("/embed/"),isFirefox=navigator.userAgent.indexOf("Firefox")>-1;for(var mutation of mutations){for(var node of mutation.addedNodes){if(!(node instanceof HTMLElement))continue;if(node.nodeName==="TP-YT-PAPER-DIALOG"){if(!node.querySelector("yt-mealbar-promo-renderer,ytmusic-mealbar-promo-renderer")){continue}node.remove()}if(node.id==="masthead-ad"){node.remove()}if(node.id==="panels"&&isInIframe&&isPlayerPage){for(var panel of node.querySelectorAll("ytd-engagement-panel-section-list-renderer[target-id=\"engagement-panel-ads\"]")){panel.remove()}}if(isPlayerPage&&node.nodeName==="YTD-MERCH-SHELF-RENDERER"){node.remove()}}}};if(document.getElementById("movie_player")){var player=document.getElementById("movie_player");var bAd=player.classList.contains("ad-interrupting")||player.classList.contains("ad-showing");if(bAd){var video=player.querySelector("video");if(video){video.currentTime=99999;video.addEventListener("timeupdate",function adTimeUpdate(){if(video.currentTime>video.duration-1){video.currentTime=99999}},{once:true})}}}var observer=new MutationObserver(observeFunction);observer.observe(document.documentElement,{childList:true,subtree:true});var css=document.createElement("style");css.type="text/css";css.textContent=hiddenCSS.map(function(s){return s+"{ display: none !important; }"}).join("\n");document.head.appendChild(css);
	]]

	function SERVICE:OnRequestBrowserURLChanged( browser, parent )
		if not IsValid(browser) or not IsValid(parent) then return end

		-- Temporarily disables it, as it supposedly triggers the
		-- "Sign in to confirm you're not a bot" prompt.
		--[[ if not browser.alreadyInjected then
			browser:RunJavascript(JS_REQUEST)
			browser.alreadyInjected = true
		end -- ]]
	end
end

function SERVICE:OnBrowserReady( browser )

	-- Resume paused player
	if self._Paused then
		self.Browser:RunJavascript( JS_Play )
		self._Paused = nil
		return
	end

	BaseClass.OnBrowserReady( self, browser )

	local videoId = self:GetYouTubeVideoId()
	local curTime = self:CurrentTime()

	local baseUrl = MediaPlayer.GetConfigValue( "youtube.url" )
	local hash = ("v=%s"):format(videoId)

	if self.IsTimed then
		hash = hash .. ("&t=%d"):format(curTime)
	end

	local url = baseUrl .. "#" .. hash
	browser:OpenURL( url )

end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if IsValid(self.Browser) then
		self.Browser:RunJavascript(JS_Pause)
		self._Paused = true
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

do	-- Metadata Prefech
	function SERVICE:PreRequest( callback )

		local videoId = self:GetYouTubeVideoId()

		local panel = vgui.Create("DHTML")
		panel:SetSize(500,500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		local svc = self
		function panel:ConsoleMessage(msg)
			print(msg)

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
				svc._metaisLive = metadata.isLive
				callback()
				panel:Remove()
			end
		end

		local baseUrl = MediaPlayer.GetConfigValue( "youtube.url_meta" )
		local hash = ("v=%s"):format(videoId)

		local url = baseUrl .. "#" .. hash
		panel:OpenURL(url)

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )
	end

	function SERVICE:NetWriteRequest()
		net.WriteString( self._metaTitle )
		net.WriteUInt( self._metaDuration, 16 )
		net.WriteBool(self._metaisLive)
	end
end