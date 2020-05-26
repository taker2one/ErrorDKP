--###############################################
--#  Project: ErrorDKP
--#  File: groupswap.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Swap players between groups
--#  Last Edit: 21.02.2020
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
ErrorDKP.GroupSwap = {}
local GroupSwap = ErrorDKP.GroupSwap

function GroupSwap:Swap(playerName1, playerName2)
    if not IsInRaid() then
        core:Print("You are not in a raid")
        return
    end

    if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
        core:Print("You dont have the rights to swap members, ask RL for assistance")
        return
    end

    if not playerName1 or not playerName2 then
        core:Print("Missing arguments")
        return
    end

    local p1Index, p2Index
    local p1grp, p2grp

    for i = 1, Members() do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
        --local unit = "party" .. i

        if string.lower(playerName1) == string.lower(name) then
            p1Index = i
            p1grp = subgroup
        elseif string.lower(playerName2) == string.lower(name) then
            p2Index = i
            p2grp = subgroup
        end

        if p1Index and p2Index then
            core:PrintDebug("Players found:", p1Index, p2Index)
            core:Print("Swap " .. playerName1 .. "(Group " .. p1grp .. ")" .. " and " .. playerName2 .. "(Group " .. p2grp .. ")")
            SwapRaidSubgroup(p1Index, p2Index)
            break
        end
    end

    if not p1Index then
        core:Error(playerName1 .. " not found in raid")
    end
    if not p2Index then
        core:Error(playerName2 .. " not found in raid")
    end
end
