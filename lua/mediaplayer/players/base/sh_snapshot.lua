--[[
  Media Player Redux
  Copyright (c) 2014–2026 GMod Media Player authors

  Originally created by Samuel Maddock
  (https://github.com/samuelmaddock/gm-mediaplayer)

  This file is part of the Media Player Redux project
  (https://github.com/PurrCoding/gm-mediaplayer)

  Licensed under the MIT License.
  See LICENSE.md in the project root for the full license text.
  The copyright notice and this permission notice must be retained
  in all copies or substantial portions of the Software.
]]

function MEDIAPLAYER:GetSnapshot()
	local queue = table.Copy( self:GetMediaQueue() )
	local media = self:GetMedia()

	return {
		media = media,
		currentTime = media and media:CurrentTime(),
		queue = queue,
		queueRepeat = self:GetQueueRepeat(),
		queueShuffle = self:GetQueueShuffle(),
		queueLocked = self:GetQueueLocked()
	}
end

function MEDIAPLAYER:RestoreSnapshot( snapshot )
	self._Queue = {}

	self:SetQueueRepeat( snapshot.queueRepeat )
	self:SetQueueShuffle( snapshot.queueShuffle )
	self:SetQueueLocked( snapshot.queueLocked )

	if snapshot.media then
		-- restore currently playing media from where it left off
		local mediaSnapshot = snapshot.media
		local media = MediaPlayer.GetMediaForUrl( mediaSnapshot.url )
		if media then
			table.Merge( media, mediaSnapshot )
			media:StartTime( RealTime() - snapshot.currentTime )
			self:SetMedia( media )
		end
	else
		self:SetMedia( nil )
	end

	if snapshot.queue then
		-- restore queue
		for _, mediaSnapshot in ipairs( snapshot.queue ) do
			local media = MediaPlayer.GetMediaForUrl( mediaSnapshot.url )
			if media then
				table.Merge( media, mediaSnapshot )
				self:AddMedia( media )
			end
		end

		self:QueueUpdated()
	end
end
