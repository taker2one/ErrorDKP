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
local Sync = core.Sync

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

function Sync:OnEnable()
    -- Guild
    self:RegisterComm("ErrDKPDKPSync")         -- Broadcast DKP Table
    self:RegisterComm("ErrDKPLootSync")        -- Broadcast LootLog Table
    self:RegisterComm("ErrDKPSyncReq")         -- Request a table sync from a officer, data defines type "DKP", "PRICELIST", "ITEMHISTORY" => "FULL"
    self:RegisterComm("ErrDKPPriceList")       -- Price List Broadcast
    self:RegisterComm("ErrDKPAdjP")            -- Adjust DKP Points of a player
    self:RegisterComm("ErrDKPAddLoot")         -- Add Loot to history
    self:RegisterComm("ErrDKPAdjPAWI")         -- Adjust DKP Points caused by lootentry, also containes the historyentry
    self:RegisterComm("ErrDKPTableCheck")      -- Check for any updated tables
    self:RegisterComm("ErrDKPBuildCheck")      -- Inform about available update
    self:RegisterComm("BuildCheck")            -- Inform about available update, new Version with Type included
    self:RegisterComm("ErrDKPManDKP")          -- Manual DKP Single Entry Update

    -- Raid
    self:RegisterComm("ErrDKPSurvStart")       -- Start a loot survey
    self:RegisterComm("ErrDKPSurvAnsw")        -- Answer for an item survey
    self:RegisterComm("ErrDKPSurvClosed")      -- Item survey is closed
    self:RegisterComm("ErrDKPSurvCancel")      -- Item survey canceled
    self:RegisterComm("CanLootSkinNpc")        -- Player report he can loot a skinnable creature
    self:RegisterComm("OffspecRoll")           -- Offspecroll for item

    -- Party
    self:RegisterComm("FollowMe")              -- Everyone follow sender
    self:RegisterComm("FollowStop")            -- StopFollowing

    --Mixed
    self:RegisterComm("VerCheck")        -- Request Version from every Group/Guild member
    self:RegisterComm("VerResp")         -- Response to Versionrequest
    self:RegisterComm("ItemCheck")       -- Request Item amount of every Group/Guild member
    self:RegisterComm("ItemCheckResp")   -- Response to ItemCheck request

    self:RegisterComm("AssignmentUpdate") -- Broadcast assignment update
end

