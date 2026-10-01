local ADDON_NAME = ...
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
        local L11n = PoisonFlow.Localization:Get()
        
        print("|cff00cc66PoisonFlow|r " .. L11n.LOADED)
        self:UnregisterEvent("ADDON_LOADED")
    end
)