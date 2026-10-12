local PoisonFlow = _G.PoisonFlow
local L11n = PoisonFlow.Localization:Get()

---@class PoisonFlowButtonTooltip
local ButtonTooltip = {}

PoisonFlow.ButtonTooltip = ButtonTooltip

local GOLD = { 1.0, 0.82, 0.0 }
local WHITE = { 1.0, 1.0, 1.0 }
local MUTED = { 0.65, 0.65, 0.65 }
local RED = { 1.0, 0.2, 0.2 }

-- =========================================================
-- Configuration
-- =========================================================

---@param weaponSlot number
---@return boolean
local function HasConfiguredPoison(weaponSlot)
    local db = PoisonFlow.Database:Get()

    if not db then
        return false
    end

    local hand = weaponSlot == 0 and "mainHand" or "offHand"
    local config = db[hand]

    if not config then
        return false
    end

    return config.primary ~= nil or config.fallback ~= nil
end

-- =========================================================
-- Tooltip Options
-- =========================================================

local function AddOptions()
    local L = L11n.PFToolTip

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L.OPTIONS, unpack(GOLD))

    local mainHandAction = HasConfiguredPoison(0)
        and L.APPLY_MAIN_HAND
        or L.NO_POISON_CONFIGURED

    local offHandAction = HasConfiguredPoison(1)
        and L.APPLY_OFF_HAND
        or L.NO_POISON_CONFIGURED

    GameTooltip:AddDoubleLine(
        L.LEFT_CLICK,
        mainHandAction,
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )

    GameTooltip:AddDoubleLine(
        L.RIGHT_CLICK,
        offHandAction,
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )

    GameTooltip:AddDoubleLine(
        L.SHIFT_LEFT_CLICK,
        L.MOVE_BUTTON,
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )

    GameTooltip:AddDoubleLine(
        L.SHIFT_RIGHT_CLICK,
        L.OPEN_SETTINGS,
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )
end

-- =========================================================
-- Current Weapon Enchant
-- =========================================================

---@param weaponSlot number
---@param label string
local function AddWeaponInfo(weaponSlot, label)
    local L = L11n.PFToolTip
    local enchant = PoisonFlow.WeaponEnchantService:Get(weaponSlot)

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(label, unpack(GOLD))

    -- =========================================================
    -- Weapon Not Equipped
    -- =========================================================

    if not PoisonFlow.WeaponEnchantService:IsWeaponEquipped(weaponSlot) then
        GameTooltip:AddLine(
            L.NOT_EQUIPPED,
            RED[1], RED[2], RED[3]
        )

        return
    end

    -- =========================================================
    -- No Active Poison
    -- =========================================================

    if not enchant then
        GameTooltip:AddLine(L.NO_ACTIVE_POISON, unpack(MUTED))
        return
    end

    GameTooltip:AddDoubleLine(
        L.POISON,
        enchant.name or L.NO_ACTIVE_POISON,
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )

    local minutes = math.ceil(
        (enchant.remainingTimeMs or 0) / 60000
    )

    GameTooltip:AddDoubleLine(
        L.REMAINING_TIME,
        string.format(L.TIME_MINUTES, minutes),
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )

    GameTooltip:AddDoubleLine(
        L.REMAINING_CHARGES,
        tostring(enchant.charges or 0),
        GOLD[1], GOLD[2], GOLD[3],
        WHITE[1], WHITE[2], WHITE[3]
    )
end

-- =========================================================
-- Public API
-- =========================================================

---@param owner Frame
function ButtonTooltip:Show(owner)
    local L = L11n.PFToolTip

    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    GameTooltip:AddLine(L.TITLE, unpack(GOLD))

    AddOptions()

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L.CURRENT, unpack(GOLD))

    AddWeaponInfo(0, L.MAIN_HAND)
    AddWeaponInfo(1, L.OFF_HAND)

    GameTooltip:Show()
end

function ButtonTooltip:Hide()
    GameTooltip:Hide()
end