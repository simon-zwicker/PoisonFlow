local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()
local Settings = {}

PoisonFlow.Settings = Settings

local FRAME_WIDTH = 600
local FRAME_HEIGHT = 400

local function CreateSettingsFrame()
    local frame = CreateFrame("Frame", "PoisonFlowSettingsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDraf("LeftButton")
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
    title:SetPoint("TOP", frame, "TOP", 0, -20)
    title:SetText(PoisonFlow.Name)

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

    local mainHandTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mainHandTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 60, -80)
    mainHandTitle:SetText(L11n.MAIN_HAND)

    local offHandTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    offHandTitle:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -60, -80)
    offHandTitle:SetText(L11n.OFF_HAND)

    frame:Hide()

    return frame
end

function Settings:Initialize()
    if self.Frame then
        return
    end
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
        return
    end
    if self.Frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end