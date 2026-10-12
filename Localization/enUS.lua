local PoisonFlow = _G.PoisonFlow
local Localization = PoisonFlow.Localization

Localization:Register(
    "enUS",
    {
        Main = {
            LOADED = "loaded.",
            MAIN_HAND = "Main Hand",
            OFF_HAND = "Off Hand",
            PRIMARY_POISON = "Primary Poison",
            FALLBACK_POISON = "Fallback Poison",
            CURRENT_POISON = "Current:",
            NO_ACTIVE_POISON = "No poison active",
            POISON_ACTIVE = "Poison active",
            REMAINING_MINUTES = "%d min",
            REMAINING_CHARGES = "%d charges",
            WEAPON_NOT_EQUIPPED = "No weapon equipped",
        },
        Settings = {
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
            ALERT_POISON = "Warn when primary poison stock is running low",
            ALERT_POISON_UNIT = "Items",
        },
        Warning = {
            -- Primary poison running low
            TITLE_PRIMARY_LOW = "Primary poison low",
            MESSAGE_PRIMARY_LOW = "%s primary poison is running low (%d remaining).",

            -- Primary poison empty, fallback available
            TITLE_PRIMARY_EMPTY = "Primary poison empty",
            MESSAGE_PRIMARY_EMPTY = "%s primary poison is empty! Fallback poison is being used.",

            -- Primary poison empty, no fallback configured
            TITLE_NO_FALLBACK = "No fallback poison",
            MESSAGE_NO_FALLBACK = "%s primary poison is empty and no fallback poison is configured!",

            -- Fallback poison running low
            TITLE_FALLBACK_LOW = "Fallback poison low",
            MESSAGE_FALLBACK_LOW = "%s fallback poison is running low (%d remaining).",

            -- Primary and fallback poison empty
            TITLE_ALL_EMPTY = "Both poisons empty",
            MESSAGE_ALL_EMPTY = "%s primary and fallback poisons are empty!",

            TITLE_MISSING = "No weapon poison",
            MESSAGE_MISSING = "Your %s has no active poison.",

            TITLE_TIME_LOW = "Poison expiring",
            MESSAGE_TIME_LOW = "The poison on your %s expires in less than %d minutes.",

            TITLE_CHARGES_LOW = "Poison charges low",
            MESSAGE_CHARGES_LOW = "The poison on your %s has only %d charges remaining.",

            TITLE_MAIN_HAND_NOT_EQUIPPED = "No main-hand weapon equipped",
            TITLE_OFF_HAND_NOT_EQUIPPED = "No off-hand weapon equipped",
        },
        Minimap = {
            TOOLTIP = "Left-click: Open settings",
        },
        PFToolTip = {
            TITLE = "PoisonFlow",

            OPTIONS = "Options",
            CURRENT = "Current",

            LEFT_CLICK = "Left-click",
            RIGHT_CLICK = "Right-click",
            SHIFT_LEFT_CLICK = "Hold Shift + Left-click",
            SHIFT_RIGHT_CLICK = "Shift + Right-click",

            APPLY_MAIN_HAND = "Apply poison to main hand",
            APPLY_OFF_HAND = "Apply poison to off hand",
            MOVE_BUTTON = "Move button",
            OPEN_SETTINGS = "Open settings",

            NO_POISON_CONFIGURED = "No poison configured – opens settings",

            MAIN_HAND = "Main Hand",
            OFF_HAND = "Off Hand",

            POISON = "Poison",
            REMAINING_TIME = "Time remaining",
            REMAINING_CHARGES = "Charges",

            NO_ACTIVE_POISON = "No active poison",
            TIME_MINUTES = "%d min",
            NOT_EQUIPPED = "Not equipped",
        },
    }
)