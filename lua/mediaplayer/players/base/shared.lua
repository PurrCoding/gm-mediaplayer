local MediaPlayer = MediaPlayer

local Audio3DCvar = MediaPlayer.Cvars.Audio3D
local ProximityMinCvar = MediaPlayer.Cvars.ProximityMin
local ProximityMaxCvar = MediaPlayer.Cvars.ProximityMax

local HasFocus = system.HasFocus
local MuteUnfocused = MediaPlayer.Cvars.MuteUnfocused
local CeilPower2 = MediaPlayerUtils.CeilPower2
local math_Clamp = math.Clamp

--[[---------------------------------------------------------
	Base Media Player
-----------------------------------------------------------]]

local MEDIAPLAYER = MEDIAPLAYER
MEDIAPLAYER.__index = MEDIAPLAYER

-- Inherit EventEmitter for all mediaplayer instances
EventEmitter:new(MEDIAPLAYER)

MEDIAPLAYER.Name = "base"
MEDIAPLAYER.IsMediaPlayer = true
MEDIAPLAYER.NoMedia = "\4" -- end of transmission character

-- Media Player states
MP_STATE_ENDED = 0
MP_STATE_PLAYING = 1
MP_STATE_PAUSED  = 2
NUM_MP_STATE = 3

include "sh_snapshot.lua"

-- Initialize the media player object.
--
function MEDIAPLAYER:Init(params)
	self._Queue = {}        -- media queue
	self._Media = nil       -- current media
	self._Owner = nil       -- media player owner

	self._State = MP_STATE_ENDED -- waiting for new media

	self._QueueRepeat = false -- should player repeat?
	self._QueueShuffle = false -- should player shuffle?
	self._QueueLocked = false -- is played locked?

	if SERVER then

		self._TransmitState = TRANSMIT_ALWAYS
		self._Listeners = {}
		self._ListenerSet = {}  -- fast lookup set for listeners

	else

		self._LastMediaUpdate = 0
		self._isFullscreen = false  -- Per-instance fullscreen state
		inputhook.Add( KEY_Q, self, self.OnQueueKeyPressed )
		inputhook.Add( KEY_C, self, self.OnQueueKeyPressed )

	end

end

--
-- Get whether the media player is valid.
--
-- @return boolean	Whether the media player is valid
--
function MEDIAPLAYER:IsValid()
	if self._removed then
		return false
	end

	return true
end

--
-- String coercion metamethod
--
-- @return String	Media player string representation
--
function MEDIAPLAYER:__tostring()
	return self:GetId()
end

--
-- Get the media player's unique ID.
--
-- @return Number	Media player ID.
--
function MEDIAPLAYER:GetId()
	return self.id
end

--
-- Get the media player's type.
--
-- @return String	MP type.
--
function MEDIAPLAYER:GetType()
	return self.Name
end

function MEDIAPLAYER:GetPlayerState()
	return self._State
end

function MEDIAPLAYER:SetPlayerState( state )
	local current = self._State
	self._State = state

	if MediaPlayer.DEBUG then
		print( "MEDIAPLAYER.SetPlayerState", state )
	end

	if current ~= state then
		self:OnPlayerStateChanged( current, state )
	end
end

function MEDIAPLAYER:OnPlayerStateChanged( old, new )
	local media = self:GetMedia()
	local validMedia = IsValid(media)

	if MediaPlayer.DEBUG then
		print( "MEDIAPLAYER.OnPlayerStateChanged", old .. " => " .. new )
	end

	if new == MP_STATE_PLAYING then
		if validMedia and not media:IsPlaying() then
			media:Play()
		end
	elseif new == MP_STATE_PAUSED then
		if validMedia and media:IsPlaying() then
			media:Pause()
		end
	end

	self:emit( MP.EVENTS.PLAYER_STATE_CHANGED, new, old )
end

--
-- Get whether the media player is currently playing media.
--
-- @return boolean	Media is playing
--
function MEDIAPLAYER:IsPlaying()
	return self._State == MP_STATE_PLAYING
end

--
-- Get the media player's position.
--
-- @return Vector3	Media player's position
--
function MEDIAPLAYER:GetPos()
	if not self._pos then
		self._pos = Vector(0,0,0)
	end
	return self._pos
end

function MEDIAPLAYER:GetOwner()
	return self._Owner
end

function MEDIAPLAYER:SetOwner( ply )
	self._Owner = ply
end

---
-- Determines if the player has privileges to use media controls (skip, seek,
-- etc.). Override this for custom behavior.
--
function MEDIAPLAYER:IsPlayerPrivileged( ply )
	return ply == self:GetOwner() or ply:IsAdmin() or
		hook.Run( "MediaPlayerIsPlayerPrivileged", self, ply )
end

