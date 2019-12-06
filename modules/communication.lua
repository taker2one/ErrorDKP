--###############################################
--#  Project: ErrorDKP
--#  File: communication.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Brodacast/Receive to/from other clients
--#  Last Edit: 21.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _G = _G
local _L = core._L

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

core.Sync = LibStub("AceAddon-3.0"):NewAddon("ErrorDKP", "AceComm-3.0")

-- Check is timestamp matches current DataTimestamp
local function CheckDKPTimestamp(timestamp)
    if timestamp == core:GetDKPDataTimestamp() then
        return true
    else 
        return nil
    end
end

local function VerifySender(sender)
    core:PrintDebug("VerifySender", sender, core:CheckTrusted(sender))
    return core:CheckTrusted(sender)
end


--###############################################
--# Register Addon Messages
--###############################################

function core.Sync:OnEnable()
    -- Guild
    core.Sync:RegisterComm("ErrDKPDKPSync")         -- Broadcast DKP Table
    core.Sync:RegisterComm("ErrDKPLootSync")        -- Broadcast LootLog Table
    core.Sync:RegisterComm("ErrDKPSyncReq")         -- Request a table sync from a officer, data defines type "DKP", "PRICELIST", "ITEMHISTORY" => "FULL"
    core.Sync:RegisterComm("ErrDKPPriceList")       -- Price List Broadcast
    core.Sync:RegisterComm("ErrDKPAdjP")            -- Adjust DKP Points of a player
    --core.Sync:RegisterComm("ErrDKPAdjPA")           -- Adjust DKP Points caused by lootentry, also containes the historyentry
    core.Sync:RegisterComm("ErrDKPAddLoot")         -- Add Loot to history
    core.Sync:RegisterComm("ErrDKPAdjPAWI")         -- Adjust DKP Points caused by lootentry, also containes the historyentry
    core.Sync:RegisterComm("ErrDKPTableCheck")      -- Check for any updated tables
    core.Sync:RegisterComm("ErrDKPBuildCheck")      -- Inform about available update
    core.Sync:RegisterComm("ErrDKPManDKP")          -- Manual DKP Single Entry Update

    -- Raid
    core.Sync:RegisterComm("ErrDKPSurvStart")       -- Start a loot survey
    core.Sync:RegisterComm("ErrDKPSurvGot")         -- Client answers that he got the survey
    core.Sync:RegisterComm("ErrDKPSurvAnsw")        -- Answer for an item survey
    core.Sync:RegisterComm("ErrDKPSurvClosed")      -- Item survey is closed
end


