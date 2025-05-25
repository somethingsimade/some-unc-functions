 --[====[

getnamecallmethod.lua
-- Originally © 2024 strawberrys (MIT License)
-- Modified by MrY7zz, 2025 (MIT License)

-- The script creates a function to extract the __namecall method name in Luau

]====]

local OverlapParams_new = OverlapParams.new
local Color3_new = Color3.new
local debug_info = debug.info
local _pcall = pcall
local _xpcall = xpcall
local string_match = string.match

local pattern = "^(.+) is not a valid member of %w+$"

local function extractNamecallHandler()
	return debug_info(2, "f")
end

local function get__namecall(obj)
	local _, handler = _xpcall(function()
		obj:__namecall()
	end, extractNamecallHandler)
	return handler
end

local firstHandler  = get__namecall(OverlapParams_new())
local secondHandler = get__namecall(Color3_new())

local function getnamecallmethod()
	local _, result = _pcall(firstHandler)
	local method = string_match(result, pattern)
	if not method then
		_, result = _pcall(secondHandler)
		method = string_match(result, pattern)
	end
	return method
end

--[=[
Usage:

local userdata = newproxy(true)
getmetatable(userdata).__namecall = function(self, ...)
	print("__namecall method: " .. tostring(getnamecallmethod()))
end

userdata:HelloWorld() --> Output: "__namecall method: HelloWorld"
]=]
