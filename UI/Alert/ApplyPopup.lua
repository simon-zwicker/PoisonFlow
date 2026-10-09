local PoisonFlow = _G.PoisonFlow
local Texture = PoisonFlow.Texture
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowApplyPopup
---@field Frame Frame?
---@field MainHandButton PoisonFlowApplyButtonInstance?
---@field OffHandButton PoisonFlowApplyButtonInstance?
local ApplyPopup = {}
PoisonFlow.ApplyPopup = ApplyPopup

-- =========================================================
-- Constants
-- =========================================================

local FRAME_WIDTH = 320
local FRAME_HEIGHT = 135
local BUTTON_OFFSET = 78
local CONTENT_OFFSET_Y = -20

-- =========================================================
-- Layout
-- =========================================================

---@param frame Frame
local function CreateBorderTexture(frame)
    local border = frame:CreateTexture(nil, "BORDER")
    border:SetAllPoints(frame)
    border:SetTexture(Texture.Window.Frame)
end

---@param frame Frame
local function CreateHandDivider(
    frame
)
    local divider =
        frame:CreateTexture(
            nil,
            "ARTWORK"
        )

    divider:SetColorTexture(
        0.55,
        0.40,
        0.15,
        0.65
    )

    divider:SetSize(
        1,
        80
    )

    divider:SetPoint(
        "CENTER",
        frame,
        "CENTER",
        0,
        0
    )

    return divider
end

-- local function UpdateLayout()
--     local mainHandButton = ApplyPopup.MainHandButton
--     local offHandButtn = ApplyPopup.OffHandButton

--     if not mainHandButton or not offHandButtn then
--         return
--     end

--     local mainHandVisible = mainHandButton.Frame:IsShown()
--     local offHandVisible = offHandButtn.Frame:IsShown()
--     mainHandButton.Frame:ClearAllPoints()
--     offHandButtn.Frame:ClearAllPoints()

--     if mainHandVisible or offHandVisible then
--         mainHandButton.Frame:SetPoint("CENTER", ApplyPopup.Frame, "CENTER", -BUTTON_OFFSET, 0)
--         offHandButtn.Frame:SetPoint("CENTER", ApplyPopup.Frame, "CENTER", BUTTON_OFFSET, 0)
--         return
--     end

--     if mainHandVisible then
--         mainHandButton.Frame:SetPoint("CENTER", ApplyPopup.Frame, "CENTER", 0, 0)
--         return
--     end

--     if offHandVisible then
--         offHandButtn.Frame:SetPoint("CENTER", ApplyPopup.Frame, "CENTER", 0, 0)
--     end
-- end

-- =========================================================
-- Create
-- =========================================================

---@param popup PoisonFlowApplyPopup
local function CreatePopup(popup)
    local frame = CreateFrame("Frame", "PoisonFlowApplyPopup", UIParent)
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)

    frame:RegisterForDrag(
        "LeftButton"
    )

    frame:SetScript(
        "OnDragStart",
        function(self)
            self:StartMoving()
        end
    )

    frame:SetScript(
        "OnDragStop",
        function(self)
            self:StopMovingOrSizing()
        end
    )

    CreateBorderTexture(frame)
    CreateHandDivider(frame)

    local closeButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelCloseButton"
    )

    closeButton:SetPoint(
        "TOPRIGHT",
        frame,
        "TOPRIGHT",
        3,
        3
    )

    closeButton:SetScript(
        "OnClick",
        function()
            popup:Hide()
        end
    )

    local mainHandButton = PoisonFlow.ApplyButton:Create(frame, "mainHand")
    local offHandButton = PoisonFlow.ApplyButton:Create(frame, "offHand")

    mainHandButton.Frame:SetPoint("TOP", frame, "TOP", -BUTTON_OFFSET, CONTENT_OFFSET_Y)
    offHandButton.Frame:SetPoint("TOP", frame, "TOP", BUTTON_OFFSET, CONTENT_OFFSET_Y)

    popup.Frame = frame
    popup.MainHandButton = mainHandButton
    popup.OffHandButton = offHandButton

    frame:Hide()
end

-- =========================================================
-- Initialize
-- =========================================================

function ApplyPopup:Initialize()
    if self.Frame then
        return
    end
    CreatePopup(self)
end

-- =========================================================
-- Hand
-- =========================================================

---@param popup PoisonFlowApplyPopup
---@param hand string
---@return PoisonFlowApplyButtonInstance?
local function GetButton(popup, hand)
    if hand == "mainHand" then
        return popup.MainHandButton
    end

    if hand == "offHand" then
        return popup.OffHandButton
    end

    return nil
end

---@param hand string
---@param itemID number
---@param state PoisonFlowPoisonMonitorState
function ApplyPopup:ShowHand(hand, itemID, state)
    self:Initialize()
    local button = GetButton(self, hand)

    if not button then
        return
    end

    PoisonFlow.ApplyButton:SetPoison(button, itemID, state)
    
    button.Frame:Show()

    -- UpdateLayout()

    self.Frame:Show()
end

---@param hand string
function ApplyPopup:HideHand(hand)
    if not self.Frame then
        return
    end

    local button = GetButton(self, hand)

    if not button then
        return
    end

    button.Frame:Hide()

    local mainHandVisible = self.MainHandButton.Frame:IsShown()
    local offHandVisible = self.OffHandButton.Frame:IsShown()

    if not mainHandVisible and not offHandVisible then
        self.Frame:Hide()
        return
    end

    -- UpdateLayout()
end

-- =========================================================
-- Hide
-- =========================================================

function ApplyPopup:Hide()
    if not self.Frame then
        return
    end

    self.MainHandButton.Frame:Hide()
    self.OffHandButton.Frame:Hide()
    self.Frame:Hide()
end