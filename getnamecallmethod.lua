--[====[

getnamecallmethod.lua
-- Originally © 2024 strawberrys (MIT License)
-- Modified by MrY7zz, 2025 (MIT License)

-- The script creates a function to extract the __namecall method name in Luau

]====]

local OverlapParams_new, debug_info, _pcall, _xpcall, string_find, string_sub = OverlapParams.new, debug.info, pcall, xpcall, string.find, string.sub
local pattern = " is not a valid"
local savedstring = "missing argument #1 (OverlapParams expected)"

local _, handler = _xpcall(function()
	OverlapParams_new():__namecall()
end, function()
	return debug_info(2, "f")
end)

function getnamecallmethod()
	local _, result = _pcall(handler)

	if result == savedstring then
		return "AddToFilter"
	end

	if string_find(result, pattern, 1, true) then
		local stop = string_find(result, " is not a valid", 1, true)
		return string_sub(result, 1, stop - 1)
	end
end

--[=[
Usage:

local userdata = newproxy(true)
getmetatable(userdata).__namecall = function(self, ...)
	print("__namecall method: " .. tostring(getnamecallmethod()))
end

userdata:HelloWorld() --> Output: "__namecall method: HelloWorld"
]=]
