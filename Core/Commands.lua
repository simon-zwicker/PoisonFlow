local PoisonFlow = _G.PoisonFlow

-- =========================================================
-- Commands
-- =========================================================

SLASH_POISONFLOW1 =
    "/poisonflow"

SLASH_POISONFLOW2 =
    "/pf"

SlashCmdList["POISONFLOW"] = function()
    PoisonFlow.Settings:Toggle()
end