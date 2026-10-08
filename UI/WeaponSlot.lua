local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowWeaponSlotInstance
---@field Frame Button
---@field Icon Texture
---@field InventorySlotID number

---@class PoisonFlowWeaponSlot
local WeaponSlot = {}

PoisonFlow.WeaponSlot = WeaponSlot

-- =========================================================
-- Constants
-- =========================================================

local SLOT_SIZE = 64
local MAIN_HAND_SLOT = 16
local OFF_HAND_SLOT = 17

-- =========================================================
-- Get Inventory Slot
-- =========================================================

---@param hand string
---@return number
local function GetInventorySlotID(hand)
    if hand == "mainHand" then
        return MAIN_HAND_SLOT
    end
    return OFF_HAND_SLOT
end

-- =========================================================
-- Update
-- =========================================================

---@param slot PoisonFlowWeaponSlotInstance
local function Update(slot)
    local texture = GetInventoryItemTexture("player", slot.InventorySlotID)

    if texture then
        slot.Icon:SetTexture(texture)
        slot.Icon:Show()
    else
        slot.Icon:SetTexture(nil)
        slot.Icon:Hide()
    end
end

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param hand string
---@return PoisonFlowWeaponSlotInstance
function WeaponSlot:Create(parent, hand)
    local inventorySlotID = GetInventorySlotID(hand)

    local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
    frame:SetSize(SLOT_SIZE, SLOT_SIZE)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0.04, 0.04, 0.04, 1.0)
    frame:SetBackdropBorderColor(0.55, 0.42, 0.18, 1.0)

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)

    ---@type PoisonFlowWeaponSlotInstance
    local slot = {
        Frame = frame,
        Icon = icon,
        InventorySlotID = inventorySlotID,
    }

    frame:SetScript(
        "OnEnter",
        function(self)
            local itemLink = GetInventoryItemLink("player", slot.InventorySlotID)

            if not itemLink then
                return
            end

            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(itemLink)
            GameTooltip:Show()
        end
    )
    frame:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )

    Update(slot)

    return slot
end
