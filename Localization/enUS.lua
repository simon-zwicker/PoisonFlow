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
        REAPPLY = "Reapply",
        ALERT_PRIMARY_POISON_LOW = "%s primary poison is running low (%d remaining).",
        ALERT_PRIMARY_POISON_EMPTY = "%s primary poison is empty! Fallback poison will be used.",
        ALERT_PRIMARY_POISON_EMPTY_NO_FALLBACK = "%s primary poison is empty and no fallback poison is configured!",
        ALERT_FALLBACK_POISON_LOW = "%s fallback poison is running low (%d remaining).",
        ALERT_ALL_POISONS_EMPTY = "%s primary and fallback poisons are empty!",
        MINIMAP_TOOLTIP = "Left-click: Open settings",
        POISON_TIME_REMAINING = "Time remaining: %s",
        POISON_CHARGES_REMAINING = "Charges: %d",
        POISON_STATUS_OK = "Poison is active",
        POISON_STATUS_REAPPLY = "Reapplication recommended",
        POISON_STATUS_EXPIRED = "Poison expired",
        ACTIVE = "Active",
    }
)