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
    local count = C_Item.GetItemCount(itemID)
    return count > 0
end

-- =========================================================
-- Selection
-- =========================================================

---@param hand string
---@return PoisonFlowPoisonSelection?
function PoisonService:GetForHand(hand)
    local db = PoisonFlow.Database:Get()
    local handData = db[hand]

    if not handData then
        return nil
    end

    local primary = handData.primary

    if IsAvailable(primary) then
        return {
            itemID = primary,
            isFallback = false,
        }
    end

    local fallback = handData.fallback

    if IsAvailable(fallback) then
        return {
            itemID = fallback,
            isFallback = true,
        }
    end

    return nil
end