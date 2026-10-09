local PoisonFlow = _G.PoisonFlow
local Texture = PoisonFlow.Texture
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowApplyButtonInstance
---@field Frame Frame
---@field Button Button
---@field Icon Texture
---@field HandLabel FontString
---@field ActionLabel FontString
---@field Hand string
---@field InventorySlot number
---@field ItemID number?
---@field Available boolean
---@field State PoisonFlowPoisonMonitorState?

---@class PoisonFlowApplyButton
local ApplyButton = {}

PoisonFlow.ApplyButton = ApplyButton

-- =========================================================
-- Constants
-- =========================================================

local FRAME_WIDTH = 120
local FRAME_HEIGHT = 80

local BUTTON_SIZE = 44
local SLOT_BORDER_SIZE = 52

local INVENTORY_SLOT = {
    mainHand = 16,
    offHand = 17,
}

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

---@param hand string
---@return number?
local function GetInventorySlot(hand)
    return INVENTORY_SLOT[hand]
end

---@param button PoisonFlowApplyButtonInstance
local function UpdateWeaponIcon(button)
    local texture = GetInventoryItemTexture(
        "player",
        button.InventorySlot
    )

    button.Icon:SetTexture(
        texture
    )
end

---@param button PoisonFlowApplyButtonInstance
---@param available boolean
local function UpdateAvailability(
    button,
    available
)
    button.Available = available

    if available then
        button.Button:SetAlpha(1)
        button.ActionLabel:SetAlpha(1)

        return
    end

    button.Button:SetAlpha(0.45)
    button.ActionLabel:SetAlpha(0.55)
end

---@param milliseconds number?
---@return string
local function FormatRemainingTime(
    milliseconds
)
    if not milliseconds then
        return "0:00"
    end

    local totalSeconds =
        math.max(
            0,
            math.floor(milliseconds / 1000)
        )

    local minutes =
        math.floor(totalSeconds / 60)

    local seconds =
        totalSeconds % 60

    return string.format(
        "%d:%02d",
        minutes,
        seconds
    )
end

---@param button PoisonFlowApplyButtonInstance
---@param state PoisonFlowPoisonMonitorState
local function UpdateActionLabel(
    button,
    state
)
    local requiresApply =
        state.missing
        or state.timeLow
        or state.chargesLow

    if requiresApply then
        button.ActionLabel:SetText(
            L11n.REAPPLY
        )

        button.ActionLabel:SetTextColor(
            1,
            0.2,
            0.2
        )

        return
    end

    button.ActionLabel:SetText(
        L11n.ACTIVE
    )

    button.ActionLabel:SetTextColor(
        0.2,
        1,
        0.2
    )
