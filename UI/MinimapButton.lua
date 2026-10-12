local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()
local Texture = PoisonFlow.Texture

-- =========================================================
-- Types
-- =========================================================
---@class PoisonFlowMinimapButton
---@field DataObject table?
local MinimapButton = {}

PoisonFlow.MinimapButton = MinimapButton

-- =========================================================
-- Constants
-- =========================================================

local ADDON_NAME = "PoisonFlow"

-- =========================================================
-- Create Data Object
-- =========================================================

---@return table
local function CreateDataObject()
    local LDB = LibStub("LibDataBroker-1.1")

    return LDB:NewDataObject(
        ADDON_NAME,
        {
            type = "launcher",
            icon = Texture.RogueIcon,
            iconCoords = {
                0.49609375,
                0.7421875,
                0,
                0.25
            },
            
            OnClick = function(_, mouseButton)
                if mouseButton == "LeftButton" then
                    PoisonFlow.Settings:Toggle()
                end
            end,

            OnTooltipShow = function(tooltip)
                tooltip:AddLine(PoisonFlow.Name, 1, 0.82, 0 )
                tooltip:AddLine(L11n.Minimap.TOOLTIP, 1, 1, 1)
            end,
        }
    )
end

-- =========================================================
-- Initialize
-- =========================================================

function MinimapButton:Initialize()
    if self.DataObject then
        return
    end

    local DBIcon = LibStub("LibDBIcon-1.0")
    local db = PoisonFlow.Database:Get()

    if not db then
        return
    end

    self.DataObject = CreateDataObject()
    DBIcon:Register(ADDON_NAME, self.DataObject, db.minimap)
end