-- gethiddenproperty.lua
-- © 2026 MrY7zz (MIT License)

--// This implementation can be detected, as it creates a service that
--// Isn't created by default.
local UGCValidationService = game:GetService('UGCValidationService')
local GetPropertyValue = UGCValidationService.GetPropertyValue
local FindFirstChild = game.FindFirstChild
local __Index
xpcall(function()
    return game[{}]
end, function()
    __Index = debug.info(2, 'f')
end)

function gethiddenproperty(instance, property)
    --// First we try to get the property with UGCValidationService
    --// This won't work 100% of the times
    local success, result = pcall(function()
        return GetPropertyValue(UGCValidationService, instance, property)
    end)
    if success and result ~= nil then
        return result, true
    else
        if FindFirstChild(instance, property) ~= nil then return nil end --// Prevent indexing an instance instead of a property
        --// If it didn't return anything, or it didn't succeed,
        --// We try accessing it directly
         local success2, result2 = pcall(__Index, instance, property)
        if success2 then
            return result2, false
        else
            return __Index(instance, property)
        end
    end
    return nil
end

--[[
Usage:

print(gethiddenproperty(Instance.new('Motor6D'), 'ReplicateCurrentAngle6D'))
print(gethiddenproperty(workspace, 'Parent')) -- Not hidden, still returns.
]]
