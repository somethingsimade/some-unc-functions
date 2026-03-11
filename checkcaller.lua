-- checkcaller.lua
-- © 2026 MrY7zz (MIT License)

local debug_info = debug.info

local function newcheckcaller()
	local original_f = debug_info(2, "f")
	local original_s, original_l, original_n, original_a1, original_a2 =
		debug_info(2, "slna")

	return (function()
		for i = 2, 8 do
			if debug_info(i, "f") == original_f then
				return true
			end
		end

		for i = 2, 8 do
			local s, l, n, a1, a2 = debug_info(i, "slna")
			if s == original_s
				and l == original_l
				and a1 == original_a1
				and a2 == original_a2
				and (original_n == nil or n == nil or n == original_n)
			then
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

local function test()
	print(checkcaller())
end
test() --> "true"

return test

--// (in the requiring script)
local modulef = require(ModuleScript.Path)
modulef() --> "false"
]=]
