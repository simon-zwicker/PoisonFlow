local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonSelection
---@field itemID number
---@field isFallback boolean

---@class PoisonFlowPoisonService
local PoisonService = {}
PoisonFlow.PoisonService = PoisonService

-- =========================================================
-- Helpers
-- =========================================================

---@param itemID number?
---@return boolean
local function IsAvailable(itemID)
    if not itemID then
        return false
    end

    return C_Item.GetItemCount(
        itemID,
        false,
        false,
        false
    ) > 0
end

-- =========================================================
-- Configuration
-- =========================================================

---@param hand string
---@return boolean
function PoisonService:IsConfigured(hand)
    local db = PoisonFlow.Database:Get()
    local config = db and db[hand]

    if not config then
        return false
    end

    return config.primary ~= nil
        or config.fallback ~= nil
end

-- =========================================================
-- Selection
-- =========================================================

---@param hand string
---@return PoisonFlowPoisonSelection?
function PoisonService:GetForHand(hand)
    local db = PoisonFlow.Database:Get()
    local config = db and db[hand]

    if not config then
        return nil
    end

    if IsAvailable(config.primary) then
        return {
            itemID = config.primary,
            isFallback = false,
        }
    end

    if IsAvailable(config.fallback) then
        return {
            itemID = config.fallback,
            isFallback = true,
        }
    end

    return nil
end