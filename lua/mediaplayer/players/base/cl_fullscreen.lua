local pcall = pcall
local RealTime = RealTime
local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid

local FullscreenCvar = MediaPlayer.Cvars.Fullscreen

--[[---------------------------------------------------------
	Convar callback
-----------------------------------------------------------]]

local function OnFullscreenConVarChanged( name, old, new )

	new = (new == "1.00")
	old = (old == "1.00")

	if new ~= old then
		print("=====================================")
		print("MediaPlayer Fullscreen - Updated Behavior")
		print("=====================================")
		print("")
		print("The 'mediaplayer_fullscreen' ConVar is no longer used.")
		print("")
		print("NEW INSTRUCTIONS:")
		print("  • Look directly at a media player screen")
		print("  • Press F11 to toggle fullscreen for that specific screen")
		print("  • Only the targeted screen will enter fullscreen mode")
		print("  • Other screens will continue playing normally")
		print("")
		print("=====================================")
	end

end
cvars.AddChangeCallback( FullscreenCvar:GetName(), OnFullscreenConVarChanged )

--[[---------------------------------------------------------
	Client controls for toggling fullscreen
-----------------------------------------------------------]]

inputhook.AddKeyPress( KEY_F11, "Toggle MediaPlayer Fullscreen", function()

	local targetMP = nil

	-- First, check if any media player is already in fullscreen
	for _, mp in pairs(MediaPlayer.List) do
		if mp._isFullscreen then
			targetMP = mp
			break
		end
	end

	-- If no fullscreen player found, find which media player we're looking at
	if not targetMP then
		MediaPlayer.DispatchScreenTrace(function(mp, x, y)
			if not targetMP then
				targetMP = mp
			end
		end)
	end

	-- only toggle if there's an active media player
	if not targetMP then
		return
	end

	-- Toggle fullscreen for this specific player
	targetMP._isFullscreen = not targetMP._isFullscreen
	targetMP._LastMediaUpdate = RealTime()

	-- Update browser size
	local media = targetMP:CurrentMedia()
	if IsValid(media) and IsValid(media.Browser) then
		local w, h = targetMP._isFullscreen and ScrW() or nil, targetMP._isFullscreen and ScrH() or nil
		media.Browser:SetSize(w, h, targetMP._isFullscreen)
	end

	hook.Run(MP.EVENTS.FULLSCREEN_STATE_CHANGED, targetMP._isFullscreen, not targetMP._isFullscreen)

end )


--[[---------------------------------------------------------
	Draw functions
-----------------------------------------------------------]]

function MEDIAPLAYER:DrawFullscreen()

	-- Don't draw if we're not fullscreen
	if not self._isFullscreen then return end

	local w, h = ScrW(), ScrH()
	local media = self:CurrentMedia()

	if IsValid(media) then

		-- Custom media draw function
		if media.Draw then
			media:Draw( w, h )
		end
		-- TODO: else draw 'not yet implemented' screen?

		-- Draw media info
		local succ, err = pcall( self.DrawMediaInfo, self, media, w, h )
		if not succ then
			print( err )
		end

	else

		local browser = MediaPlayer.GetIdlescreen()

		if IsValid(browser) then
			self:DrawHTML( browser, w, h )
		end

	end

end