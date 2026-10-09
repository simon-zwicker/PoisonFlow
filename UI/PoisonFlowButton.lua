local PoisonFlow = _G.PoisonFlow
local Texture = PoisonFlow.Texture

-- =========================================================
-- Constants
-- =========================================================

local MAIN_HAND_SLOT = 16
local OFF_HAND_SLOT = 17
local BUTTON_SIZE = 48

local TEST_POISON_ID = 6947

-- =========================================================
-- PoisonFlow Button
-- =========================================================

---@class PoisonFlowButton
local PoisonFlowButton = {}
PoisonFlow.PoisonFlowButton = PoisonFlowButton

---@class PoisonFlowButtonInstance
---@field Frame Button
---@field Icon Texture

---@type PoisonFlowButtonInstance?
PoisonFlowButton.Instance = nil

-- =========================================================
-- Create Icon
-- =========================================================

---@param button Button
---@return Texture
local function CreateIcon(button)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(button)
    icon:SetTexture(Texture.Icon)
    return icon
end

-- =========================================================
-- Configure Secure Action
-- =========================================================

---@param button Button
local function ConfigureSecureAction(button)
    local mainHandPoison = TEST_POISON_ID
    local offHandPoison = TEST_POISON_ID

    if mainHandPoison then
        button:SetAttribute("type1", "item")
        button:SetAttribute("item1", "item:" .. mainHandPoison)
        button:SetAttribute("target-slot1", MAIN_HAND_SLOT)
    end

    if offHandPoison then
        button:SetAttribute("type2", "item")
        button:SetAttribute("item2", "item:" .. offHandPoison)
        button:SetAttribute("target-slot2", OFF_HAND_SLOT)
    end

    button:SetAttribute("shift-type1", "")
    button:SetAttribute("shift-type2", "")
end

-- =========================================================
-- Position
-- =========================================================

---@param button Button
local function RestorePosition(button)
    local db = PoisonFlow.Database:Get()
    local position = db.poisonFlowButton
    button:ClearAllPoints()
    button:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
end

---@param button Button
local function SavePosition(button)
    local db = PoisonFlow.Database:Get()
    local point, _, relativePoint, x, y = button:GetPoint(1)
    db.poisonFlowButton.point = point
    db.poisonFlowButton.relativePoint = relativePoint
    db.poisonFlowButton.x = x
    db.poisonFlowButton.y = y
end

-- =========================================================
-- Dragging
-- =========================================================

---@param button Button
local function ConfigureDragging(button)
    button:SetMovable(true)
    button:SetClampedToScreen(true)

    button:SetScript(
        "OnMouseDown",
        function(self, mouseButton)
            if mouseButton ~= "LeftButton" then
                return
            end

            if not IsShiftKeyDown() then
                return
            end

            self:StartMoving()
        end
    )

    button:SetScript(
        "OnMouseUp",
        function(self, mouseButton)
            if mouseButton ~= "LeftButton" then
                return
            end

            self:StopMovingOrSizing()

            SavePosition(self)
        end
    )
end

-- =========================================================
-- Create Button
-- =========================================================

---@return PoisonFlowButtonInstance
local function CreateButton()
    local button = CreateFrame("Button", "PoisonFlowPoisonFlowButton", UIParent, "SecureActionButtonTemplate")
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:RegisterForClicks("AnyDown", "AnyUp")
    RestorePosition(button)
    ConfigureDragging(button)

    local icon = CreateIcon(button)
    ConfigureSecureAction(button)

    ---@type PoisonFlowButtonInstance
    local instance = {
        Frame = button,
        Icon = icon,
    }

    return instance
end

-- =========================================================
-- Initialize
-- =========================================================

function PoisonFlowButton:Initialize()
    if self.Instance then
        return
    end
    self.Instance = CreateButton()
end