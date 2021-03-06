--###############################################
--#  Project: ErrorDKP
--#  File: init.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Setup events, register slash commands
--#  Last Edit: 18.03.2020
--###############################################

local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L

local function mapImportDKPData()
    local imported = {}
    local index = 1

    local timestamp = ErrorDKP.GNoteDKP:GetTimestamp()
    local importDataTimestamp = DKPInfo["timestamp"]

    if (not timestamp and tonumber(importDataTimestamp)) or tonumber(importDataTimestamp) > timestamp then
        -- fine
        for k,v in pairs(gdkp["players"]) do
            ErrorDKP.GNoteDKP:SetPlayerDKP(k, v["dkp_current"], true)
        end

        C_Timer.After(5, function() ErrorDKP.GNoteDKP:UpdateDKPInfo() end)
        core:Print("DKP Import done.")
    else
        core:Print("The timestamp of the data you want to import is older than the dkp data in the guild info")
    end
end

-------------------------------------------------------------------
--
--    Slash Commands    
--
-------------------------------------------------------------------

core.Commands = {
    ["debug"] = function(enable)
        if enable then
            core.Debug = true
            core:Print("Debug output enabled")
        else
            core.Debug = false
            core:Print("Debug output disabled")
        end
    end,
    ["testmode"] = function(enable)
        if enable then
            core.TestMode = true
            core:Print("TestMode enabled")
        else
            core.TestMode = false
            core:Print("TestMode disabled")
        end
    end,
    ["broadcast"] = function(mode)
        if not core:CheckSelfTrusted() then return; end
        if not mode or string.lower(mode) == "full" then
            core:Print(_L["MSG_BROADCAST_FULL"])
            ErrorDKP:BroadcastDKPTable()
            ErrorDKP:BroadcastLootTable()
        elseif string.lower(mode) == "dkp" then
            core:Print(_L["MSG_BROADCAST_DKP"])
            ErrorDKP:BroadcastDKPTable()
        elseif string.lower(mode) == "items" then
            core:Print(_L["MSG_BROADCAST_LOOT"])
            ErrorDKP:BroadcastLootTable() 
        end
    end,
    ["swap"] = function(p1,p2)
        ErrorDKP.GroupSwap:Swap(p1, p2)
    end,

    ["help"] = function()
        print(" ")
        core:Print("|cff00cc66/edkp|r - ".._L["HELP_EDKP"])
        core:Print("|cff00cc66/edkp help|r - ".._L["HELP_HELP"])
        core:Print("|cff00cc66/edkp swap <player1> <player2>|r - ".._L["HELP_SWAP"])
        if core:CheckSelfTrusted() then
            core:Print(" ")
            core:Print("|cff00cc66".._L["HELP_BROADCAST"])
            core:Print("|cff00cc66/edkp broadcast|r - ".._L["HELP_BROADCAST_FULL"])
            core:Print("|cff00cc66/edkp broadcast dkp|r - ".._L["HELP_BROADCAST_DKP"])
            core:Print("|cff00cc66/edkp broadcast items|r - ".._L["HELP_BROADCAST_ITEMS"])
        end
    end,

    ["roll"] = function()
        core:Roll()
    end,

    ["dkp"] = {
        ["reset"] = function (...)
            if core:CheckDKPOfficer() then
                ErrorDKP.GNoteDKP:Reset(true)
            else
                core:Print("Not allowed.")
            end
        end
    },

    ["import"] = {
        ["dkp"] = function(...)
            if core:CheckDKPOfficer() then
                mapImportDKPData()
            else
                core:Print("Not allowed.")
            end
        end
    },
    ["print"] = {
        ["stat"] = function(...)
            core:Print("==========Stats=========")
            local ts = ErrorDKP.GNoteDKP:GetTimestamp()
            core:Print("Local DKP-Timestamp:", ts)
        end
    },
    ["follow"] = {
        ["me"] = function(...)
            core.Follow:Me()
        end,
        ["stop"] = function(...)
            core.Follow:SendStop()
        end,
        ["test"] = function(...)
            --TargetUnit("party1")
            CastSpellByName("Healing Wave",1)
        end,
    },
    ["test"] = {
        ["corehound"] = function(...)
            if core:CheckSelfTrusted() then
                local registered = ErrorDKP.EventFrame:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED")
                core:Print("IsEventRegistered(COMBAT_LOG_EVENT_UNFILTERED)", registered)
            end
        end,
        ["lootsurvey"] = function(...)
            if core:CheckSelfTrusted() then
                core:Print("Test lootsurvey")
                ErrorDKP.LootSurvey:Start(core:tcopy(ErrorDKP.LootSurvey.DemoSurveyData), 120)
            end
        end,
        ["lootsurveyresult"] = function(...)
            if core:CheckSelfTrusted() then
                core:Print("Test lootsurvey")
                ErrorDKP.MLResult:Show(1, true)
            end
        end,
        ["loottrack"] = function(...)
            core:Print("Test loottrack")
            core.PendingMLI = {
                ["slot"] = 1,
                ["charName"] = "Testchar",
                ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
                ["lootQuantity"] = 1
            }
            ErrorDKP:AddPendingMasterLoot(1)
        end,
        ["lootsurveysetup"] = function(...)
            ErrorDKP.MLSetupSurvey:Show({})
        end,
        ["notedkp"] = function(...)
            ErrorDKP.GNoteDKP:GetAll()
        end,
        ["writenote"] = function(...)
            ErrorDKP.GNoteDKP:UpdateNote("Kräuterlisl", "{125.12}")
        end,
        ["mrti"] = function(...)
            core:PrintDebug("Test MizusRaidtracker Interface")
            core.MrtI:AddItem("|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r", "Rassputin", 10)
        end,
        ["abs"] = function(...)
            local actionType, id, subType = GetActionInfo(1)
            core:Print(actionType, id, subType)
            local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(id)
            core:Print(name, rank, spellId)
            actionType, id, subType = GetActionInfo(2)
            core:Print(actionType, id, subType)
            name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(id)
            core:Print(name, rank, spellId)

            local rank = GetSpellSubtext(spellId)
            core:Print(rank)
        end
    }
}

