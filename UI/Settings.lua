local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =====================================================
-- Types
-- =====================================================

---@class PoisonFlowSettings
---@field Frame Frame?
local Settings = {}

PoisonFlow.Settings = Settings

-- =========================================================
-- Constants
-- =========================================================

local FRAME_WIDTH = 600
local FRAME_HEIGHT = 620
local COLUMN_OFFSET = 145

-- =========================================================
-- Create Settings Frame
-- =========================================================

local function CreateSettingsFrame()
    local frame = CreateFrame("Frame", "PoisonFlowSettingsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 8,
            right = 8,
            top = 8,
            bottom = 8,
        }
    })
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

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -10)
    title:SetText(PoisonFlow.Name)

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

    -- =========================================================
    -- Main Hand Weapon
    -- =========================================================

    local mainHandTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mainHandTitle:SetPoint("TOP", frame, "TOP", -COLUMN_OFFSET, -80)
    mainHandTitle:SetText(L11n.MAIN_HAND)

    local mainHandWeapon = PoisonFlow.WeaponSlot:Create(frame, "mainHand")
    mainHandWeapon.Frame:SetPoint("TOP", mainHandTitle, "BOTTOM", 0, -12)

    local mainHandPrimary = PoisonFlow.PoisonSlot:Create(frame, "mainHand", "primary")
    mainHandPrimary.Frame:SetPoint("TOP", mainHandWeapon.Frame, "BOTTOM", 0, -60)

    local mainHandFallback = PoisonFlow.PoisonSlot:Create(frame, "mainHand", "fallback")
    mainHandFallback.Frame:SetPoint("TOP", mainHandPrimary.Frame, "BOTTOM", 0, -80)

    -- =========================================================
    -- Off Hand Weapon
    -- =========================================================

    local offHandTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    offHandTitle:SetPoint("TOP", frame, "TOP", COLUMN_OFFSET, -80)
    offHandTitle:SetText(L11n.OFF_HAND)

    local offHandWeapon = PoisonFlow.WeaponSlot:Create(frame, "offHand")
    offHandWeapon.Frame:SetPoint("TOP", offHandTitle, "BOTTOM", 0, -12)

    local offHandPrimary = PoisonFlow.PoisonSlot:Create(frame, "offHand", "primary")
    offHandPrimary.Frame:SetPoint("TOP", offHandWeapon.Frame, "BOTTOM", 0, -60)

    local offHandFallback = PoisonFlow.PoisonSlot:Create(frame, "offHand", "fallback")
    offHandFallback.Frame:SetPoint("TOP", offHandPrimary.Frame, "BOTTOM", 0, -80)

    -- =========================================================
    -- Alerts
    -- =========================================================

    local db = PoisonFlow.Database:Get()
    
    local divider = frame:CreateTexture(nil, "ARTWORK")
    divider:SetHeight(1)
    divider:SetPoint("LEFT", frame, "LEFT", 40, 0)
    divider:SetPoint("RIGHT", frame, "RIGHT", -40, 0)
    divider:SetPoint("BOTTOM", frame, "BOTTOM", 0, 145)
    divider:SetColorTexture(0.55, 0.42, 0.18, 1.0)

    local alertsTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    alertsTitle:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -14)
    alertsTitle:SetText(L11n.ALERTS)

    local timeCheckBox = PoisonFlow.CheckBox:Create(
        frame,
        L11n.ALERT_TIME,
        db.alerts.time.enabled,
        function(checked)
            db.alerts.time.enabled = checked
        end
    )
    timeCheckBox.Frame:SetPoint("TOPLEFT", alertsTitle, "BOTTOMLEFT", 0, -12)

    local timeInput = PoisonFlow.NumberInput:Create(
        frame,
        db.alerts.time.threshold,
        1,
        30,
        function(value)
            db.alerts.time.threshold = value
        end
    )
    timeInput.Frame:SetPoint("LEFT", timeCheckBox.Frame, "LEFT", 330, 0)

    local timeUnit = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    timeUnit:SetPoint("LEFT", timeInput.Frame, "RIGHT", 8, 0)
    timeUnit:SetText(L11n.ALERT_TIME_UNIT)

    local chargeCheckBox = PoisonFlow.CheckBox:Create(
        frame,
        L11n.ALERT_CHARGES,
        db.alerts.charges.enabled,
        function(checked)
            db.alerts.charges.enabled = checked
        end
    )
    chargeCheckBox.Frame:SetPoint("TOPLEFT", timeCheckBox.Frame, "BOTTOMLEFT", 0, -10)

    local chargeInput = PoisonFlow.NumberInput:Create(
        frame,
        db.alerts.charges.threshold,
        1,
        100,
        function(value)
            db.alerts.charges.threshold = value
        end
    )
    chargeInput.Frame:SetPoint("LEFT", chargeCheckBox.Frame, "LEFT", 330, 0)

    local chargeUnit = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    chargeUnit:SetPoint("LEFT", chargeInput.Frame, "RIGHT", 8,0)
    chargeUnit:SetText(L11n.ALERT_CHARGES_UNIT)

    frame:Hide()

    return frame
end

function Settings:Initialize()
    self.Frame = CreateSettingsFrame()
end

function Settings:Show()
    if not self.Frame then
        self:Initialize()
    end
    self.Frame:Show()
end

function Settings:Hide()
    if not self.Frame then
        return
    end
    self.Frame:Hide()
end

function Settings:Toggle()
    if not self.Frame then
        self:Initialize()
    end
    if self.Frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end