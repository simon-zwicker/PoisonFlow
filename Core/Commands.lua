local PoisonFlow = _G.PoisonFlow

SLASH_POISONFLOW1 = "/poisonflow"
SLASH_POISONFLOW2 = "/pf"

SlashCmdList["POISONFLOW"] = function (message)
    PoisonFlow.Settings:Toggle()
end