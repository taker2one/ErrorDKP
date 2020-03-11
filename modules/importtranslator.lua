--###############################################
--#  Project: ErrorDKP
--#  File: importtranslator.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Translate input like class names etc
--#  Last Edit: 28.11.2019
--###############################################

local addonName, core = ...

local ClassTableDE = {
    ["Druide"] = "DRUID",
    ["Jäger"] = "HUNTER",
    ["Magier"] = "MAGE",
    ["Priester"] = "PRIEST",
    ["Schurke"] = "ROGUE",
    ["Schamane"] = "SHAMAN",
    ["Hexenmeister"] = "WARLOCK",
    ["Krieger"] = "WARRIOR",
    ["Paladin"] = "PALADIN"
}

local ClassTableEN = {
    ["Druid"] = "DRUID",
    ["Hunter"] = "HUNTER",
    ["Mage"] = "MAGE",
    ["Priest"] = "PRIEST",
    ["Rogue"] = "ROGUE",
    ["Shaman"] = "SHAMAN",
    ["Warlock"] = "WARLOCK",
    ["Warrior"] = "WARRIOR",
    ["Paladin"] = "PALADIN"
}

local ClassFileNameIdTable = {
    ["DRUID"] = 11,
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["SHAMAN"] = 7,
    ["MAGE"] = 8,
    ["WARLOCK"] = 9
}

function core:LocalizedClassToEng(localizedClassString)
    local a = ClassTableDE[localizedClassString]
    if not a then a = ClassTableEN[localizedClassString] end
    if not a then a = "NOTFOUND" end

    local b = ClassFileNameIdTable[a];

    return a,b
end

function core:classFileNameToId(classFileName)
    return ClassFileNameIdTable[classFileName]
end
