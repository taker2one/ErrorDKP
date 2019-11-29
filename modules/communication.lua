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

function ErrorDKP:HasSendPermissions(sender)
    -- We should check if this was a valid sender
end


--###############################################
--# Register Addon Messages
--###############################################

function core.Sync:OnEnable()
    core.Sync:RegisterComm("ErrDKPDKPSync")         -- Broadcast DKP Table
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
    core:PrintDebug("OnMessageReceived", prefix, message, channel, sender)

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
    elseif prefix == "ErrDKPAdjP" or prefix == "ErrDKPAdjPA" then
        -- Data is serialized { PTS, ATS, Data }
        local deserialized = Serializer:Deserialize(decoded)
        local timestampMatches = CheckDKPTimestamp(deserialized.PTS)

        -- timestamp doesnt match request a full update
        if not timestampMatches then
            core.Sync:Send("ErrDKPSyncReq", "DKP")
            core:Print(_L["MSG_DKPTABLE_OUTOFDATE"])
        end

        local entry;
        for i, v in ipairs(core.DKPTable) do
            if v["name"] == deserialized.Data["name"] then
                v = deserialized.Data
                entry = v
                core:SetDKPDataTimestamp(deserialized.ATS)
                break
            end
        end
        if not entry then
            table.insert(core.DKPTable, player)
        end
    end
end

--###############################################
--# Send
--###############################################
function core.Sync:Send(prefix, data)
    if type(data) == "table" then
        core:PrintDebug("Data is a tabla -> serialize to string")
        local serialized = Serializer:Serialize(data)
        core:PrintDebug("serialized:", serialized)
        core.Sync:SendCommMessage(prefix, serialized, "GUILD")
    else
        core.Sync:SendCommMessage(prefix, data, "GUILD")
    end

end