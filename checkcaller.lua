-- checkcaller.lua
-- © 2026 MrY7zz (MIT License)

local debug_info = debug.info

local function newcheckcaller()
	local original_f = debug_info(2, "f")
	local original_s, original_n, original_a1, original_a2 = debug_info(2, "sna")

	return (function()
		for i = 2, 8 do
			if debug_info(i, "f") == original_f then
				return true
			end
		end

		for i = 2, 8 do
			local s, n, a1, a2 = debug_info(i, "sna")
			if s == original_s and a1 == original_a1 and a2 == original_a2 and (original_n == nil or n == nil or n == original_n) then
				return true
			end
		end

		return false
	end)
end

--[=[
Usage:

--// (in the ModuleScript)
checkcaller = newcheckcaller()

local userdata = newproxy(true)
getmetatable(userdata).__index = function(self, key)
	print("is the original caller? " .. tostring(checkcaller()))
end

local nothing = userdata.key --> Output: "is the original caller? true"

return userdata

--// (in the requiring script)
local moduleu = require(ModuleScript.Path)
local nothing = moduleu.key --> Output: "is the original caller? false"
]=]
