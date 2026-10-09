local PoisonFlow = _G.PoisonFlow

-- =====================================================
-- Types
-- =====================================================

---@class PoisonFlowDatabase
local Database = {}

PoisonFlow.Database = Database

local DEFAULTS = {
    version = 1,
    mainHand = {
        primary = nil,
        fallback = nil,
    },
    offHand = {
        primary = nil,
        fallback = nil,
    },
    alerts = {
        time = {
            enabled = true,
            threshold = 2,
        },
        charges = {
            enabled = true,
            threshold = 5,
        },
        stock = {
            enabled = true,
            threshold = 5,
        },
    },
    minimap = {
        angle = 225,
    },
    poisonFlowButton = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = 0,
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