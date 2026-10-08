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
        return L11n.MAIN_HAND
    end
    return L11n.OFF_HAND
end

---@param hand string
---@param state PoisonFlowPoisonStockState
---@return string[]
local function BuildMessages(hand, state)
    local messages = {}
    local handLabel = GetHandLabel(hand)

    -- No primary poison configured
    if not state.primaryItemID then
        return messages
    end

    -- Primary and configured fallback are both empty
    if state.primaryEmpty and state.fallbackItemID and state.fallbackEmpty then
        table.insert(messages, string.format(L11n.ALERT_ALL_POISONS_EMPTY, handLabel))
        return messages
    end

    -- Primary is empty and no fallback is configured
    if state.primaryEmpty and not state.fallbackItemID then
        table.insert(messages, string.format(L11n.ALERT_PRIMARY_POISON_EMPTY_NO_FALLBACK, handLabel))
        return messages
    end

    -- Primary is empty, fallback is available
    if state.primaryEmpty then
        table.insert(messages, string.format(L11n.ALERT_PRIMARY_POISON_EMPTY, handLabel))
        if state.fallbackLow then
            table.insert(messages, string.format(L11n.ALERT_FALLBACK_POISON_LOW, handLabel, state.fallbackCount))
        end
        return messages
    end

    -- Primary is still available but running low.
    if state.primaryLow then
        table.insert(messages, string.format(L11n.ALERT_PRIMARY_POISON_LOW, handLabel, state.primaryCount))
    end

    return messages
end

---@return string[]
function PoisonStockMonitor:GetMessages()
    local messages = {}
    local db = PoisonFlow.Database:Get()

    if not db.alerts.stock.enabled then
        return messages
    end

    local mainHandState = self:GetState("mainHand")
    if mainHandState then
        local mainHandMessages = BuildMessages("mainHand", mainHandState)
        for _, message in ipairs(mainHandMessages) do
            table.insert(messages, message)
        end
    end

    local offHandState = self:GetState("offHand")
    if offHandState then
        local offHandMessages = BuildMessages("offHand", offHandState)
        for _, message in ipairs(offHandMessages) do
            table.insert(messages, message)
        end
    end

    return messages
end

-- =========================================================
-- Update Messages
-- =========================================================

function PoisonStockMonitor:Update()
    local messages = self:GetMessages()
    PoisonFlow.StockWarnings:SetMessages(messages)
end