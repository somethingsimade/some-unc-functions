-- islclosure.lua
-- © 2026 MrY7zz (MIT License)

local debug_info = debug.info

@native
function islclosure(func)
	return debug_info(func, "s") ~= "[C]"
end

--[=[
Usage:

local emptyfunction = function() end
local twait = task.wait

print(islclosure(twait)) --> Outputs "false"
print(islclosure(emptyfunction)) --> Outputs "true"
]=]
