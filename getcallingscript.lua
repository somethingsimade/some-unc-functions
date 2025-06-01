-- getcallingscript.lua
-- © 2025 MrY7zz (MIT License)

-- // Caching
local game = Game
local DescendantRemoving = game.DescendantRemoving
local DescendantAdded = game.DescendantAdded
local GetDescendants = game.GetDescendants
local Connect = DescendantRemoving.Connect
local table = table
local table_insert = table.insert
local table_freeze = table.freeze

local debug = debug
local debug_info = debug.info
local debug_traceback = debug.traceback
local string_gmatch   = string.gmatch
local string_find   = string.find
local string_sub   = string.sub
local string_match   = string.match
local _xpcall   = xpcall
local _getfenv   = getfenv
local _rawget   = rawget
local _typeof   = typeof
local _ipairs   = ipairs
local _tostring   = tostring
local IsA  = game.IsA
local RunContext = Enum.RunContext

-- // Allows for more instances to be captured.
-- // Earlier this starts = more chance (of course if the instances are LocalScripts etc..)
local tblnil = {}
local tblvalid = {}
Connect(DescendantRemoving, function(d)
	table_insert(tblnil, d)
end)
Connect(DescendantAdded, function(d)
	table_insert(tblvalid, d)
end)
for i, v in ipairs(GetDescendants(game)) do
	table_insert(tblvalid, v)
end

local getnilinstances = getnilinstances
local getinstances = getinstances

if not getnilinstances then
	getnilinstances = function()
		return table_freeze(tblnil)
	end
end

if not getinstances then
	getinstances = function()
		local tbltmp = {}
		for i, v in ipairs(tblnil) do
			table_insert(tbltmp, v)
		end
		for i, v in ipairs(tblvalid) do
			table_insert(tbltmp, v)
		end
		return table_freeze(tbltmp)
	end
end

local dummy = {}
local returndebug  = function() return debug_info(2, "f") end

local indexinstance
_xpcall(
	function() return game[dummy] end,
	function() indexinstance = returndebug() end
)

local function getInstance(path)
	local current = game
	if path == "game" then 
		return game
	end
	if string_sub(path, 1, 5) == "game." then 
		path = string_sub(path, 6) 
	end
	if not string_find(path, "%.", 1, true) then 
		return 
	end
	for seg in string_gmatch(path, "[^%.]+") do
		current = indexinstance(current, seg)
		if not current then 
			return 
		end
	end
	return current
end

-- // Main function
getcallingscript = function()
	local src = debug_info(1, "s")
	local inst = getInstance(src)
	if inst then 
		return inst 
	end

	for i = 1, 3 do
		local f = debug_info(i, "f")
		if f then
			local env = _getfenv(f)
			local s   = _rawget(env, "script")
			if _typeof(s) == "Instance" and IsA(s, "LuaSourceContainer") then
				return s
			end
		end
	end

	local tb = debug_traceback()
	local path = string_match(tb, "([%w%.]+):%d+")
	if path then
		for _, v in _ipairs(getinstances()) do
			if IsA(v, "LuaSourceContainer") then
				if (v:IsA("LocalScript") or (v:IsA("Script") and v.RunContext == RunContext.Client))
				   and v:GetFullName() == path then
					return v
				end
			end
		end
	end
end

--[==[
Usage:

local userdata = newproxy(true)
getmetatable(userdata).__index = function(self, key)
	if key == "KeyThatPrints" then
		print(tostring(getcallingscript()) .. " has the key that prints.")
	end
end

local access = userdata.KeyThatPrints
]==]
