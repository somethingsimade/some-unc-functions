-- islclosure.lua
-- © 2025 MrY7zz (MIT License)

local debug_info = debug.info

function islclosure(func)
	if typeof(func) ~= "function" then
		error("invalid argument #1 to 'islclosure' (function expected, got " .. typeof(func) .. ")")
	end
	return debug_info(func, "s") ~= "[C]"
end

--[=[
Usage:

local emptyfunction = function() end
local twait = task.wait

print(islclosure(twait)) --> Outputs "false"
print(islclosure(emptyfunction)) --> Outputs "true"
]=]
