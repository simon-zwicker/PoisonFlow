local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowSettings
---@field Frame Frame?
---@field MainHandWeapon PoisonFlowWeaponSlotInstance?
---@field OffHandWeapon PoisonFlowWeaponSlotInstance?
---@field Refresh fun(self: PoisonFlowSettings)
local Settings = {
    Frame = nil,
    MainHandWeapon = nil,
    OffHandWeapon = nil,
}

PoisonFlow.Settings = Settings

-- =========================================================
-- Constants
-- =========================================================

local FRAME_WIDTH = 540

local PADDING = 24
local HEADER_HEIGHT = 48

local WEAPON_SECTION_HEIGHT = 190
local ALERT_SECTION_HEIGHT = 192

local SECTION_GAP = 12

local CONTENT_WIDTH = FRAME_WIDTH - (PADDING * 2)

local FRAME_HEIGHT =
    HEADER_HEIGHT
    + (WEAPON_SECTION_HEIGHT * 2)
    + ALERT_SECTION_HEIGHT
    + (SECTION_GAP * 2)
    + (PADDING * 2)

local COLOR_GOLD = {
    0.65,
    0.48,
    0.20,
    1.0,
}

-- =========================================================
-- Divider
-- =========================================================

---@param parent Frame
---@return Texture
local function CreateHorizontalDivider(parent)
    local divider = parent:CreateTexture(nil, "ARTWORK")

    divider:SetHeight(1)
    divider:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 0, 0)
    divider:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)

    divider:SetColorTexture(unpack(COLOR_GOLD))

    return divider
end

-- =========================================================
-- Section
-- =========================================================

---@param parent Frame
---@param height number
---@return Frame
local function CreateSection(parent, height)
    local section = CreateFrame("Frame", nil, parent)

    section:SetSize(CONTENT_WIDTH, height)

    return section
end

-- =========================================================
-- Weapon Status
-- =========================================================

---@param section Frame
---@param hand string
---@param titleText string
---@return PoisonFlowWeaponSlotInstance
local function CreateWeaponStatus(section, hand, titleText)
    -- =========================================================
    -- Weapon Column
    -- =========================================================

    local column = CreateFrame("Frame", nil, section)

    column:SetSize(160, WEAPON_SECTION_HEIGHT)
    column:SetPoint("TOPLEFT", section, "TOPLEFT", 0, 0)

    -- =========================================================
    -- Title
    -- =========================================================

    local title = column:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    title:SetPoint("TOP", column, "TOP", 0, -12)
    title:SetText(titleText)

    -- =========================================================
    -- Weapon
    -- =========================================================

    local weapon = PoisonFlow.WeaponSlot:Create(column, hand)

    weapon.Frame:SetPoint(
        "TOP",
        column,
        "TOP",
        0,
        -40
    )

    -- =========================================================
    -- Current Poison Status
    -- =========================================================

    weapon.StatusTitle:ClearAllPoints()
    weapon.StatusTitle:SetPoint(
        "TOP",
        weapon.Frame,
        "BOTTOM",
        0,
        -10
    )

    weapon.StatusName:ClearAllPoints()
    weapon.StatusName:SetPoint(
        "TOP",
        weapon.StatusTitle,
        "BOTTOM",
        0,
        -3
    )

    weapon.StatusName:SetWidth(150)
    weapon.StatusName:SetJustifyH("CENTER")

    weapon.StatusTime:ClearAllPoints()
    weapon.StatusTime:SetPoint(
        "TOP",
        weapon.StatusName,
        "BOTTOM",
        0,
        -3
    )

    weapon.StatusCharges:ClearAllPoints()
    weapon.StatusCharges:SetPoint(
        "TOP",
        weapon.StatusTime,
        "BOTTOM",
        0,
        -3
    )

    return weapon
end

-- =========================================================
-- Poison Configuration
-- =========================================================

---@param parent Frame
---@param hand string
---@param slotType string
---@param offsetY number
local function CreatePoisonConfiguration(
    parent,
    hand,
    slotType,
    offsetY
)
    local poison = PoisonFlow.PoisonSlot:Create(
        parent,
        hand,
        slotType
    )

    -- =========================================================
    -- Title
    -- =========================================================

    poison.Title:ClearAllPoints()

    poison.Title:SetPoint(
        "TOPLEFT",
        parent,
        "TOPLEFT",
        0,
        offsetY
    )

    -- =========================================================
    -- Icon
    -- =========================================================

    poison.Frame:SetPoint(
        "TOPLEFT",
        poison.Title,
        "BOTTOMLEFT",
        0,
        -6
    )

    -- =========================================================
    -- Name
    -- =========================================================

    poison.Name:ClearAllPoints()

    poison.Name:SetPoint(
        "LEFT",
        poison.Frame,
        "RIGHT",
        12,
        8
    )

    poison.Name:SetWidth(210)
    poison.Name:SetJustifyH("LEFT")
    poison.Name:SetWordWrap(false)

    -- =========================================================
    -- Count
    -- =========================================================

    poison.Count:ClearAllPoints()

    poison.Count:SetPoint(
        "TOPLEFT",
        poison.Name,
        "BOTTOMLEFT",
        0,
        -4
    )

    return poison
