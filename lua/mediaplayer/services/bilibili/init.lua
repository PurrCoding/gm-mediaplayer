AddCSLuaFile "shared.lua"
include "shared.lua"

local MetadataUrlBV = "https://api.bilibili.com/x/web-interface/view?bvid=%s"
local MetadataUrlAV = "https://api.bilibili.com/x/web-interface/view?aid=%s"

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
		return callback( false, "Failed to parse Bilibili video metadata." )
	end

	local metadata = BuildMetadata( self, data )
	self:SetMetadata( metadata, true )
	MediaPlayer.Metadata:Save( self )

	callback( self._metadata )
end

function SERVICE:GetMetadata( callback )
	local cached, found = self:GetCachedMetadata()
	if found then
		callback( cached )
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
		return callback( false, "Could not extract Bilibili video ID from URL." )
	end

	self:Fetch( apiurl,
		function( body, length, headers, code )
			OnReceiveMetadata( self, callback, body )
		end,
		function( code )
			callback( false, "Failed to fetch Bilibili metadata [" .. tostring(code) .. "]" )
		end
	)
end