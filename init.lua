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

-- Slash Command Handler
local function HandleSlashCommands(cmd)
    core:PrintDebug("HandleSlashCommand: ", cmd)

    if( #cmd == 0 ) then
        --open list
        core.ErrorDKP:Toggle()
    elseif( cmd == "config" ) then
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
        imported[index] = { name = k, dkp = v["DKP"] }
        index = index + 1
    end

    return imported
end

local function GetNewestData(dkpdb, dkpinfo, importinfo)
    if #dkpdb == 0 or not dkpinfo["timestamp"] or( importinfo["timestamp"] and tonumber(importinfo["timestamp"]) > tonumber(dkpinfo["timestamp"]) ) then
        dkpdb = mapImportDKPData()
        dkpinfo["timestamp"] = importinfo["timestamp"]

        return dkpdb, dkpinfo
    end

    return dkpdb                                                                                                                                                                                                                 
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

    -- Check which data is the newest
    if not ErrorDKPDataInfo.DKPInfo then ErrorDKPDataInfo.DKPInfo = {} end
    ErrorDKPDKPList, ErrorDKPDataInfo.DkpInfo = GetNewestData(ErrorDKPDKPList, ErrorDKPDataInfo.DKPInfo, DKPInfo) --DKP is global from the jdkp export

    -- Same for itemprices
    if not ErrorDKPDataInfo.PriceListInfo then ErrorDKPDataInfo.PriceListInfo = {} end
    if #ErrorDKPPriceList == 0 or (ErrorDKPDataInfo.PriceListInfo["timestamp"] < core.Imports.ItemPriceListInfo) then
        ErrorDKPPriceList = core.Imports.ItemPriceList
        ErrorDKPDataInfo.PriceListInfo["timestamp"] = core.Imports.ItemPriceListInfo["timestamp"]
        ErrorDKPDataInfo.PriceListInfo["version"] = core.Imports.ItemPriceListInfo["version"]
    end

    --Apply to core
    core.DKPTable = ErrorDKPDKPList                     -- the dkp table
    core.DKPDataInfo = ErrorDKPDKPDataInfo              -- contains info about the data like last sync, last full import
    core.DKPTableWorkingEntries = ErrorDKPDKPList
    core.ItemPriceList = ErrorDKPPriceList
    core.Settings = ErrorDKPConfig
    core.LootLog = ErrorDKPLootLog

    -- Hook ItemPriceToolTipScript
    ErrorDKP:RegisterItemPriceTooltip()
    
    -- Create MiniMapIcon
    ErrorDKP:CreateMiniMapIcon()
    ErrorDKP:CreateLootConfirmDialog()
    --ErrorDKP:CreateLootNeedSurveyFrame()
    --ErrorDKP:CreateDKPAdjustmentDialog()
    core:VersionCheck(11320, "Herbert")
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
event:RegisterEvent("BOSS_KILL")
event:RegisterEvent("CHAT_MSG_LOOT")
event:RegisterEvent("CHAT_MSG_WHISPER")
event:RegisterEvent("ENCOUNTER_END")
event:RegisterEvent("RAID_INSTANCE_WELCOME")
event:RegisterEvent("RAID_ROSTER_UPDATE")
event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
event:RegisterEvent("ENCOUNTER_END")
event:SetScript("OnEvent", ErrorDKP_OnEventHandler)