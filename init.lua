--###############################################
--#  Project: ErrorDKP
--#  File: init.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Setup events, register slash commands
--#  Last Edit: 21.11.2019
--###############################################

local addonName, core = ...
local ErrorDKP = core.ErrorDKP


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
    ["broadcast"] = function()
        ErrorDKP:BroadcastDKPTable()
    end,
    ["bl"] = function()
        ErrorDKP:BroadcastLootTable()
    end,
    ["help"] = function()
        print(" ");
        core:Print("|cff00cc66/dkp|r")
		-- MonDKP:Print(L["SLASHCOMMANDLIST"]..":")
		-- MonDKP:Print("|cff00cc66/dkp|r - "..L["DKPLAUNCH"]);
		-- MonDKP:Print("|cff00cc66/dkp ?|r - "..L["HELPINFO"]);
		-- MonDKP:Print("|cff00cc66/dkp reset|r - "..L["DKPRESETPOS"]);
		-- MonDKP:Print("|cff00cc66/dkp lockouts|r - "..L["DKPLOCKOUT"]);
		-- MonDKP:Print("|cff00cc66/dkp timer|r - "..L["CREATERAIDTIMER"]);
		-- MonDKP:Print("|cff00cc66/dkp bid|r - "..L["OPENBIDWINDOWHELP"]);
		-- MonDKP:Print("|cff00cc66/dkp award "..L["PLAYERCOST"].."|r - "..L["DKPAWARDHELP"]);
		-- MonDKP:Print("|cff00cc66/dkp modes|r - "..L["DKPMODESHELP"]);
		-- MonDKP:Print("|cff00cc66/dkp export|r - "..L["DKPEXPORTHELP"]);
		-- print(" ");
		-- MonDKP:Print(L["WHISPERCMDSHELP"]);
		-- MonDKP:Print("|cff00cc66!bid (or !bid <"..L["VALUE"]..">)|r - "..L["BIDHELP"]);
		-- MonDKP:Print("|cff00cc66!dkp (or !dkp <"..L["PLAYERNAME"]..">)|r - "..L["DKPCMDHELP"]);
	end
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
        imported[index] = { name = k, dkp = v["DKP"], classFilename = classFilename, classId = classId  }
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

    -- Check which data is the newest
    if not ErrorDKPDataInfo.DKPInfo then 
        ErrorDKPDataInfo.DKPInfo = {} 
        core:PrintDebug("No ErrorDKPDataInfo.DKPInfo, create it")
    end
    ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo = GetNewestData(ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo, DKPInfo) --DKP is global from the jdkp export
    -- Same for itemprices
    if not ErrorDKPDataInfo.PriceListInfo then ErrorDKPDataInfo.PriceListInfo = {} end
    if #ErrorDKPPriceList == 0 or (ErrorDKPDataInfo.PriceListInfo["timestamp"] < core.Imports.ItemPriceListInfo) then
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

    --ErrorDKP:GetLootSurveyDialog()
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
        ErrorDKP:AskItemCost()
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if IsInGuild() then
            core.Sync:Send("ErrDKPBuildCheck", tostring(core.Build))
        end
    elseif event == "CHAT_MSG_LOOT" then
        --Add loot
        ErrorDKP:AutoAddLoot(...)
    elseif event == "ENCOUNTER_END" then
        --currently no use for that, just for reference
        local encounterID, name, difficulty, size, success = ...
        core:PrintDebug("ENCOUNTER_END,encounterID="..encounterID..", name="..name..", difficulty="..difficulty..", size="..size..", success="..success)
    elseif (event == "BOSS_KILL") then
        local encounterID, name = ...
        core:PrintDebug("BOSS_KILL", "encounterID="..encounterID..", name="..name)
        --if (not MRT_Options["General_MasterEnable"]) then return end;
        --mrt:BossKillHandler(encounterID, name);  
    elseif (event == "PARTY_LOOT_METHOD_CHANGED") then
        -- check if mastlooter an enable modules
        core:PrintDebug("RAID_ROSTER_UPDATE", ...)
        core.IsMLooter = core:CheckMasterLooter()
    elseif (event == "RAID_ROSTER_UPDATE") then
        -- track attendance
        -- members goes offline triggers this?
        core:PrintDebug("RAID_ROSTER_UPDATE", ...)
    end
end

-- Register Events
local event = CreateFrame("Frame", "EventFrame")
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
-- event:RegisterEvent("BOSS_KILL")
event:RegisterEvent("CHAT_MSG_LOOT")
-- event:RegisterEvent("CHAT_MSG_WHISPER")
-- event:RegisterEvent("ENCOUNTER_END")
-- event:RegisterEvent("RAID_INSTANCE_WELCOME")
event:RegisterEvent("RAID_ROSTER_UPDATE")
event:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
-- event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
-- event:RegisterEvent("ENCOUNTER_END")
event:SetScript("OnEvent", ErrorDKP_OnEventHandler)
--LOOT_CLOSED --Firest before lat chat loot event
--LOOT_OPENED
--LOOT_SLOT_CLEARED Fired when loot is removed from a corpse