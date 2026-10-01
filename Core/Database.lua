local PoisonFlow = _G.PoisonFlow
local Database = {}

PoisonFlow.Database = Database

local DEFAULTS = {
    version = 1,
    mainHand = {
        primary = nil,
        fallback = nil,
        monitor = {
            time = true,
            charges = true,
            timeThreshold = 120,
            chargeThreshold = 5,
        }
    },
    offHand = {
        primary = nil,
        fallback = nil,
        monitor = {
            time = true,
            charges = true,
            timeThreshold = 120,
            chargeThreshold = 5,
        }
    },
}

local function ApplyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            
            ApplyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

function Database:Initialize()
    if type(PoisonFlowDB) ~= "table" then
        PoisonFlowDB = {}
    end

    ApplyDefaults(PoisonFlowDB, DEFAULTS)
end

function Database:Get()
    return PoisonFlowDB
end