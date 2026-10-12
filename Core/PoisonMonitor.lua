local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowPoisonMonitorState
---@field configuredPoisonID number?
---@field weaponEquipped boolean
---@field hasEnchant boolean
---@field enchantID number?
---@field remainingTimeMs number?
---@field charges number?
---@field missing boolean
---@field timeLow boolean
---@field chargesLow boolean
---@field activePoisonType string?

---@class PoisonFlowPoisonAlertState
---@field missing boolean
---@field timeLow boolean
---@field chargesLow boolean

---@class PoisonFlowPoisonWarning
---@field id string
---@field stateKey string
---@field weaponSlot number
---@field headline string
---@field description string
---@field severity string
---@field centered boolean?

---@class PoisonFlowPoisonMonitor
local PoisonMonitor = {}
PoisonFlow.PoisonMonitor = PoisonMonitor

-- =========================================================
-- Constants
-- =========================================================

local WEAPON_SLOT_MAIN_HAND = 0
local WEAPON_SLOT_OFF_HAND = 1
local UPDATE_INTERVAL = 15

-- =========================================================
-- Helpers
-- =========================================================

---@param hand string
---@return number?
local function GetWeaponSlot(hand)
    if hand == "mainHand" then
        return WEAPON_SLOT_MAIN_HAND
    end

    if hand == "offHand" then
        return WEAPON_SLOT_OFF_HAND
    end

    return nil
end

-- =========================================================
-- Get Configured Poison
-- =========================================================

---@param hand string
---@return number?
local function GetConfiguredPoison(hand)
    local db = PoisonFlow.Database:Get()
    local handData = db and db[hand]

    if not handData then
        return nil
    end

    -- Prefer primary poison when available.
    if handData.primary then
        return handData.primary
    end

    -- Fallback-only configuration.
    return handData.fallback
end

-- =========================================================
-- Warning Severity
-- =========================================================

---@param value number
---@param threshold number
---@return string
local function GetWarningSeverity(value, threshold)
    local criticalThreshold = math.max(
        1,
        math.floor(threshold * 0.25)
    )

    if value <= criticalThreshold then
        return "danger"
    end

    return "warning"
end

-- =========================================================
-- State
-- =========================================================

---@param hand string
---@return PoisonFlowPoisonMonitorState?
function PoisonMonitor:GetState(hand)
    local weaponSlot = GetWeaponSlot(hand)

    if weaponSlot == nil then
        return nil
    end

    local configuredPoisonID = GetConfiguredPoison(hand)
    local weaponEquipped = PoisonFlow.WeaponEnchantService:IsWeaponEquipped(weaponSlot)
    local enchant = PoisonFlow.WeaponEnchantService:Get(weaponSlot)

    ---@type PoisonFlowPoisonMonitorState
    local state = {
        configuredPoisonID = configuredPoisonID,
        weaponEquipped = weaponEquipped,
        hasEnchant = enchant ~= nil,
        enchantID = nil,
        remainingTimeMs = nil,
        charges = nil,
        missing = false,
        timeLow = false,
        chargesLow = false,
        activePoisonType = nil,
    }

    -- =========================================================
    -- Weapon Not Equipped
    -- =========================================================

    if not weaponEquipped then
        return state
    end

    if not enchant then
        state.missing = configuredPoisonID ~= nil
        return state
    end

    state.enchantID = enchant.enchantID
    state.remainingTimeMs = enchant.remainingTimeMs
    state.charges = enchant.charges

    if not configuredPoisonID then
        return state
    end

    -- =========================================================
    -- Active Poison
    -- =========================================================

    local activePoison = PoisonFlow.Poison:GetPoisonByEnchant(
        enchant.enchantID
    )

    state.activePoisonType = activePoison and activePoison.type or nil

    local db = PoisonFlow.Database:Get()

    -- =========================================================
    -- Time
    -- =========================================================

    if db.alerts.time.enabled
        and activePoison
        and activePoison.monitor.time
        and enchant.remainingTimeMs ~= nil
    then
        local thresholdMs = db.alerts.time.threshold * 60 * 1000

        state.timeLow = enchant.remainingTimeMs <= thresholdMs
    end

    -- =========================================================
    -- Charges
    -- =========================================================

    if db.alerts.charges.enabled
        and activePoison
        and activePoison.monitor.charges
        and enchant.charges ~= nil
    then
        state.chargesLow = enchant.charges <= db.alerts.charges.threshold
    end

    return state
end

-- =========================================================
-- Build Warnings
-- =========================================================

