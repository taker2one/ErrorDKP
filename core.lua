--###############################################
--#  Project: ErrorDKP
--#  File: core.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 21.11.2019
--###############################################

local addonName, core = ...;

core.ErrorDKP = {}
local ErrorDKP = core.ErrorDKP
local _C = core.CONSTANTS


-- Version
core.Version = GetAddOnMetadata("ErrorDKP", "Version")
core.Build = 1130200
core.Type = "R" -- R = Release, B = Beta

SetCVar("ScriptErrors", 1)

-- Defaults
core.PrintPrefix = "<ErrorDKP>"

-- Variables
core.Imports = {}
core.DKPTable = {}
core.DKPDataInfo = {}
core.ItemPriceList = {} -- From saved data
core.WorkItemPriceList = {} 
core.ItemInfosLoaded = {}
core.LootLog = {}
core.LootQueue = {}

core.LastUpdateAvailableMsg = 0
core.AskCostQueueRunning = false
--
core.IsTrusted = ""
core.IsMLooter = nil
core.TrustedPlayers = {
  "Doktorwho",
  "Rassputin",
  "Repa",
  "Dichterin"
}

core.ClassColors = {
	["DRUID"] = { r = 1, g = 0.49, b = 0.04, hex = "FF7D0A" },
	["HUNTER"] = {  r = 0.67, g = 0.83, b = 0.45, hex = "ABD473" },
	["MAGE"] = { r = 0.25, g = 0.78, b = 0.92, hex = "40C7EB" },
	["PRIEST"] = { r = 1, g = 1, b = 1, hex = "FFFFFF" },
	["ROGUE"] = { r = 1, g = 0.96, b = 0.41, hex = "FFF569" },
	["SHAMAN"] = { r = 0.96, g = 0.55, b = 0.73, hex = "F58CBA" },
	["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, hex = "F58CBA" },
	["WARLOCK"] = { r = 0.53, g = 0.53, b = 0.93, hex = "8787ED" },
	["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, hex = "C79C6E" }
}

-- Internal Settings
core.ISettings = {
    DKPTable = {
        Width = 500,
        RowHeight = 18,
        RowCount = 27
    },
    ItemTracking_MinItemQualityToLog = _C.ITEMRARITY.COMMON,
    ItemTracking_IgnoreEnchantingMats = true
}

core.Settings = {
  
}

core.UI = {}

-- Debug
core.Debug = true
function core:PrintDebug(...)
    if core.Debug then
        print("|cff90EE90<ErrorDKP-Dbg>|r", ...)
    end
end

-- Print
function core:Print(...)
    print("|cff75DAFF"..core.PrintPrefix.."|r", ...)
end


function core:GetGuildRankIndex(player)
  local name, rank;
  local guildSize,_,_ = GetNumGuildMembers();

  if IsInGuild() then
    for i=1, tonumber(guildSize) do
      name,_,rank = GetGuildRosterInfo(i)
      name = strsub(name, 1, string.find(name, "-")-1)
      if name == player then
        return rank+1;
      end
    end
    return false;
  end
end

function core:CheckSelfTrusted()
    if core.IsTrusted == "" then
        core:PrintDebug("Check if player is on trusted list")
        core.IsTrusted = core:CheckTrusted(UnitName("player"))
    end
    return core.IsTrusted
end

function core:CheckTrusted(player)
    for i=1, #core.TrustedPlayers do
        if core.TrustedPlayers[i] == player then
            return true
        end
    end
    return nil
end

function core:CheckMasterLooter()
    if IsInRaid() then
      local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
      if lootmethod == "master" and masterlooterPartyID == 0 then
          return true
      end
    end
    return nil
end

function core:ToEQDKPTime(timestamp)
    return date("%m/%d/%y %H:%M:%S", timestamp)
end

function core:GenerateTimestamp()
	local timestamp = GetServerTime() -- using utc times instead of time()
	return timestamp
end

function core:GetDKPDataTimestamp()
  return core.DKPDataInfo["DKPInfo"]["timestamp"]
end

-- this is used after received dkp update message
function core:SetDKPDataTimestamp(timestamp)
  core.DKPDataInfo["DKPInfo"]["timestamp"] = timestamp
end

function core:GetLootDataTimestamp()
  return core.DKPDataInfo["LootInfo"]["timestamp"]
end

function core:SetLootDataTimestamp(timestamp)
  core.DKPDataInfo["LootInfo"]["timestamp"] = timestamp
end

-- function core:UpdateTimestamps()		-- updates seeds on leaders note as well as all 3 tables
-- 	local leader = MonDKP:GetGuildRankGroup(1)
-- 	local seed = MonDKP:RosterSeedUpdate(leader[1].index)
	
-- 	MonDKP_DKPTable.seed = seed
-- 	MonDKP_DKPHistory.seed = seed
-- 	MonDKP_Loot.seed = seed
-- end