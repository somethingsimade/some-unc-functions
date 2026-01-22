--[====[

getnamecallmethod.lua
-- Originally © 2024 strawberrys (MIT License)
-- Modified by MrY7zz, 2026 (MIT License)

-- The script creates a function to extract the __namecall method name in Luau

]====]

local OverlapParams_new, debug_info, _pcall, _xpcall, string_find, string_sub = OverlapParams.new, debug.info, pcall, xpcall, string.find, string.sub

local _, handler = _xpcall(function()
	OverlapParams_new():__namecall()
end, function()
	return debug_info(2, "f")
end)

function getnamecallmethod()
	local _, r = _pcall(handler)
	local s = string_find(r, " is not a valid", 1, true)
	return s and string_sub(r, 1, s - 1) or "AddToFilter"
end

--[=[
Usage:

local userdata = newproxy(true)
getmetatable(userdata).__namecall = function(self, ...)
	print("__namecall method: " .. tostring(getnamecallmethod()))
end

userdata:HelloWorld() --> Output: "__namecall method: HelloWorld"
]=]
