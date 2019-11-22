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
        DKPPRICE = "DKP Preis",
        MINIMAP = {
            DESCRLCLICK = "Left CLick - Open Window"
        }
    }

end