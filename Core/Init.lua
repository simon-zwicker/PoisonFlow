local ADDON_NAME = ...

-- =====================================================
-- Types
-- =====================================================

---@class PoisonFlow
---@field Name string
---@field Version string
---@field Localization PoisonFlowLocalization
---@field Database PoisonFlowDatabase
---@field Poison PoisonFlowPoison
---@field WeaponEnchantService PoisonFlowWeaponEnchantService
---@field Settings PoisonFlowSettings
---@field WeaponSlot PoisonFlowWeaponSlot
---@field PoisonSlot PoisonFlowPoisonSlot
---@field CheckBox PoisonFlowCheckBox
---@field Slider PoisonFlowSlider
---@field PoisonMonitor PoisonFlowPoisonMonitor
---@field PoisonService PoisonFlowPoisonService
---@field PoisonStockMonitor PoisonFlowPoisonStockMonitor
---@field WarningManager PoisonFlowWarningManager
---@field MinimapButton PoisonFlowMinimapButton
---@field Texture PoisonFlowTexture
---@field PoisonFlowButton PoisonFlowButton
---@field Warning PoisonFlowWarning
---@field ButtonTooltip PoisonFlowButtonTooltip
---@field Font PoisonFlowFont
---@field PoisonBagFilter PoisonFlowPoisonBagFilter

local PoisonFlow = {}

_G.PoisonFlow = PoisonFlow
PoisonFlow.Name = ADDON_NAME
PoisonFlow.Version = "1.0.0"

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript(
    "OnEvent",
    function(self, event, addonName)
        if event ~= "ADDON_LOADED" then
            return
        end

        if addonName ~= ADDON_NAME then
            return
        end

        PoisonFlow.Database:Initialize()
        PoisonFlow.PoisonFlowButton:Initialize()
        PoisonFlow.MinimapButton:Initialize()
        PoisonFlow.WarningManager:Initialize()
        PoisonFlow.PoisonMonitor:Initialize()
        local L11n = PoisonFlow.Localization:Get()
        
        print("|cff00cc66PoisonFlow|r " .. L11n.Main.LOADED .. "Version: " .. PoisonFlow.Version)
        self:UnregisterEvent("ADDON_LOADED")
    end
)

-- =========================================================
-- Testing AREA
-- =========================================================

local LibLayout = _G.LibLayout

local window = CreateFrame("Frame", nil, UIParent)
window:SetSize(500, 350)
window:SetPoint("CENTER")

local background = window:CreateTexture(nil, "BACKGROUND")
background:SetColorTexture(0.12, 0.10, 0.08, 0.95)

LibLayout:Make(background, function(make)
    make:Edges(window)
end)

local content = CreateFrame("Frame", nil, window)

local contentBackground = content:CreateTexture(nil, "BACKGROUND")
contentBackground:SetAllPoints()
contentBackground:SetColorTexture(0.20, 0.17, 0.12, 1)

LibLayout:Make(content, function(make)
    make:Edges(window):Inset(16)
end)

local button = CreateFrame("Button", nil, content)
button:SetNormalFontObject(GameFontNormal)

button:SetText("Test Button")

local buttonBackground = button:CreateTexture(nil, "BACKGROUND")
buttonBackground:SetAllPoints()
buttonBackground:SetColorTexture(0.35, 0.25, 0.12, 1)

LibLayout:Make(button, function(make)
    make:Top(content):Inset(16)
    make:Trailing(content):Inset(16)
    make:Size(140, 32)
end)

window:Show()