if GetLocale() == "deDE" then
    local addonName, core = ...;
    core._L = {
        PRICELISTTABLE = {
            COLICON = "Icon",
            COLNAME = "Item",
            COLPRICE = "Preis",
            COLPRIO = "Priorität",
            TITLE = "Item-Preisliste"
        },
        DKPLISTTABLE = {
            COLNAME = "Name",
            COLDKP = "DKP",
            COLCLASS = "Klasse",
            TITLE = "DKP-Liste"
        },
        LOOTHISTORYTABLE = {
            TITLE = "Loot Historie",
            COLITEMLINK = "Item",
            COLLOOTER = "Looter",
            COLDKP = "DKP"
        },
        DKPPRICE = "DKP Preis",
        MINIMAP = {
            DESCRLCLICK = "Left CLick - Open Window"
        },
        OK = "Ok",
        CANCEL = "Abbrechen",
        LCD_ENTERCOSTFOR = "DKP-Preis eingeben für",
        LCD_LOOTETBY = "Looted by |cFFFFFFFF%s|r.",
        
        TOOLTIP_PRIO_NONE = "Keine",
        TOOLTIP_PRIO_LABEL = "Prio",

        MSG_NEW_VERSION_AVAILABLE = "Eine neuere Version von |cff90EE90ErrorDKP|r ist verfügbar. Gehe auf |cff90EE90wow-error.at|r und hol sie dir.",
        MSG_DKPTABLE_OUTOFDATE = "Deine DKP Liste ist nicht aktuell, Update-Anfrage wurde an Offiziere gesendet.",
        MSG_PLAYER_NOT_FOUND_DKP = "%s nicht in der Liste gedunden, aktualisieren nicht möglich.",
        MSG_DKP_ADJUST_AUTO = "%s %d DKP für %s",
        MSG_DKP_ADJUST_MAN = "Manuelle Anpassung: %s %d DKP",
        MSG_NOT_ALLOWED = "Das is nicht erlaubt, du bist kein Offizier.",
        MSG_BROADCAST_DKP_REQ = "Veteile DKP Table auf Anfrage von ",
        MSG_BROADCAST_LOOT_REQ = "Verteile Loot-Tabelle auf Anfrage von ",
        MSG_BROADCAST_FULL_REQ = "Veteile sämtliche Date auf Anfrage von ",

        HELP_EDKP = "Öffnet das ErrorDKP Fenster.",
        HELP_HELP = "Gibt die aktuelle Hilfeliste aus.",
        HELP_BROADCAST = "Braodcast der Daten an alle Gildenmitglieder."
    }

end