--###############################################
--# Message Implementation
--###############################################
function Sync:OnCommReceived(prefix, message, channel, sender)
    core:PrintDebug("OnMessageReceived", prefix, channel, sender)

    if prefix == "ErrDKPBuildCheck" and sender ~= UnitName("player") then
        -- This version is newer => inform sender
        if tonumber(message) < core.Build and tonumber(message) <= 1130408 and core.Type == "R" then
            core:PrintDebug("I have newer Version, inform player")
            core.Sync:Send("ErrDKPBuildCheck", tostring(core.Build))
        end
        return
    elseif prefix == "BuildCheck" and sender ~= UnitName("player")
    then
        -- This is V2 of the BuildCheck which also includes Build and Type (Alpha,Beta,Release)
        -- Create a second prefix for compatibility reasons
        
        local success, deserialized = Serializer:Deserialize(message)
        if success then
            -- Theres someone with a newer Version, print message then mute for 15 minutes
            if time() - core.LastUpdateAvailableMsg > 900 then
                if core.Type == "R" then
                    if deserialized["type"] == "R" and tonumber(deserialized["version"]) > core.Build then
                        core.LastUpdateAvailableMsg = time()
                        core:Print(string.format(_L["MSG_NEW_VERSION_AVAILABLE_FORMAT"], deserialized["version"], deserialized["type"]))
                    end
                elseif core.Type == "B" then 
                    if (deserialized["type"] == "R" or deserialized["type"] == "B") and tonumber(deserialized["version"]) > core.Build then
                        core.LastUpdateAvailableMsg = time()
                        core:Print(string.format(_L["MSG_NEW_VERSION_AVAILABLE_FORMAT"], deserialized["version"], deserialized["type"]))
                    end
                elseif tonumber(deserialized["version"]) > core.Build then
                    core.LastUpdateAvailableMsg = time()
                    core:Print(string.format(_L["MSG_NEW_VERSION_AVAILABLE_FORMAT"], deserialized["version"], deserialized["type"]))
                end
            end

            -- This version is newer => inform sender
            if tonumber(deserialized["version"]) < core.Build then
                if deserialized["type"] == "R" or 
                   deserialized["type"] == "B" and (core.Type == "B" or  core.Type == "A") or
                   deserialized["type"] == "A" and core.Type == "A"
                then
                    core:PrintDebug("I have newer Version, inform player")
                    core.Sync:Send("BuildCheck", { version = core.Build, type = core.Type })
                end
            end
        end
    elseif prefix == "ErrDKPAdjP" and sender ~= UnitName("player") 
    then
        -- Data is serialized { PTS, ATS, Data }
        local success, deserialized = Serializer:Deserialize(message)
            if success then
            -- core:PrintDebug(deserialized.PTS, deserialized.ATS)
            -- local timestampMatches = CheckDKPTimestamp(deserialized.PTS)

            -- if not timestampMatches then
            --     -- timestamp doesnt match request a full update
            --     core:Print(_L["MSG_DKPTABLE_OUTOFDATE"])
             
            --     -- In dieser Situation lieber direkt vom Sender anfragen da nicht sichergestellt ist, dass die Offiziere die Daten bereits verbucht haben
            --     core.Sync:SendTo("ErrDKPSyncReq", "FULL", officer)
            -- end

            local entry;
            for i, v in ipairs(core.DKPTable) do
                if string.lower(v["name"]) == string.lower(deserialized.DataSet["name"]) then
                    v["dkp"] = deserialized.DataSet["dkp"]
                    entry = v
                    -- I want to update the table when wow server guild roster sync is done
                    --core:SetDKPDataTimestamp(deserialized.ATS)
                    break
                end
            end
            if not entry then
                table.insert(core.DKPTable, deserialized.DataSet)
            end

            -- No local table update required cause player can build local table based in public available Guild Information (Public Note and Guild Info)
            if prefix == "ErrDKPAdjPA" then
                core:Print(string.format(_L["MSG_DKP_ADJUST_AUTO"], deserialized.DataSet["name"], deserialized.Details["DKP"], deserialized.Details["ItemLink"]))
            elseif prefix == "ErrDKPAdjP" then
                core:Print(string.format(_L["MSG_DKP_ADJUST_MAN"], deserialized.DataSet["name"], deserialized.Details["DKP"] ))
            end
            ErrorDKP.GNoteDKP:RefreshLocalTableIfRequired()
            ErrorDKP:DKPTableUpdate()
            -- ErrorDKP:DKPTableUpdate()
        else
            core:Error("Error while deserializing data from message: ", prefix)
        end
    elseif prefix == "ErrDKPAdjPAWI" and sender ~= UnitName("player") 
    then
        -- Data is serialized { PTS, ATS, Data, Item }
        local success, deserialized = Serializer:Deserialize(message)
            if success then
            core:PrintDebug("ErrDKPAdjPAWI", "sender", deserialized.PTS, deserialized.ATS)
            --local timestampMatches = CheckDKPTimestamp(deserialized.PTS)

            -- timestamp doesnt match request a full update
            -- if not timestampMatches then
            --     core:Print(_L["MSG_DKPTABLE_OUTOFDATE"])
            --     core.Sync:SendTo("ErrDKPSyncReq", "FULL", officer)
            -- end

            local entry;
            for i, v in ipairs(core.DKPTable) do
                if string.lower(v["name"]) == string.lower(deserialized.DataSet["name"]) then
                    v["dkp"] = deserialized.DataSet["dkp"]
                    entry = v
                    -- I want to update the table when wow server guild roster sync is done
                    --core:SetDKPDataTimestamp(deserialized.ATS)
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
            
            --Add to MRT if installed
            core.MrtI:AddItem(deserialized.Item.ItemLink, deserialized.Item.Looter, deserialized.Item.Dkp)

           
            core:Print(string.format(_L["MSG_DKP_ADJUST_AUTO"], deserialized.DataSet["name"], "-"..deserialized.Item["Dkp"], deserialized.Item["ItemLink"]))
            --ErrorDKP:DKPTableUpdate()
            ErrorDKP.GNoteDKP:RefreshLocalTableIfRequired()
            ErrorDKP:DKPTableUpdate()
            ErrorDKP:LootHistoryTableUpdate()
        else
            core:Print("Error while deserializing data from message: ", prefix)
        end
    elseif prefix == "ErrDKPAddLoot" and sender ~= UnitName("player")
    then
        -- Data is serialized { PTS, ATS, Data, Item }
        local success, deserialized = Serializer:Deserialize(message)
        if success then
            table.insert(core.LootLog, 1, deserialized.Item)
            while #core.LootLog > 50 do
                table.remove(core.LootLog, #core.LootLog)
            end
            core:SetLootDataTimestamp(deserialized.ATS)
            ErrorDKP:LootHistoryTableUpdate()

            -- Add to MRT if installed
            core.MrtI:AddItem(deserialized.Item.ItemLink, deserialized.Item.Looter, deserialized.Item.Dkp)

            if deserialized.Item.Looter == "disenchanted" then
                core:Print(string.format(_L["MSG_LOOT_DISENCHANTED"], deserialized.Item.ItemLink))
            else
                core:Print(string.format(_L["MSG_LOOT_ADDED"], deserialized.Item.ItemLink))
            end
        else
            core:Error("Error while deserializing data from message: ", prefix)
        end
    --
    -- Sync
    --
    elseif prefix == "ErrDKPDKPSync" and sender ~= UnitName("player")  
    then
        -- if VerifySender(sender) then
        --     local success, deserialized = Serializer:Deserialize(message)
        --     if success then
        --         table.wipe(core.DKPTable)
        --         for i, v in ipairs(deserialized.DataSet) do
        --             table.insert(core.DKPTable, v)
        --         end
        --         core:SetDKPDataTimestamp(deserialized.ATS)
        --         core:Print(string.format(_L["MSG_SYNC_FINISHED"], "DKP", sender))
        --     else
        --         core:Print("Error while deserializing data from message: ", prefix)
        --     end
        --     ErrorDKP:DKPTableUpdate()
        -- end
        core:PrintDebug("No more dkp sync required")
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
    --
    -- Request
    --
    elseif prefix == "ErrDKPSyncReq" and sender ~= UnitName("player")
    then
        if message == "DKP" then
            -- Members will send request if there data was out of date after a Broadcast, ingore all requests within 5 seconds
            if self.LastErrDKPSyncReqDKP and time() - self.LastErrDKPSyncReqDKP < 10 then
                core:Print(string.format("Ingore DKP Sync request from %s. Last broadcast was done: %s", sender, core:ToDateString(self.LastErrDKPSyncReqDKP)))
                return
            end
            core:Print(_L["MSG_BROADCAST_DKP_REQ"], sender, self.LastErrDKPSyncReqDKP)
            self.LastErrDKPSyncReqDKP = time()
            ErrorDKP:BroadcastDKPTable()
        end
        if message == "ITEMHISTORY" then
            -- Members will send request if there data was out of date after a Broadcast, ingore all requests within 5 seconds
            if self.LastErrDKPSyncReqItemhistory and time() - self.LastErrDKPSyncReqItemhistory < 10 then
                core:Print(string.format("Ingore Itemhistory Sync request from %s. Last broadcast was done: %s", sender, core:ToDateString(self.LastErrDKPSyncReqItemhistory)))
                return
            end
            core:Print(_L["MSG_BROADCAST_LOOT_REQ"], sender)
            self.LastErrDKPSyncReqItemhistory = time()
            ErrorDKP:BroadcastLootTable()
        end
        if message == "FULL" then
            -- Members will send request if there data was out of date after an item Broadcast, ingore all requests within 5 seconds
            if self.LastErrDKPSyncReqFull and time() - self.LastErrDKPSyncReqFull < 10 then
                core:Print(string.format("Ingore Full Sync request from %s. Last broadcast was done: %s", sender, core:ToDateString(self.LastErrDKPSyncReqFull)))
                return
            end

            core:Print(_L["MSG_BROADCAST_FULL_REQ"], sender)
            self.LastErrDKPSyncReqFull = time()
            -- Is this Ok? maybe its neccessary to split some data? We will see
            ErrorDKP:BroadcastDKPTable()
            ErrorDKP:BroadcastLootTable()
        end
    end

    if channel == "RAID" or channel == "PARTY" then
        if prefix == "ErrDKPSurvStart" then
            if VerifySender(sender) then
                local success, deserialized = Serializer:Deserialize(message)
                core:PrintDebug("ItemSurveyStarted", deserialized["id"])
                ErrorDKP.LootSurvey:Start(deserialized, deserialized["countdown"])
                core.Sync:SendRaid("ErrDKPSurvAnsw", {["id"] = deserialized["id"], ["response"] = "GOT"})
            end
        elseif prefix == "ErrDKPSurvAnsw" then
            --  { ["id"], ["itemIndex"], ["response"]  } 
            -- clients also responds instantly after receiving the survey
            local success, deserialized = Serializer:Deserialize(message)
            if success then
                if core:CheckSelfTrusted() then
                    ErrorDKP:OnCommReceived_SurvAnsw(sender, deserialized)
                end
                ErrorDKP.LootSurvey:UpdateAnswerCount(sender, deserialized)
            end
        elseif prefix == "ErrDKPSurvClosed" then
            if VerifySender(sender) then
                core:PrintDebug("Lottsurvey closed")
                ErrorDKP.LootSurvey:OnCommCloseReceived("CLOSED")
                core:Print(string.format(_L["MSG_SURVEY_CLOSED_BY"], sender))
            end
        elseif prefix == "ErrDKPSurvCancel" then
            if VerifySender(sender) then
                core:PrintDebug("Lottsurvey cancelled")
                ErrorDKP.LootSurvey:OnCommCloseReceived("CANCEL")
                core:Print(string.format(_L["MSG_SURVEY_CANCELLED_BY"], sender))
            end
        elseif prefix == "FollowMe" and sender ~= UnitName("player") then
            core:Print("Got do follow from ", sender)
            core.Follow:DoFollow(sender)
        elseif prefix == "FollowStop" and sender ~= UnitName("player") then
            core.Follow:Stop()
        elseif prefix == "AssignmentUpdate" --and sender ~= UnitName("player") 
        then
            local success, deserialized = Serializer:Deserialize(message)
            if success then            
                core:PrintDebug("AssignmentUpdate")
                ErrorDKP.AssignmentImport:GotAssignmentUpdate(deserialized)
            end
        end

    end

    if prefix == "ItemCheck" then
        if VerifySender(sender) then
            core:PrintDebug("Got Itemcheck request from",sender, message)
            -- For combatibility reasons do this here and check bank too for ony bags
            if message == tostring(179661) then
                self:SendTo("ItemCheckResp", tostring(GetItemCount(message, true)), sender)
            else
                self:SendTo("ItemCheckResp", tostring(GetItemCount(message)), sender)
            end
        end
    elseif prefix == "ItemCheckResp" then
        ErrorDKP.ItemCheck:OnCommResponse(sender, message)
    elseif prefix == "CanLootSkinNpc" then
        local success, deserialized = Serializer:Deserialize(message)
        if success then
            if core.CanLootMessages["LastChange"] and time() - core.CanLootMessages["LastChange"] > 10 then
                table.wipe(core.CanLootMessages)
            end
            if not core.CanLootMessages[deserialized.guid] then
                core:PrintDebug("Got first CanLootSkinNpc", core:tcount(core.CanLootMessages))
                core.CanLootMessages[deserialized.guid] = 1
                core.CanLootMessages["LastChange"] = time()
                C_Timer.After(1, function()
                    core:ValidateCanLoot(core.CanLootMessages[deserialized.guid], deserialized.name, sender)
                end)
            else
                core.CanLootMessages[deserialized.guid] =  core.CanLootMessages[deserialized.guid] + 1
                core.CanLootMessages["LastChange"] = time()
            end
        end
    elseif prefix == "OffspecRoll" and sender ~= UnitName("player") then
        local success, deserialized = Serializer:Deserialize(message)
        if success then
            -- Just Print
            core:Print(string.format(_L["MSG_OFFSPEC_ROLL"], sender, deserialized.roll, deserialized.itemLink))
        end
    end

    if prefix == "VerCheck" then
        if VerifySender(sender) then
            core:PrintDebug("Got Version request from ", sender)
            self:SendTo("VerResp", tostring(core.Build..core.Type), sender)
        end
    elseif prefix == "VerResp" then
        ErrorDKP.VersionCheck:OnCommResponse(sender, message)
    end
end

--###############################################
--# Send
--###############################################
function Sync:Send(prefix, data)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        --core:PrintDebug("serialized:", serialized)
        self:SendCommMessage(prefix, serialized, "GUILD")
    else
        self:SendCommMessage(prefix, data, "GUILD")
    end
end

function Sync:SendTo(prefix, data, player)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        --core:PrintDebug("serialized:", serialized)
        self:SendCommMessage(prefix, serialized, "WHISPER", player)
    else
        self:SendCommMessage(prefix, data, "WHISPER", player)
    end
end

function Sync:SendRaid(prefix, data)
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        self:SendCommMessage(prefix, serialized, "RAID")
    else
        self:SendCommMessage(prefix, data, "RAID")
    end
end

function Sync:SendParty(prefix, data)
    if IsInRaid() then
        self:SendRaid(prefix, data)
        return;
    end
    if type(data) == "table" then
        core:PrintDebug("Data is a table -> serialize to string")
        local serialized = Serializer:Serialize(data)
        self:SendCommMessage(prefix, serialized, "PARTY")
    else
        self:SendCommMessage(prefix, data, "PARTY")
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