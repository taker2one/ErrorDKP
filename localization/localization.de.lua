if GetLocale() == "deDE" then
    local addonName, core = ...;
    core._L = {
        PRICELISTTABLE = {
            COLICON = "Icon",
            COLNAME = "Name",
            COLPRICE = "Preis",
            COLPRIO = "Priorität",
            TITLE = "Item-Preisliste"
        },
        DKPLISTTABLE = {
            COLNAME = "Name",
            COLDKP = "DKP",
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
        DKP_ADJUST_AUTO_MSG = "%s %d DKP für %s",
        
        TOOLTIP_PRIO_NONE = "Keine",
        TOOLTIP_PRIO_LABEL = "Prio",

        MSG_NEW_VERSION_AVAILABLE = "Eine neuere Version von |cff90EE90ErrorDKP|r ist verfügbar. Gehe auf |cff90EE90wow-error.at|r und hol sie dir.",
        MSG_DKPTABLE_OUTOFDATE = "Deine DKP Liste ist nicht aktuell, Update-Anfrage wurde an Offiziere gesendet.",
        MSG_PLAYER_NOT_FOUND_DKP = "%s nicht in der Liste gedunden, aktualisieren nicht möglich."
    }

end