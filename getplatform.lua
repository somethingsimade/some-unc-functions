-- getplatform.lua
-- © 2026 MrY7zz (MIT License)

--// Yes some checks are AI generated (Windows timezone, iOS and some others)
--// And AI renamed some of the variables

--// Credits to devforum (give me the links to the posts if you can find them, open an issue)

--// Services
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local TextService = game:GetService("TextService")

local string_sub, string_match, string_lower, string_len = string.sub, string.match, string.lower, string.len
local os_date, tonumber, tostring, type, typeof, pcall, xpcall, debug_info = os.date, tonumber, tostring, type, typeof, pcall, xpcall, debug.info

local instanceIndex
xpcall(function()
	return game[{}]
end, function()
	instanceIndex = debug.info(2, "f")
end)

local enumIndex
xpcall(function()
	return Enum.Platform[{}]
end, function()
	enumIndex = debug.info(2, "f")
end)

--// Cache Methods
local GetTextSize = TextService.GetTextSize
local IsTenFootInterface = GuiService.IsTenFootInterface
local GetImageForKeyCode = UserInputService.GetImageForKeyCode
local us = UserSettings()
local IsUserFeatureEnabled = us.IsUserFeatureEnabled

local Enum_Platform = Enum.Platform
local Enum_KeyCode = Enum.KeyCode

local Plat_None = enumIndex(Enum_Platform, "None")
local Plat_UWP = enumIndex(Enum_Platform, "UWP")
local Plat_XBoxOne = enumIndex(Enum_Platform, "XBoxOne")
local Plat_Windows = enumIndex(Enum_Platform, "Windows")
local Plat_Linux = enumIndex(Enum_Platform, "Linux")
local Plat_OSX = enumIndex(Enum_Platform, "OSX")
local Plat_PS4 = enumIndex(Enum_Platform, "PS4")
local Plat_PS5 = enumIndex(Enum_Platform, "PS5")
local Plat_MetaOS = enumIndex(Enum_Platform, "MetaOS")
local Plat_Android = enumIndex(Enum_Platform, "Android")
local Plat_IOS = enumIndex(Enum_Platform, "IOS")

local KeyCode_ButtonSelect = enumIndex(Enum_KeyCode, "ButtonSelect")

--// Pre-configuration
local TextSettings = {
	16,
	"SourceSans",
	Vector2.new(1000, 1000),
}

local invalidSize = GetTextSize(TextService, "\u{FFFF}", unpack(TextSettings))
local _version = version()

local vPrefix = string_sub(_version, 1, 2)
local Web = (vPrefix == "0.")
local MobileUwpOrVr = (vPrefix == "2." or vPrefix == "3.")

--// Helpers
local function isValidCharacter(character)
	local size = GetTextSize(TextService, character, unpack(TextSettings))
	return size.Magnitude ~= invalidSize.Magnitude
end

local function getArchitecture()
	local address = tonumber(string_sub(tostring({math.huge}), 8))

	if string_len(tostring(address)) <= 10 then
		return 32
	end

	return 64
end

--// Timezone detections (new method)

-- Windows
local function isWindowsTimezone(value)
	if typeof(value) ~= "string" then return false end

	local s = (value):gsub("^%s+", ""):gsub("%s+$", "")
	if s == "" or string_sub(s, 1, 4) == "(UTC" then return false end

	if string_lower(string_sub(s, -7)) == "_dstoff" then
		s = string_sub(s, 1, -8):gsub("%s+$", "")
		if s == "" then return false end
	end

	if #s > 80 or string_match(s, "[^A-Za-z0-9 .,'&/%(%)+%-]") then return false end
	if s == "UTC" then return true end

	local hh = string_match(s, "^UTC[%+%-](%d%d)$")
	if hh then
		local n = tonumber(hh)
		if n and n >= 0 and n <= 14 then return true end
	end

	if string_sub(s, -14) == " Standard Time" or string_match(s, " Standard Time%s*%b()$") then return true end
	if string_sub(s, -14) == " Daylight Time" or string_match(s, " Daylight Time%s*%b()$") then return true end

	if string_match(s, "^.+ Time Zone %d%d?$") then return true end
	return false
end

