local PoisonFlow = _G.PoisonFlow

-- =====================================================
-- Types
-- =====================================================

---@class PoisonFlowLocalization
---@field FallbackLocale string
---@field ActiveLocale string
---@field Locales table<string, table<string, table<string, string>>>
---@field OverrideLocal string?
---@field Register fun(self: PoisonFlowLocalization, locale: string, translation: table)
---@field Get fun(self: PoisonFlowLocalization): table
---@field GetActiveLocale fun(self: PoisonFlowLocalization): string
---@field SetOverride fun(self: PoisonFlowLocalization, locale: string): boolean
---@field ClearOverride fun(self: PoisonFlowLocalization)

local Localization = {}
PoisonFlow.Localization = Localization

Localization.FallbackLocale = "enUS"
Localization.ActiveLocale = GetLocale()
Localization.Locales = {}

---@param locale string
---@param translations table
function Localization:Register(locale, translations)
    if type(locale) ~= "string" or type(translations) ~= "table" then
        return
    end

    if not self.Locales[locale] then
        self.Locales[locale] = {}
    end

    for key, value in pairs(translations) do
        self.Locales[locale][key] = value
    end
end

-- Return locale sections with per-key English fallback.
---@return table
function Localization:Get()
    local localization = self
    return setmetatable({}, {
        __index = function(_, section)
            local active = localization.Locales[localization.ActiveLocale]
            local fallback = localization.Locales[localization.FallbackLocale]
            local activeSection = active and active[section]
            local fallbackSection = fallback and fallback[section]

            if type(activeSection) ~= "table" and type(fallbackSection) ~= "table" then
                return section
            end

            return setmetatable({}, {
                __index = function(_, key)
                    if activeSection and activeSection[key] ~= nil then
                        return activeSection[key]
                    end
                    if fallbackSection and fallbackSection[key] ~= nil then
                        return fallbackSection[key]
                    end
                    return key
                end
            })
        end
    })
end

-- =====================================================
-- Locale Override
-- =====================================================

---@param locale string
---@return boolean
function Localization:SetOverride(locale)
    if not self.Locales[locale] then
        return false
    end

    self.OverrideLocale = locale
    self.ActiveLocale = locale

    return true
end

-- =====================================================
-- Clear Override
-- =====================================================

function Localization:ClearOverride()
    self.OverrideLocale = nil
    self.ActiveLocale = GetLocale()
end

-- =====================================================
-- Get Active Locale
-- =====================================================

---@return string
function Localization:GetActiveLocale()
    return self.ActiveLocale
end