local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowWarningContent
---@field weaponSlot number
---@field headline string
---@field description string
---@field severity string
---@field centered boolean?

---@class PoisonFlowWarningInstance
---@field Frame Frame
---@field Icon Texture
---@field Headline FontString
---@field Description FontString
---@field CloseButton Button

---@class PoisonFlowWarning
local Warning = {}
PoisonFlow.Warning = Warning

-- =========================================================
-- Constants
-- =========================================================

local WARNING = {
    Width = 400,
    Height = 76,

    Padding = 12,

    Background = {
        Color = { 0.02, 0.02, 0.02, 0.70 },
    },

    Divider = {
        Height = 1,
        Color = { 0.65, 0.48, 0.20, 0.85 },
    },

    Icon = {
        Size = 40,
        OffsetX = 16,
    },

    Text = {
        Gap = 5,
        OffsetX = 12,
    },

    Headline = {
        FontSize = 16,
        CenteredFontSize = 22,
    },

    Description = {
        FontSize = 12,
    },

    Colors = {
        Warning = { 1.0, 0.72, 0.12 },
        Danger = { 1.0, 0.25, 0.25 },
        Text = { 1.0, 1.0, 1.0 },
    },

    CloseButton = {
        Size = 18,
        OffsetX = 8,
        OffsetY = 8,
        FontSize = 14,
        Color = { 0.65, 0.65, 0.65 },
        HoverColor = { 1.0, 0.82, 0.0 },
    },
}

-- =========================================================
-- Create Background
-- =========================================================

---@param frame Frame
local function CreateBackground(frame)
    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(frame)
    background:SetColorTexture(unpack(WARNING.Background.Color))
end

-- =========================================================
-- Create Divider
-- =========================================================

---@param frame Frame
---@param isTop boolean
local function CreateDivider(frame, isTop)
    local divider = frame:CreateTexture(nil, "ARTWORK")
    divider:SetHeight(WARNING.Divider.Height)
    divider:SetPoint(isTop and "TOPLEFT" or "BOTTOMLEFT", frame, isTop and "TOPLEFT" or "BOTTOMLEFT", WARNING.Padding, 0)
    divider:SetPoint(isTop and "TOPRIGHT" or "BOTTOMRIGHT", frame, isTop and "TOPRIGHT" or "BOTTOMRIGHT", -WARNING.Padding, 0)
    divider:SetColorTexture(unpack(WARNING.Divider.Color))
end

-- =========================================================
-- Create Icon
-- =========================================================

---@param frame Frame
---@return Texture
local function CreateIcon(frame)
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(WARNING.Icon.Size, WARNING.Icon.Size)
    icon:SetPoint("LEFT", frame, "LEFT", WARNING.Icon.OffsetX, 0)
    return icon
end

-- =========================================================
-- Create Headline
-- =========================================================

---@param frame Frame
---@return FontString
local function CreateHeadline(frame)
    local headline = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    headline:SetFont(PoisonFlow.Font:Get(), WARNING.Headline.FontSize, "OUTLINE")
    local headlineOffsetX = WARNING.Icon.OffsetX + WARNING.Icon.Size + WARNING.Text.OffsetX
    headline:SetPoint("LEFT", frame, "LEFT", headlineOffsetX, WARNING.Text.Gap + 7)
    local headlineWidth = WARNING.Width - WARNING.Icon.OffsetX - WARNING.Icon.Size - WARNING.Text.OffsetX - WARNING.Padding
    headline:SetWidth(headlineWidth)
    headline:SetJustifyH("LEFT")
    return headline
end

-- =========================================================
-- Create Description
-- =========================================================

---@param frame Frame
---@param headline FontString
---@return FontString
local function CreateDescription(frame, headline)
    local description = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    description:SetFont(PoisonFlow.Font:Get(), WARNING.Description.FontSize)
    description:SetPoint("TOPLEFT", headline, "BOTTOMLEFT", 0, -WARNING.Text.Gap)
    local descWidth = WARNING.Width - WARNING.Icon.OffsetX - WARNING.Icon.Size - WARNING.Text.OffsetX - WARNING.Padding
    description:SetWidth(descWidth)
    description:SetJustifyH("LEFT")
    description:SetTextColor(unpack(WARNING.Colors.Text))
    return description
