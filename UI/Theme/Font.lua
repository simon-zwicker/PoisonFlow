local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Font
-- =========================================================

---@class PoisonFlowFont
local Font = {}

PoisonFlow.Font = Font

-- =========================================================
-- Locale Fonts
-- =========================================================

local LOCALE_FONTS = {
    ruRU = "Fonts\\FRIZQT___CYR.TTF",
    zhCN = "Fonts\\ARKai_T.ttf",
    zhTW = "Fonts\\bLEI00D.ttf",
    koKR = "Fonts\\2002.TTF",
}

-- =========================================================
-- Get Font
-- =========================================================

---@return string
function Font:Get()
    local locale = PoisonFlow.Localization:GetActiveLocale()

    return LOCALE_FONTS[locale] or STANDARD_TEXT_FONT
end