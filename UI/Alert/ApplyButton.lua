local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowApplyButtonInstance
---@field Frame Button
---@field Icon Texture
---@field HandLabel FontString
---@field ActionLabel FontString
---@field Hand string
---@field ItemID number?
---@field Available boolean

---@class PoisonFlowApplyButton
local ApplyButton = {}
PoisonFlow.ApplyButton = ApplyButton

-- =========================================================
-- Constants
-- =========================================================

local BUTTON_WIDTH = 110
local BUTTON_HEIGHT = 110
local ICON_SIZE = 48

-- =========================================================
-- Helpers
-- =========================================================

---@param hand string
---@return string
local function GetHandLabel(hand)
    if hand == "mainHand" then
        return L11n.MAIN_HAND
    end
    return L11n.OFF_HAND
end

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param hand string
---@return PoisonFlowApplyButtonInstance
function ApplyButton:Create(parent, hand)
   local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
   frame:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
   frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
   })
   frame:SetBackdropColor(0.04, 0.04, 0.04, 0.95)
   frame:SetBackdropBorderColor(0.45, 0.35, 0.18, 1.0)

   local icon = frame:CreateTexture(nil, "ARTWORK")
   icon:SetSize(ICON_SIZE, ICON_SIZE)
   icon:SetPoint("TOP", frame, "TOP", 0, -8)

   local handLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
   handLabel:SetPoint("TOP", icon, "BOTTOM", 0, -6)
   handLabel:SetText(GetHandLabel(hand))

   local actionLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
   actionLabel:SetPoint("TOP", handLabel, "BOTTOM", 0, -4)
   actionLabel:SetText(L11n.REAPPLY)

   ---@type PoisonFlowApplyButtonInstance
   local button = {
        Frame = frame,
        Icon = icon,
        HandLabel = handLabel,
        ActionLabel = actionLabel,
        Hand = hand,
        ItemID = nil,
        Available = false,
   }

   return button
end

-- =========================================================
-- Poison
-- =========================================================

---@param button PoisonFlowApplyButtonInstance
---@param itemID number
function ApplyButton:SetPoison(button, itemID)
    button.ItemID = itemID
    local count = C_Item.GetItemCount(itemID) or 0
    button.Available = count > 0
    local icon = C_Item.GetItemIconByID(itemID)
    button.Icon:SetTexture(icon)
end
