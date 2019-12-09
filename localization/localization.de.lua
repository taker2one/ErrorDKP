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
            DESCRLCLICK = "Linke Maustaste - Öffne Fenster"
        },
        EXPORTDIALOG = {
            TITLE = "Exportieren",
            HELPTEXT = "STRG+C um Inhalt zu kopieren\r\nESC um Fenster zu schliessen."
        },
        ML_SURVEY_RESULT = {
            TITLE = "Ergebnis",
            RESPONSE_OFFLINE = "|cFFBDBDBDOffline oder Addon nicht installiert|r",
            RESPONSE_PENDING = "|cFFBDBDBDAustehend|r",
            RESPONSE_PASS = "|cFFB2B2B2Gepasst|r",
            RESPONSE_SECOND = "|cFFFF4F00Second|r",
            RESPONSE_MAIN = "|cFF00FF00Main/Need|r",
            RESPONSE_TIMEOUT = "|cFF0000FFSpieler hat nicht geantwortet|r",
            RESPONSE_AUTOPASS = "|cFFB2B2B2Autopass|r",
            COLPLAYER = "Spieler",
            COLRESPONSE = "Antwort",
            COLDKP = "DKP",
            RESPONSES = "Antworten"
        },
        OK = "Ok",
        CANCEL = "Abbrechen",
        LCD_ENTERCOSTFOR = "DKP-Preis eingeben für",
        LCD_LOOTETBY = "Geplündert von |cFFFFFFFF%s|r.",
        
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
        MSG_SYNC_FINISHED = "Vollständiges %s update von %s erhalten.",
        MSG_LOOT_ADDED = "%s zur Loot-Historie hinzugefügt.",
        MSG_LOOT_DISENCHANTED = "%s wurde entzaubert.",

        HELP_EDKP = "Öffnet das ErrorDKP Fenster.",
        HELP_HELP = "Gibt die aktuelle Hilfeliste aus.",
        HELP_BROADCAST = "Braodcast der Daten an alle Gildenmitglieder."
    }

end