local PoisonFow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonSlotInstance
---@field Frame Button
---@field Icon Texture
---@field Plus FontString
---@field Hand string
---@field SlotType string

---@class PoisonFlowPoisonSlot
local PoisonSlot = {}
PoisonFlow.PoisonSlot = PoisonSlot

-- =========================================================
-- Constants
-- =========================================================

local PRIMARY_SIZE = 64
local FALLBACK_SIZE = 40

-- =========================================================
-- Get Slot Size
-- =========================================================

---@param slotType string
---@return number
local function GetSlotSize(slotType)
    if slotType == "primary" then
        return PRIMARY_SIZE
    end
    return FALLBACK_SIZE
end

-- =========================================================
-- Get Poison Data
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
---@return table?
local function GetPoisonData(slot)
    local db = PoisonFow.Database:Get()
    local handData = db[slot.Hand]
    
    if not handData then
        return nil
    end

    return handData[slot.SlotType]
end

-- =========================================================
-- Update
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
local function Update(slot)
    local poison = GetPoisonData(slot)

    if poison and poison.icon then
        slot.Icon:SetTexture(poison.icon)
        slot.Icon:Show()
        slot.Plus:Hide()

        return 
    end

    slot.Icon:SetTexture(nil)
    slot.Icon:Hide()
    slot.Icon:Show()
end
-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param hand string
---@param slotType string
---@return PoisonFlowPoisonSlotInstance
function PoisonSlot:Create(parent, hand, slotType)
    local size = GetSlotSize(slotType)

    local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
    frame:SetSize(size, size)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    -- frame:SetBackdrop({
    --     bgFile = "Interface\\Button\\WHITE8X8",
    --     edgeFile = "Interface\\Button\\WHITE8X8",
    --     edgeSize = 1,
    -- })
    -- frame:SetBackdropColor(0.04, 0.04, 0.04, 1.0)
    
    -- if slotType == "primary" then
    --     frame:SetBackdropBorderColor(0.85, 0.60, 0.15, 1.0)
    -- else
    --     frame:SetBackdropBorderColor(0.35, 0.35, 0.35, 1.0)
    -- end
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0.04, 0.04, 0.04, 1.0)
    frame:SetBackdropBorderColor(0.55, 0.42, 0.18, 1.0)

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)

    local plus = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    plus:SetPoint("CENTER")
    plus:SetText("+")

    local slot = {
        Frame = frame,
        Icon = icon,
        Plus = plus,
        Hand = hand,
        SlotType = slotType,
    }

    frame:SetScript(
        "OnReceiveDrag",
        function()
            local cursorType, itemID, itemLink = GetCursorInfo()
            print("PoisonFow Drop: ", cursorType, itemID, itemLink)
        end
    )

    Update(slot)

    return slot
end