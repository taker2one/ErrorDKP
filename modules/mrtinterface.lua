--###############################################
--#  Project: ErrorDKP
--#  File: mrtinterface.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Interface to use functions of 
--#               the MizusRaidTracker Addon 
--#               if installed
--#  Last Edit: 15.04.2020
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L

local MrtI = {}
core.MrtI = MrtI

function MrtI:AddItem(itemLink, looter, cost)
    core:PrintDebug("MrtI:AddItem()")
    if(MizusRaidTracker == nil and MRT_ManualAddLoot == nil) then
        core:PrintDebug("MizusRaidTracker is  not installed.")
        return value
    end
    
    core:PrintDebug("MRT_ManualAddLoot is installed => AddItem.", itemLink, looter, cost)
    MRT_ManualAddLoot(itemLink, looter, cost);
end