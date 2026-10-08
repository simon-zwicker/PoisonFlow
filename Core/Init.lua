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
---@field NumberInput PoisonFlowNumberInput
---@field PoisonMonitor PoisonFlowPoisonMonitor

local PoisonFlow = {}

_G.PoisonFlow = PoisonFlow
PoisonFlow.Name = ADDON_NAME
PoisonFlow.Version = "0.1.0"

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
        PoisonFlow.PoisonMonitor:Initialize()
        local L11n = PoisonFlow.Localization:Get()
        
        print("|cff00cc66PoisonFlow|r " .. L11n.LOADED)
        self:UnregisterEvent("ADDON_LOADED")
    end
)