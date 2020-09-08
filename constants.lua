--###############################################
--#  Project: ErrorDKP
--#  File: constants.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 28.11.2019
--###############################################
local addonName, core = ...
local c = {}

c.ITEMRARITY = {
    ["POOR"] = 0,
    ["COMMON"] = 1,
    ["UNCOMMON"] = 2,
    ["RARE"] = 3,
    ["EPIC"] = 4,
    ["LEGENDARY"] = 5
}

c.CLASSCOLOR = {
    ["PRIEST"] = ""
}

-- Required for import of eqdkpdata
c.CLASSID_EQDKP = {
    ["2"] = "DRUID",
    ["3"] = "HUNTER",
    ["4"] = "MAGE",
    ["6"] = "PRIEST",
    ["7"] = "ROGUE",
    ["8"] = "SHAMAN",
    ["9"] = "WARLOCK",
    ["10"] = "WARRIOR"
}

-- ignored items
c.IGNORED_ITEMS = {  
    -- Shards
    [20725] = true,     -- Nexus Crystal
    [18562] = true      -- Elementium ore
}

core.CONSTANTS = c