---
-- Media player update
--
function MEDIAPLAYER:Think()

	if SERVER then
		self:UpdateListeners()
	end

	local media = self:GetMedia()
	local validMedia = IsValid(media)

	-- Waiting to play new media
	if SERVER then
		if self._State <= MP_STATE_ENDED then

			-- Check queue for videos to play
			if not self:IsQueueEmpty() then
				self:OnMediaFinished()
			end

		elseif self._State == MP_STATE_PLAYING then

			-- Wait for media to finish
			if validMedia and media:IsTimed() then
				local time = media:CurrentTime()
				local duration = media:Duration()

				if time > duration then
					self:OnMediaFinished()
				end
			end

		end
	end

	if CLIENT and validMedia then

		-- Reset caches when media object changes
		if media ~= self._cachedVolumeMedia then
			self._cachedVolumeMedia = media
			self._cachedVolume = nil
			self._nextSyncTime = nil
		end

		local now = RealTime()
		if not self._nextSyncTime or now >= self._nextSyncTime then
			media:Sync()
			self._nextSyncTime = now + 0.3
		end

		local volume

		-- Allow gamemodes/addons to force-mute a media player.
		-- Return true from the hook to mute, false/nil to use default behavior.
		if hook.Run( "MediaPlayerShouldMute", self, media ) then
			volume = 0
		elseif not HasFocus() and MuteUnfocused:GetBool() then
			volume = 0
		else
			local baseVolume = MediaPlayer.Volume()

			if Audio3DCvar:GetBool() then
				local localPlayer = LocalPlayer()

				local playerPos = localPlayer:GetPos()
				local entityPos = self:GetPos()
				local distance = playerPos:Distance(entityPos)

				local minDistance = ProximityMinCvar:GetFloat()
				local maxDistance = ProximityMaxCvar:GetFloat()

				if minDistance >= maxDistance then
					maxDistance = minDistance + 1
				end

				local falloff = 1 - ((distance - minDistance) / (maxDistance - minDistance))
				volume = math_Clamp(baseVolume * falloff, 0, 1)
			else
				volume = baseVolume
			end
		end

		-- Only push volume to media when it actually changes
		if volume ~= self._cachedVolume then
			media:Volume( volume )
			self._cachedVolume = volume
		end
	end

end

local function IsMediaObject( media )
	return istable(media) and
		isfunction(media.StartTime) and
		isfunction(media.CurrentTime) and
		isfunction(media.UniqueID) and
		isfunction(media.Url)
end

function MediaPlayer.RehydrateMedia( media, restorePlayback )
	if not istable(media) then
		return media
	end

	if IsMediaObject(media) then
		return media
	end

	local url = rawget(media, "url")
	if not isstring(url) or url == "" then
		return media
	end

	local recreated = MediaPlayer.GetMediaForUrl( url, true )
	if not istable(recreated) then
		return media
	end

	table.Merge( recreated, media )

	if recreated:IsTimed() then
		recreated:ResetTime()

		if restorePlayback then
			local savedTime = rawget(media, "currentTime")
			if not isnumber(savedTime) then
				local pauseTime = rawget(media, "_PauseTime")
				local startTime = rawget(media, "_StartTime")

				if isnumber(pauseTime) and isnumber(startTime) then
					savedTime = math.max( pauseTime - startTime, 0 )
				else
					savedTime = 0
				end
			end

			recreated:StartTime( RealTime() - savedTime )

			if rawget(media, "_PauseTime") ~= nil or rawget(media, "_playing") == false then
				recreated:Pause()
			end
		else
			recreated._playing = false
		end
	end

	return recreated
end

function MEDIAPLAYER:NormalizeMedia( media, restorePlayback )
	return MediaPlayer.RehydrateMedia( media, restorePlayback )
end

function MEDIAPLAYER:NormalizeMediaQueue()
	if not istable(self._Queue) then
		self._Queue = {}
		return self._Queue
	end

	for i = 1, #self._Queue do
		local normalized = self:NormalizeMedia( self._Queue[i], false )
		if normalized ~= self._Queue[i] then
			self._Queue[i] = normalized
		end
	end

	return self._Queue
end

--
-- Get the currently playing media.
--
-- @return Media	Currently playing media
--
function MEDIAPLAYER:GetMedia()
	local media = self:NormalizeMedia( self._Media, true )
	if media ~= self._Media then
		self._Media = media
	end
	return media
end

MEDIAPLAYER.CurrentMedia = MEDIAPLAYER.GetMedia

--
-- Set the currently playing media.
--
-- @param media		Media object.
--
function MEDIAPLAYER:SetMedia( media )
	media = self:NormalizeMedia( media, true )
	self._Media = media
	self:OnMediaStarted( media )

	-- NOTE: media can be nil!
	self:emit(MP.EVENTS.MEDIA_CHANGED, media)
end

--
-- Get the media queue.
-- TODO: Remove this as it should only be accessed internally?
--
-- @return table	Media queue.
--
function MEDIAPLAYER:GetMediaQueue()
	return self:NormalizeMediaQueue()
end

