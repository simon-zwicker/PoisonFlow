local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonStockState
---@field primaryItemID number?
---@field primaryCount number
---@field primaryLow boolean
---@field primaryEmpty boolean
---@field fallbackItemID number?
---@field fallbackCount number
---@field fallbackLow boolean
---@field fallbackEmpty boolean
---@field usingFallback boolean
---@field completelyEmpty boolean

---@class PoisonFlowWarnings
---@field id string
---@field stateKey string
---@field weaponSlot number
---@field headline string
---@field description string
---@field severity string

---@class PoisonFlowPoisonStockMonitor
local PoisonStockMonitor = {}
PoisonFlow.PoisonStockMonitor = PoisonStockMonitor

-- =========================================================
-- Helpers
-- =========================================================

---@param itemID number?
---@return number
local function GetItemCount(itemID)
    if not itemID then
        return 0
    end
    return C_Item.GetItemCount(itemID) or 0
end

-- =========================================================
-- State
-- =========================================================

---@param hand string
---@return PoisonFlowPoisonStockState?
function PoisonStockMonitor:GetState(hand)
    local db = PoisonFlow.Database:Get()
    local handData = db[hand]

    if not handData then
        return nil
    end

    local primaryItemID = handData.primary
    local fallbackItemID = handData.fallback
    local primaryCount = GetItemCount(primaryItemID)
    local fallbackCount = GetItemCount(fallbackItemID)
    local threshold = db.alerts.stock.threshold
    local primaryEmpty = primaryItemID ~= nil and primaryCount == 0
    local fallbackEmpty = fallbackItemID ~= nil and fallbackCount == 0
    local primaryLow = primaryItemID ~= nil and primaryCount > 0 and primaryCount <= threshold
    local fallbackLow = fallbackItemID ~= nil and fallbackCount > 0 and fallbackCount <= threshold
    local usingFallback = primaryEmpty and fallbackItemID ~= nil and fallbackCount > 0
    local completelyEmpty = primaryEmpty and (fallbackItemID == nil or fallbackEmpty)

    ---@type PoisonFlowPoisonStockState
    return {
        primaryItemID = primaryItemID,
        primaryCount = primaryCount,
        primaryLow = primaryLow,
        primaryEmpty = primaryEmpty,

        fallbackItemID = fallbackItemID,
        fallbackCount = fallbackCount,
        fallbackLow = fallbackLow,
        fallbackEmpty = fallbackEmpty,

        usingFallback = usingFallback,
        completelyEmpty = completelyEmpty,
    }
end

---@param hand string
---@return string
local function GetHandLabel(hand)
    if hand == "mainHand" then
        return L11n.Main.MAIN_HAND
    end
    return L11n.Main.OFF_HAND
end

-- =========================================================
-- Build Warnings
-- =========================================================

---@param hand string
---@param state PoisonFlowPoisonStockState
---@return PoisonFlowWarnings[]
local function BuildWarnings(hand, state)
    ---@type PoisonFlowWarnings[]
    local warnings = {}

    if not state.primaryItemID then
        return warnings
    end

    local handLabel = GetHandLabel(hand)
    local weaponSlot = hand == "mainHand" and 16 or 17

    ---@param warningType string
    ---@param headline string
    ---@param description string
    ---@param severity string
    local function AddWarning(warningType, headline, description, severity)
        table.insert(
            warnings,
            {
                id = "stock:" .. hand .. ":" .. warningType,
                stateKey = warningType,
                weaponSlot = weaponSlot,
                headline = headline,
                description = description,
                severity = severity,
            }
        )
    end

    -- Primary and fallback are both empty
    if state.primaryEmpty and state.fallbackItemID and state.fallbackEmpty then
        AddWarning(
            "allEmpty",
            L11n.Warning.TITLE_ALL_EMPTY,
            string.format(
                L11n.Warning.MESSAGE_ALL_EMPTY,
                handLabel
            ),
            "danger"
        )

        return warnings
    end

    -- Primary empty without fallback
    if state.primaryEmpty and not state.fallbackItemID then
        AddWarning(
            "noFallback",
            L11n.Warning.TITLE_NO_FALLBACK,
            string.format(
                L11n.Warning.MESSAGE_NO_FALLBACK,
                handLabel
            ),
            "danger"
        )
        return warnings
    end

    -- Primary empty, fallback available
    if state.primaryEmpty then
        AddWarning(
            "primaryEmpty",
            L11n.Warning.TITLE_PRIMARY_EMPTY,
            string.format(
                L11n.Warning.MESSAGE_PRIMARY_EMPTY,
                handLabel
            ),
            "danger"
        )

        if state.fallbackLow then
            AddWarning(
                "fallbackLow",
                L11n.Warning.TITLE_FALLBACK_LOW,
                string.format(
                    L11n.Warning.MESSAGE_FALLBACK_LOW,
                    handLabel,
                    state.fallbackCount
                ),
                "warning"
            )
        end
        return warnings
    end

    -- Primary running low
    if state.primaryLow then
        AddWarning(
            "primaryLow",
            L11n.Warning.TITLE_PRIMARY_LOW,
            string.format(
                L11n.Warning.MESSAGE_PRIMARY_LOW,
                handLabel,
                state.primaryCount
            ),
            "warning"
        )
    end

    return warnings
end

-- =========================================================
-- Get Warnings
-- =========================================================

---@return PoisonFlowWarnings[]
function PoisonStockMonitor:GetWarnings()
    ---@type PoisonFlowWarnings[]
    local warnings = {}
    local db = PoisonFlow.Database:Get()

    if not db.alerts.stock.enabled then
        return warnings
    end

    local hands = { "mainHand", "offHand", }

    for _, hand in ipairs(hands) do
        local state = self:GetState(hand)
        if state then
            local handWarnings = BuildWarnings(hand, state)
            for _, warning in ipairs(handWarnings) do
                table.insert(warnings, warning)
            end
        end
    end

    return warnings
end

-- =========================================================
-- Update Warnings
-- =========================================================

function PoisonStockMonitor:Update()
    local warnings = self:GetWarnings()
    local manager = PoisonFlow.WarningManager
    if not manager or not manager.Container then
        return
    end

    local activeIDs = {}
    for _, warning in ipairs(warnings) do
        activeIDs[warning.id] = true

        manager:Show(
            warning.id,
            {
                weaponSlot = warning.weaponSlot,
                headline = warning.headline,
                description = warning.description,
                severity = warning.severity,
            },
            warning.stateKey
        )
    end

    -- Remove warnings that are no longer relevant.
    for id in pairs(manager.Entries) do
        if string.sub(id, 1, 6) == "stock:" and not activeIDs[id] then
            manager:Remove(id)
        end
    end
end