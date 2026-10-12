local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowWeaponEnchantInfo
---@field enchantID number
---@field enchantType number
---@field remainingTimeMs number
---@field charges number
---@field iconID number
---@field name string?

---@class PoisonFlowWeaponEnchantService
local WeaponEnchantService = {}

PoisonFlow.WeaponEnchantService = WeaponEnchantService

-- =========================================================
-- Constants
-- =========================================================

local ENCHANT_TYPE_IMBUE = 3

local MAIN_HAND_INVENTORY_SLOT = 16
local OFF_HAND_INVENTORY_SLOT = 17

-- =========================================================
-- Get Inventory Slot
-- =========================================================

---@param weaponSlot number
---@return number?
local function GetInventorySlot(weaponSlot)
    if weaponSlot == 0 then
        return MAIN_HAND_INVENTORY_SLOT
    end

    if weaponSlot == 1 then
        return OFF_HAND_INVENTORY_SLOT
    end

    return nil
end

-- =========================================================
-- Weapon Equipped
-- =========================================================

---@param weaponSlot number
---@return boolean
function WeaponEnchantService:IsWeaponEquipped(weaponSlot)
    local inventorySlot = GetInventorySlot(weaponSlot)

    if not inventorySlot then
        return false
    end

    return GetInventoryItemID("player", inventorySlot) ~= nil
end

-- =========================================================
-- Is Enchant Tooltip Line
-- =========================================================

---@param line table
---@return boolean
local function IsEnchantTooltipLine(line)
    if line.type ~= 0 or not line.leftText then
        return false
    end

    local color = line.leftColor

    if not color then
        return false
    end

    -- Temporary weapon enchants are displayed in green.
    if color.r > 0.1 or color.g < 0.9 or color.b > 0.1 then
        return false
    end

    return true
end

-- =========================================================
-- Parse Tooltip Enchant
-- =========================================================

---@param text string
---@return string?, number?
local function ParseTooltipEnchant(text)
    -- Examples:
    -- deDE: Sofort wirkendes Gift (29 Min.) (60 Aufladungen)
    -- enUS: Instant Poison (29 min) (60 charges)

    local name, duration, charges = text:match(
        "^(.-)%s+%((%d+%s+[^()]+)%)%s+%((%d+)%s+[^()]+%)$"
    )

    if name and duration and charges then
        return name, tonumber(charges)
    end

    -- Temporary enchants without charges.
    local nameWithoutCharges, durationWithoutCharges = text:match(
        "^(.-)%s+%((%d+%s+[^()]+)%)$"
    )

    if nameWithoutCharges and durationWithoutCharges then
        return nameWithoutCharges, nil
    end

    return nil, nil
end

-- =========================================================
-- Get Tooltip Enchant
-- =========================================================

---@param inventorySlot number
---@return string?, number?
local function GetTooltipEnchant(inventorySlot)
    local tooltip = C_TooltipInfo.GetInventoryItem(
        "player",
        inventorySlot
    )

    if not tooltip or not tooltip.lines then
        return nil, nil
    end

    local matchedName = nil
    local matchedCharges = nil

    for _, line in ipairs(tooltip.lines) do
        if IsEnchantTooltipLine(line) then
            local name, charges = ParseTooltipEnchant(
                line.leftText
            )

            if name then
                -- Ambiguous tooltip: do not guess.
                if matchedName then
                    return nil, nil
                end

                matchedName = name
                matchedCharges = charges
            end
        end
    end

    return matchedName, matchedCharges
end

-- =========================================================
-- Get Enchant Info
-- =========================================================

---@param weaponSlot number
---@return PoisonFlowWeaponEnchantInfo?
function WeaponEnchantService:Get(weaponSlot)
    local enchants = C_Item.GetWeaponEnchantInfo(weaponSlot)

    if not enchants then
        return nil
    end

    for _, enchant in ipairs(enchants) do
        if enchant.hasEnchant
            and enchant.enchantType == ENCHANT_TYPE_IMBUE
        then
            local name = nil
            local charges = enchant.charges or 0

            local inventorySlot = GetInventorySlot(weaponSlot)

            if inventorySlot then
                local tooltipName, tooltipCharges =
                    GetTooltipEnchant(inventorySlot)

                name = tooltipName

                if tooltipCharges then
                    charges = tooltipCharges
                end
            end

            ---@type PoisonFlowWeaponEnchantInfo
            return {
                enchantID = enchant.enchantID,
                enchantType = enchant.enchantType,
                remainingTimeMs = enchant.timeLeft,
                charges = charges,
                iconID = enchant.enchantIconID,
                name = name,
            }
        end
    end

    return nil
end