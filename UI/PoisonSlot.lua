local PoisonFow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonSlotInstance
---@field Frame Button
---@field Icon Texture
---@field Plus FontString
---@field Title FontString
---@field Name FontString
---@field Count FontString
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
-- Get Slot Title
-- =========================================================

---@param slotType string
---@return string
local function GetSlotTitle(slotType)
    if slotType == "primary" then
        return L11n.PRIMARY_POISON
    end
    return L11n.FALLBACK_POISON
end

-- =========================================================
-- Get Poison Data
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
---@return number?
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
    local itemID = GetPoisonData(slot)


    if not itemID then
        slot.Icon:SetTexture(nil)
        slot.Icon:Hide()
        slot.Plus:Show()

        slot.Name:SetText("")
        slot.Count:SetText("")

        return
    end

    local icon = C_Item.GetItemIconByID(itemID)
    local itemName = C_Item.GetItemNameByID(itemID)
    local itemCount = C_Item.GetItemCount(itemID)
    
    if icon then
        slot.Icon:SetTexture(icon)
        slot.Icon:Show()
        slot.Plus:Hide()
    else
        slot.Icon:SetTexture(nil)
        slot.Icon:Hide()
        slot.Plus:Show()
    end

    slot.Name:SetText(itemName or "")
    slot.Count:SetText(string.format(L11n.ITEM_COUNT, itemCount or 0))
end

-- =========================================================
-- Set Poison Data
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
---@param itemID number?
local function SetPoisonData(slot, itemID)
    local db = PoisonFlow.Database:Get()
    local handData = db[slot.Hand]

    if not handData then
        return
    end

    handData[slot.SlotType] = itemID
end

-- =========================================================
-- Handle Cursor Item
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
local function HandleCursorItem(slot)
    local cursorType, cursorData, itemLink = GetCursorInfo()
    
    if cursorType ~= "item" then
        return
    end

    if type(cursorData) ~= "number" then
        return
    end

    local itemID = cursorData
    
    if not PoisonFow.Poison:IsPoison(itemID) then
        print("|cffff4444PoisonFlow:|r", L11n.INVALID_POISON, itemLink)
        return
    end

    SetPoisonData(slot, itemID)
    print("PoisonFlow DEBUG saved: ", slot.Hand, slot.SlotType, itemID, GetPoisonData(slot))
    Update(slot)
    ClearCursor()

    print("|cff00cc66PoisonFlow:|r", L11n.VALID_POISON, itemLink)
end

-- =========================================================
-- Tooltip
-- =========================================================

---@param slot PoisonFlowPoisonSlotInstance
local function ShowTooltip(slot)
    local itemID = GetPoisonData(slot)

    if not itemID then
        return
    end

    GameTooltip:SetOwner(slot.Frame, "ANCHOR_RIGHT")
    GameTooltip:SetItemByID(itemID)
    GameTooltip:Show()
end

local function HideTooltip()
    GameTooltip:Hide()
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
    frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
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

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("BOTTOM", frame, "TOP", 0, 8)
    title:SetText(GetSlotTitle(slotType))

    local name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    name:SetPoint("TOP", frame, "BOTTOM", 0, -8)
    name:SetText("")

    local count = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    count:SetPoint("TOP", name, "BOTTOM", 0, -3)
    count:SetText("")

    local slot = {
        Frame = frame,
        Icon = icon,
        Plus = plus,
        Title = title,
        Name = name,
        Count = count,
        Hand = hand,
        SlotType = slotType,
    }

    frame:SetScript(
        "OnReceiveDrag",
        function()
            HandleCursorItem(slot)
        end
    )
    frame:SetScript(
        "OnClick",
        function(_, button)
            if button == "LeftButton" then
                HandleCursorItem(slot)
                return
            end

            if button == "RightButton" then
                SetPoisonData(slot, nil)
                Update(slot)
                HideTooltip()
            end
        end
    )
    frame:SetScript(
        "OnEnter",
        function()
            ShowTooltip(slot)
        end
    )
    frame:SetScript(
        "OnLeave",
        function()
            HideTooltip()
        end
    )

    Update(slot)

    return slot
end