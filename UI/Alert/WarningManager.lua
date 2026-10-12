local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Types
-- =========================================================

---@class PoisonFlowWarningManagerEntry
---@field warning PoisonFlowWarningInstance
---@field dismissed boolean
---@field stateKey string

---@class PoisonFlowWarningManager
---@field Container Frame?
---@field Entries table<string, PoisonFlowWarningManagerEntry>
---@field Order string[]
---@field Show fun(self: PoisonFlowWarningManager, id: string, content: PoisonFlowWarningContent, stateKey: string?)
---@field Remove fun(self: PoisonFlowWarningManager, id: string)
---@field Dismiss fun(self: PoisonFlowWarningManager, id: string)
---@field UpdateLayout fun(self: PoisonFlowWarningManager)
---@field Clear fun(self: PoisonFlowWarningManager)
---@field Initialize fun(self: PoisonFlowWarningManager)
local WarningManager = {
    Container = nil,
    Entries = {},
    Order = {},
}
PoisonFlow.WarningManager = WarningManager

-- =========================================================
-- Constants
-- =========================================================

local CONSTANTS = {
    Position = {
        Point = "TOP",
        RelativePoint = "TOP",
        X = 0,
        Y = -50,
    },
    Layout = {
        Width = 400,
        WarningHeight = 92,
        Spacing = 8,
    },
    FrameStrata = "HIGH",
}

-- =========================================================
-- Create Container
-- =========================================================

---@return Frame
local function CreateContainer()
    local container = CreateFrame("Frame", nil, UIParent)
    container:SetSize(CONSTANTS.Layout.Width, 1)
    container:SetPoint(CONSTANTS.Position.Point, UIParent, CONSTANTS.Position.RelativePoint, CONSTANTS.Position.X, CONSTANTS.Position.Y)
    container:SetFrameStrata(CONSTANTS.FrameStrata)
    return container
end

-- =========================================================
-- Update Layout
-- =========================================================

function WarningManager:UpdateLayout()
    if not self.Container then
        return
    end

    local offsetY = 0
    local visibleCount = 0

    for _, id in ipairs(self.Order) do
        local entry = self.Entries[id]
        if entry and not entry.dismissed then
            local frame = entry.warning.Frame
            frame:ClearAllPoints()
            frame:SetPoint("TOP", self.Container, "TOP", 0, -offsetY)
            frame:Show()

            offsetY = offsetY + frame:GetHeight() + CONSTANTS.Layout.Spacing
            visibleCount = visibleCount + 1
        elseif entry then
            entry.warning.Frame:Hide()
        end
    end

    local height = 1
    if visibleCount > 0 then
        height = offsetY - CONSTANTS.Layout.Spacing
    end

    self.Container:SetHeight(height)
end

-- =========================================================
-- Show Warning
-- =========================================================

---@param id string
---@param content PoisonFlowWarningContent
---@param stateKey string?
function WarningManager:Show(id, content, stateKey)
    if not self.Container then
        return
    end
    stateKey = stateKey or id
    local entry = self.Entries[id]
    if not entry then
        local warning = PoisonFlow.Warning:Create(self.Container)
        PoisonFlow.Warning:SetOnDismiss(
            warning,
            function()
                self:Dismiss(id)
            end
        )
        entry = {
            warning = warning,
            dismissed = false,
            stateKey = stateKey,
        }
        self.Entries[id] = entry
        table.insert(self.Order, id)
    elseif entry.stateKey ~= stateKey then
        entry.stateKey = stateKey
        entry.dismissed = false
    end

    PoisonFlow.Warning:SetContent(entry.warning, content)
    self:UpdateLayout()
end

-- =========================================================
-- Dismiss Warning
-- =========================================================

---@param id string
function WarningManager:Dismiss(id)
    local entry = self.Entries[id]
    if not entry then
        return
    end
    entry.dismissed = true
    self:UpdateLayout()
end

-- =========================================================
-- Remove Warning
-- =========================================================

---@param id string
function WarningManager:Remove(id)
    local entry = self.Entries[id]
    if not entry then
        return
    end
    entry.warning.Frame:Hide()
    self.Entries[id] = nil
    for index, entryID in ipairs(self.Order) do
        if entryID == id then
            table.remove(self.Order, index)
            break
        end
    end
    self:UpdateLayout()
end

-- =========================================================
-- Clear Warnings
-- =========================================================

function WarningManager:Clear()
    for _, entry in pairs(self.Entries) do
        entry.warning.Frame:Hide()
    end

    wipe(self.Entries)
    wipe(self.Order)

    self:UpdateLayout()
end

-- =========================================================
-- Initialize
-- =========================================================

function WarningManager:Initialize()
    if self.Container then
        return
    end
    self.Container = CreateContainer()
end

-- =========================================================
-- DEBUG
-- =========================================================

function WarningManager:ShowTestWarnings()
    self:Show(
        "test:mainHand",
        {
            weaponSlot = 16,
            headline = "Poison mainhand low",
            description = "Mainhand poison is low (3 lfet).",
            severity = "warning",
        },
        "primaryLow"
    )

    self:Show(
        "test:offHand",
        {
            weaponSlot = 17,
            headline = "Both poison empty",
            description = "Offhand main poison and fallback poison are empty!",
            severity = "danger",
        },
        "allEmpty"
    )
end