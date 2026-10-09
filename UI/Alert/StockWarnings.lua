local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowStockWarnings
---@field Frame Frame?
---@field Lines FontString[]
local StockWarnings = {
    Lines = {},
}
PoisonFlow.StockWarnings = StockWarnings

-- =========================================================
-- Constants
-- =========================================================

local FRAME_WIDTH = 420
local PADDING_HORIZONTAL = 16
local PADDING_VERTICAL = 12
local LINE_HEIGHT = 18
local LINE_SPACING = 4

-- =========================================================
-- Create
-- =========================================================

local function CreateStockFrame()
    local frame = CreateFrame("Frame", "PoisonFlowStockWarnings", UIParent, "BackdropTemplate")
    frame:SetWidth(FRAME_WIDTH)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0.04, 0.04, 0.04, 0.95)
    frame:SetBackdropBorderColor(0.55, 0.42, 0.18, 1.0)
    frame:Hide()
    StockWarnings.Frame = frame
end

-- =========================================================
-- Initialize
-- =========================================================

function StockWarnings:Initialize()
    if self.Frame then
        return
    end
    CreateStockFrame()
end

-- =========================================================
-- Lines
-- =========================================================

---@param index number
---@return FontString
local function GetLine(index)
    local line = StockWarnings.Lines[index]

    if line then
        return line
    end

    line = StockWarnings.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    line:SetJustifyH("LEFT")
    line:SetHeight(LINE_HEIGHT)

    StockWarnings.Lines[index] = line
    
    return line
end

local function HideAllLines()
    for _, line in ipairs(StockWarnings.Lines) do
        line:Hide()
    end
end

-- =========================================================
-- Messages
-- =========================================================

---@param messages string[]
function StockWarnings:SetMessages(messages)
    self:Initialize()
    HideAllLines()

    if #messages == 0 then
        self.Frame:Hide()
        return
    end

    local previousLine = nil

    for index, message in ipairs(messages) do 
        local line = GetLine(index)
        line:ClearAllPoints()

        if previousLine then
            line:SetPoint("TOPLEFT", previousLine, "BOTTOMLEFT", 0, -LINE_SPACING)
        else
            line:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", PADDING_HORIZONTAL, -PADDING_VERTICAL)
        end

        line:SetPoint("RIGHT", self.Frame, "RIGHT", -PADDING_HORIZONTAL, 0)
        line:SetText(message)
        line:Show()
        previousLine = line
    end

    local contentHeight = (#messages * LINE_HEIGHT) +((#messages - 1) * LINE_SPACING)
    local frameHeight = contentHeight + (PADDING_VERTICAL * 2)
    self.Frame:SetHeight(frameHeight)
    self.Frame:Show()
end

-- =========================================================
-- Hide
-- =========================================================

function StockWarnings:Hide()
    if not self.Frame then
        return
    end

    HideAllLines()
    self.Frame:Hide()
end