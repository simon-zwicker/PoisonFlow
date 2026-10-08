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

---@class PoisonFlowWeaponEnchantService
local WeaponEnchantService = {}
PoisonFlow.WeaponEnchantService = WeaponEnchantService

-- =========================================================
-- Constants
-- =========================================================

local ENCHANT_TYPE_IMBUE = 3

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
        if enchant.hasEnchant and enchant.enchantType == ENCHANT_TYPE_IMBUE then

            ---@type PoisonFlowWeaponEnchantInfo
            return {
                enchantID = enchant.enchantID,
                enchantType = enchant.enchantType,
                remainingTimeMs = enchant.timeLeft,
                charges = enchant.charges,
                iconID = enchant.enchantIconID,
            }
        end
    end

    return nil
end