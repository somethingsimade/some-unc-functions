-- iscclosure.lua
-- © 2026 MrY7zz (MIT License)

local debug_info = debug.info

function iscclosure(func)
	if typeof(func) ~= "function" then
		error("invalid argument #1 to 'iscclosure' (function expected, got " .. typeof(func) .. ")")
	end
	return debug_info(func, "s") == "[C]"
end

--[=[
Usage:

local emptyfunction = function() end
local twait = task.wait

print(iscclosure(twait)) --> Outputs "true"
print(iscclosure(emptyfunction)) --> Outputs "false"
]=]
