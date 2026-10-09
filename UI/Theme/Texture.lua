local PoisonFlow = _G.PoisonFlow

---@class PoisonFlowTexture
local Texture = {}
PoisonFlow.Texture = Texture

-- =========================================================
-- Constants
-- =========================================================

local BASE_PATH = "Interface\\AddOns\\PoisonFlow\\Assets\\UI\\"
local ICON_PATH = "Interface\\AddOns\\PoisonFlow\\Assets\\PoisonFlow"

Texture.Icon = ICON_PATH

-- =========================================================
-- Window
-- =========================================================

Texture.Window = {
    Frame = BASE_PATH .. "WindowFrame",
    Background = BASE_PATH .. "Background",
}

-- =========================================================
-- Border
-- =========================================================

Texture.Border = {
    Corner = {
        TopLeft = BASE_PATH .. "BorderCornerTL",
        TopRight = BASE_PATH .. "BorderCornerTR",
        BottomLeft = BASE_PATH .. "BorderCornerBL",
        BottomRight = BASE_PATH .. "BorderCornerBR",
    },
    Horizontal = BASE_PATH .. "BorderHorizontal",
    Vertical = BASE_PATH .. "BorderVertical",
}

-- =========================================================
-- Divider
-- =========================================================

Texture.Divider = {
    Horizontal = BASE_PATH .. "DividerHorizontal",
    Vertical = BASE_PATH .. "DividerVertical",
}

-- =========================================================
-- Slot
-- =========================================================

Texture.Slot = {
    Border = BASE_PATH .. "SlotBorder",
}

-- =========================================================
-- Button
-- =========================================================

Texture.Button = {
    Add = BASE_PATH .. "AddButton",
    AddSmall = BASE_PATH .. "AddButtonSmall",
    Close = BASE_PATH .. "CloseButton",
}

-- =========================================================
-- Title
-- =========================================================

Texture.Title = {
    Left = BASE_PATH .. "TitleLeft",
    Center = BASE_PATH .. "TitleCenter",
    Right = BASE_PATH .. "TitleRight",
    Glow = BASE_PATH .. "HeaderGlow",
}