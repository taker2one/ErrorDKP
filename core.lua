--###############################################
--#  Project: ErrorDKP
--#  File: core.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 11.12.2019
--###############################################

local addonName, core = ...;

core.ErrorDKP = {}
local ErrorDKP = core.ErrorDKP
local _C = core.CONSTANTS


-- Version
core.Version = GetAddOnMetadata("ErrorDKP", "Version")
core.Build = 1130301
core.Type = "R" -- R = Release, B = Beta, A = Alpha

--SetCVar("ScriptErrors", 1)

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
core.PendingMLI = nil -- Master Loot detected but waiting for LOOT_SLOT_CLEARED

core.LastUpdateAvailableMsg = 0
core.AskCostQueueRunning = false
--
core.IsTrusted = ""
core.IsMLooter = nil

-- LootNeedSurveyStuff
core.LootSlotInfos = {}
core.LootTable = {} -- Shown in Survey Setup
core.SurveyInProgress = nil
core.ActiveSurveyData = {}

core.TrustedPlayers = {
  "Doktorwho",
  "Rassputin",
  "Repa",
  "Dichterin",
  "Karaffe"
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
    MasterLootMinQuality = _C.ITEMRARITY.EPIC, 
    ItemTracking_MinItemQualityToLog = _C.ITEMRARITY.EPIC,
    ItemTracking_IgnoreEnchantingMats = true
}

core.Settings = {
  
}

core.UI = {}

-- Debug
core.Debug = true --DBG
function core:PrintDebug(...)
    if core.Debug then
        print("|cff90EE90<ErrorDKP-Dbg>|r", ...)
    end
end

function core:ErrorDebug(...)
  if core.Debug then
      print("|cffff0000<ErrorDKP-Dbg>|r", ...)
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

function core:ToDateString(t)
    return date("%m/%d/%Y %H:%M:%S", t)
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
    --if IsInRaid() then
      local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
      if lootmethod == "master" and masterlooterPartyID == 0 then
          return true
      end
    --end
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

function core:IsTableEmpty(t)
    if not t then return true end
    for k,v in pairs(t) do
      if k or v then return nil end
      return true
    end
    return true
end

function core:tcount(t)
    if not t then return 0 end;
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function core:tcopy(t)
    local to = {}
    self:tcopyto(to, t)
    return to
end

function core:tcopyto(to, from)
    for k,v in pairs(from) do
      if(type(v)=="table") then
        to[k] = {}
        self:tcopyto(to[k], v);
      else
        to[k] = v;
      end
    end
end

function core:SplitString(inputstr, sep, doUnpack)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    if doUnpack then return unpack(t) end
    return t
end

function core:CreateDefaultFrame(name, title, width, height, addCloseButton)
    local f = CreateFrame("Frame", name, UIParent)
    f:SetSize(width,height)
    f:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      edgeSize = 32,
      tileSize = 32,
      insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    f:RegisterForDrag("LeftButton")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    if title then
      f.Header = f:CreateTexture(nil, "ARTWORK")
      f.Header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
      f.Header:SetSize(300,64)
      f.Header:SetPoint("TOP", f, "TOP", 0, 12)

      f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      f.Title:SetPoint("TOP", f, "TOP", 0, -2)
      f.Title:SetText(title)

      f.Header:SetWidth(string.len(title)*20 + 50)
    end

    if addCloseButton then
        f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        f.CloseButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
    end

    return f
end

function core:CreateButton(parent, name, text)
    local b = CreateFrame("Button", parent:GetName()..name, parent, "UIPanelButtonTemplate")
    b:SetText(text or "")
    b:SetSize(100,25)
    return b
end

-- Just append a random number to current timestamp and use it as unique reference
function core:GenUniqueId()
    -- Its not real unique cause in theory random could give us 2 times same number but its more than enough for our need
    local t = time()
    local rndNumber = math.random(1000)
    return tostring(t)..tostring(rndNumber)
end

function core:ItemInfo(linkorid)
  core:PrintDebug("core:ItemInfo", linkorid)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(linkorid);
  if (not itemLink) then 
      core:Debug('core:ItemInfo: No itemLink')
      return nil; 
  end
  local _, itemString, _ = deformat(itemLink, "|c%s|H%s|h%s|h|r")
  local itemId, _ = deformat(itemString, "item:%d:%s")
  local itemColor = nil
  core:PrintDebug("Demposed: ", itemRarity)
  return itemName, itemLink, itemId, itemString, itemRarity, itemColor, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
end

-- shift-click-parsing of item links
function core:Hook_ChatEdit_InsertLink(link)
    ErrorDKP.LootTracker:OnChatEdit_InsertLink(link)
end
hooksecurefunc("ChatEdit_InsertLink", core.Hook_ChatEdit_InsertLink);
