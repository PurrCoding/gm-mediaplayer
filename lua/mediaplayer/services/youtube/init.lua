AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	if self._metadata then
		callback( self._metadata )
		return
	end

	local cache = MediaPlayer.Metadata:Query(self)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.GetMetadata Cache results:")
		PrintTable(cache or {})
	end

	if cache then

		local metadata = {}
		metadata.title = cache.title
		metadata.duration = tonumber(cache.duration)
		metadata.thumbnail = cache.thumbnail

		self:SetMetadata(metadata)
		MediaPlayer.Metadata:Save(self)

		callback(self._metadata)

	else

		local videoId = self:GetYouTubeVideoId()
		local metadata = {}

		-- Title & Duration is taken from Client via PreRequest
		metadata.title = self._metaTitle

		if self._metaisLive then
			metadata.duration = 0
		else
			metadata.duration = math.Round(self._metaDuration)
		end

		metadata.thumbnail = ("https://img.youtube.com/vi/%s/mqdefault.jpg"):format(videoId)

		self:SetMetadata(metadata, true)
		MediaPlayer.Metadata:Save(self)

		callback(self._metadata)
	end
end

function SERVICE:NetReadRequest()

	if not self.PrefetchMetadata then return end

	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
	self._metaisLive = net.ReadBool()

end