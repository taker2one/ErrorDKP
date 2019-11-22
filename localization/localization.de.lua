if GetLocale() == "deDE" then
    local addonName, core = ...;
    core._L = {
        PRICELISTTABLE = {
            COLICON = "Icon",
            COLNAME = "Name",
            COLPRICE = "Preis",
            COLPRIO = "Priorität"
        }
    }

end