end

-- =========================================================
-- Weapon Section
-- =========================================================

---@param parent Frame
---@param hand string
---@param titleText string
---@return Frame
---@return PoisonFlowWeaponSlotInstance
local function CreateWeaponSection(parent, hand, titleText)
    local section = CreateSection(
        parent,
        WEAPON_SECTION_HEIGHT
    )

    -- =========================================================
    -- Weapon Status
    -- =========================================================

    local weapon = CreateWeaponStatus(
        section,
        hand,
        titleText
    )

    -- =========================================================
    -- Vertical Divider
    -- =========================================================

    local divider = section:CreateTexture(
        nil,
        "ARTWORK"
    )

    divider:SetWidth(1)

    divider:SetPoint(
        "TOPLEFT",
        section,
        "TOPLEFT",
        170,
        -10
    )

    divider:SetPoint(
        "BOTTOMLEFT",
        section,
        "BOTTOMLEFT",
        170,
        10
    )

    divider:SetColorTexture(unpack(COLOR_GOLD))

    -- =========================================================
    -- Poison Column
    -- =========================================================

    local poisonColumn = CreateFrame(
        "Frame",
        nil,
        section
    )

    poisonColumn:SetPoint(
        "TOPLEFT",
        section,
        "TOPLEFT",
        190,
        0
    )

    poisonColumn:SetSize(
        CONTENT_WIDTH - 190,
        WEAPON_SECTION_HEIGHT
    )

    -- =========================================================
    -- Primary Poison
    -- =========================================================

    CreatePoisonConfiguration(
        poisonColumn,
        hand,
        "primary",
        -10
    )

    -- =========================================================
    -- Fallback Poison
    -- =========================================================

    CreatePoisonConfiguration(
        poisonColumn,
        hand,
        "fallback",
        -105
    )

    CreateHorizontalDivider(section)

    return section, weapon
end

-- =========================================================
-- Alert Row
-- =========================================================

---@param parent Frame
---@param text string
---@param setting table
---@param minValue number
---@param maxValue number
---@param unit string
---@return Frame
local function CreateAlertRow(
    parent,
    text,
    setting,
    minValue,
    maxValue,
    unit
)
    local row = CreateFrame("Frame", nil, parent)

    row:SetSize(CONTENT_WIDTH, 46)

    -- =========================================================
    -- Slider
    -- =========================================================

    local slider = PoisonFlow.Slider:Create(
        row,
        setting.threshold,
        minValue,
        maxValue,
        unit,
        function(value)
            if setting.threshold == value then
                return
            end

            setting.threshold = value

            PoisonFlow.PoisonMonitor:Update()
        end
    )

    slider.Frame:SetPoint(
        "RIGHT",
        row,
        "RIGHT",
        -10,
        -6
    )

    -- =========================================================
    -- Checkbox
    -- =========================================================

    local checkBox = PoisonFlow.CheckBox:Create(
        row,
        text,
        setting.enabled,
        function(checked)
            if setting.enabled == checked then
                return
            end

            setting.enabled = checked

            slider:SetEnabled(checked)

            PoisonFlow.PoisonMonitor:Update()
        end
    )

    checkBox.Frame:SetPoint(
        "LEFT",
        row,
        "LEFT",
        0,
        -6
    )

    slider:SetEnabled(setting.enabled)

    return row
end

-- =========================================================
-- Alerts Section
-- =========================================================

