# some-unc-functions
Some functions i spent time on, that will be added to Extended API

## Documentation

### 1. `getcallingscript`

Returns the script that called the function. This may not always work, look at the code inside `getcallingscript.lua` to know its limitations.

**Example:**

```lua
local userdata = newproxy(true)
getmetatable(userdata).__index = function(self, key)
	if key == "KeyThatPrints" then
		print(tostring(getcallingscript()) .. " has the key that prints.")
	end
end

local access = userdata.KeyThatPrints --> Output: "(script name) has the key that prints."
```

---

### 2. `getnamecallmethod`

Returns the name of the invoked `__namecall` method. If no method name is found, it will return `"__namecall"`.

**Example:**

```lua
local userdata = newproxy(true)
getmetatable(userdata).__namecall = function(self, ...)
	print("__namecall method: " .. tostring(getnamecallmethod()))
end

userdata:HelloWorld() --> Output: "__namecall method: HelloWorld"
```
