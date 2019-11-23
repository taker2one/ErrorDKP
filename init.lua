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

local function dummyDKPData(d)
    for i=1, 5 do
     d[i]={}
     d[i].name = "Tester"..i
     d[i].dkp = 50+i
    end
    return d
end

local function importDKPData()
    local imported = {}
    local index = 1
    for k,v in pairs(gdkp["players"]) do
        imported[index] = { name = k, dkp = v["DKP"] }
        index = index + 1
    end

    return imported
end

local function OnInit()
    core:PrintDebug("Initialize")
    RegisterSlashCommands()

    core:Print(addonName, core.Version)
    --Load Saved Data
    if not ErrorDKPDB then ErrorDKPDB = {} end
    if not ErrorDKPConfig then ErrorDKPConfig = {} end
    --if not ErrorDKPDKPList then ErrorDKPDKPList = dummyDKPData({}) end
    ErrorDKPDKPList = importDKPData()
    --if not ErrorDKPPriceList then ErrorDKPPriceList = core.Imports.ItemPriceList end 
    ErrorDKPPriceList = core.Imports.ItemPriceList

    --Apply to core
    core.DKPTableWorkingEntries = ErrorDKPDKPList
    core.ItemPriceList = ErrorDKPPriceList
    core.Settings = ErrorDKPConfig

    -- Hook ItemPriceToolTipScript
    ErrorDKP:RegisterItemPriceTooltip()
    -- Create MiniMapIcon
    ErrorDKP:CreateMiniMapIcon()
    ErrorDKP:CreateLootNeedSurveyFrame()
    core:VersionCheck(11320, "Herbert")
    --test sync
    --core.Sync:Send("ErrDKPPriceList", core.ItemPriceList)
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
    end
end

-- Register Events
local event = CreateFrame("Frame", "EventFrame")
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("PLAYER_ENTERING_WORLD")
event:SetScript("OnEvent", ErrorDKP_OnEventHandler)

