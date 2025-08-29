-- setnamecallmethod.lua
-- © 2025 MrY7zz (MIT License)

local _Instance = Instance.new("BuoyancySensor")

local function setnamecallmethod(method)
	if type(method) ~= "string" then
		return error("invalid argument #1 to 'setnamecallmethod' (string expected, got " .. typeof(method) .. ")")
	end
	
	local res = loadstring("local args = { ... }; local instance = args[1]; instance:" .. method .. "()")
	pcall(res, _Instance)
end

--[=[
Usage:

local _, namecall = xpcall(function()
	return game:__namecall()
end, function()
	return debug.info(2, "f")
end)

local patched__namecall = function(instance, method, ...)
	setnamecallmethod(method)

	return namecall(instance, ...)
end

print(patched__namecall(game, "FindFirstChild", "Workspace")) --> Output: Workspace

--> Or you can do this: <--

local _, namecall = xpcall(function()
	return game:__namecall()
end, function()
	return debug.info(2, "f")
end)

setnamecallmethod("FindFirstChild")

print(namecall(game, "Workspace"))
]=]
