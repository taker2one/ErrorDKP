--###############################################
--#  Project: ErrorDKP
--#  File: lootsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: The survey dialog which gets 
--#  shown to the raidmembers to make theyr decision
--#  Last Edit: 27.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _LS = core._L["LOOT_SURVEY"]
local _L = core._L
local LootSurvey = {}
ErrorDKP.LootSurvey = LootSurvey

local itemSurveyData

LootSurvey.DemoSurveyData = {
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
    if not data and not itemSurveyData then 
        core:Print("Cant show survey cause there is no data")
        return
    end
    itemSurveyData = data
    core:PrintDebug("LootSurvey:Show")
    self:GetFrame():Show()
    LootSurvey:Update(itemSurveyData)
end

-- Start new LootSurvey
function LootSurvey:Start(data, countdown)
    self:Show(data)
    PlaySoundFile("Interface\\AddOns\\ErrorDKP\\media\\sounds\\epic.ogg")
    self:SetupTimerBar(countdown)
end

function LootSurvey:Update(data)
    local f = LootSurvey:GetFrame()
    self:HideAllEntries()
    for i,v in ipairs(data.items) do
        entryFrame = LootSurvey:GetEntry(i)
        entryFrame:SetParent(f)
        entryFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 11, 65+(-90*i))

        entryFrame.ItemText:SetText(v.itemLink)
        entryFrame.Icon.texture:SetTexture(v.icon)
        entryFrame.MainBtn:SetEnabled(true)
        entryFrame.MainBtn.ResponseCount = 0
        self:ApplyRespButtonText(entryFrame.MainBtn)
        entryFrame.SecBtn:SetEnabled(true)
        entryFrame.SecBtn.ResponseCount = 0
        self:ApplyRespButtonText(entryFrame.SecBtn)
        entryFrame.PassBtn:SetEnabled(true)
        entryFrame.PassBtn.ResponseCount = 0
        self:ApplyRespButtonText(entryFrame.PassBtn)
        entryFrame.OffspecBtn:SetEnabled(true)
        entryFrame.OffspecBtn.ResponseCount = 0
        self:ApplyRespButtonText(entryFrame.OffspecBtn)
        entryFrame.TwinkBtn:SetEnabled(true)
        entryFrame.TwinkBtn.ResponseCount = 0
        self:ApplyRespButtonText(entryFrame.TwinkBtn)

        wipe(entryFrame.Responses)
        entryFrame:Show()
    end

    f:SetHeight(#data.items*100+60)
end

function LootSurvey:OnClickEntryButton(button, index)
    core:PrintDebug("LootSurvey:OnClickEntryButton", button, index)
    local entry = itemSurveyData.items[index]

    if not entry then 
        -- WTF happened
        core:Error("WTF happened there is no entry")
        return
    end

    -- If Offspec roll
    local roll = 0
    if button == "OFFSPEC" or button == "TWINK" then
        roll = core:Roll(true)
        core:Print(string.format(_L["MSG_OFFSPEC_ROLL_YOU"], tostring(roll), entry.itemLink))
        core.Sync:Send("OffspecRoll", { roll = roll, itemLink = entry.itemLink })
    end

    if not entry.responded then
        --local hasItem = GetItemCount((tonumber(itemSurveyData["id"]) or 0), true)
        --  { ["id"], ["itemIndex"], ["response"]  } 
        core.Sync:SendRaid("ErrDKPSurvAnsw", {
            ["id"] = itemSurveyData["id"],
            ["itemIndex"] = index,
            ["response"] = button,
            ["hasItem"] = GetItemCount(entry.itemLink, true),
            ["roll"] = roll or 0
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
    local f = core:CreateDefaultFrame("ErrorDKPLootSurveyFrame", "Loot Survey", 420, 375, false, true)
    core.UI.LootSurvey = f

    f.Entries = {}

    f:SetWidth(520)
    f:SetHeight(200)
    f:SetFrameLevel(25)
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

function LootSurvey:HideAllEntries()
    local f = LootSurvey:GetFrame()
    for i,v in ipairs(f.Entries) do
        v:Hide()
    end
end

local function BuildResponseTooltipTable(responsesTable, response)
    local t = {}
        for k,v in pairs(responsesTable) do
            if v["response"] == response then
                tinsert(t, v["player"])
            end
        end
        if #t > 0 then
            return t
        else
           return _LS["RESP_TOOLTIP_EMPTY"]
        end
end

function LootSurvey:CreateEntry(name)
    local f = CreateFrame("Frame", name, UIParent)
    f:SetSize(478,100)
   
    local icon = CreateFrame("Frame", nil, f)
    icon:SetSize(50,50)
    icon:SetPoint("LEFT", f, "LEFT", 30, 0)
    icon.texture = icon:CreateTexture(nil, "ARTWORK")
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture("Interface\\InventoryItems\\WoWUnknownItem01")
    icon:SetScript("OnEnter", function(self)
        ErrorDKP:ShowItemTooltip(self, f.ItemText:GetText())
    end)
    icon:SetScript("OnLeave", function(self)
        ErrorDKP:HideItemTooltip()
    end)
    icon:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            if IsShiftKeyDown() then
                core:PutInChatbox( f.ItemText:GetText())
            elseif IsControlKeyDown() then
                DressUpItemLink(f.ItemText:GetText())
            end
        end
    end)

    f.Icon = icon

    f.ItemText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.ItemText:SetText("Text")
    f.ItemText:SetPoint("TOPLEFT", f, "TOPLEFT", 85, -15)

    f.MainBtn = core:CreateButton(f, "MainSpecBtn", _LS["BTN_NEED"])
    f.MainBtn.Title = _LS["BTN_NEED"]
    f.MainBtn.ResponseCount = 0
    f.MainBtn:SetPoint("TOPLEFT", f, "TOPLEFT", 85, -40)
    f.MainBtn:SetScript("OnEnter", function(self)
        ErrorDKP.Tooltip:ShowTooltipBottom(self, _LS["RESP_TOOLTIP_TITLE"], function()
            return BuildResponseTooltipTable(f.Responses, "MAIN")
        end)
    end)
    f.MainBtn:SetScript("OnLeave", function(self)
        ErrorDKP.Tooltip:Hide()
    end)

    f.SecBtn = core:CreateButton(f, "SecSpecBtn", _LS["BTN_GREED"])
    f.SecBtn.Title = _LS["BTN_GREED"]
    f.SecBtn.ResponseCount = 0
    f.SecBtn:SetPoint("LEFT", f.MainBtn, "RIGHT")
    f.SecBtn:SetScript("OnEnter", function(self)
        ErrorDKP.Tooltip:ShowTooltipBottom(self, _LS["RESP_TOOLTIP_TITLE"], function()
            return BuildResponseTooltipTable(f.Responses, "SECOND")
        end)
    end)
    f.SecBtn:SetScript("OnLeave", function(self)
        ErrorDKP.Tooltip:Hide()
    end)
    
    f.OffspecBtn = core:CreateButton(f, "OffspecBtn", _LS["BTN_OFFSPEC"])
    f.OffspecBtn.Title = _LS["BTN_OFFSPEC"]
    f.OffspecBtn.ResponseCount = 0
    f.OffspecBtn:SetPoint("LEFT", f.SecBtn, "RIGHT")
    f.OffspecBtn:SetScript("OnEnter", function(self)
        ErrorDKP.Tooltip:ShowTooltipBottom(self, _LS["RESP_TOOLTIP_TITLE"], function()
            return BuildResponseTooltipTable(f.Responses, "OFFSPEC")
        end)
    end)
    f.OffspecBtn:SetScript("OnLeave", function(self)
        ErrorDKP.Tooltip:Hide()
    end)

    f.TwinkBtn = core:CreateButton(f, "TwinkBtn", _LS["BTN_TWINK"])
    f.TwinkBtn.Title = _LS["BTN_TWINK"]
    f.TwinkBtn.ResponseCount = 0
    f.TwinkBtn:SetPoint("TOPLEFT", f.OffspecBtn, "BOTTOMLEFT")
    f.TwinkBtn:SetScript("OnEnter", function(self)
        ErrorDKP.Tooltip:ShowTooltipBottom(self, _LS["RESP_TOOLTIP_TITLE"], function()
            return BuildResponseTooltipTable(f.Responses, "TWINK")
        end)
    end)
    f.TwinkBtn:SetScript("OnLeave", function(self)
        ErrorDKP.Tooltip:Hide()
    end)
    

    f.PassBtn = core:CreateButton(f, "PassBtn", _LS["BTN_PASS"])
    f.PassBtn.Title = _LS["BTN_PASS"]
    f.PassBtn.ResponseCount = 0
    f.PassBtn:SetPoint("LEFT", f.OffspecBtn, "RIGHT")
    f.PassBtn:SetScript("OnEnter", function(self)
        ErrorDKP.Tooltip:ShowTooltipBottom(self, _LS["RESP_TOOLTIP_TITLE"], function()
            return BuildResponseTooltipTable(f.Responses, "PASS")
        end)
    end)
    f.PassBtn:SetScript("OnLeave", function(self)
        ErrorDKP.Tooltip:Hide()
    end)


    -- Show Offspec only to people which have an offspec
    local localizedClass, englishClass, classIndex = UnitClass("PLAYER")
    if englishClass == "MAGE" or englishClass == "WARLOCK" or englishClass == "ROGUE" or englishClass == "HUNTER" then
        f.OffspecBtn:Hide()
    end

    f.MainBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("MAIN", f.Index)
    end)
    f.SecBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("SECOND", f.Index)
    end)
    f.PassBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("PASS", f.Index)
    end)
    f.OffspecBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("OFFSPEC", f.Index)
    end)
    f.TwinkBtn:SetScript("OnClick", function()
        LootSurvey:OnClickEntryButton("TWINK", f.Index)
    end)

    f.Responses = {}

    return f
