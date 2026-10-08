local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowMinimapButton
---@field Frame Button?
local MinimapButton = {}
PoisonFlow.MinimapButton = MinimapButton

-- =========================================================
-- Constants
-- =========================================================

local BUTTON_SIZE = 32
local MINIMAP_RADIUS = 80
local ICON_TEXTURE = "Interface\\AddOns\\PoisonFlow\\Assets\\PoisonFlow"

-- =========================================================
-- Position Update
-- =========================================================

---@param frame Button
---@param angle number
local function UpdatePosition(frame, angle)
    local radians = math.rad(angle)
    local x = math.cos(radians) * MINIMAP_RADIUS
    local y = math.sin(radians) * MINIMAP_RADIUS
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

---@return number
local function GetCursorAngle()
    local minimapX, minimapY = Minimap:GetCenter()
    if not minimapX or not minimapY then
        return 225
    end
    local cursorX, cursorY = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    cursorX = cursorX / scale
    cursorY = cursorY / scale
    local angle = math.deg(math.atan2(cursorY - minimapY, cursorX - minimapX))
    return angle
end

-- =========================================================
-- Create
-- =========================================================

local function CreateMinimapButton()
    local frame = CreateFrame("Button", "PoisonFlowMinimapButton", Minimap)
    frame:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    local db = PoisonFlow.Database:Get()
    UpdatePosition(frame, db.minimap.angle)
    frame:SetFrameStrata("MEDIUM")
    frame:RegisterForClicks("LeftButtonUp")
    frame:RegisterForDrag("LeftButton")

    local icon = frame:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture(ICON_TEXTURE)
    icon:SetAllPoints(frame)

    frame:SetScript(
        "OnClick",
        function()
            PoisonFlow.Settings:Toggle()
        end
    )

    frame:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText(PoisonFlow.Name, 1, 0.82, 0, 1.0)
            GameTooltip:AddLine(L11n.MINIMAP_TOOLTIP, 1, 1, 1)
            GameTooltip:Show()
        end
    )

    frame:SetScript(
        "OnLeave",
        function()
            GameTooltip:Hide()
        end
    )

    frame:SetScript(
        "OnDragStart",
        function(self)
            self:SetScript(
                "OnUpdate",
                function()
                    local angle = GetCursorAngle()
                    local db = PoisonFlow.Database:Get()
                    db.minimap.angle = angle
                    UpdatePosition(self, angle)
                end
            )
        end
    )

    frame:SetScript(
        "OnDragStop",
        function(self)
            self:SetScript("OnUpdate", nil)
        end
    )

    return frame
end

-- =========================================================
-- Initialize
-- =========================================================

function MinimapButton:Initialize()
    if self.Frame then
        return
    end
    self.Frame = CreateMinimapButton()
end