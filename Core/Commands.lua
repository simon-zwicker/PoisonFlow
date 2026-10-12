local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Constants
-- =========================================================

local SUPPORTED_LOCALES = {
    enUS = true,
    deDE = true,
    frFR = true,
    esES = true,
    esMX = true,
    ptBR = true,
    itIT = true,
    ruRU = true,
    koKR = true,
    zhCN = true,
    zhTW = true,
}

-- =========================================================
-- Locale Command
-- =========================================================

---@param locale string?
local function HandleLocaleCommand(locale)
    local localization = PoisonFlow.Localization

    if not locale or locale == "" then
        print(
            "PoisonFlow Locale:",
            localization:GetActiveLocale()
        )

        return
    end

    if locale == "reset" then
        localization:ClearOverride()

        print(
            "PoisonFlow Locale reset:",
            localization:GetActiveLocale()
        )

        return
    end

    if not SUPPORTED_LOCALES[locale] then
        print(
            "PoisonFlow: Unsupported locale:",
            locale
        )

        return
    end

    if not localization:SetOverride(locale) then
        print(
            "PoisonFlow: Locale not loaded:",
            locale
        )

        return
    end

    if PoisonFlow.Settings then
        PoisonFlow.Settings:RefreshLocalization()
    end

    print(
        "PoisonFlow Locale:",
        localization:GetActiveLocale()
    )
end

-- =========================================================
-- Slash Commands
-- =========================================================

SLASH_POISONFLOW1 = "/poisonflow"
SLASH_POISONFLOW2 = "/pf"

SlashCmdList["POISONFLOW"] = function(message)
    local command, argument = message:match(
        "^(%S+)%s*(.-)%s*$"
    )

    if command == "locale" then
        HandleLocaleCommand(argument)
        return
    end

    PoisonFlow.Settings:Toggle()
end