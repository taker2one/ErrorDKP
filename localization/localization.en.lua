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
            DESCRLCLICK = "Left Click - Open Window",
            MENU_SELECT = "Select an option:",
            MENU_TOGGLE_ERRORDKP = "Toggle ErrorDKP window",
            MENU_ML_VOTE = "Lootsurvey result"
        },
        EXPORTDIALOG = {
            TITLE = "Export",
            HELPTEXT = "CRTL+C to copy content.\r\n ESC to close window."
        },
        ML_SURVEY_RESULT = {
            TITLE = "Result",
            RESPONSE_OFFLINE = "|cFFBDBDBDOffline or addon not installed|r",
            RESPONSE_PENDING = "|cFFBDBDBDPending|r",
            RESPONSE_PASS = "|cFFB2B2B2Pass|r",
            RESPONSE_SECOND = "|cFFFF4F00Second|r",
            RESPONSE_MAIN = "|cFF00FF00Main/Need|r",
            RESPONSE_TIMEOUT = "|cFF0000FFPlayer didn't respond in time|r",
            RESPONSE_AUTOPASS = "|cFFB2B2B2Autopass|r",
            COLPLAYER = "Player",
            COLRESPONSE = "Response",
            COLDKP = "DKP",
            RESPONSES = "Responses",
            SURVEYCLOSED = "Survey closed"
        },
        OK = "Ok",
        CANCEL = "Cancel",
        LCD_ENTERCOSTFOR = "Enter DKP cost for",
        LCD_LOOTETBY = "Looted by |cFFFFFFFF%s|r.",
        
        
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
        MSG_SYNC_FINISHED = "Got full %s update from %s.",
        MSG_LOOT_ADDED = "%s added to loot history.",
        MSG_LOOT_DISENCHANTED = "%s got disenchanted.",
        MSG_SURVEY_CLOSED_BY = "The Item-Survey got closed by %s",
        MSG_SURVEY_CANCELLED_BY = "The Item-Survey got cancelled by %s",

        HELP_EDKP = "Opens ErrorDKP window.",
        HELP_HELP = "Prints cuurent help list.",
        HELP_BROADCAST = "Initiate a table broadcast."
    }