end

function LootSurvey:FinishEntry(index)
    local f = LootSurvey:GetEntry(index)
    if not f then return; end

    f.MainBtn:SetEnabled(false)
    f.SecBtn:SetEnabled(false)
    f.PassBtn:SetEnabled(false)
    f.OffspecBtn:SetEnabled(false)
    f.TwinkBtn:SetEnabled(false)
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

function LootSurvey:OnCommCloseReceived(closeType)
    if closeType == "CLOSED" then
        self:FinishSurvey() -- i think this should be enough
    elseif closeType == "CANCEL" then
        self:FinishSurvey() -- i think this should be enough
    end
end

function LootSurvey:UpdateAnswerCount(sender, data)
    --data["itemIndex"],
    --data["response"],
    --data["id"]
    
    if  not data["id"] or not data["itemIndex"] or not data["response"] then
        return
    end

    -- Check if survey is in progress and survey id matches
    if itemSurveyData and itemSurveyData["id"] == data["id"] then
        local entry = LootSurvey:GetEntry(data["itemIndex"])
        core:PrintDebug("UpdateAnswerCount", data["response"])
        table.insert(entry.Responses, { response = data["response"], player=sender })
        if data["response"] == "MAIN" then
            entry.MainBtn.ResponseCount = entry.MainBtn.ResponseCount + 1
            LootSurvey:ApplyRespButtonText(entry.MainBtn)
        elseif data["response"] == "SECOND" then
            entry.SecBtn.ResponseCount = entry.SecBtn.ResponseCount + 1
            LootSurvey:ApplyRespButtonText(entry.SecBtn)
        elseif data["response"] == "PASS" then
            entry.PassBtn.ResponseCount = entry.PassBtn.ResponseCount + 1 
            LootSurvey:ApplyRespButtonText(entry.PassBtn)      
        elseif data["response"] == "OFFSPEC" then
            entry.OffspecBtn.ResponseCount = entry.OffspecBtn.ResponseCount + 1
            LootSurvey:ApplyRespButtonText(entry.OffspecBtn)
        elseif data["response"] == "TWINK" then
            entry.TwinkBtn.ResponseCount = entry.TwinkBtn.ResponseCount + 1
            LootSurvey:ApplyRespButtonText(entry.TwinkBtn)
        end
    end
end

function LootSurvey:ApplyRespButtonText(button)
    if button then
        local text = button.Title
        if button.ResponseCount > 0 then
            text = text .. " - " .. button.ResponseCount
        end
        button:SetText( text )
    end
end