end

-- =========================================================
-- Create Close Button
-- =========================================================

---@param frame Frame
---@return Button
local function CreateCloseButton(frame)
    local constants = WARNING.CloseButton
    local button = CreateFrame("Button", nil, frame)
    button:SetSize(constants.Size, constants.Size)
    button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -constants.OffsetX, -constants.OffsetY)
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetFont(PoisonFlow.Font:Get(), constants.FontSize, "OUTLINE")
    label:SetPoint("CENTER", button, "CENTER", 0, 0)
    label:SetText("×")
    label:SetTextColor(unpack(constants.Color))

    button:SetScript(
        "OnEnter",
        function()
            label:SetTextColor(unpack(constants.HoverColor))
        end
    )

    button:SetScript(
        "OnLeave",
        function()
            label:SetTextColor(unpack(constants.Color))
        end
    
    )
    return button
end

-- =========================================================
-- Create Warning
-- =========================================================

---@param parent Frame
---@return PoisonFlowWarningInstance
function Warning:Create(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(WARNING.Width, WARNING.Height)
    CreateBackground(frame)
    CreateDivider(frame, true)
    CreateDivider(frame, false)
    local headline = CreateHeadline(frame)

    ---@type PoisonFlowWarningInstance
    local instance = {
        Frame = frame,
        Icon = CreateIcon(frame),
        Headline = headline,
        Description = CreateDescription(frame, headline),
        CloseButton = CreateCloseButton(frame),
    }
    frame:Hide()
    return instance
end

-- =========================================================
-- Set Content
-- =========================================================

---@param warning PoisonFlowWarningInstance
---@param content PoisonFlowWarningContent
function Warning:SetContent(warning, content)
    -- =========================================================
    -- Locale Fonts
    -- =========================================================

    local font = PoisonFlow.Font:Get()

    local headlineSize = content.centered
        and WARNING.Headline.CenteredFontSize
        or WARNING.Headline.FontSize

    warning.Headline:SetFont(
        font,
        headlineSize,
        "OUTLINE"
    )

    warning.Description:SetFont(
        font,
        13,
        ""
    )

    local item = GetInventoryItemTexture("player", content.weaponSlot)

    warning.Icon:SetTexture(item)
    warning.Headline:SetText(content.headline)
    warning.Description:SetText(content.description)

    local color = WARNING.Colors.Warning

    if content.severity == "danger" then
        color = WARNING.Colors.Danger
    end

    warning.Headline:SetTextColor(unpack(color))

    -- =====================================================
    -- Centered Warning
    -- =====================================================

    if content.centered then
        warning.Icon:Hide()
        warning.Description:Hide()

        warning.Headline:ClearAllPoints()
        warning.Headline:SetPoint(
            "CENTER",
            warning.Frame,
            "CENTER",
            0,
            0
        )

        warning.Headline:SetWidth(
            WARNING.Width - WARNING.Padding * 2
        )

        warning.Headline:SetJustifyH("CENTER")
        warning.Headline:SetFont(
            PoisonFlow.Font:Get(),
            WARNING.Headline.CenteredFontSize,
            "OUTLINE"
        )

        return
    end

    -- =====================================================
    -- Default Warning
    -- =====================================================

    warning.Icon:Show()
    warning.Description:Show()

    warning.Headline:ClearAllPoints()

    local headlineOffsetX =
        WARNING.Icon.OffsetX
        + WARNING.Icon.Size
        + WARNING.Text.OffsetX

    warning.Headline:SetPoint(
        "LEFT",
        warning.Frame,
        "LEFT",
        headlineOffsetX,
        WARNING.Text.Gap + 7
    )

    warning.Headline:SetWidth(
        WARNING.Width
        - headlineOffsetX
        - WARNING.Padding
    )

    warning.Headline:SetJustifyH("LEFT")

    warning.Headline:SetFont(
        PoisonFlow.Font:Get(),
        WARNING.Headline.FontSize,
        "OUTLINE"
    )
end

-- =========================================================
-- Set On Dismiss
-- =========================================================

---@param warning PoisonFlowWarningInstance
---@param callback fun()
function Warning:SetOnDismiss(warning, callback)
    warning.CloseButton:SetScript("OnClick", callback)
end