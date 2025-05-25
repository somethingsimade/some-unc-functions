# some-unc-functions
Some functions i spent time on, that will be added to Extended API

# Documentation
1. getcallingscript
It is used to get the script that called the function. Not 100% of the times it will work. See file getcallingscript.lua to know its limits.
```lua
local userdata = newproxy(true)
getmetatable(userdata).__index = function(self, key)
	if key == "KeyThatPrints" then
		print(tostring(getcallingscript()) .. " has the key that prints.")
	end
end

local access = userdata.KeyThatPrints --> Output: "(script name) has the key that prints."
```
2. getnamecallmethod
It is used to get the __namecall method name which was called. If there is none it is going to return "__namecall".
```lua
local userdata = newproxy(true)
getmetatable(userdata).__namecall = function(self, ...)
	print("__namecall method: " .. tostring(getnamecallmethod()))
end

userdata:HelloWorld() --> Output: "__namecall method: HelloWorld"
```
