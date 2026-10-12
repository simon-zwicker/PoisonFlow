local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowSliderInstance
---@field Frame Slider
---@field Value FontString
---@field SetEnabled fun(self: PoisonFlowSliderInstance, enabled: boolean)
---@field SetUnit fun(self: PoisonFlowSliderInstance, unit: string)

---@class PoisonFlowSlider
local Slider = {}

PoisonFlow.Slider = Slider

-- =========================================================
-- Constants
-- =========================================================

local SLIDER_WIDTH = 150
local SLIDER_HEIGHT = 8

local COLOR_GOLD = { 0.75, 0.55, 0.22, 1.0 }
local COLOR_DISABLED = { 0.35, 0.35, 0.35, 1.0 }

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param value number
---@param minValue number
---@param maxValue number
---@param unit string
---@param onChanged fun(value: number)?
---@return PoisonFlowSliderInstance
function Slider:Create(parent, value, minValue, maxValue, unit, onChanged)
    local frame = CreateFrame("Slider", nil, parent)
    frame:SetSize(SLIDER_WIDTH, SLIDER_HEIGHT)
    frame:SetOrientation("HORIZONTAL")
    frame:SetMinMaxValues(minValue, maxValue)
    frame:SetValueStep(1)
    frame:SetObeyStepOnDrag(true)

    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0.12, 0.10, 0.07, 0.95)

    local progress = frame:CreateTexture(nil, "ARTWORK")
    progress:SetColorTexture(unpack(COLOR_GOLD))
    progress:SetPoint("LEFT", frame, "LEFT")
    progress:SetHeight(SLIDER_HEIGHT)

    local thumb = frame:CreateTexture(nil, "OVERLAY")
    thumb:SetSize(12, 16)
    thumb:SetColorTexture(unpack(COLOR_GOLD))
    frame:SetThumbTexture(thumb)

    local valueText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    valueText:SetPoint("BOTTOM", frame, "TOP", 0, 8)

    local instance = {
        Frame = frame,
        Value = valueText,
    }
    local currentUnit = unit
    local function UpdateVisuals(currentValue)
        local rounded = math.floor(currentValue + 0.5)
        valueText:SetText(string.format("%d %s", rounded, currentUnit))

        local range = maxValue - minValue
        local progressValue = 0

        if range > 0 then
            progressValue = (rounded - minValue) / range
        end

        progress:SetWidth(math.max(1, SLIDER_WIDTH * progressValue))
    end

    -- =========================================================
    -- Set Unit
    -- =========================================================

    function instance:SetUnit(newUnit)
        currentUnit = newUnit

        UpdateVisuals(frame:GetValue())
    end

    frame:SetScript(
        "OnValueChanged",
        function(_, currentValue)
            local rounded = math.floor(currentValue + 0.5)

            UpdateVisuals(rounded)

            if onChanged then
                onChanged(rounded)
            end
        end
    )

    function instance:SetEnabled(enabled)
        if enabled then
            frame:Enable()
            thumb:SetColorTexture(unpack(COLOR_GOLD))
            valueText:SetTextColor(1, 0.82, 0.4)
        else
            frame:Disable()
            thumb:SetColorTexture(unpack(COLOR_DISABLED))
            valueText:SetTextColor(0.5, 0.5, 0.5)
        end
    end

    frame:SetValue(value)
    UpdateVisuals(value)

    return instance
end