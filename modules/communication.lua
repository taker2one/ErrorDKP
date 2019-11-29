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
    core.Sync:RegisterComm("ErrDKPDKPSync")         -- Broadcast DKP Table
    core.Sync:RegisterComm("ErrDKPLootSync")        -- Broadcast LootLog Table
    core.Sync:RegisterComm("ErrDKPSyncReq")         -- Request a table sync from a officer, data defines type "DKP", "PRICELIST", "ITEMHISTORY" => "FULL"
    core.Sync:RegisterComm("ErrDKPPriceList")       -- Price List Broadcast
    core.Sync:RegisterComm("ErrDKPAdjP")            -- Adjust DKP Points of a player
    core.Sync:RegisterComm("ErrDKPAdjPA")           -- Adjust DKP Points caused by lootentry
    core.Sync:RegisterComm("ErrDKPTableCheck")      -- Check for any updated tables
    core.Sync:RegisterComm("ErrDKPBuildCheck")      -- Inform about available update
    core.Sync:RegisterComm("ErrDKPManDKP")          -- Manual DKP Single Entry Update
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
    elseif (prefix == "ErrDKPAdjP" or prefix == "ErrDKPAdjPA") --and sender ~= UnitName("player") 
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
                    core.Sync:SendTo("ErrDKPSyncReq", "DKP", officer)
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
    elseif prefix == "ErrDKPDKPSync" then
        if VerifySender(sender) then
            local success, deserialized = Serializer:Deserialize(message)
            if success then
                table.wipe(core.DKPTable)
                for i, v in ipairs(deserialized.DataSet) do
                    table.insert(core.DKPTable, v)
                end
                core:SetDKPDataTimestamp(deserialized.ATS)
                core:PrintDebug("Sync finished")
            else
                core:Print("Error while deserializing data from message: ", prefix)
            end
            ErrorDKP:DKPTableUpdate()
        end
    elseif prefix == "ErrDKPLootSync" then
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
                core:PrintDebug("Sync LootTable finished")
            else
                core:Print("Error while deserializing data from message: ", prefix)
            end
            ErrorDKP:LootHistoryTableUpdate()
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