-- IOS
local function matchesIOS(s)
	return string_match(s, "^[+-]%d%d%d?%d?$") ~= nil
		or string_match(s, "^%a%a%a%a?%a?$") ~= nil
end

local isWindowsSucceeded, isWindows = pcall(function()
	return instanceIndex(GuiService, "IsWindows")
end)

@native
local function GetPlatform() 
	local timeZone = os_date("%Z")

	if type(timeZone) ~= "string" then
		return Plat_None
	end
	
	local isWindowsTz = isWindowsTimezone(timeZone)

	-- Executing the cached methods by passing 'self'
	local Console = IsTenFootInterface(GuiService)
	local VR = instanceIndex(UserInputService, "VREnabled") and instanceIndex(VRService, "VREnabled")
	
	-- Console
	if Console then
		local rbxassetForKeycode = string_lower(GetImageForKeyCode(UserInputService, KeyCode_ButtonSelect))
		local triggerButtonName = enumIndex(enumIndex(Enum_KeyCode, "ButtonL2"), "Name")

		if triggerButtonName == "ButtonL2" then --// PlayStation
			if string_match(rbxassetForKeycode, "ps4") then
				return Plat_PS4
			elseif string_match(rbxassetForKeycode, "ps5") then 
				return Plat_PS5
			end
		elseif triggerButtonName == "ButtonLT" then --// Xbox
			if string_match(rbxassetForKeycode, "xbox") or isWindowsTz then 
				--// OneStatFrame detection wouldn't work 1. LocalScripts can't access instances inside CoreGui and even more recently Roblox made CoreGui nil for LocalScripts...
				return Plat_XBoxOne
			end
		end
	end

	--// We are operating on windows
	if not isWindowsSucceeded then
		if MobileUwpOrVr and isWindowsTz then
			return Plat_UWP
		elseif Console and isWindowsTz then 
			return Plat_XBoxOne
		elseif isWindowsTz and Web then
			return Plat_Windows
		end
	elseif isWindows then
		if MobileUwpOrVr and isWindowsTz then
			return Plat_UWP
		elseif Console then
			return Plat_XBoxOne
		elseif isValidCharacter("\u{E0FF}") then
			return Plat_Linux
		end
		--// ^ Maybe leave outside isWindows check

		if isWindowsTz and Web then
			return Plat_Windows
		end
	end

	--// More checks

	-- OSX
	local hasTouch = instanceIndex(UserInputService, "TouchEnabled")
	local success1, UserFixOrbitalCam = pcall(IsUserFeatureEnabled, us, "UserFixOrbitalCam")

	if success1 and UserFixOrbitalCam then
		local success2, UserInputRefactor2 = pcall(IsUserFeatureEnabled, us, "UserInputRefactor2")
		if success2 and UserInputRefactor2 then
			return Plat_OSX
		end
	end
	
	if isValidCharacter("\u{F8FF}") and not hasTouch then
		return Plat_OSX
	end
	
	-- Final checks
	if MobileUwpOrVr then
		if VR then
			return Plat_MetaOS
		end

		local hasAccel = instanceIndex(UserInputService, "AccelerometerEnabled")
		local hasGyro = instanceIndex(UserInputService, "GyroscopeEnabled")

		if not hasAccel and not hasGyro then --// No hasTouch since some laptops have touchscreen
			return Plat_Linux -- Sober
		end

		if getArchitecture() == 32 or not isValidCharacter("\u{F8FF}") then
			return Plat_Android
		end

		if matchesIOS(timeZone) then
			return Plat_IOS
		end
		
		local success3, FFlagUserHandleChatHotKey = pcall(IsUserFeatureEnabled, us, "FFlagUserHandleChatHotKeyWithContextActionService")
		local isDesktopDPI = GetTextSize(TextService, utf8.char(0xFFFD), unpack(TextSettings)).X >= 12.8
			
		if success3 and (FFlagUserHandleChatHotKey or isDesktopDPI) then
			return Plat_Linux -- Sober
		end
	elseif VR then
		-- There isn't another VR platform, at least in Enum.Platform
	end

	return Plat_None
end

--[==[
Usage:

if GetPlatform() == Enum.Platform.PS5 then
	print("PS6 Better")
	game:Shutdown()
end

]==]
