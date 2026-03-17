AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrlBV = "https://api.bilibili.com/x/web-interface/view?bvid=%s"
local MetadataUrlAV = "https://api.bilibili.com/x/web-interface/view?aid=%s"

local function SetFallbackMetadata( self )
	local metadata = {
		title = "Bilibili",
		duration = 0,
		thumbnail = "",
	}

	self:SetMetadata( metadata, true )
	MediaPlayer.Metadata:Save( self )
end

local function BuildMetadata( self, payload )
	local data = payload.data or {}
	local pageIndex = self:GetBilibiliPage() or 1
	local selectedPage = nil

	if istable(data.pages) then
		selectedPage = data.pages[pageIndex]
	end

	local title = data.title or "Bilibili"
	if selectedPage and selectedPage.part and selectedPage.part ~= "" then
		if tonumber(data.videos or 1) > 1 then
			title = string.format( "%s - %s", title, selectedPage.part )
		end
	end

	local duration = tonumber( data.duration ) or 0
	if selectedPage and selectedPage.duration then
		duration = tonumber( selectedPage.duration ) or duration
	end

	return {
		title = title,
		duration = duration,
		thumbnail = data.pic or "",
	}
end

local function OnReceiveMetadata( self, callback, body )
	local data = util.JSONToTable( body )
	if not data or data.code ~= 0 or not data.data then
		SetFallbackMetadata( self )
		return callback( self._metadata )
	end

	local metadata = BuildMetadata( self, data )
	self:SetMetadata( metadata, true )
	MediaPlayer.Metadata:Save( self )

	callback( self._metadata )
end

function SERVICE:GetMetadata( callback )
	if self._metadata then
		callback( self._metadata )
		return
	end

	local cache = MediaPlayer.Metadata:Query( self )

	if MediaPlayer.DEBUG then
		print( "MediaPlayer.GetMetadata Cache results:" )
		PrintTable( cache or {} )
	end

	if cache then
		local metadata = {
			title = cache.title,
			duration = tonumber( cache.duration ) or 0,
			thumbnail = cache.thumbnail,
		}

		self:SetMetadata( metadata )
		MediaPlayer.Metadata:Save( self )
		callback( self._metadata )
		return
	end

	local bvid = self:GetBilibiliBVID()
	local aid = self:GetBilibiliAID()

	local apiurl
	if bvid then
		apiurl = MetadataUrlBV:format( bvid )
	elseif aid then
		apiurl = MetadataUrlAV:format( aid )
	else
		SetFallbackMetadata( self )
		return callback( self._metadata )
	end

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveMetadata( self, callback, body )
		end,
		function( code )
			SetFallbackMetadata( self )
			callback( self._metadata )
		end
	)
end
