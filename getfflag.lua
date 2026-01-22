-- getfflag.lua
-- © 2026 MrY7zz (MIT License)

local GetFFlag = game.GetFastFlag
local DataModel = game

function getfflag(fastFlag)
	return GetFFlag(DataModel, fastFlag)
end

--[=[
Usage:

print(getfflag("FFlagDisablePostFx")) --> Should output "false" by default
]=]
