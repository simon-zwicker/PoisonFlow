local PoisonFlow =
    _G.PoisonFlow

-- =========================================================
-- Debug
-- =========================================================

local function DebugPoisonState(
    name,
    hand
)
    local state =
        PoisonFlow.PoisonMonitor:GetState(
            hand
        )

    if not state then
        print(
            "PoisonFlow DEBUG:",
            name,
            "invalid hand"
        )

        return
    end

    print(
        "PoisonFlow DEBUG:",
        name
    )

    print(
        "Configured:",
        state.configuredPoisonID,
        "Enchant:",
        state.enchantID
    )

    print(
        "Has Enchant:",
        state.hasEnchant,
        "Time:",
        state.remainingTimeMs,
        "Charges:",
        state.charges
    )

    print(
        "Time Low:",
        state.timeLow,
        "Charges Low:",
        state.chargesLow
    )
end

-- =========================================================
-- Commands
-- =========================================================

SLASH_POISONFLOW1 =
    "/poisonflow"

SLASH_POISONFLOW2 =
    "/pf"

SlashCmdList["POISONFLOW"] =
    function(message)

        if message == "state" then

            DebugPoisonState(
                "Main Hand",
                "mainHand"
            )

            DebugPoisonState(
                "Off Hand",
                "offHand"
            )

            return

        end

        PoisonFlow.Settings:Toggle()

    end