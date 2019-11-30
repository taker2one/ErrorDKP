--###############################################
--#  Project: ErrorDKP
--#  File: communication.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Brodacast/Receive to/from other clients
--#  Last Edit: 21.11.2019
--###############################################
local addonName, core = ...

local function Init()
    f.SetScript("OnUpdate", function()
        -- There is no event if user goes offline so we check the roster an a regular basis
        --Update
        if ((time() - self.lastCheck) > 5) then
            self.lastCheck = time();
            MRT_RaidRosterUpdate();
        end
    end)
end

local function RaidRosterUpdate(frame)
    if (not MRT_NumOfCurrentRaid) then return; end
    if (not MRT_IsInRaid()) then 
        MRT_EndActiveRaid();
        return;
    end
    local numRaidMembers = MRT_GetNumRaidMembers();
    local realm = GetRealmName();
    local raidSize = MRT_RaidLog[MRT_NumOfCurrentRaid]["RaidSize"];
    local activePlayerList = {};
    --MRT_Debug("RaidRosterUpdate: Processing RaidRoster");
    --MRT_Debug(tostring(numRaidMembers).." raidmembers found.");
    for i = 1, numRaidMembers do
        local playerName, _, playerSubGroup, playerLvl, playerClassL, playerClass, _, playerOnline = mrt:GetRaidRosterInfo(i);
        -- seems like there is a slight possibility, that playerName is not available - so check it
        if playerName then
            if (playerOnline or MRT_Options["Attendance_TrackOffline"]) and (not MRT_Options["Attendance_GroupRestriction"] or (playerSubGroup <= (raidSize / 5))) then
                tinsert(activePlayerList, playerName);
            end
            local playerInRaid = nil;
            for key, val in pairs(MRT_RaidLog[MRT_NumOfCurrentRaid]["Players"]) do
                if (val["Name"] == playerName) then
                    if(val["Leave"] == nil) then playerInRaid = true; end
                end
            end
            if ((playerInRaid == nil) and (playerOnline or MRT_Options["Attendance_TrackOffline"]) and (not MRT_Options["Attendance_GroupRestriction"] or (playerSubGroup <= (raidSize / 5)))) then
                MRT_Debug("New player found: "..playerName);
                local UnitID = mrt:UnitID(i);
                local playerRaceL, playerRace = UnitRace(UnitID);
                local playerSex = UnitSex(UnitID);
                local playerInfo = {
                    ["Name"] = playerName,
                    ["Join"] = MRT_GetCurrentTime(),
                    ["Leave"] = nil,
                };
                tinsert(MRT_RaidLog[MRT_NumOfCurrentRaid]["Players"], playerInfo);
            end
            -- PlayerDB is being renewed when creating a new raid, so only update unknown players here
            if (not MRT_PlayerDB[realm][playerName]) then
                local UnitID = mrt:UnitID(i);
                local playerRaceL, playerRace = UnitRace(UnitID);
                local playerSex = UnitSex(UnitID);
                local playerGuild = GetGuildInfo(UnitID);
                local playerDBEntry = {
                    ["Name"] = playerName,
                    ["Race"] = playerRace,
                    ["RaceL"] = playerRaceL,
                    ["Class"] = playerClass,
                    ["ClassL"] = playerClassL,
                    ["Level"] = playerLvl,
                    ["Sex"] = playerSex,
                    ["Guild"] = playerGuild,
                };
                MRT_PlayerDB[realm][playerName] = playerDBEntry;
            end
        end
    end
    -- MRT_Debug("RaidRosterUpdate: Checking for leaving players...");
    for key, val in pairs(MRT_RaidLog[MRT_NumOfCurrentRaid]["Players"]) do
        local matchFound = nil;
        for index, activePlayer in ipairs (activePlayerList) do
            if (val["Name"] == activePlayer) then 
                matchFound = true; 
            end
        end
        if (not matchFound) then
            if (not MRT_RaidLog[MRT_NumOfCurrentRaid]["Players"][key]["Leave"]) then
                MRT_Debug("Leaving player found: "..val["Name"]);
                MRT_RaidLog[MRT_NumOfCurrentRaid]["Players"][key]["Leave"] = MRT_GetCurrentTime();
            end
        end
    end
end
