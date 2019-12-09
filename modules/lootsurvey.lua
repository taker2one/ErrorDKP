--###############################################
--#  Project: ErrorDKP
--#  File: lootsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: The survey dialog which gets 
--#  shown to the raidmembers to make theyr decision
--#  Last Edit: 06.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local LootSurvey = {}

local ScrollingTable = LibStub("ScrollingTable")

local itemSurveyData

local DemoSurveyData = {
    id = "157564448499",
    items = {
        {
            ["index"] = 1,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\Icons\\inv_pants_07"
        },
        {
            ["index"] = 2,
            ["name"] = "Giantstalker's Gloves",
            ["itemLink"] = "|cffa335ee|Hitem:16852::::::::60:::::::|h[Giantstalker's Gloves]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\Icons\\inv_gauntlets_10"
        },
        {
            ["index"] = 3,
            ["name"] = "Seal of the Archmagus",
            ["itemLink"] = "|cffa335ee|Hitem:17110::::::::60:::::::|h[Seal of the Archmagus]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\Icons\\inv_jewelry_ring_21"
        }
    }
}

function LootSurvey:Show(data)
    local d = DemoSurveyData
    if not d and not itemSurveyData then 
        core:Print("Cant show survey cause there is no data")
    end
    itemSurveyData = d
    core:PrintDebug("LootSurvey:Show")
    self:GetFrame():Show()
    LootSurvey:Update(itemSurveyData)
end

-- Start new LootSurvey
function LootSurvey:Start(data, countdown)
    self:Show(data)
    self:SetupTimerBar(120)
end

