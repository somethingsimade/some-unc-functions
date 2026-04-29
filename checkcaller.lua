-- checkcaller.lua
-- © 2026 MrY7zz (MIT License)

local debug_info = debug.info
local math_huge = math.huge
local coroutine_running = coroutine.running

local function newcheckcaller(supportloadstring)
	if supportloadstring then
		local original_t = coroutine_running()

		return (function()
			if coroutine_running() == original_t then
				return true
			end

			return false
		end)
	elseif not supportloadstring then
		local original_f = debug_info(2, "f")
		local original_s, original_n, original_a1, original_a2 = debug_info(2, "sna")
		local original_t = coroutine_running()

		return (function()
			local t = coroutine_running()

			for i = 2, math_huge do
				local s, n, a1, a2 = debug_info(i, "sna")
				if t == original_t and s == original_s and a1 == original_a1 and a2 == original_a2 and (original_n == nil or n == nil or n == original_n) then
					return true
				end

				local f = debug_info(i, "f")

				if f == nil then
					break
				end

				if t == original_t and original_f ~= nil and f == original_f then
					return true
				end
			end

			return false
		end)
	end
end

--[=[
Usage:

--// (in the ModuleScript)
checkcaller = newcheckcaller(true) --// Takes a boolean, true = checkcaller returns true inside a loadstring,
                                   --   however, the checks will be weaker. false = Returns false inside a loadstring and keeps the stack check

local function test()
	print(checkcaller())
end
test() --> "true"

return test

--// (in the requiring script)
local modulef = require(ModuleScript.Path)
modulef() --> "false"
]=]
