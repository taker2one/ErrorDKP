local addonName, core = ...;
    core._L = {
        PRICELISTTABLE = {
            COLICON = "Icon",
            COLNAME = "Item",
            COLPRICE = "Price(BiS)",
            COLPRIO = "Priority",
            TITLE = "Itempricelist"
        },
        DKPLISTTABLE = {
            COLNAME = "Name",
            COLDKP = "DKP",
            COLCLASS = "Class",
            TITLE = "DKP-List",
            CHECKBTN_SHOWONLYRAIDMEMBERS = "Show only raidmembers"
        },
        LOOTHISTORYTABLE = {
            TITLE = "Loot History",
            COLITEMLINK = "Item",
            COLLOOTER = "Looter",
            COLDKP = "DKP",
            CHECKBTN_SHOWONLYTODAY = "Only items from today"
        },
        DKPPRICE = "Price",
        DKPPRICEBIS = "BiS Price",
        MINIMAP = {
            DESCRLCLICK = "Left Click - Open Window",
            MENU_SELECT = "Select an option:",
            MENU_TOGGLE_ERRORDKP = "Toggle ErrorDKP window",
            MENU_ML_VOTE = "Lootsurvey result",
            MENU_VERSIONCHECK = "Version-check",
            MENU_ITEMCHECK = "Item-check"
        },
        EXPORTDIALOG = {
            TITLE = "Export",
            HELPTEXT = "CRTL+C to copy content.\r\n ESC to close window."
        },
        LOOT_SURVEY = {
            BTN_NEED = "High Prio",
            BTN_GREED = "Low Prio",
            BTN_PASS = "Pass",
            BTN_OFFSPEC = "Offspec"
        },
        ML_SURVEY_RESULT = {
            TITLE = "Result",
            RESPONSE_OFFLINE = "|cFFBDBDBDOffline or addon not installed|r",
            RESPONSE_PENDING = "|cFFBDBDBDPending|r",
            RESPONSE_PASS = "|cFFB2B2B2Pass|r",
            RESPONSE_SECOND = "|cFFFF4F00Low Priority|r",
            RESPONSE_MAIN = "|cFF00FF00High Priority|r",
            RESPONSE_TIMEOUT = "|cFF0000FFPlayer didn't respond in time|r",
            RESPONSE_AUTOPASS = "|cFFB2B2B2Autopass|r",
            RESPONSE_OFFSPEC = "|cFFFF4F00Offspec|r",
            COLPLAYER = "Player",
            COLRESPONSE = "Response",
            COLDKP = "DKP",
            COLHASITEM = "Has Item",
            COLROLL = "Roll",
            HASITEM = "Yes",
            HASNOTITEM = "No",
            RESPONSES = "Responses",
            SURVEYCLOSED = "Survey closed"
        },
        OK = "Ok",
        CANCEL = "Cancel",
        LCD_ENTERCOSTFOR = "Enter DKP cost for",
        LCD_LOOTETBY = "Looted by |cFFFFFFFF%s|r.",
        LOOTER = "Looter",
        PRICE = "Price",
        ITEM = "Item",
        
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
        MSG_BROADCAST_DKP = "Broadcasting DKP-Table.",
        MSG_BROADCAST_LOOT = "Broadcasting Loot-Table.",
        MSG_BROADCAST_FULL = "Broadcasting all Data.",
        MSG_SYNC_FINISHED = "Got full %s update from %s.",
        MSG_LOOT_ADDED = "%s added to loot history.",
        MSG_LOOT_DISENCHANTED = "%s got disenchanted.",
        MSG_SURVEY_CLOSED_BY = "The Item-Survey got closed by %s",
        MSG_SURVEY_CANCELLED_BY = "The Item-Survey got cancelled by %s",
        MSG_LOOT_SKIN_REQUIRED = "%s needs to loot %s!",
        MSG_LOOT_SKIN_REQUIRED_YOU = "You need to loot %s!",
        MSG_OFFSPEC_ROLL_YOU = "You roll |cff00FF00%s|r for %s",
        MSG_OFFSPEC_ROLL = "%s rolls |cff00FF00%s|r for %s",

        HELP_EDKP = "Opens ErrorDKP window.",
        HELP_HELP = "Prints current help list.",
        HELP_BROADCAST = "------Broadcasts------",
        HELP_BROADCAST_FULL = "Initiate a full data broadcast (DKP+Items).",
        HELP_BROADCAST_DKP = "Initiate a DKP-Table broadcast to all guild members.",
        HELP_BROADCAST_ITEMS = "Initiate a Itemhistory-Table broadcast to all guild members.",
        HELP_SWAP = "Swap raidgroups of <player1> and <player2> (requires assist!)"
    }