--[[--------------------------------------------
	Vote object
----------------------------------------------]]

local VOTE = {}
VOTE.__index = VOTE

function VOTE:New( ply, value )
	local obj = setmetatable( {}, self )

	obj.player = ply
	obj.value = value or 1

	return obj
end

function VOTE:IsValid()
	return IsValid(self.player)
end

function VOTE:GetPlayer()
	return self.player
end

function VOTE:GetValue()
	return self.value
end

MediaPlayer.VOTE = VOTE