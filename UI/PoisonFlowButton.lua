local PoisonFlow = _G.PoisonFlow
local Texture = PoisonFlow.Texture

-- =========================================================
-- Constants
-- =========================================================

local MAIN_HAND_SLOT = 16
local OFF_HAND_SLOT = 17
local BUTTON_SIZE = 48

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
    icon:SetTexture(Texture.RogueIcon)
    icon:SetTexCoord(0.49609375, 0.7421875, 0, 0.25)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetAllPoints(button)
    border:SetTexture(Texture.PoisonButtonFrame)

    return icon
end

-- =========================================================
-- Configure Secure Action
-- =========================================================

---@param button Button
local function ConfigureSecureAction(button)
    if InCombatLockdown() then
        return
    end

    local mainHandSelection = PoisonFlow.PoisonService:GetForHand(
        "mainHand"
    )

    local offHandSelection = PoisonFlow.PoisonService:GetForHand(
        "offHand"
    )

    local mainHandPoison = mainHandSelection
        and mainHandSelection.itemID

    local offHandPoison = offHandSelection
        and offHandSelection.itemID

    button:SetAttribute("type1", mainHandPoison and "item" or nil)
    button:SetAttribute(
        "item1",
        mainHandPoison and ("item:" .. mainHandPoison) or nil
    )
    button:SetAttribute(
        "target-slot1",
        mainHandPoison and MAIN_HAND_SLOT or nil
    )

    button:SetAttribute("type2", offHandPoison and "item" or nil)
    button:SetAttribute(
        "item2",
        offHandPoison and ("item:" .. offHandPoison) or nil
    )
    button:SetAttribute(
        "target-slot2",
        offHandPoison and OFF_HAND_SLOT or nil
    )

    button:SetAttribute("shift-type1", "")
    button:SetAttribute("shift-type2", "")
end

-- =========================================================
-- Refresh Secure Actions
-- =========================================================

function PoisonFlowButton:Refresh()
    if not self.Instance then
        return
    end

    if InCombatLockdown() then
        self.PendingRefresh = true
        return
    end

    self.PendingRefresh = false

    ConfigureSecureAction(self.Instance.Frame)
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
-- Tooltip
-- =========================================================

---@param button Button
local function ConfigureTooltip(button)
    button:SetScript(
        "OnEnter",
        function(self)
            PoisonFlow.ButtonTooltip:Show(self)
        end
    )

    button:SetScript(
        "OnLeave",
        function()
            PoisonFlow.ButtonTooltip:Hide()
        end
    )
end

-- =========================================================
-- Configure Settings Action
-- =========================================================

---@param button Button
local function ConfigureSettingsAction(button)
    button:HookScript(
        "OnClick",
        function(_, mouseButton)
            if InCombatLockdown() then
                return
            end

            -- Shift + Right Click
            if mouseButton == "RightButton" and IsShiftKeyDown() then
                PoisonFlow.Settings:Show()
                return
            end

            -- Shift + Left Click is reserved for dragging.
            if IsShiftKeyDown() then
                return
            end

            local hand

            if mouseButton == "LeftButton" then
                hand = "mainHand"
            elseif mouseButton == "RightButton" then
                hand = "offHand"
            else
                return
            end

            if not PoisonFlow.PoisonService:IsConfigured(hand) then
                PoisonFlow.Settings:Show()
            end
        end
    )
end

-- =========================================================
-- Create Button
-- =========================================================

---@return PoisonFlowButtonInstance
local function CreateButton()
    local button = CreateFrame(
        "Button",
        "PoisonFlowPoisonFlowButton",
        UIParent,
        "SecureActionButtonTemplate"
    )

    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button:RegisterForClicks("AnyDown", "AnyUp")

    RestorePosition(button)
    ConfigureDragging(button)
    ConfigureTooltip(button)
    ConfigureSettingsAction(button)

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
-- Events
-- =========================================================

local function ConfigureEvents()
    local eventFrame = CreateFrame("Frame")

    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")

    eventFrame:SetScript(
        "OnEvent",
        function(_, event)
            if event == "BAG_UPDATE_DELAYED" then
                -- Update secure Apply actions.
                PoisonFlowButton:Refresh()

                -- Update poison warnings immediately.
                PoisonFlow.PoisonMonitor:Update()

                return
            end

            if event == "PLAYER_REGEN_ENABLED"
                and PoisonFlowButton.PendingRefresh
            then
                PoisonFlowButton:Refresh()
            end
        end
    )
end

-- =========================================================
-- Initialize
-- =========================================================

function PoisonFlowButton:Initialize()
    if self.Instance then
        return
    end
    self.Instance = CreateButton()
    ConfigureEvents()
end