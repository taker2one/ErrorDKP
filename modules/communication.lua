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

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

core.Sync = LibStub("AceAddon-3.0"):NewAddon("ErrorDKP", "AceComm-3.0")


function ErrorDKP:HasSendPermissions(sender)
    -- We should check if this was a valid sender
end


--###############################################
--# Register Addon Messages
--###############################################

function core.Sync:OnEnable()
    core.Sync:RegisterComm("ErrDKPPriceList")       -- Price List Broadcast
    core.Sync:RegisterComm("ErrDKPAdjP")            -- Adjust DKP Points of a player
end


--###############################################
--# Message Implementation
--###############################################
function core.Sync:OnCommReceived(prefix, message, channel, sender)
    core:PrintDebug("OnMessageReceivedbefore")
    core:PrintDebug("OnMessageReceived", prefix, message, channel, sender)
end

--###############################################
--# Send
--###############################################
function core.Sync:Send(prefix, data)
    --core.Sync:SendCommMessage(prefix, data, "GUILD")
    if type(data) == "table" then
        core:PrintDebug("Data is a tabla -> serialize to string")
        local serialized = Serializer:Serialize(data)
        core:PrintDebug("serialized:", serialized)
        core.Sync:SendCommMessage(prefix, serialized, "GUILD")
    end

end