end

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param hand string
---@return PoisonFlowApplyButtonInstance
function ApplyButton:Create(
    parent,
    hand
)
    local inventorySlot =
        GetInventorySlot(hand)

    assert(
        inventorySlot,
        "PoisonFlow: invalid weapon hand"
    )

    -- -----------------------------------------------------
    -- Container
    -- -----------------------------------------------------

    local container = CreateFrame(
        "Frame",
        nil,
        parent
    )

    container:SetSize(
        FRAME_WIDTH,
        FRAME_HEIGHT
    )

    -- -----------------------------------------------------
    -- Hand
    -- -----------------------------------------------------

    local handLabel =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalLarge"
        )

    handLabel:SetPoint(
        "TOP",
        container,
        "TOP",
        0,
        0
    )

    handLabel:SetText(
        GetHandLabel(hand)
    )

    -- -----------------------------------------------------
    -- Secure Weapon Button
    -- -----------------------------------------------------

    local button = CreateFrame(
        "Button",
        nil,
        container,
        "SecureActionButtonTemplate"
    )

    button:SetSize(
        BUTTON_SIZE,
        BUTTON_SIZE
    )

    button:SetPoint(
        "TOP",
        container,
        "TOP",
        0,
        -32
    )

    button:RegisterForClicks(
        "AnyDown",
        "AnyUp"
    )

    button:SetAttribute(
        "target-slot",
        inventorySlot
    )

    -- -----------------------------------------------------
    -- Weapon Icon
    -- -----------------------------------------------------

    local icon =
        button:CreateTexture(
            nil,
            "ARTWORK"
        )

    icon:SetAllPoints(
        button
    )

    -- -----------------------------------------------------
    -- Slot Border
    -- -----------------------------------------------------

    local slotBorder =
        container:CreateTexture(
            nil,
            "OVERLAY"
        )

    slotBorder:SetTexture(
        Texture.Slot.Border
    )

    slotBorder:SetSize(
        SLOT_BORDER_SIZE,
        SLOT_BORDER_SIZE
    )

    slotBorder:SetPoint(
        "CENTER",
        button,
        "CENTER",
        0,
        0
    )

    -- -----------------------------------------------------
    -- Action
    -- -----------------------------------------------------

    local actionLabel =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlight"
        )

    actionLabel:SetPoint(
        "TOP",
        button,
        "BOTTOM",
        0,
        -8
    )

    actionLabel:SetText(
        L11n.REAPPLY
    )

    -- -----------------------------------------------------
    -- Instance
    -- -----------------------------------------------------

    local instance = {
        Frame = container,
        Button = button,
        Icon = icon,
        HandLabel = handLabel,
        ActionLabel = actionLabel,
        Hand = hand,
        InventorySlot = inventorySlot,
        ItemID = nil,
        Available = false,
        State = nil,
    }

    button:SetScript(
        "OnEnter",
        function(self)
            if not instance.ItemID then
                return
            end

            local state =
                instance.State

            if not state then
                return
            end

            local poisonName =
                C_Item.GetItemNameByID(
                    instance.ItemID
                )

            if not poisonName then
                return
            end

            GameTooltip:SetOwner(
                self,
                "ANCHOR_RIGHT"
            )

            GameTooltip:SetText(
                poisonName,
                1,
                0.82,
                0,
                1
            )

            if state.remainingTimeMs ~= nil then
                GameTooltip:AddLine(
                    string.format(
                        L11n.POISON_TIME_REMAINING,
                        FormatRemainingTime(
                            state.remainingTimeMs
                        )
                    ),
                    1,
                    1,
                    1
                )
            end

            if state.charges ~= nil then
                GameTooltip:AddLine(
                    string.format(
                        L11n.POISON_CHARGES_REMAINING,
                        state.charges
                    ),
                    1,
                    1,
                    1
                )
            end

            GameTooltip:AddLine(" ")

            if state.missing then
                GameTooltip:AddLine(
                    L11n.POISON_STATUS_EXPIRED,
                    1,
                    0.2,
                    0.2
                )
            elseif state.timeLow
                or state.chargesLow then

                GameTooltip:AddLine(
                    L11n.POISON_STATUS_REAPPLY,
                    1,
                    0.82,
                    0
                )
            else
                GameTooltip:AddLine(
                    L11n.POISON_STATUS_OK,
                    0.2,
                    1,
                    0.2
                )
            end

            GameTooltip:Show()
        end
    )

    button:SetScript(
        "OnLeave",
        function()
            GameTooltip:Hide()
        end
    )

    UpdateWeaponIcon(
        instance
    )

    return instance
end

-- =========================================================
-- Poison
-- =========================================================

---@param button PoisonFlowApplyButtonInstance
---@param itemID number
---@param state PoisonFlowPoisonMonitorState
function ApplyButton:SetPoison(
    button,
    itemID,
    state
)
    button.ItemID = itemID
    button.State = state

    UpdateActionLabel(button, state)

    UpdateWeaponIcon(
        button
    )

    local count =
        C_Item.GetItemCount(itemID)
        or 0

    local available =
        count > 0

    UpdateAvailability(
        button,
        available
    )

    if not available then
        button.Button:SetAttribute(
            "type",
            nil
        )

        button.Button:SetAttribute(
            "item",
            nil
        )

        return
    end

    button.Button:SetAttribute(
        "type",
        "item"
    )

    button.Button:SetAttribute(
        "item",
        "item:" .. itemID
    )
end

-- =========================================================
-- Weapon
-- =========================================================

---@param button PoisonFlowApplyButtonInstance
function ApplyButton:RefreshWeapon(
    button
)
    UpdateWeaponIcon(
        button
    )
end