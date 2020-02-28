--###############################################
--#  Project: ErrorDKP
--#  File: core.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 27.02.2020
--###############################################

local addonName, core = ...;

core.ErrorDKP = {}
local ErrorDKP = core.ErrorDKP
local _C = core.CONSTANTS
local _L = core._L

local deformat = LibStub("LibDeformat-3.0")

-- Version
core.Version = GetAddOnMetadata("ErrorDKP", "Version")
core.Build = 1130312
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

core.CreatureIdsSkinning = { -- Ids of creatures that can be skinned in raid
    11673,
    11671
}
core.CanLootMessages = { -- save the messages from other members that they can loot something

}

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
  "Karaffe",
  "Lightrider"
}

core.ClassColors = {
	["DRUID"] = { r = 1, g = 0.49, b = 0.04, hex = "FF7D0A" },
	["HUNTER"] = {  r = 0.67, g = 0.83, b = 0.45, hex = "ABD473" },
	["MAGE"] = { r = 0.25, g = 0.78, b = 0.92, hex = "40C7EB" },
	["PRIEST"] = { r = 1, g = 1, b = 1, hex = "FFFFFF" },
	["ROGUE"] = { r = 1, g = 0.96, b = 0.41, hex = "FFF569" },
	["SHAMAN"] = { r = 0.00, g = 0.44, b = 0.87, hex = "0070DE" },
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

-- Will be overriden in init from db
core.Settings = {
}

-- Used to initial fill db settings table
core.DefaultSettings = {
    ShowOnlyItemsToday = false,
    ShowOnlyRaidmembers = false
}

core.UI = {}

-- Debug
core.TestMode = false -- TestMode for some features -- DBG
core.Debug = true -- Enable debug output -- DBG
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


function core:Error(...)
    print("|cffFF0000"..core.PrintPrefix.."|r", ...)
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
    return date("%d/%m/%Y %H:%M:%S", t)
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

function core:CheckOfficer() 
	if core.IsOfficer == nil then
		if IsInGuild() then
			local curPlayerRank = core:GetGuildRankIndex(UnitName("player"))
			if curPlayerRank then
				core.IsOfficer = C_GuildInfo.GuildControlGetRankFlags(curPlayerRank)[12]
			end
		else
			core.IsOfficer = false;
		end
    end
    
    return core.IsOfficer
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

function core:HandleUnitDiedLogEvent(creatureName, creatureGUID)
  --CreatureIdsSkinning
    core:PrintDebug("Can loot unit", CanLootUnit(creatureGUID))
    local hasLoot, canLoot = CanLootUnit(creatureGUID)
    if hasLoot then
        local _, _, _, _, _, npcId = strsplit("-", creatureGUID)
        npcId = tonumber(npcId)
        if npcId then
            for i,v in ipairs(core.CreatureIdsSkinning) do
                core:PrintDebug(v, npcId)
                if v == npcId then -- is in skinnable list, inform raid
                    core:PrintDebug("NPC is lootable and in list, inform raid")
                    core.Sync:SendRaid("CanLootSkinNpc", { ["guid"] = creatureGUID, ["id"] = npcId, ["name"] = creatureName })
                    return
                elseif core.TestMode then
                    core:PrintDebug("Send CanLootSkinNpc to Karaffe cause addon is in TestMode!")
                    core.Sync:SendTo("CanLootSkinNpc", { ["guid"] = creatureGUID, ["id"] = npcId, ["name"] = creatureName }, GetUnitName("player"))
                    return
                end
            end
        end
    end
end

function core:ValidateCanLoot(messageCnt, creatureName, sender)
    if messageCnt == 1 then -- Only 1 person can loot, write to chat
        if GetUnitName("player") == sender then
            core:Print(string.format(_L["MSG_LOOT_SKIN_REQUIRED_YOU"], creatureName))
        else
            core:Print(string.format(_L["MSG_LOOT_SKIN_REQUIRED"], sender, creatureName))
        end
    elseif messageCnt > 1 then -- More then 1 person can loot, ignore
        
    end
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

function core:ltrim(s)
    if not s then return end
    return (s:gsub("^%s*(.-)%s*$", "%1"))
 end

function core:CreateDefaultFrame(
        name, 
        title, 
        width, height, 
        addCloseButton, 
        savePosition -- Save Position after Drag requires Name!!
    )
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

    if savePosition then
        f:SetScript("OnDragStop", function(self, mouseButton)
            self:StopMovingOrSizing()

            local point, _, relativePoint, x, y = self:GetPoint()
            core:PrintDebug("StopMoving", f:GetName(), point, relativePoint, x, y)

            core.Settings[name.."PosX"] = x
            core.Settings[name.."PosY"] = y
            core.Settings[name.."PosPoint"] = point
            core.Settings[name.."PosRelativePoint"] = relativePoint
        end)
        f:SetPoint("CENTER", UIParent, "CENTER")
        if core.Settings[name.."PosX"] and core.Settings[name.."PosY"] and core.Settings[name.."PosPoint"] and core.Settings[name.."PosRelativePoint"] then
            f:ClearAllPoints()
            f:SetPoint(core.Settings[name.."PosPoint"], f:GetParent(), core.Settings[name.."PosRelativePoint"], core.Settings[name.."PosX"], core.Settings[name.."PosY"])
        end
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
      core:PrintDebug('core:ItemInfo: No itemLink')
      return nil; 
  end
  local _, itemString, _ = deformat(itemLink, "|c%s|H%s|h%s|h|r")
  local itemId, _ = deformat(itemString, "item:%d:%s")
  local itemColor = nil
  core:PrintDebug("Demposed id: ", itemId, itemLink)
  return itemName, itemLink, itemId, itemString, itemRarity, itemColor, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
end

-- shift-click-parsing of item links
local function Hook_ChatEdit_InsertLink(link)
    core:PrintDebug("core:Hook_ChatEdit_InsertLink", link)
    ErrorDKP.LootTracker:OnChatEdit_InsertLink(link)
end
hooksecurefunc("ChatEdit_InsertLink", Hook_ChatEdit_InsertLink);

