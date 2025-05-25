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

### 3. `checkcaller`

Returns `true` if the caller is the original, otherwise returns `false`

**Example:**

```lua
local userdata = newproxy(true)
getmetatable(userdata).__index = function(self, key)
	print("is the original caller? " .. tostring(checkcaller()))
end

local nothing = userdata.key --> Output: "is the original caller? true"
```

### 4. `hookmetamethod`

Hooks a metamethod in a metatable.

**Example:**

```lua
local old
old = hookmetamethod(game, "__index", function(self, key)
	if key == "NotAllowed" then
		return -- Return nothing.
	end
	return old(self, key)
end)
```

*Please note that it should not be implemented as the following example:*

```lua
local hookmetamethod = function(first, metamethod, func)
	local mt = getrawmetatable(first)
	setreadonly(mt, false)
	local old = mt[metamethod]
	mt[metamethod] = func
	return old
end
```

It should be implemented with actual hooking, since the game can access the original `__index` (before changes, after it is changed you can't anymore) with this method:
```lua
local __Index
xpcall(function()
	return game[{}]
end, function()
	__Index = debug.info(2, "f")
end)
-- Now they can do whatever they want with the function
local _workspace = __Index(game, "Workspace")

-- Also with
local __newIndex
xpcall(function()
	game[{}] = {}
end, function()
	__newIndex = debug.info(2, "f")
end)
-- Now they can do this:
__newIndex(workspace.Baseplate, "Parent", nil)
```
