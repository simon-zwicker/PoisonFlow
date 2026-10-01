local PoisonFlow = _G.PoisonFlow
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

---@return table
function Localization:Get()
    local localization = self
    return setmetatable(
        {},
        {
            __index = function(_, key)
                local active = localization.Locales[localization.ActiveLocale]

                if active and active[key] ~= nil then
                    return active[key]
                end

                local fallback = localization.Locales[localization.FallbackLocale]

                if fallback and fallback[key] ~= nil then
                    return fallback[key]
                end

                return key
            end
        }
    )
end