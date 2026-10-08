local PoisonFlow = _G.PoisonFlow
local Localization = PoisonFlow.Localization

Localization:Register(
    "deDE",
    {
        LOADED = "geladen.",
        MAIN_HAND = "Waffenhand",
        OFF_HAND = "Nebenhand",
        PRIMARY_POISON = "Hauptgift",
        FALLBACK_POISON = "Ersatzgift",
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
        REAPPLY = "Erneuern",
        ALERT_PRIMARY_POISON_LOW = "%s Hauptgift geht zur Neige (%d Stück übrig).",
        ALERT_PRIMARY_POISON_EMPTY = "%s Hauptgift ist leer! Ersatzgift wird verwendet.",
        ALERT_PRIMARY_POISON_EMPTY_NO_FALLBACK = "%s Hauptgift ist leer und es wurde kein Ersatzgift eingestellt!",
        ALERT_FALLBACK_POISON_LOW = "%s Ersatzgift geht zur Neige (%d Stück übrig).",
        ALERT_ALL_POISONS_EMPTY = "%s Hauptgift und Ersatzgift sind leer!",
        MINIMAP_TOOLTIP = "Linksklick: Einstellungen öffnen",
    }
)