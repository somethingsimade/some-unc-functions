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

--// Pre-configuration
local TextSettings = {
	16,
	"SourceSans",
	Vector2.one * 1000,
}

local invalidSize = TextService:GetTextSize("\u{FFFF}", unpack(TextSettings))
local _version = version()

--// Helpers
local function isValidCharacter(character)
	local size = TextService:GetTextSize(character, unpack(TextSettings))

	return size.Magnitude ~= invalidSize.Magnitude
end

local function getArchitecture()
	local address = tonumber(string.sub(tostring{math.huge}, 8))

	if string.len(tostring(address)) <= 10 then
		return 32
	end

	return 64
end

--// Timezone detections (new method)

-- Windows
local function isWindowsTimezone(value)
	if typeof(value) ~= "string" then return false end

	local s = (value):gsub("^%s+", ""):gsub("%s+$", "")
	if s == "" or s:sub(1, 4) == "(UTC" then return false end

	if s:lower():sub(-7) == "_dstoff" then
		s = s:sub(1, -8):gsub("%s+$", "")
		if s == "" then return false end
	end

	if #s > 80 or s:find("[^A-Za-z0-9 .,'&/%(%)+%-]") then return false end
	if s == "UTC" then return true end

	local hh = s:match("^UTC[%+%-](%d%d)$")
	if hh then
		local n = tonumber(hh)
		if n and n >= 0 and n <= 14 then return true end
	end

	if s:sub(-14) == " Standard Time" or s:match(" Standard Time%s*%b()$") then return true end
	if s:sub(-14) == " Daylight Time" or s:match(" Daylight Time%s*%b()$") then return true end

	if s:match("^.+ Time Zone %d%d?$") then return true end
	return false
end

-- IOS
local function matchesIOS(s)
	return s:match("^[+-]%d%d%d?%d?$") ~= nil
		or s:match("^%a%a%a%a?%a?$") ~= nil
end

local isWindowsSucceeded, isWindows = pcall(function()
	return GuiService.IsWindows
end)

local function GetPlatform() 
	local timeZone = os.date("%Z")
	local touchEnabled = UserInputService.TouchEnabled

	if type(timeZone) ~= "string" then
		return Enum.Platform.None
	end

	local isWindowsTimezoneDetected = isWindowsTimezone(timeZone)
	local timezoneMatchesIOS = matchesIOS(timeZone)

	local Web = string.match(_version, "^0%.") ~= nil
	local Console = GuiService:IsTenFootInterface()
	local MobileUwpOrVr = string.match(_version, "^2%.") ~= nil or string.match(_version, "^3%.") ~= nil
	local VR = UserInputService.VREnabled and VRService.VREnabled

	--// We are operating on windows
	if not isWindowsSucceeded then
		if MobileUwpOrVr and isWindowsTimezoneDetected then
			return Enum.Platform.UWP
		elseif Console and isWindowsTimezoneDetected then 
			return Enum.Platform.XBoxOne
		elseif isWindowsTimezoneDetected and Web then
			return Enum.Platform.Windows
		end
	elseif isWindows then
		if MobileUwpOrVr and isWindowsTimezoneDetected then
			return Enum.Platform.UWP
		elseif Console then
			return Enum.Platform.XBoxOne
		elseif isValidCharacter("\u{E0FF}") then
			return Enum.Platform.Linux
		end
		--// ^ Maybe leave outside isWindows check

		if isWindowsTimezoneDetected and Web then
			return Enum.Platform.Windows
		end
	end

	--// More checks

	-- OSX
	local success1, UserFixOrbitalCam = pcall(UserSettings().IsUserFeatureEnabled, UserSettings(), "UserFixOrbitalCam")
	local success2, UserInputRefactor2 = pcall(UserSettings().IsUserFeatureEnabled, UserSettings(), "UserInputRefactor2")

	if (success1 and success2) and (UserFixOrbitalCam and UserInputRefactor2) and isValidCharacter("\u{F8FF}") then
		return Enum.Platform.OSX
	end

	-- Console

	if Console then
		local rbxassetForKeycode = string.lower(UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect))

		if string.match(rbxassetForKeycode, "ps4") then
			return Enum.Platform.PS4
		elseif string.match(rbxassetForKeycode, "ps5") then 
			return Enum.Platform.PS5
		elseif string.match(rbxassetForKeycode, "xbox") or isWindowsTimezoneDetected then --// OneStatFrame detection wouldn't work 1. LocalScripts can't access instances inside CoreGui and even more recently Roblox made CoreGui nil for LocalScripts...
			return Enum.Platform.XBoxOne
		end
	end

	-- Final checks
	if MobileUwpOrVr then
		if VR then
			return Enum.Platform.MetaOS
		elseif getArchitecture() == 32 or not isValidCharacter("\u{F8FF}") then
			if not UserInputService.TouchEnabled and isValidCharacter("\u{E0FF}") then
				return Enum.Platform.Linux -- "Sober"
			end

			return Enum.Platform.Android
		end

		if timezoneMatchesIOS then
			return Enum.Platform.IOS
		end
	elseif VR then
		-- There isn't another VR platform, at least in Enum.Platform
	end

	return Enum.Platform.None
end

--[==[
Usage:

if GetPlatform() == Enum.Platform.PS5 then
	print("PS6 Better")
	game:Shutdown()
end

]==]
