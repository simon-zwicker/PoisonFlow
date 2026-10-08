local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowNumberInputInstance
---@field Frame EditBox

---@class PoisonFlowNumberInput
local NumberInput = {}
PoisonFlow.NumberInput = NumberInput

-- =========================================================
-- Constants
-- =========================================================

local INPUT_WIDTH = 60
local INPUT_HEIGHT = 24

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param value number
---@param minValue number
---@param maxValue number
---@param onChanged fun(value: number)?
---@return PoisonFlowNumberInputInstance
function NumberInput:Create(parent, value, minValue, maxValue, onChanged)
    local frame = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    frame:SetSize(INPUT_WIDTH, INPUT_HEIGHT)
    frame:SetAutoFocus(false)
    frame:SetNumeric(true)
    frame:SetMaxLetters(tostring(maxValue):len())
    frame:SetText(tostring(value))

    local function ApplyValue()
        local newValue = tonumber(frame:GetText())

        if not newValue then
            newValue = minValue
        end

        newValue = math.max(minValue, math.min(maxValue, newValue))
        
        frame:SetText(tostring(newValue))
        frame:ClearFocus()
        if onChanged then
            onChanged(newValue)
        end
    end

    frame:SetScript(
        "OnEnterPressed",
        function()
            ApplyValue()
        end
    )

    frame:SetScript(
        "OnEditFocusLost",
        function()
            ApplyValue()
        end
    )

    local numberInput = {
        Frame = frame
    }

    return numberInput
end