AddCSLuaFile "shared.lua"
include "shared.lua"

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback(cached)
		return
	end

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

function SERVICE:NetReadRequest()

	if not self.PrefetchMetadata then return end

	self._metaTitle = net.ReadString()
	self._metaDuration = net.ReadUInt( 16 )
	self._metaisLive = net.ReadBool()

end