-- gethiddenproperty.lua
-- © 2025 MrY7zz (MIT License)

--// This implementation can be detected, as it creates a service that
--// Isn't created by default.
local UGCValidationService = game:GetService('UGCValidationService')
local GetPropertyValue = UGCValidationService.GetPropertyValue
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
    if success and result then
        return result
    else
        --// If it didn't return anything, or it didn't succeed,
        --// We try accessing it directly
        local success, result = pcall(__Index, instance, property)
        if success then
            return result
        end
    end
end

--[[
Usage:

print(gethiddenproperty(Instance.new('Motor6D'), 'ReplicateCurrentAngle6D'))
print(gethiddenproperty(workspace, 'Parent')) -- Not hidden, still returns.
]]