-- Slash Command Handler
local function HandleSlashCommands(cmd)
    core:PrintDebug("HandleSlashCommand: ", cmd)

    if( #cmd == 0 ) then
        --open list
        core.ErrorDKP:Toggle()
        return
    end

    local args = {};
	for _, arg in ipairs({ string.split(' ', cmd) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
    end
    
    local path = core.Commands;
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then
			arg = arg:lower();			
			if (path[arg]) then
				if (type(path[arg]) == "function") then
					path[arg](select(id + 1, unpack(args))); 
					return;					
				elseif (type(path[arg]) == "table") then				
					path = path[arg];
				end
			else
				core.Commands.help();
				return;
			end
		end
	end
end

--Register slash commands
local function RegisterSlashCommands()
    core:PrintDebug("Register slash commands")

    SLASH_ERRORDKP1 = "/edkp"
    SlashCmdList.ERRORDKP = HandleSlashCommands 
end

-------------------------------------------------------------------
--
--    Init
--
-------------------------------------------------------------------
local function mapImportDKPData()
    local imported = {}
    local index = 1
    for k,v in pairs(gdkp["players"]) do
        local classFilename, classId = core:LocalizedClassToEng(v["class"])
        imported[index] = { name = k, dkp = v["dkp_current"], classFilename = classFilename, classId = classId  }
        index = index + 1
    end

    return imported
end

local function GetNewestData(dkpdb, dkpinfo, importinfo)
    if #dkpdb == 0 or not dkpinfo["timestamp"] or( importinfo["timestamp"] and tonumber(importinfo["timestamp"]) > tonumber(dkpinfo["timestamp"]) ) then
        core:PrintDebug("Import eqdkpdata")
        dkpdb = mapImportDKPData()
        dkpinfo["timestamp"] = importinfo["timestamp"]

        return dkpdb, dkpinfo
    end

    return dkpdb, dkpinfo                                                                                                                                                                                                            
end

local function FillMissingSettings(dbset, defset)
    for k,v in pairs(defset) do
        if dbset[k] == nil then
            core:PrintDebug("Add missing entry in settings", k)
            dbset[k] = v
        end
    end
end

local function OnInit()
    core:PrintDebug("Initialize")
    RegisterSlashCommands()
    core:Print(addonName, core.Version)
    --Load Saved Data
    if not ErrorDKPDB then ErrorDKPDB = {} end
    if not ErrorDKPConfig then ErrorDKPConfig = {} end
    if not ErrorDKPLootLog then ErrorDKPLootLog = {} end
    if not ErrorDKPDataInfo then ErrorDKPDataInfo = {} end
    if not ErrorDKPDKPList then ErrorDKPDKPList = {} end 
    if not ErrorDKPPriceList then ErrorDKPPriceList = {} end
    if not ErrorDKPLootQueue then ErrorDKPLootQueue = {} end

    --ValidateSettings
    FillMissingSettings(ErrorDKPConfig, core.DefaultSettings)

    -- Check which data is the newest
    -- if not ErrorDKPDataInfo.DKPInfo then 
    --     ErrorDKPDataInfo.DKPInfo = {} 
    --     core:PrintDebug("No ErrorDKPDataInfo.DKPInfo, create it")
    -- end
    -- ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo = GetNewestData(ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo, DKPInfo) --DKP is global from the jdkp export
    -- Same for itemprices
    if not ErrorDKPDataInfo.PriceListInfo then ErrorDKPDataInfo.PriceListInfo = {} end
    if core:IsTableEmpty(ErrorDKPPriceList) or (ErrorDKPDataInfo.PriceListInfo["timestamp"] < core.Imports.ItemPriceListInfo["timestamp"]) then
        core:PrintDebug("Pricelist in import folder is newer, use it.", core:IsTableEmpty(ErrorDKPPriceList), ErrorDKPDataInfo.PriceListInfo["timestamp"], core.Imports.ItemPriceListInfo["timestamp"])
        ErrorDKPPriceList = core.Imports.ItemPriceList
        ErrorDKPDataInfo.PriceListInfo["timestamp"] = core.Imports.ItemPriceListInfo["timestamp"]
        ErrorDKPDataInfo.PriceListInfo["version"] = core.Imports.ItemPriceListInfo["version"]
    end
    -- Same for loothistory
    if not ErrorDKPDataInfo.LootInfo then ErrorDKPDataInfo.LootInfo = {} end

    -- Get DKP Info
    -- local noteDkpTable
    -- local dkpDataInfo = core.ErrorDKP.GNoteDKP:GetGInfoData()
    -- if dkpDataInfo then
    --     core:PrintDebug("Dkp-Data-Timestamp: ", dkpDataInfo.Timestamp)
    --     noteDkpTable = core.ErrorDKP.GNoteDKP.GetAll()
    --     ErrorDKPDKPList = noteDkpTable and noteDkpTable or ErrorDKPDKPList
    --     ErrorDKPDataInfo.DKPInfo = dkpDataInfo and dkpDataInfo or ErrorDKPDataInfo.DKPInfo
    -- else
    --     core:PrintDebug("Dkp-Data-Timestamp: ", "no timestamp found")
    -- end

    --Apply to core
    
    -- Do not save Table anymore cause we rebuild it from GuildNotes anyway
    --core.DKPTable = ErrorDKPDKPList    -- the dkp table
    --core.DKPDataInfo = ErrorDKPDataInfo  -- contains info about the data like last sync, last full import
    core.DKPDataInfo.LootInfo = ErrorDKPDataInfo.LootInfo
    core.DKPDataInfo.PriceListInfo = ErrorDKPDataInfo.PriceListInfo
    core.ItemPriceList = ErrorDKPPriceList
    core.Settings = ErrorDKPConfig
    core.LootLog = ErrorDKPLootLog
    core.LootQueue = ErrorDKPLootQueue

    -- Hook ItemPriceToolTipScript
    ErrorDKP:RegisterItemPriceTooltip()
    
    -- Create MiniMapIcon
    ErrorDKP:CreateMiniMapIcon()
    ErrorDKP.GNoteDKP:InitRosterUpdate()
    core.Initialized = true
end


-------------------------------------------------------------------
--
--    Events
--
-------------------------------------------------------------------

-- Event Handler
function ErrorDKP_OnEventHandler(self, event, ...)
    local arg1, arg2, arg3, arg4 = ...
    if event == "ADDON_LOADED" and arg1 == addonName then
        core:PrintDebug(event)
        OnInit()
        self:UnregisterEvent("ADDON_LOADED")
        -- Ask if items in queue
        core.IsMLooter = core:CheckMasterLooter()
        ErrorDKP:AskItemCost()
        if core.TestMode then core:Print("Testmode is enabled!") end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        if IsInGuild() then
            if core.Type == "R" then
                core.Sync:Send("ErrDKPBuildCheck", tostring(core.Build))
            end
            -- BuildCheckV2
            core.Sync:Send("BuildCheck", { version = core.Build, type = core.Type })
        end
    --elseif event == "CHAT_MSG_LOOT" then
        --Add loot
    --    ErrorDKP:AutoAddLoot(...)
    elseif event == "ENCOUNTER_END" then
        --currently no use for that, just for reference
        local encounterID, name, difficulty, size, success = ...
        core:PrintDebug("ENCOUNTER_END,encounterID="..encounterID..", name="..name..", difficulty="..difficulty..", size="..size..", success="..success)
    elseif (event == "BOSS_KILL") then
        local encounterID, name = ...
        core:PrintDebug("BOSS_KILL", "encounterID="..encounterID..", name="..name)
    elseif (event == "PARTY_LOOT_METHOD_CHANGED") then
        -- check if mastlooter an enable modules
        core:PrintDebug("PARTY_LOOT_METHOD_CHANGED", ...)
        core.IsMLooter = core:CheckMasterLooter()
    elseif (event == "RAID_ROSTER_UPDATE") then
        -- track attendance
        -- members goes offline triggers this?
        core:PrintDebug("RAID_ROSTER_UPDATE", ...)
        core.IsMLooter = core:CheckMasterLooter()
        if not self:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
            core:PrintDebug("COMBAT_LOG_EVENT_UNFILTERED is not registered => do it")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    --elseif (event == "OPEN_MASTER_LOOT_LIST") then 
    --    core:PrintDebug(event, ...)
    elseif (event == "RAID_INSTANCE_WELCOME") then
        if not self:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
            core:PrintDebug("COMBAT_LOG_EVENT_UNFILTERED is not registered => do it")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    elseif (event == "LOOT_SLOT_CLEARED")  then
        ErrorDKP:AddPendingMasterLoot(arg1)
    elseif (event == "LOOT_CLOSED") then 
        ErrorDKP:ClearPedingMasterLoot()
        ErrorDKP:OnLootClosed()
    --elseif (event == "LOOT_READY") then
        --core:PrintDebug(event, ...)
        --ErrorDKP:BuidLootSlotInfo()
    elseif (event == "LOOT_OPENED") then
        core:PrintDebug(event, ...)
        ErrorDKP:OnLootOpened()
    elseif (event == "ENCOUNTER_LOOT_RECEIVED") then
        core:PrintDebug(event, ...)
    elseif (event == "GUILD_ROSTER_UPDATE") then
        ErrorDKP.GNoteDKP:ResetUpdateCycle()
        --core:PrintDebug(event, ...)
        if not core.Initialized then
            core:PrintDebug("Addon not initalized, cannot update dkp from guildroster")
            return
        end
        if ErrorDKP.GNoteDKP:IsGuildDataAvailable() then         
            if ErrorDKP.GNoteDKP:IsUpdateRequired() then
                core:PrintDebug("Local dkp-table update required")
                ErrorDKP.GNoteDKP:RefreshLocalDKPTable()
                ErrorDKP:DKPTableUpdate()
            end
        else
            core:PrintDebug("Guild Data Cache not filled yet, wait....")
        end
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        if 
        not UnitInRaid("player") and 
        not core.TestMode then
            core:PrintDebug("Not in a raid, unregister: COMBAT_LOG_EVENT_UNFILTERED")
            self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            return
        end
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName = CombatLogGetCurrentEventInfo()
        if subevent == "UNIT_DIED" then
            core:PrintDebug(subevent, destName, destGUID)
            C_Timer.After(1, function()
                core:HandleUnitDiedLogEvent(destName, destGUID)
            end) -- wait a bit till loot is ready
        end
    elseif event == "TRADE_CLOSED" or
           event == "TRADE_TARGET_ITEM_CHANGED" or
           event == "TRADE_ACCEPT_UPDATE" or
           event == "TRADE_SHOW"
    then
        ErrorDKP.Trading:HandleEvent(event, ...)
    elseif event == "UI_INFO_MESSAGE" then
        local messageType, message = ...
        local errorName, soundKitID, voiceID = GetGameMessageInfo(messageType)

        if errorName == "ERR_TRADE_CANCELLED" or errorName == "ERR_TRADE_COMPLETE" then
            ErrorDKP.Trading:HandleEvent(errorName, ...)
        end
    end
end

-- Register Events
local event = CreateFrame("Frame", "EventFrame")
ErrorDKP.EventFrame = event
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:RegisterEvent("CHAT_MSG_LOOT")
event:RegisterEvent("RAID_ROSTER_UPDATE")
event:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
event:RegisterEvent("RAID_INSTANCE_WELCOME")
event:RegisterEvent("LOOT_SLOT_CLEARED")
event:RegisterEvent("LOOT_CLOSED")
event:RegisterEvent("LOOT_OPENED")

event:RegisterEvent("GUILD_ROSTER_UPDATE")

event:RegisterEvent("TRADE_SHOW")
event:RegisterEvent("TRADE_CLOSED")
event:RegisterEvent("TRADE_TARGET_ITEM_CHANGED")
event:RegisterEvent("TRADE_ACCEPT_UPDATE")
event:RegisterEvent("UI_INFO_MESSAGE")

event:SetScript("OnEvent", ErrorDKP_OnEventHandler)


--event:RegisterEvent("LOOT_READY")
--event:RegisterEvent("ENCOUNTER_LOOT_RECEIVED") -- encounterID, itemID, "itemLink", quantity, "itemName", "fileName"
--event:RegisterEvent("OPEN_MASTER_LOOT_LIST")

--LOOT_CLOSED --Firest before lat chat loot event
--LOOT_OPENED
--LOOT_SLOT_CLEARED Fired when loot is removed from a corpse