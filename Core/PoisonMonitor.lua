local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonMonitorState
---@field configuredPoisonID number?
---@field hasEnchant boolean
---@field enchantID number?
---@field remainingTimeMs number?
---@field charges number?
---@field missing boolean
---@field timeLow boolean
---@field chargesLow boolean

---@class PoisonFlowPoisonAlertState
---@field missing boolean
---@field timeLow boolean
---@field chargesLow boolean

---@class PoisonFlowPoisonMonitor
local PoisonMonitor = {}
PoisonFlow.PoisonMonitor = PoisonMonitor

-- =========================================================
-- Constants
-- =========================================================

local WEAPON_SLOT_MAIN_HAND = 0
local WEAPON_SLOT_OFF_HAND = 1
local UPDATE_INTERVAL = 15

---@type table<string, PoisonFlowPoisonAlertState>
local previousStates = {}

-- =========================================================
-- Helpers
-- =========================================================

---@param hand string
---@return number?
local function GetWeaponSlot(hand)
    if hand == "mainHand" then
        return WEAPON_SLOT_MAIN_HAND
    end

    if hand == "offHand" then
        return WEAPON_SLOT_OFF_HAND
    end

    return nil
end

---@param hand string
---@return number?
local function GetConfiguredPoison(hand)
    local db = PoisonFlow.Database:Get()
    local handData = db[hand]

    if not handData then
        return nil
    end

    return handData.primary
end

---@param state PoisonFlowPoisonMonitorState
---@return PoisonFlowPoisonAlertState
local function CreateAlertState(state)
    return {
        missing = state.missing,
        timeLow = state.timeLow,
        chargesLow = state.chargesLow,
    }
end

-- =========================================================
-- Process State
-- =========================================================

---@param hand string
---@param state PoisonFlowPoisonMonitorState
local function ProcessState(hand, state)
    local previousState = previousStates[hand]

    if previousState then
        if not previousState.missing and state.missing then
            print("PoisonFlow DEBUG: ", hand, "poison missing")
        end

        if not previousState.timeLow and state.timeLow then
            print("PoisonFlow DEBUG: ", hand, "time is low")
        end

        if not previousState.chargesLow and state.chargesLow then
            print("PoisonFlow DEBUG: ", hand, "charge is low")
        end
    end

    previousStates[hand] = CreateAlertState(state)
end

-- =========================================================
-- State
-- =========================================================

---@param hand string
---@return PoisonFlowPoisonMonitorState?
function PoisonMonitor:GetState(hand)
    local weaponSlot = GetWeaponSlot(hand)

    if weaponSlot == nil then
        return nil
    end

    local configuredPoisonID = GetConfiguredPoison(hand)
    local enchant = PoisonFlow.WeaponEnchantService:Get(weaponSlot)

    ---@type PoisonFlowPoisonMonitorState
    local state = {
        configuredPoisonID = configuredPoisonID,
        hasEnchant = enchant ~= nil,
        enchantID = nil,
        remainingTimeMs = nil,
        charges = nil,
        missing = false,
        timeLow = false,
        chargesLow = false,
    }

    if not configuredPoisonID then
        return state
    end
    
    if not enchant then
        state.missing = true
        return state
    end

    state.enchantID = enchant.enchantID
    state.remainingTimeMs = enchant.remainingTimeMs
    state.charges = enchant.charges

    if not configuredPoisonID then
        return state
    end

    local db = PoisonFlow.Database:Get()

    -- =========================================================
    -- Time
    -- =========================================================

    if db.alerts.time.enabled and PoisonFlow.Poison:IsBasedOnTime(configuredPoisonID) then
        local thresholdMs = db.alerts.time.threshold * 60 * 1000
        state.timeLow = enchant.remainingTimeMs <= thresholdMs
    end

    -- =========================================================
    -- Charges
    -- =========================================================

    if db.alerts.charges.enabled and PoisonFlow.Poison:IsBasedOnCharges(configuredPoisonID) then
        state.chargesLow = enchant.charges <= db.alerts.charges.threshold
    end

    return state
end

-- =========================================================
-- Update
-- =========================================================

function PoisonMonitor:Update()
    local mainHandState = self:GetState("mainHand")
    local offHandState = self:GetState("offHand")

    if mainHandState then
        ProcessState("mainHand", mainHandState)
    end

    if offHandState then
        ProcessState("offHand", offHandState)
    end
end

-- =========================================================
-- Initialize
-- =========================================================

function PoisonMonitor:Initialize()
    local frame = CreateFrame("Frame")
    local elapsedSinceUpdate = 0

    frame:SetScript(
        "OnUpdate",
        function(_, elapsed)
            elapsedSinceUpdate = elapsedSinceUpdate + elapsed
            if elapsedSinceUpdate < UPDATE_INTERVAL then
                return
            end
            elapsedSinceUpdate = 0
            self:Update()
        end
    )
end
