local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowCheckBoxInstance
---@field Frame CheckButton
---@field Label FontString

---@class PoisonFlowCheckBox
local CheckBox = {}
PoisonFlow.CheckBox = CheckBox

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param text string
---@param checked boolean
---@param onChanged fun(checked: boolean)?
---@return PoisonFlowCheckBoxInstance
function CheckBox:Create(parent, text, checked, onChanged)
    local frame = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    frame:SetSize(24, 24)
    frame:SetChecked(checked)

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", frame, "RIGHT", 4, 0)
    label:SetText(text)

    frame:SetScript(
        "OnClick",
        function(self)
            local isChecked = self:GetChecked()
            if onChanged then
                onChanged(isChecked == true)
            end
        end
    )

    ---@type PoisonFlowCheckBoxInstance
    local checkBox = {
        Frame = frame,
        Label = label,
    }

    return checkBox
end