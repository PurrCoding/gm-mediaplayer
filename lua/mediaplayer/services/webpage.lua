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

DEFINE_BASECLASS( "mp_service_browser" )

SERVICE.Name 	= "Webpage"
SERVICE.Id 		= "www"
SERVICE.Base 	= "res"
SERVICE.Abstract = true -- This service must be handled as a special case.

if CLIENT then

	function SERVICE:OnBrowserReady( browser )
		BaseClass.OnBrowserReady( self, browser )
		browser:OpenURL( self.url )
	end

	function SERVICE:IsMouseInputEnabled()
		return IsValid( self.Browser )
	end

else

	function SERVICE:Match( url )
		return false
	end

end
