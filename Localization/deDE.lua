local PoisonFlow = _G.PoisonFlow
local Localization = PoisonFlow.Localization

Localization:Register(
    "deDE",
    {
        Main = {
            LOADED = "geladen.",
            MAIN_HAND = "Waffenhand",
            OFF_HAND = "Nebenhand",
            PRIMARY_POISON = "Hauptgift",
            FALLBACK_POISON = "Ersatzgift",
            CURRENT_POISON = "Aktuell:",
            NO_ACTIVE_POISON = "Kein Gift aktiv",
            POISON_ACTIVE = "Gift aktiv",
            REMAINING_MINUTES = "%d Min.",
            REMAINING_CHARGES = "%d Aufladungen",
            WEAPON_NOT_EQUIPPED = "Keine Waffe ausgerüstet",
        },
        Settings = {
            DROP_POISON_HERE = "Gift hier ablegen",
            RIGHT_CLICK_REMOVE = "Rechtsklick zum Entfernen",
            INVALID_POISON = "Dieses Item ist kein gültiges Gift.",
            VALID_POISON = "Gültiges Gift: ",
            ITEM_COUNT = "%d Stk.",
            ALERTS = "Warnungen",
            ALERT_TIME = "Warnung bei auslaufender Zeit",
            ALERT_TIME_UNIT = "Minuten",
            ALERT_CHARGES = "Warnung bei auslaufender Aufladungen",
            ALERT_CHARGES_UNIT = "Aufladungen",
            ALERT_POISON = "Warnung bei niedrigem Hauptgiftbestand",
            ALERT_POISON_UNIT = "Stück",
        },
        Warning = {
            -- Primary poison running low
            TITLE_PRIMARY_LOW = "Wenig Hauptgift",
            MESSAGE_PRIMARY_LOW = "%s Hauptgift geht zur Neige (%d Stück übrig).",

            -- Primary poison empty, fallback available
            TITLE_PRIMARY_EMPTY = "Hauptgift leer",
            MESSAGE_PRIMARY_EMPTY = "%s Hauptgift ist leer! Ersatzgift wird verwendet.",

            -- Primary poison empty, no fallback configured
            TITLE_NO_FALLBACK = "Kein Ersatzgift",
            MESSAGE_NO_FALLBACK = "%s Hauptgift ist leer und es wurde kein Ersatzgift eingestellt!",

            -- Fallback poison running low
            TITLE_FALLBACK_LOW = "Wenig Ersatzgift",
            MESSAGE_FALLBACK_LOW = "%s Ersatzgift geht zur Neige (%d Stück übrig).",

            -- Primary and fallback poison empty
            TITLE_ALL_EMPTY = "Beide Gifte leer",
            MESSAGE_ALL_EMPTY = "%s Hauptgift und Ersatzgift sind leer!",

            TITLE_MISSING = "Kein Waffengift",
            MESSAGE_MISSING = "Auf deiner %s ist kein Gift aktiv.",

            TITLE_TIME_LOW = "Giftdauer läuft ab",
            MESSAGE_TIME_LOW = "Das Gift auf deiner %s läuft in weniger als %d Minuten ab.",

            TITLE_CHARGES_LOW = "Giftaufladungen niedrig",
            MESSAGE_CHARGES_LOW = "Das Gift auf deiner %s hat nur noch %d Aufladungen.",

            TITLE_MAIN_HAND_NOT_EQUIPPED = "Keine Waffenhand ausgerüstet",
            TITLE_OFF_HAND_NOT_EQUIPPED = "Keine Nebenhand ausgerüstet",
        },
        Minimap = {
            TOOLTIP = "Linksklick: Einstellungen öffnen",
        },
        PFToolTip = {
            TITLE = "PoisonFlow",

            OPTIONS = "Optionen",
            CURRENT = "Aktuell",

            LEFT_CLICK = "Linksklick",
            RIGHT_CLICK = "Rechtsklick",
            SHIFT_LEFT_CLICK = "Shift + Linksklick halten",
            SHIFT_RIGHT_CLICK = "Shift + Rechtsklick",

            APPLY_MAIN_HAND = "Gift auf Waffenhand auftragen",
            APPLY_OFF_HAND = "Gift auf Nebenhand auftragen",
            MOVE_BUTTON = "Button verschieben",
            OPEN_SETTINGS = "Einstellungen öffnen",

            NO_POISON_CONFIGURED = "Kein Gift eingestellt – öffnet Einstellungen",

            MAIN_HAND = "Waffenhand",
            OFF_HAND = "Nebenhand",

            POISON = "Gift",
            REMAINING_TIME = "Restlaufzeit",
            REMAINING_CHARGES = "Aufladungen",

            NO_ACTIVE_POISON = "Kein Gift aktiv",
            TIME_MINUTES = "%d Min.",
            NOT_EQUIPPED = "Nicht ausgerüstet",
        },
    }
)