--###############################################
--# Message Implementation
--###############################################
function core.Sync:OnCommReceived(prefix, message, channel, sender)
    core:PrintDebug("OnMessageReceived", prefix, channel, sender)

    if prefix == "ErrDKPBuildCheck" and sender ~= UnitName("player") then
        -- Theres someone with a newer Version, mute message for 15 minutes
        if time() - core.LastUpdateAvailableMsg > 900 then
            if tonumber(message) > core.Build then
                core.LastUpdateAvailableMsg = time()
                core:Print(_L["MSG_NEW_VERSION_AVAILABLE"])
            end
        end

        -- This version is newer => inform sender
        if tonumber(message) < core.Build then
            core.Sync:Send("ErrDKPBuildCheck", tostring(core.Build))
        end
        return
    elseif prefix == "ErrDKPAdjP" and sender ~= UnitName("player") 
    then
        -- Data is serialized { PTS, ATS, Data }
        local success, deserialized = Serializer:Deserialize(message)
            if success then
            core:PrintDebug(deserialized.PTS, deserialized.ATS)
            local timestampMatches = CheckDKPTimestamp(deserialized.PTS)

            -- timestamp doesnt match request a full update
            if not timestampMatches then
                core:Print(_L["MSG_DKPTABLE_OUTOFDATE"])
                local officer = core:GetOnlineOfficer()
                if officer then
                    core.Sync:SendTo("ErrDKPSyncReq", "FULL", officer)
                else
                    core:Print("There is currently no online officer")
                end
            end

            local entry;
            for i, v in ipairs(core.DKPTable) do
                if v["name"] == deserialized.DataSet["name"] then
                    v["dkp"] = deserialized.DataSet["dkp"]
                    entry = v
                    core:SetDKPDataTimestamp(deserialized.ATS)
                    break
                end
            end
            if not entry then
                table.insert(core.DKPTable, deserialized.DataSet)
            end

            if prefix == "ErrDKPAdjPA" then
                core:Print(string.format(_L["MSG_DKP_ADJUST_AUTO"], deserialized.DataSet["name"], deserialized.Details["DKP"], deserialized.Details["ItemLink"]))
            elseif prefix == "ErrDKPAdjP" then
                core:Print(string.format(_L["MSG_DKP_ADJUST_MAN"], deserialized.DataSet["name"], deserialized.Details["DKP"] ))
            end
            ErrorDKP:DKPTableUpdate()
        else
            core:Print("Error while deserializing data from message: ", prefix)
        end
    elseif prefix == "ErrDKPAdjPAWI" and sender ~= UnitName("player") 
    then
        -- Data is serialized { PTS, ATS, Data, Item }
        local success, deserialized = Serializer:Deserialize(message)
            if success then
            core:PrintDebug(deserialized.PTS, deserialized.ATS)
            local timestampMatches = CheckDKPTimestamp(deserialized.PTS)

            -- timestamp doesnt match request a full update
            if not timestampMatches then
                core:Print(_L["MSG_DKPTABLE_OUTOFDATE"])
                local officer = core:GetOnlineOfficer()
                if officer then
                    core.Sync:SendTo("ErrDKPSyncReq", "FULL", officer)
                else
                    core:Print("There is currently no online officer")
                end
            end

            local entry;
            for i, v in ipairs(core.DKPTable) do
                if v["name"] == deserialized.DataSet["name"] then
                    v["dkp"] = deserialized.DataSet["dkp"]
                    entry = v
                    core:SetDKPDataTimestamp(deserialized.ATS)
                    break
                end
            end
            if not entry then
                table.insert(core.DKPTable, deserialized.DataSet)
            end

            -- we also get the item that caused the adjsutment so add it to loothistory
            table.insert(core.LootLog, 1, deserialized.Item)
            while #core.LootLog > 50 do
                table.remove(core.LootLog, #core.LootLog)
            end
            core:SetLootDataTimestamp(deserialized.IATS)

           
            core:Print(string.format(_L["MSG_DKP_ADJUST_AUTO"], deserialized.DataSet["name"], "-"..deserialized.Item["Dkp"], deserialized.Item["ItemLink"]))
            ErrorDKP:DKPTableUpdate()
            ErrorDKP:LootHistoryTableUpdate()
        else
            core:Print("Error while deserializing data from message: ", prefix)
        end
    elseif prefix == "ErrDKPAddLoot" 
    --and sender ~= UnitName("player")
    then
        -- Data is serialized { PTS, ATS, Data, Item }
        local success, deserialized = Serializer:Deserialize(message)
        if success then
            table.insert(core.LootLog, deserialized.Item)
            core:SetLootDataTimestamp(deserialized.IATS)
            ErrorDKP:LootHistoryTableUpdate()

            if deserialized.Item.Looter == "disenchanted" then
                core:Print(string.format(_L["MSG_LOOT_DISENCHANTED"], deserialized.Item.ItemLink))
            else
                core:Print(string.format(_L["MSG_LOOT_ADDED"], deserialized.Item.ItemLink))
            end
        else
            core:Print("Error while deserializing data from message: ", prefix)
        end
    elseif prefix == "ErrDKPDKPSync" and sender ~= UnitName("player")  
    then
        if VerifySender(sender) then
            local success, deserialized = Serializer:Deserialize(message)
            if success then
                table.wipe(core.DKPTable)
                for i, v in ipairs(deserialized.DataSet) do
                    table.insert(core.DKPTable, v)
                end
                core:SetDKPDataTimestamp(deserialized.ATS)
                core:Print(string.format(_L["MSG_SYNC_FINISHED"], "DKP", sender))
            else
                core:Print("Error while deserializing data from message: ", prefix)
            end
            ErrorDKP:DKPTableUpdate()
        end
    elseif prefix == "ErrDKPLootSync" and sender ~= UnitName("player")  
    then
        if VerifySender(sender) then
            local success, deserialized = Serializer:Deserialize(message)
            if success then
                table.wipe(core.LootLog)
                for i, v in ipairs(deserialized.DataSet) do
                    if i ~= 1 then
                    table.insert(core.LootLog, v)
                    end
                end
                core:SetLootDataTimestamp(deserialized.ATS)
                core:Print(string.format(_L["MSG_SYNC_FINISHED"], "Loot", sender))
            else
                core:Print("Error while deserializing data from message: ", prefix)
            end
            ErrorDKP:LootHistoryTableUpdate()
        end
    elseif prefix == "ErrDKPSyncReq" and sender ~= UnitName("player")  then
        if message == "DKP" then
            core:Print(_L["MSG_BROADCAST_DKP_REQ"], sender)
            ErrorDKP:BroadcastDKPTable()
        end
        if message == "ITEMHISTORY" then
            core:Print(_L["MSG_BROADCAST_LOOT_REQ"], sender)
            ErrorDKP:BroadcastLootTable()
        end
        if message == "FULL" then
            core:Print(_L["MSG_BROADCAST_FULL_REQ"], sender)
            -- Is this Ok? maybe its neccessary to split some data? We will see
            ErrorDKP:BroadcastDKPTable()
            ErrorDKP:BroadcastLootTable()
        end
    end

    if channel == "RAID" then
        if prefix == "ErrDKPSurvStart" then
            --if VerifySender(sender) then
            local success, deserialized = Serializer:Deserialize(message)
            core:PrintDebug("ItemSurveyStarted", deserialized["id"])
        end

    end
end

--###############################################
--# Send
--###############################################
function core.Sync:Send(prefix, data)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        --core:PrintDebug("serialized:", serialized)
        core.Sync:SendCommMessage(prefix, serialized, "GUILD")
    else
        core.Sync:SendCommMessage(prefix, data, "GUILD")
    end
end

function core.Sync:SendTo(prefix, data, player)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        --core:PrintDebug("serialized:", serialized)
        core.Sync:SendCommMessage(prefix, serialized, "WHISPER", player)
    else
        core.Sync:SendCommMessage(prefix, data, "WHISPER", player)
    end
end

function core.Sync:SendRaid(prefix, data)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        --core:PrintDebug("serialized:", serialized)
        core.Sync:SendCommMessage(prefix, serialized, "RAID")
    else
        core.Sync:SendCommMessage(prefix, data, "RAID")
    end
end

function core:GetOnlineOfficer()
    if IsInGuild() then
        local guildMembers = GetNumGuildMembers()
        for i=1, #core.TrustedPlayers do
            for a=1, guildMembers do
                local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(a)
                name = strsub(name, 1, string.find(name, "-")-1) 
                if core.TrustedPlayers[i] == name and online then
                    core:PrintDebug("Found online officer", name)
                    return name
                end
            end
        end
    end
end