function LootSurvey:Update(data)
    local f = LootSurvey:GetFrame()
    for i,v in ipairs(data.items) do
        entryFrame = LootSurvey:GetEntry(i)
        entryFrame:SetParent(f)
        entryFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 11, 65+(-90*i))

        entryFrame.ItemText:SetText(v.itemLink)
        entryFrame.Icon.texture:SetTexture(v.icon)
        entryFrame.MainBtn:SetEnabled(true)
        entryFrame.SecBtn:SetEnabled(true)
        entryFrame.PassBtn:SetEnabled(true)
    end

    f:SetHeight(#data.items*90+60)
end

function LootSurvey:OnClickEntryButton(button, index)
    core:PrintDebug("LootSurvey:OnClickEntryButton", button, index)
    local entry = itemSurveyData.items[index]

    if not entry then 
        -- WTF happened
        core:ErrorDebug("WTF happened there is no entry")
        return
    end

    if not entry.responded then 
        --  { ["id"], ["itemIndex"], ["response"]  } 
        core.Sync:SendRaid("ErrDKPSurvAnsw", {
            ["id"] = itemSurveyData["id"],
            ["itemIndex"] = index,
            ["response"] = button
        })

        entry.responded = true
    end
    LootSurvey:FinishEntry(index)
    if not LootSurvey:EntryOpen() then
        LootSurvey:FinishSurvey()
    end
end

function LootSurvey:EntryOpen()
    if not itemSurveyData.items or #itemSurveyData.items == 0 then return false; end
    for i, v in ipairs(itemSurveyData.items) do
        if v.responded ~= true then return true; end
    end
    return false
end

function LootSurvey:CreateFrame()
    local f = core:CreateDefaultFrame("ErrorDKPLootSurveyFrame", "Loot Survey", 420, 375)
    core.UI.LootSurvey = f
    f:SetPoint("CENTER", UIParent, "CENTER")

    f.Entries = {}

    f:SetWidth(500)
    f:SetHeight(200)
    f:Hide()

    -- Timer bar  
    local bar = CreateFrame("StatusBar", nil, f)
    f.CountdownBar = bar
    bar:SetSize(128, 25)
    bar:SetPoint("BOTTOMLEFT", f , "BOTTOMLEFT", 12, 15)
    bar:SetPoint("BOTTOMRIGHT", f , "BOTTOMRIGHT", -12, 15)
    bar:SetBackdrop({bgFile = [[Interface\ChatFrame\ChatFrameBackground]]})
    bar:SetBackdropColor(0, 0, 0, 0.7)
    bar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    bar:SetStatusBarColor(0.98, 0.9, 0.01)
    bar:SetMinMaxValues(0, 60)
    bar.TimeSinceLastUpdate = 0
    local countdown = bar:CreateFontString(nil, "OVERLAY")
    countdown:SetFontObject("GameFontNormal")
    countdown:SetText(0)
    countdown:SetSize(200,30)
    countdown:SetPoint("CENTER", bar, "CENTER", 0, 0)
    bar.countdownString = countdown
    bar.countdown = 0

    -- this function will run repeatedly, incrementing the value of timer as it goes
    bar:SetScript("OnUpdate", function(self, elapsed)
        if not CountdownActive then return; end
        self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 	
        self.countdown = self.countdown - elapsed
        if (self.TimeSinceLastUpdate >= 1) then
            bar.countdownString:SetText(math.floor(self.countdown))
            self.TimeSinceLastUpdate = 0
        end

        self:SetValue(self.countdown)
        local statusMin, statusMax = self:GetMinMaxValues()
        if self.countdown <= statusMin then
            CountdownActive = false
            LootSurvey:OnCountdownExpired()
        end
    end)

    return f
end

function LootSurvey:GetFrame()
    local f = core.UI.LootSurvey or self:CreateFrame()
    return f
end

function LootSurvey:GetEntry(index)
    local f = LootSurvey:GetFrame()
    if not f.Entries[index] then
        f.Entries[index] = LootSurvey:CreateEntry("LootSurveyEntry"..index)
        f.Entries[index].Index = index
    end
    return f.Entries[index]
end

function LootSurvey:CreateEntry(name)
    local f = CreateFrame("Frame", name, UIParent)
    f:SetSize(478,80)
   
    local icon = CreateFrame("Frame", nil, f)
    icon:SetSize(50,50)
    icon:SetPoint("LEFT", f, "LEFT", 30, 0)
    icon.texture = icon:CreateTexture(nil, "ARTWORK")
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture("Interface\\InventoryItems\\WoWUnknownItem01")
    f.Icon = icon

    f.ItemText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.ItemText:SetText("Text")
    f.ItemText:SetPoint("TOPLEFT", f, "TOPLEFT", 85, -15)

    f.MainBtn = core:CreateButton(f, "MainSpecBtn", "Main")
    f.MainBtn:SetPoint("TOPLEFT", f, "TOPLEFT", 85, -40)
    f.SecBtn = core:CreateButton(f, "SecSpecBtn", "Second")
    f.SecBtn:SetPoint("LEFT", f.MainBtn, "RIGHT")
    f.PassBtn = core:CreateButton(f, "PassBtn", "Pass")
    f.PassBtn:SetPoint("LEFT", f.SecBtn, "RIGHT")

    f.MainBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("MAIN", f.Index)
    end)
    f.SecBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("SECOND", f.Index)
    end)
    f.PassBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("PASS", f.Index)
    end)

    return f
end

function LootSurvey:FinishEntry(index)
    local f = LootSurvey:GetEntry(index)
    if not f then return; end

    f.MainBtn:SetEnabled(false)
    f.SecBtn:SetEnabled(false)
    f.PassBtn:SetEnabled(false)
end

function LootSurvey:FinishSurvey()
    self:GetFrame():Hide()
end

function LootSurvey:SetupTimerBar(countdown)
    if not countdown or countdown == 0 then return; end 
    local f = LootSurvey:GetFrame()
    f.CountdownBar:SetMinMaxValues(0, countdown)
    f.CountdownBar.countdown = countdown
    CountdownActive = true
end

function LootSurvey:OnCountdownExpired()
    if itemSurveyData and itemSurveyData.items then
        for i,v in ipairs(itemSurveyData.items) do
            core:PrintDebug("SurveyTimeout, send asnwer", v.itemLink )
            self:OnClickEntryButton("TIMEOUT", i)
        end
    end
end


ErrorDKP.LootSurvey = LootSurvey