--
-- Clear the media queue.
--
function MEDIAPLAYER:ClearMediaQueue()
	self._Queue = {}
	if SERVER then
		self:BroadcastUpdate()
	end
end

--
-- Get whether the media queue is empty.
--
-- @return boolean	Whether the queue is empty
--
function MEDIAPLAYER:IsQueueEmpty()
	return #self._Queue == 0
end

function MEDIAPLAYER:GetQueueLimit( bNetLength )
	local limit = MediaPlayer.Cvars.QueueLimit:GetInt()

	if bNetLength then
		limit = math.max( CeilPower2( limit ) / 2, 2 )
	end

	return limit
end

function MEDIAPLAYER:GetQueueRepeat()
	return self._QueueRepeat
end

function MEDIAPLAYER:SetQueueRepeat( shouldRepeat )
	self._QueueRepeat = shouldRepeat
end

function MEDIAPLAYER:GetQueueShuffle()
	return self._QueueShuffle
end

function MEDIAPLAYER:SetQueueShuffle( shouldShuffle )
	self._QueueShuffle = shouldShuffle

	if SERVER then
		if shouldShuffle then
			self:ShuffleQueue()
		else
			self:SortQueue()
		end
	end
end

function MEDIAPLAYER:GetQueueLocked()
	return self._QueueLocked
end

function MEDIAPLAYER:SetQueueLocked( locked )
	self._QueueLocked = locked
end

---
-- Called when the queue is updated; emits a change event.
--
function MEDIAPLAYER:QueueUpdated()
	self:NormalizeMediaQueue()

	if SERVER then
		self:SortQueue()
	end

	self:emit( MP.EVENTS.QUEUE_CHANGED, self._Queue )
end

--
-- Add media to the queue.
--
-- @param media		Media object.
--
function MEDIAPLAYER:AddMedia( media )
	media = self:NormalizeMedia( media, false )
	if not media then return end

	if SERVER then
		-- cache the time the media has been queued for sorting purposes
		media:SetMetadataValue("queueTime", RealTime())
	end

	table.insert( self._Queue, media )
end

--
-- Event called when media should begin playing.
--
-- @param media		Media object to be played.
--
function MEDIAPLAYER:OnMediaStarted( media )

	media = media or self:CurrentMedia()

	if MediaPlayer.DEBUG then
		print( "MEDIAPLAYER.OnMediaStarted", media )
	end

	if IsValid(media) then

		if SERVER then
			local startTime
			local currentTime = media:CurrentTime()

			if currentTime > 0 then
				startTime = RealTime() - currentTime
			else
				startTime = RealTime()
			end

			media:StartTime( startTime + 1 )
		else
			self._LastMediaUpdate = RealTime()
		end

		if SERVER then
			self:SetPlayerState( MP_STATE_PLAYING )
		end

		self:emit("mediaStarted", media)

	elseif SERVER then
		self:SetPlayerState( MP_STATE_ENDED )
	end

end

--
-- Event called when media should stop playing and the next in the queue
-- should begin.
--
-- @param media		Media object to stop.
--
function MEDIAPLAYER:OnMediaFinished( media )

	media = media or self:CurrentMedia()

	if MediaPlayer.DEBUG then
		print( "MEDIAPLAYER.OnMediaFinished", media )
	end

	if SERVER then
		self:SetPlayerState( MP_STATE_ENDED )
	end

	self._Media = nil

	if CLIENT and IsValid(media) then
		media:Stop()
	end

	self:emit("mediaFinished", media)

	if SERVER then
		if media and self:GetQueueRepeat() then
			media:ResetTime()
			self:AddMedia( media )
		end

		self:NextMedia()
	end

end

--
-- Event called when the media player is to be removed/destroyed.
--
function MEDIAPLAYER:Remove()
	MediaPlayer.Destroy( self )
	self._removed = true

	if SERVER then

		-- Remove all listeners
		local listeners = table.Copy( self._Listeners )
		for _, ply in pairs( listeners ) do
			-- TODO: it's probably better not to send individual net messages
			-- for each player removed.
			self:RemoveListener( ply )
		end

	else

		-- Clean up fullscreen state
		if self._isFullscreen then
			self._isFullscreen = false
			local media = self:CurrentMedia()
			if IsValid(media) and IsValid(media.Browser) then
				media.Browser:SetSize(nil, nil, false)
			end
		end

		local media = self:CurrentMedia()

		if IsValid(media) then
			media:Stop()
		end

	end
end

function MEDIAPLAYER:GetSupportedServiceIDs()

	local serviceIDs = table.Copy( MediaPlayer.GetSupportedServiceIDs() )

	if self.ServiceWhitelist then
		local tbl = {}

		for _, id in ipairs(serviceIDs) do
			if table.HasValue( self.ServiceWhitelist, id ) then
				table.insert( tbl, id )
			end
		end

		serviceIDs = tbl
	end

	return serviceIDs

end
