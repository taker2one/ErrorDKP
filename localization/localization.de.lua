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
        TOOLTIP_PRIO_LABEL = "Prio"
    }

end