---@param parent Frame
---@return Frame
local function CreateAlertsSection(parent)
    local section = CreateSection(
        parent,
        ALERT_SECTION_HEIGHT
    )

    local db = PoisonFlow.Database:Get()

    -- =========================================================
    -- Title
    -- =========================================================

    local title = section:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    title:SetPoint(
        "TOPLEFT",
        section,
        "TOPLEFT",
        0,
        -8
    )

    title:SetText(L11n.Settings.ALERTS)

    -- =========================================================
    -- Time
    -- =========================================================

    local timeRow = CreateAlertRow(
        section,
        L11n.Settings.ALERT_TIME,
        db.alerts.time,
        1,
        30,
        L11n.Settings.ALERT_TIME_UNIT
    )

    timeRow:SetPoint(
        "TOPLEFT",
        section,
        "TOPLEFT",
        0,
        -34
    )

    -- =========================================================
    -- Charges
    -- =========================================================

    local chargesRow = CreateAlertRow(
        section,
        L11n.Settings.ALERT_CHARGES,
        db.alerts.charges,
        1,
        100,
        L11n.Settings.ALERT_CHARGES_UNIT
    )

    chargesRow:SetPoint(
        "TOPLEFT",
        timeRow,
        "BOTTOMLEFT",
        0,
        -6
    )

    -- =========================================================
    -- Stock
    -- =========================================================

    local stockRow = CreateAlertRow(
        section,
        L11n.Settings.ALERT_POISON,
        db.alerts.stock,
        1,
        100,
        L11n.Settings.ALERT_POISON_UNIT
    )

    stockRow:SetPoint(
        "TOPLEFT",
        chargesRow,
        "BOTTOMLEFT",
        0,
        -6
    )

    return section
end

-- =========================================================
-- Create Settings Frame
-- =========================================================

local function CreateSettingsFrame()
    local frame = CreateFrame(
        "Frame",
        "PoisonFlowSettingsFrame",
        UIParent,
        "BackdropTemplate"
    )

    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

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

    -- =========================================================
    -- Background
    -- =========================================================

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
    })

    frame:SetBackdropColor(
        0.025,
        0.022,
        0.018,
        0.94
    )

    -- =========================================================
    -- Header
    -- =========================================================

    local title = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

    title:SetPoint(
        "TOP",
        frame,
        "TOP",
        0,
        -12
    )

    title:SetText(PoisonFlow.Name)

    local closeButton = CreateFrame(
        "Button",
        nil,
        frame
    )

    closeButton:SetSize(20, 20)

    closeButton:SetPoint(
        "TOPRIGHT",
        frame,
        "TOPRIGHT",
        -10,
        -10
    )

    local closeText = closeButton:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    closeText:SetPoint("CENTER")
    closeText:SetText("×")

    closeButton:SetScript(
        "OnClick",
        function()
            frame:Hide()
        end
    )

    -- =========================================================
    -- Header Divider
    -- =========================================================

    local headerDivider = frame:CreateTexture(
        nil,
        "ARTWORK"
    )

    headerDivider:SetHeight(1)

    headerDivider:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        PADDING,
        -46
    )

    headerDivider:SetPoint(
        "TOPRIGHT",
        frame,
        "TOPRIGHT",
        -PADDING,
        -46
    )

    headerDivider:SetColorTexture(unpack(COLOR_GOLD))

    -- =========================================================
    -- Main Hand Section
    -- =========================================================

    local mainHandSection, mainHandWeapon =
        CreateWeaponSection(
            frame,
            "mainHand",
            L11n.Main.MAIN_HAND
        )

    mainHandSection:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        PADDING,
        -58
    )

    -- =========================================================
    -- Off Hand Section
    -- =========================================================

    local offHandSection, offHandWeapon =
        CreateWeaponSection(
            frame,
            "offHand",
            L11n.Main.OFF_HAND
        )

    offHandSection:SetPoint(
        "TOPLEFT",
        mainHandSection,
        "BOTTOMLEFT",
        0,
        -SECTION_GAP
    )

    -- =========================================================
    -- Alerts Section
    -- =========================================================

    local alertsSection = CreateAlertsSection(frame)

    alertsSection:SetPoint(
        "TOPLEFT",
        offHandSection,
        "BOTTOMLEFT",
        0,
        -SECTION_GAP
    )

    frame:Hide()

    return frame, mainHandWeapon, offHandWeapon
end

-- =========================================================
-- Initialize
-- =========================================================

function Settings:Initialize()
    if self.Frame then
        return
    end

    self.Frame,
    self.MainHandWeapon,
    self.OffHandWeapon = CreateSettingsFrame()
end

-- =========================================================
-- Refresh
-- =========================================================

function Settings:Refresh()
    if not self.Frame or not self.Frame:IsShown() then
        return
    end

    if self.MainHandWeapon then
        self.MainHandWeapon:Update()
    end

    if self.OffHandWeapon then
        self.OffHandWeapon:Update()
    end
end

-- =========================================================
-- Show
-- =========================================================

function Settings:Show()
    if not self.Frame then
        self:Initialize()
    end

    self.Frame:Show()
    self:Refresh()
end

-- =========================================================
-- Hide
-- =========================================================

function Settings:Hide()
    if self.Frame then
        self.Frame:Hide()
    end
end

-- =========================================================
-- Toggle
-- =========================================================

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