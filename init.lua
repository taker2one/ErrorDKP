--###############################################
--#  Project: ErrorDKP
--#  File: init.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Setup events, register slash commands
--#  Last Edit: 21.11.2019
--###############################################

local addonName, core = ...


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
        core:PrintDebug("Open List")
        core.ErrorDKP:Toggle()
    elseif( cmd == "config" ) then
        core:PrintDebug("Open config")
    end
end

local function LoadDebugToolsFrameStack()
    LoadAddOn('Blizzard_DebugTools')
    FrameStackTooltip_Toggle()
end

--Register slash commands
local function RegisterSlashCommands()
    core:PrintDebug("Register slash commands")

    -- SLASH_FRAMESTK1 = "/fs" -- For quicker access to frame stack
    -- SlashCmdList.FRAMESTK = LoadDebugToolsFrameStack

    -- SLASH_RELOADUI1 = "/rl" -- For quicker access to frame stack
    -- SlashCmdList.RELOADUI = ReloadUI

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

local function OnInit()
    core:PrintDebug("Initialize")
    RegisterSlashCommands()

    core:Print(addonName, core.Version)
    --Load Saved Data
    if not ErrorDKPDB then ErrorDKPDB = {} end
    if not ErrorDKPDKPList then ErrorDKPDKPList = dummyDKPData({}) end

    --Apply to core
    core.DKPTableWorkingEntries = ErrorDKPDKPList
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

