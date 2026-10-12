local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowWeaponSlotInstance
---@field Frame Button
---@field Icon Texture
---@field InventorySlotID number
---@field EnchantSlot number
---@field StatusTitle FontString
---@field StatusName FontString
---@field StatusTime FontString
---@field StatusCharges FontString
---@field SectionTitle FontString?
---@field PrimaryPoison PoisonFlowPoisonSlotInstance?
---@field FallbackPoison PoisonFlowPoisonSlotInstance?
---@field Update fun(self: PoisonFlowWeaponSlotInstance)

---@class PoisonFlowWeaponSlot
local WeaponSlot = {}

PoisonFlow.WeaponSlot = WeaponSlot

-- =========================================================
-- Constants
-- =========================================================

local SLOT_SIZE = 48

local MAIN_HAND_SLOT = 16
local OFF_HAND_SLOT = 17

local MAIN_HAND_ENCHANT_SLOT = 0
local OFF_HAND_ENCHANT_SLOT = 1

local STATUS_COLOR = {
    Normal = { 1.0, 1.0, 1.0 },
    Danger = { 1.0, 0.2, 0.2 },
}

-- =========================================================
-- Get Inventory Slot
-- =========================================================

---@param hand string
---@return number
local function GetInventorySlotID(hand)
    if hand == "mainHand" then
        return MAIN_HAND_SLOT
    end
    return OFF_HAND_SLOT
end

-- =========================================================
-- Get Enchant Slot
-- =========================================================

---@param hand string
---@return number
local function GetEnchantSlot(hand)
    if hand == "mainHand" then
        return MAIN_HAND_ENCHANT_SLOT
    end
    return OFF_HAND_ENCHANT_SLOT
end

-- =========================================================
-- Update
-- =========================================================

---@param slot PoisonFlowWeaponSlotInstance
local function Update(slot)
        -- =========================================================
    -- Localization
    -- =========================================================

    slot.StatusTitle:SetText(L11n.Main.CURRENT_POISON)
    
    -- =========================================================
    -- Weapon Icon
    -- =========================================================

    local texture = GetInventoryItemTexture(
        "player",
        slot.InventorySlotID
    )

    if texture then
        slot.Icon:SetTexture(texture)
        slot.Icon:Show()
    else
        slot.Icon:SetTexture(nil)
        slot.Icon:Hide()
    end

    -- =========================================================
    -- Weapon Not Equipped
    -- =========================================================

    local weaponEquipped = PoisonFlow.WeaponEnchantService:IsWeaponEquipped(
        slot.EnchantSlot
    )

    if not weaponEquipped then
        slot.StatusName:SetText(L11n.Main.WEAPON_NOT_EQUIPPED)

        slot.StatusName:SetTextColor(
            unpack(STATUS_COLOR.Danger)
        )

        slot.StatusTime:SetText("")
        slot.StatusCharges:SetText("")

        return
    end

    -- =========================================================
    -- Weapon Enchant
    -- =========================================================

    slot.StatusName:SetTextColor(
        unpack(STATUS_COLOR.Normal)
    )

    local enchant = PoisonFlow.WeaponEnchantService:Get(
        slot.EnchantSlot
    )

    if not enchant then
        slot.StatusName:SetText(L11n.Main.NO_ACTIVE_POISON)
        slot.StatusTime:SetText("")
        slot.StatusCharges:SetText("")

        return
    end

    slot.StatusName:SetText(
        enchant.name or L11n.Main.POISON_ACTIVE
    )

    -- =========================================================
    -- Remaining Time
    -- =========================================================

    if enchant.remainingTimeMs and enchant.remainingTimeMs > 0 then
        local minutes = math.ceil(
            enchant.remainingTimeMs / 60000
        )

        slot.StatusTime:SetText(
            string.format(
                L11n.Main.REMAINING_MINUTES,
                minutes
            )
        )
    else
        slot.StatusTime:SetText("")
    end

    -- =========================================================
    -- Charges
    -- =========================================================

    if enchant.charges and enchant.charges > 0 then
        slot.StatusCharges:SetText(
            string.format(
                L11n.Main.REMAINING_CHARGES,
                enchant.charges
            )
        )
    else
        slot.StatusCharges:SetText("")
    end
end

-- =========================================================
-- Create
-- =========================================================

---@param parent Frame
---@param hand string
---@return PoisonFlowWeaponSlotInstance
function WeaponSlot:Create(parent, hand)
    local inventorySlotID = GetInventorySlotID(hand)

    local frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
    frame:SetSize(SLOT_SIZE, SLOT_SIZE)
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

    -- =========================================================
    -- Current Poison Status
    -- =========================================================

    local statusTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusTitle:SetPoint("TOP", frame, "BOTTOM", 0, -12)
    statusTitle:SetText(L11n.Main.CURRENT_POISON)

    local statusName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusName:SetPoint("TOP", statusTitle, "BOTTOM", 0, -4)
    statusName:SetWidth(140)
    statusName:SetJustifyH("CENTER")

    local statusTime = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusTime:SetPoint("TOP", statusName, "BOTTOM", 0, -3)
    
    local statusCharges = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusCharges:SetPoint("TOP", statusTime, "BOTTOM", 0, -3)

    ---@type PoisonFlowWeaponSlotInstance
    local slot = {
        Frame = frame,
        Icon = icon,
        InventorySlotID = inventorySlotID,
        EnchantSlot = GetEnchantSlot(hand),
        StatusTitle = statusTitle,
        StatusName = statusName,
        StatusTime = statusTime,
        StatusCharges = statusCharges,
        Update = Update,
    }

    function slot:Update()
        Update(self)
    end

    frame:SetScript(
        "OnEnter",
        function(self)
            local itemLink = GetInventoryItemLink("player", slot.InventorySlotID)

            if not itemLink then
                return
            end

            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(itemLink)
            GameTooltip:Show()
        end
    )
    frame:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )

    slot:Update()

    return slot
end
