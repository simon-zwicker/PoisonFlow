local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonMonitor
---@field time boolean
---@field charges boolean

---@class PoisonFlowPoisonInfo
---@field type string
---@field rank number
---@field monitor PoisonFlowPoisonMonitor

---@class PoisonFlowPoison
local Poison = {}

PoisonFlow.Poison = Poison

-- =========================================================
-- Poison Types
-- =========================================================

Poison.Type = {
    Instant = "instant",
    Deadly = "deadly",
    Wound = "wound",
    MindNumbing = "mindNumbing",
    Crippling = "crippling",
    Occult = "occult",
    Atrophic = "atrophic",
    Numbing = "numbing",
    Sebacious = "sebacious",
}

-- =========================================================
-- Poison Data
-- =========================================================

---@type table<number, PoisonFlowPoisonInfo>
local POISONS = {

    -- =====================================================
    -- Instant Poison
    -- =====================================================

    [6947] = {
        type = Poison.Type.Instant,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [6949] = {
        type = Poison.Type.Instant,
        rank = 2,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [6950] = {
        type = Poison.Type.Instant,
        rank = 3,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [8926] = {
        type = Poison.Type.Instant,
        rank = 4,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [8927] = {
        type = Poison.Type.Instant,
        rank = 5,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [8928] = {
        type = Poison.Type.Instant,
        rank = 6,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Deadly Poison
    -- =====================================================

    [2892] = {
        type = Poison.Type.Deadly,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [2893] = {
        type = Poison.Type.Deadly,
        rank = 2,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [8984] = {
        type = Poison.Type.Deadly,
        rank = 3,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [8985] = {
        type = Poison.Type.Deadly,
        rank = 4,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [20844] = {
        type = Poison.Type.Deadly,
        rank = 5,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Wound Poison
    -- =====================================================

    [10918] = {
        type = Poison.Type.Wound,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [10920] = {
        type = Poison.Type.Wound,
        rank = 2,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [10921] = {
        type = Poison.Type.Wound,
        rank = 3,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [10922] = {
        type = Poison.Type.Wound,
        rank = 4,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Mind-numbing Poison
    -- =====================================================

    [5237] = {
        type = Poison.Type.MindNumbing,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [6951] = {
        type = Poison.Type.MindNumbing,
        rank = 2,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [9186] = {
        type = Poison.Type.MindNumbing,
        rank = 3,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Crippling Poison
    -- =====================================================

    [3775] = {
        type = Poison.Type.Crippling,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

    [3776] = {
        type = Poison.Type.Crippling,
        rank = 2,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Occult Poison
    -- =====================================================

    [226374] = {
        type = Poison.Type.Occult,
        rank = 1,
        monitor = {
            time = true,
            charges = false,
        },
    },

    [234444] = {
        type = Poison.Type.Occult,
        rank = 2,
        monitor = {
            time = true,
            charges = false,
        },
    },


    -- =====================================================
    -- Atrophic Poison
    -- =====================================================

    [217347] = {
        type = Poison.Type.Atrophic,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Numbing Poison
    -- =====================================================

    [217346] = {
        type = Poison.Type.Numbing,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },


    -- =====================================================
    -- Sebacious Poison
    -- =====================================================

    [217345] = {
        type = Poison.Type.Sebacious,
        rank = 1,
        monitor = {
            time = true,
            charges = true,
        },
    },

}

-- =========================================================
-- Weapon Enchant Mapping
-- =========================================================

---@class PoisonFlowEnchantData
---@field type string
---@field rank number

---@type table<number, PoisonFlowEnchantData>
local ENCHANT_TYPES = {
    -- =====================================================
    -- Instant Poison
    -- =====================================================

    [323] = { type = Poison.Type.Instant, rank = 1 },
    [324] = { type = Poison.Type.Instant, rank = 2 },
    [325] = { type = Poison.Type.Instant, rank = 3 },
    [623] = { type = Poison.Type.Instant, rank = 4 },
    [624] = { type = Poison.Type.Instant, rank = 5 },
    [625] = { type = Poison.Type.Instant, rank = 6 },

    -- =====================================================
    -- Deadly Poison
    -- =====================================================

    [7]    = { type = Poison.Type.Deadly, rank = 1 },
    [8]    = { type = Poison.Type.Deadly, rank = 2 },
    [626]  = { type = Poison.Type.Deadly, rank = 3 },
    [627]  = { type = Poison.Type.Deadly, rank = 4 },
    [2630] = { type = Poison.Type.Deadly, rank = 5 },

    -- =====================================================
    -- Crippling Poison
    -- =====================================================

    [22]  = { type = Poison.Type.Crippling, rank = 1 },
    [603] = { type = Poison.Type.Crippling, rank = 2 },

    -- =====================================================
    -- Mind-Numbing Poison
    -- =====================================================

    [35]  = { type = Poison.Type.MindNumbing, rank = 1 },
    [23]  = { type = Poison.Type.MindNumbing, rank = 2 },
    [643] = { type = Poison.Type.MindNumbing, rank = 3 },

    -- =====================================================
    -- Wound Poison
    -- =====================================================

    [703] = { type = Poison.Type.Wound, rank = 1 },
    [704] = { type = Poison.Type.Wound, rank = 2 },
    [705] = { type = Poison.Type.Wound, rank = 3 },
    [706] = { type = Poison.Type.Wound, rank = 4 },

    -- =====================================================
    -- Occult Poison (Forever)
    -- =====================================================

    [7542] = { type = Poison.Type.Occult, rank = 1 },
}

-- =========================================================
-- GET
-- =========================================================

---@param itemID number
---@return PoisonFlowPoisonInfo?
function Poison:Get(itemID)
    return POISONS[itemID]
end

-- =========================================================
-- Get By Enchant
-- =========================================================

---@param enchantID number?
---@return PoisonFlowEnchantData?
function Poison:GetByEnchant(enchantID)
    if not enchantID then
        return nil
    end

    return ENCHANT_TYPES[enchantID]
end

-- =========================================================
-- Get Poison By Enchant
-- =========================================================

---@param enchantID number?
---@return PoisonFlowPoisonInfo?
function Poison:GetPoisonByEnchant(enchantID)
    local enchant = self:GetByEnchant(enchantID)

    if not enchant then
        return nil
    end

    for _, poison in pairs(POISONS) do
        if poison.type == enchant.type
            and poison.rank == enchant.rank
        then
            return poison
        end
    end

    return nil
end

-- =========================================================
-- Get Type By Enchant
-- =========================================================

---@param enchantID number?
---@return string?
function Poison:GetTypeByEnchant(enchantID)
    local enchant = self:GetByEnchant(enchantID)

    return enchant and enchant.type or nil
end

-- =========================================================
-- Is Poison
-- =========================================================

---@param itemID number
---@return boolean
function Poison:IsPoison(itemID)
    return POISONS[itemID] ~= nil
end

-- =========================================================
-- Supports Time
-- =========================================================

---@param itemID number
---@return boolean
function Poison:IsBasedOnTime(itemID)
    local poison = self:Get(itemID)

    if not poison then
        return false
    end

    return poison.monitor.time
end

-- =========================================================
-- Supports Charges
-- =========================================================

---@param itemID number
---@return boolean
function Poison:IsBasedOnCharges(itemID)
    local poison = self:Get(itemID)

    if not poison then
        return false
    end

    return poison.monitor.charges
end