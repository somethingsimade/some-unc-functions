-- setsimulationradius.lua
-- © 2025 MrY7zz (MIT License)

local Players = game:GetService("Players")

local newIndex
local Index

--// Extracting __newindex
xpcall(function()
	game[{}] = {}
end, function()
	newIndex = debug.info(2, "f")
end)

--// Extracting __index
xpcall(function()
	return game[{}]
end, function()
	Index = debug.info(2, "f")
end)


function setsimulationradius(Radius, maxRadius)
	local LocalPlayer = Index(Players, "LocalPlayer")
	newIndex(LocalPlayer, "SimulationRadius", Radius)
	
	if maxRadius then
		newIndex(LocalPlayer, "MaximumSimulationRadius", maxRadius)
	end
end

--[=[
Usage:

local radius = 100 --// Let's take for example, 100, we will set the simulation radius to 100.
local maxradius = 150 --// Let's set the maximum radius to 150, for example.

setsimulationradius(radius, maxradius) --// Now the radius is 100, and the maximum radius is 150.

]=]
