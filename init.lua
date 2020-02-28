--###############################################
--#  Project: ErrorDKP
--#  File: init.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Setup events, register slash commands
--#  Last Edit: 21.11.2019
--###############################################

local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L


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
                ErrorDKP.LootSurvey:Start({}, 120)
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
    core:PrintDebug("Initialize", core.Imports.ItemPriceListInfo["version"])
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
    if not ErrorDKPDataInfo.DKPInfo then 
        ErrorDKPDataInfo.DKPInfo = {} 
        core:PrintDebug("No ErrorDKPDataInfo.DKPInfo, create it")
    end
    ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo = GetNewestData(ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo, DKPInfo) --DKP is global from the jdkp export
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

    --Apply to core
    core.DKPTable = ErrorDKPDKPList                     -- the dkp table
    core.DKPDataInfo = ErrorDKPDataInfo              -- contains info about the data like last sync, last full import
    core.ItemPriceList = ErrorDKPPriceList
    core.Settings = ErrorDKPConfig
    core.LootLog = ErrorDKPLootLog
    core.LootQueue = ErrorDKPLootQueue;

    -- Hook ItemPriceToolTipScript
    ErrorDKP:RegisterItemPriceTooltip()
    
    -- Create MiniMapIcon
    ErrorDKP:CreateMiniMapIcon()

    --DBG
    ErrorDKP.GNoteDKP:GetAll()
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
            core.Sync:Send("ErrDKPBuildCheck", tostring(core.Build))
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
    elseif (event == "LOOT_READY") then
        core:PrintDebug(event, ...)
        ErrorDKP:BuidLootSlotInfo()
    elseif (event == "ENCOUNTER_LOOT_RECEIVED") then
        core:PrintDebug(event, ...)
    --elseif (event == "GUILD_ROSTER_UPDATE") then
      --  core:PrintDebug(event, ...)
    elseif (event == "LOOT_OPENED") then
        core:PrintDebug(event, ...)
        ErrorDKP:OnLootOpened()
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
event:RegisterEvent("LOOT_READY")
event:RegisterEvent("LOOT_OPENED")
--event:RegisterEvent("ENCOUNTER_LOOT_RECEIVED") -- encounterID, itemID, "itemLink", quantity, "itemName", "fileName"
event:RegisterEvent("GUILD_ROSTER_UPDATE")
--event:RegisterEvent("OPEN_MASTER_LOOT_LIST")
event:SetScript("OnEvent", ErrorDKP_OnEventHandler)


--LOOT_CLOSED --Firest before lat chat loot event
--LOOT_OPENED
--LOOT_SLOT_CLEARED Fired when loot is removed from a corpse