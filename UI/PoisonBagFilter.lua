local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonBagFilter
---@field Active boolean
---@field Hand string?
---@field SlotType string?
local PoisonBagFilter = {}

PoisonFlow.PoisonBagFilter = PoisonBagFilter

-- =========================================================
-- State
-- =========================================================

PoisonBagFilter.Active = false

-- =========================================================
-- Is Active
-- =========================================================

---@return boolean
function PoisonBagFilter:IsActive()
    return self.Active
end

-- =========================================================
-- Is Valid Item
-- =========================================================

---@param itemID number?
---@return boolean
function PoisonBagFilter:IsValidItem(itemID)
    if not itemID then
        return false
    end

    return PoisonFlow.Poison:IsPoison(itemID)
end

-- =========================================================
-- Start
-- =========================================================

---@param hand string
---@param slotType string
function PoisonBagFilter:Start(hand, slotType)
    if InCombatLockdown() then
        return
    end

    self.Active = true
    self.Hand = hand
    self.SlotType = slotType

    OpenAllBags()

    C_Timer.After(0.1, function()
        if PoisonBagFilter.Active then
            PoisonBagFilter:Update()
        end
    end)
end

-- =========================================================
-- Stop
-- =========================================================

function PoisonBagFilter:Stop()
    self.Active = false
    self.Hand = nil
    self.SlotType = nil

    local container = ContainerFrameCombinedBags

    if container and container.Items then
        for _, button in ipairs(container.Items) do
            if button.searchOverlay then
                button.searchOverlay:Hide()
            end
        end
    end
end

-- =========================================================
-- Update Bag Filter
-- =========================================================

function PoisonBagFilter:Update()
    if not self.Active then
        return
    end

    local container = ContainerFrameCombinedBags

    if not container or not container.Items then
        return
    end

    for _, button in ipairs(container.Items) do
        local bagID = button:GetBagID()
        local slotID = button:GetID()

        if bagID and slotID and button.searchOverlay then
            local itemID = C_Container.GetContainerItemID(
                bagID,
                slotID
            )

            local isPoison = self:IsValidItem(itemID)

            if isPoison then
                button.searchOverlay:Hide()
            else
                button.searchOverlay:Show()
            end
        end
    end
end

-- =========================================================
-- Bag Events
-- =========================================================

local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")

eventFrame:SetScript("OnEvent", function()
    if not PoisonBagFilter:IsActive() then
        return
    end

    C_Timer.After(0, function()
        if PoisonBagFilter:IsActive() then
            PoisonBagFilter:Update()
        end
    end)
end)

-- =========================================================
-- Bag Close Handler
-- =========================================================

local function RegisterBagCloseHandler()
    local container = ContainerFrameCombinedBags

    if not container then
        return
    end

    container:HookScript("OnHide", function()
        if PoisonBagFilter:IsActive() then
            PoisonBagFilter:Stop()
        end
    end)
end

RegisterBagCloseHandler()