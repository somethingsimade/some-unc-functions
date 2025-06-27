-- setfflag.lua
-- © 2025 MrY7zz (MIT License)

local SetFFlagFunc = game.DefineFastFlag
local DataModel = game

function setfflag(fastFlag, newValue)
	return SetFFlagFunc(DataModel, fastFlag, newValue)
end

--[=[
Usage:

setfflag("FFlagDisablePostFx", true) --> Sets FFlag "FFlagDisablePostFx" to true
]=]
