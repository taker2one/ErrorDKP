--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 29.12.2019
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "2.0",
    ["timestamp"] = "1581079088"
}

local pricelist = {
    ["16795"]= { price = "30" ,prio = "Warrior-Tank", bis="Warrior, Shadow", alt="19131,18735"},
    ["16796"]= { price = "30" ,prio = "Warr", bis="Warrior"},
    ["16797"]= { price = "50" ,prio = ""},
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo