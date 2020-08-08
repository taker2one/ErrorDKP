--###############################################
--#  Project: ErrorDKP
--#  File: follow.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: 
--#  Last Edit: 05.06.2020
--###############################################
local addonName, core = ...
local Follow = {}
local ErrorDKP = core.ErrorDKP
core.Follow = Follow

function Follow:Me()
    core:Print("Tell everyone in Party/Raid to follow me.")
    core.Sync:SendRaid("FollowMe", " ")
end

function Follow:DoFollow(player)
    core:Print(string.format("Follow player: %s", player))

    local numRaidMembers = GetNumGroupMembers()
    for i=1, numRaidMembers do
        if IsInRaid() then
            name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name == player then
                FollowUnit(string.format("raid%d", i))
            end
        elseif IsInGroup() then
            local name = UnitName(string.format("party%d",i))
            if name == player then
                FollowUnit(string.format("party%d",i))
            end
        end
    end
end

function Follow:Stop()
    core:Print("Stop follow")
    FollowUnit("player")
end

function Follow:SendStop()
    core:Print("Tell everyone in Party/Raid to stop follow me.")
    core.Sync:SendRaid("FollowStop", " ")
end