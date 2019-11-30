local addonName, core = ...;
    core._L = {
        PRICELISTTABLE = {
            COLICON = "Icon",
            COLNAME = "Item",
            COLPRICE = "Price",
            COLPRIO = "Priority",
            TITLE = "Itempricelist"
        },
        DKPLISTTABLE = {
            COLNAME = "Name",
            COLDKP = "DKP",
            COLCLASS = "Class",
            TITLE = "DKP-List"
        },
        LOOTHISTORYTABLE = {
            TITLE = "Loot History",
            COLITEMLINK = "Item",
            COLLOOTER = "Looter",
            COLDKP = "DKP"
        },
        DKPPRICE = "DKP Price",
        MINIMAP = {
            DESCRLCLICK = "Left CLick - Open Window"
        },
        OK = "Ok",
        CANCEL = "Cancel",
        LCD_ENTERCOSTFOR = "Enter DKP cost for",
        LCD_LOOTETBY = "Geplündert von |cFFFFFFFF%s|r.",
        
        
        TOOLTIP_PRIO_NONE = "None",
        TOOLTIP_PRIO_LABEL = "Prio",

        MSG_NEW_VERSION_AVAILABLE = "A newer version of |cff90EE90ErrorDKP|r is available. Visit |cff90EE90wow-error.at|r to download.",
        MSG_DKPTABLE_OUTOFDATE = "Your dkp list ist out of date, a update request was sent to all officers.",
        MSG_PLAYER_NOT_FOUND_DKP = "%s not found in list, update not possible.",
        MSG_DKP_ADJUST_AUTO = "%s %d DKP for %s",
        MSG_DKP_ADJUST_MAN = "Manual adjustment: %s %d DKP",
        MSG_NOT_ALLOWED = "This is not allowed, you are not an Officer",
        MSG_BROADCAST_DKP_REQ = "Broadcasting DKP-Table after request from ",
        MSG_BROADCAST_LOOT_REQ = "Broadcasting Loot-Table after request from ",
        MSG_BROADCAST_FULL_REQ = "Broadcasting all Data after request from ",

        HELP_EDKP = "Opens ErrorDKP window.",
        HELP_HELP = "Prints cuurent help list.",
        HELP_BROADCAST = "Initiate a table broadcast."
    }