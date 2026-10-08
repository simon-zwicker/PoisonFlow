local PoisonFlow = _G.PoisonFlow
local Localization = PoisonFlow.Localization

Localization:Register(
    "enUS",
    {
        LOADED = "loaded.",
        MAIN_HAND = "Main Hand",
        OFF_HAND = "Off Hand",
        PRIMARY_POISON = "Primary Posion",
        FALLBACK_POISON = "Fallback Posion",
        DROP_POISON_HERE = "Drop poison here",
        RIGHT_CLICK_REMOVE = "Right-click to remove",
        INVALID_POISON = "This item is not a valid poison.",
        VALID_POISON = "Valid poison: ",
        ITEM_COUNT = "%d pcs.",
        ALERTS = "Alerts",
        ALERT_TIME = "Warn when poison duration is running low",
        ALERT_TIME_UNIT = "Minutes",
        ALERT_CHARGES = "Warn when poison charges are running low",
        ALERT_CHARGES_UNIT = "Charges",
        ALERT_POISON = "Warn when the main poison stock is running low",
        ALERT_POISON_UNIT = "Pieces",
    }
)