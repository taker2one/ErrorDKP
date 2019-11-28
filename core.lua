--###############################################
--#  Project: ErrorDKP
--#  File: core.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 21.11.2019
--###############################################

local addonName, core = ...;

core.ErrorDKP = {}
local ErrorDKP = core.ErrorDKP


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
core.DKPTableWorkingEntries = {} -- contains current dkp list (filtered,sorted,...)
core.ItemPriceList = {} -- From saved data
core.WorkItemPriceList = {} 
core.ItemInfosLoaded = {}
core.LootLog = {}
core.LootQueue = {}

core.AskCostQueueRunning = false
--
core.IsOfficer = ""

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
    ItemTracking_MinItemQualityToLog = 0,
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

-- Version Check
function core:VersionCheck(sentvers, sender)
    local vers = GetAddOnMetadata("ErrorDKP", "Version")
    local one, two, three , four = string.match(vers, "(%d).*(%d).*(%d).*(%d)")
    core:PrintDebug("VERSION", "VersionCheck called")
    if one and two and three and four then
      vers = tonumber(one..two..three..four)
      core:PrintDebug("VERSION", "VersionCheck version is", vers, ", sent vers was ", sentvers)
      if vers<sentvers then
        core:Print("A newer version of ErrorDKP is available.  Visit wow-error.at to download.")
      elseif vers>sentvers then
        --SendAddonMessage("flamingloot", "print:"..GetUnitName("player").." has a newer version of flaming loot than you.  Visit curse.com/addons/wow/flaming to update.", "WHISPER", sender)
      end
    end
  end

  function core:IsOfficer()      
    if core.IsOfficer == "" then    
      if MonDKP:GetGuildRankIndex(UnitName("player")) == 1 then       -- automatically gives permissions above all settings if player is guild leader
        core.IsOfficer = true
        MonDKP.ConfigTab3.WhitelistContainer:Show()
        return;
      end
      if IsInGuild() then
        if #MonDKP_Whitelist > 0 then
          core.IsOfficer = false;
          for i=1, #MonDKP_Whitelist do
            if MonDKP_Whitelist[i] == UnitName("player") then
              core.IsOfficer = true;
            end
          end
        else
          local curPlayerRank = MonDKP:GetGuildRankIndex(UnitName("player"))
          if curPlayerRank then
            core.IsOfficer = C_GuildInfo.GuildControlGetRankFlags(curPlayerRank)[12]
          end
        end
      else
        core.IsOfficer = false;
      end
    end

    return core.IsOfficer
  end

function core:ToEQDKPTime(timestamp)
    return date("%m/%d/%y %H:%M:%S", timestamp)
end


-- -----------------UI-------------------
-- local UIConfig = CreateFrame("Frame", "ERRORDKPListFrame", UIParent, "UIPanelDialogTemplate")
-- UIConfig:SetSize(300, 150)
-- UIConfig:SetPoint("CENTER", UIParent, "CENTER")

-- -- Child frames
-- --UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
-- UIConfig.Title:ClearAllPoints()
-- UIConfig.Title:SetFontObject("GameFontHighlight")
-- UIConfig.Title:SetPoint("LEFT", ERRORDKPListFrameTitleBG, "LEFT", 5 , 0)
-- UIConfig.Title:SetText("Error DKP")

-- -- ScrollFrame
-- UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate")
-- UIConfig.ScrollFrame:SetPoint("TOPLEFT", ERRORDKPListFrameDialogBG, "TOPLEFT", 4, -8)
-- UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", ERRORDKPListFrameDialogBG, "BOTTOMRIGHT", -3, 4)
-- UIConfig.ScrollFrame:SetClipsChildren(true)

-- -- Scroll child
-- local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame)
-- child:SetSize(308,500)
-- --UIConfig.ScrollFrame.Scroll
-- UIConfig.ScrollFrame:SetScrollChild(child)

-- UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
-- UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12,-18)
-- UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7,18)

-- -- Reload Button
-- UIConfig.reloadButton = CreateFrame("Button", nil, UIConfig.ScrollFrame, "GameMenuButtonTemplate")
-- UIConfig.reloadButton:SetPoint("CENTER", child, "TOP", 0, -70)
-- UIConfig.reloadButton:SetSize(140, 40)
-- UIConfig.reloadButton:SetText("Reload")
-- UIConfig.reloadButton:SetNormalFontObject("GameFontNormalLarge")
-- UIConfig.reloadButton:SetHighlightFontObject("GameFOntHighlightLarge")

-- -- UI Reload Button
-- UIConfig.reloadUIButton = CreateFrame("Button", nil, UIConfig.ScrollFrame, "GameMenuButtonTemplate")
-- UIConfig.reloadUIButton:SetPoint("TOP", UIConfig.reloadButton, "BOTTOM", 0, -10)
-- UIConfig.reloadUIButton:SetSize(140, 40)
-- UIConfig.reloadUIButton:SetText("ReloadUI")
-- UIConfig.reloadUIButton:SetNormalFontObject("GameFontNormalLarge")
-- UIConfig.reloadUIButton:SetHighlightFontObject("GameFOntHighlightLarge")

-- --Sliders

-- --1
-- UIConfig.slider1 = CreateFrame("Slider", nil, UIConfig.ScrollFrame, "OptionsSliderTemplate")
-- UIConfig.slider1:SetPoint("TOP", UIConfig.reloadUIButton, "BOTTOM", 0, -20)
-- UIConfig.slider1:SetMinMaxValues(1,100)
-- UIConfig.slider1:SetValue(50)
-- UIConfig.slider1:SetValueStep(30)
-- UIConfig.slider1:SetObeyStepOnDrag(true)

-- --Check button
-- UIConfig.checkbtn1 = CreateFrame("CheckButton", nil, UIConfig.ScrollFrame, "UICheckButtonTemplate")
-- UIConfig.checkbtn1:SetPoint("TOPLEFT", UIConfig.slider1, "BOTTOMLEFT", 0, -20)
-- UIConfig.checkbtn1.text:SetText("My Check Button")
-- UIConfig:Hide()