---@param hand string
---@param state PoisonFlowPoisonMonitorState
---@return PoisonFlowPoisonWarning[]
local function BuildWarnings(hand, state)
    ---@type PoisonFlowPoisonWarning[]
    local warnings = {}

    if not state.configuredPoisonID then
        return warnings
    end

    local L11n = PoisonFlow.Localization:Get()
    local L = L11n.Warning

    local handLabel = hand == "mainHand"
        and L11n.Main.MAIN_HAND
        or L11n.Main.OFF_HAND

    local weaponSlot = hand == "mainHand" and 16 or 17

    ---@param warningType string
    ---@param headline string
    ---@param description string
    ---@param severity string
    ---@param centered boolean?
    local function AddWarning(warningType, headline, description, severity, centered)
        table.insert(
            warnings,
            {
                id = "poison:" .. hand .. ":" .. warningType,

                stateKey = warningType .. ":" .. severity,

                weaponSlot = weaponSlot,
                headline = headline,
                description = description,
                severity = severity,
                centered = centered or false
            }
        )
    end

    -- =========================================================
    -- Weapon Not Equipped
    -- =========================================================

    if not state.weaponEquipped then
        local headline = hand == "mainHand"
            and L.TITLE_MAIN_HAND_NOT_EQUIPPED
            or L.TITLE_OFF_HAND_NOT_EQUIPPED

        AddWarning(
            "weaponNotEquipped",
            headline,
            "",
            "danger",
            true
        )

        return warnings
    end

    if state.missing then
        AddWarning(
            "missing",
            L.TITLE_MISSING,
            string.format(L.MESSAGE_MISSING, handLabel),
            "danger"
        )

        return warnings
    end

    if state.timeLow then
        local db = PoisonFlow.Database:Get()

        local minutes = math.ceil(
            (state.remainingTimeMs or 0) / 60000
        )

        local severity = GetWarningSeverity(
            minutes,
            db.alerts.time.threshold
        )

        AddWarning(
            "timeLow",
            L.TITLE_TIME_LOW,
            string.format(
                L.MESSAGE_TIME_LOW,
                handLabel,
                minutes
            ),
            severity
        )
    end

    if state.chargesLow then
        local db = PoisonFlow.Database:Get()

        local severity = GetWarningSeverity(
            state.charges or 0,
            db.alerts.charges.threshold
        )

        AddWarning(
            "chargesLow",
            L.TITLE_CHARGES_LOW,
            string.format(
                L.MESSAGE_CHARGES_LOW,
                handLabel,
                state.charges or 0
            ),
            severity
        )
    end

    return warnings
end

-- =========================================================
-- Get Warnings
-- =========================================================

---@return PoisonFlowPoisonWarning[]
function PoisonMonitor:GetWarnings()
    ---@type PoisonFlowPoisonWarning[]
    local warnings = {}
    for _, hand in ipairs({ "mainHand", "offHand" }) do
        local state = self:GetState(hand)
        if state then
            local handWarnings = BuildWarnings(hand, state)
            for _, warning in ipairs(handWarnings) do
                table.insert(warnings, warning)
            end
        end
    end
    return warnings
end

-- =========================================================
-- Update Warnings
-- =========================================================

function PoisonMonitor:UpdateWarnings()
    local manager = PoisonFlow.WarningManager
    if not manager or not manager.Container then
        return
    end

    local warnings = self:GetWarnings()
    local activeIDs = {}
    for _, warning in ipairs(warnings) do
        activeIDs[warning.id] = true
        manager:Show(
            warning.id,
            {
                weaponSlot = warning.weaponSlot,
                headline = warning.headline,
                description = warning.description,
                severity = warning.severity,
                centered = warning.centered,
            },
            warning.stateKey
        )
    end

    for id in pairs(manager.Entries) do
        if string.sub(id, 1, 7) == "poison:" and not activeIDs[id] then
            manager:Remove(id)
        end
    end
end

-- =========================================================
-- Update
-- =========================================================

function PoisonMonitor:Update()
    self:UpdateWarnings()
    PoisonFlow.PoisonStockMonitor:Update()

    -- =========================================================
    -- Refresh Settings
    -- =========================================================

    if PoisonFlow.Settings then
        PoisonFlow.Settings:Refresh()
    end
end

-- =========================================================
-- Initialize
-- =========================================================

function PoisonMonitor:Initialize()
    local frame = CreateFrame("Frame")
    local elapsedSinceUpdate = 0

    -- =========================================================
    -- Events
    -- =========================================================

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

    frame:SetScript(
        "OnEvent",
        function(_, event, ...)
            if event == "PLAYER_ENTERING_WORLD" then
                self:Update()
                elapsedSinceUpdate = 0

            elseif event == "WEAPON_ENCHANT_CHANGED" then
                self:Update()
                elapsedSinceUpdate = 0
            elseif event == "PLAYER_EQUIPMENT_CHANGED" then
                local inventorySlot = ...
                if inventorySlot == 16 or inventorySlot == 17 then
                    self:Update()
                    elapsedSinceUpdate = 0
                end

                return
            end
        end
    )

    -- =========================================================
    -- Periodic Update
    -- =========================================================

    frame:SetScript(
        "OnUpdate",
        function(_, elapsed)
            elapsedSinceUpdate = elapsedSinceUpdate + elapsed

            if elapsedSinceUpdate < UPDATE_INTERVAL then
                return
            end

            elapsedSinceUpdate = 0

            self:Update()
        end
    )
end