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


local colDef = {
    { name = "", width = 80, ["DoCellUpdate"] = function(...) LootSurvey:DoCellUpdateIcon(...) end }, -- icon
    { name = "", width = 400, ["DoCellUpdate"] = function(...) LootSurvey:DoCellUpdateItemAndButtons(...) end } -- Itemname + buttons
}
local DemoSurveyData = {
    id = "157564448499",
    items = {
        {
            ["index"] = 1,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01"
        },
        {
            ["index"] = 2,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01"
        },
        {
            ["index"] = 3,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
            ["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01"
        }
    }
}


local function buildTableData()
    local t = {}
    for i,v in ipairs(DemoSurveyData.items) do
        local row = {
            v.icon,
            v.itemLink
        }
        table.insert(t, row)
    end
    return t
end

function LootSurvey:Show()
    core:PrintDebug("LootSurvey:Show")
    self:GetFrame():Show()
    --local data = buildTableData()
    LootSurvey:Update(data)
end

function LootSurvey:Update(data)
    local f = LootSurvey:GetFrame()
    for i,v in ipairs(DemoSurveyData.items) do
        entryFrame = LootSurvey:GetEntry(i)
        entryFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 10, 80+(-80*i))
    end

    f:SetHeight(#DemoSurveyData.items*80+50)
end

-- 'function LootSurvey:DoCellUpdateIcon(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
--     core:PrintDebug("DoCellUpdate")
--     local icon = self:GetCell(realrow, column) or "Interface/ICONS/INV_Sigil_Thorim.png"
--     cellFrame local f = CreateFrame("Frame", nil, UIParent)
-- end'

function LootSurvey:DoCellUpdateItemAndButtons(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
    local buttonSetFrame = LootSurvey:GetButtonSet(realrow)
    --buttonSetFrame:SetParent(cellFrame)
    buttonSetFrame:SetPoint("LEFT", cellFrame, "LEFT")
end


function LootSurvey:GetButtonSet(index)
    local f = LootSurvey:GetFrame()
    if not f.ButtonSets[index] then
        local setFrame = CreateFrame("Frame", "LootSurveyBtnSetFrame"..index, f)
        --Create new ButtonSet on index
        setFrame.MainBtn = core:CreateButton(setFrame, "MainSpecBtn", "Main")
        setFrame.MainBtn:SetPoint("TOPLEFT", setFrame, "TOPLEFT", 85, 40)
        setFrame.SecBtn = core:CreateButton(setFrame, "SecSpecBtn", "Second")
        setFrame.SecBtn:SetPoint("LEFT", setFrame.MainBtn, "RIGHT")
        setFrame.PassBtn = core:CreateButton(setFrame, "PassBtn", "Pass")
        setFrame.PassBtn:SetPoint("LEFT", setFrame.SecBtn, "RIGHT")

        table.insert(f.ButtonSets, index, setFrame)
    end
    return f.ButtonSets[index]
end

function LootSurvey:CreateFrame()
    local f = core:CreateDefaultFrame("ErrorDKPLootSurveyFrame", "Loot Survey", 420, 375)
    core.UI.LootSurvey = f
    f:SetPoint("CENTER", UIParent, "CENTER")

    f.Entries = {}

    f:SetWidth(500)
    f:SetHeight(200)
    f:Hide()

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
    end
    return f.Entries[index]
end

function LootSurvey:CreateEntry(name)
    local f = CreateFrame("Frame", name, UIParent)
    f:SetSize(500,80)
   
    local icon = CreateFrame("Frame", nil, f)
    icon:SetPoint("LEFT", f, "LEFT")
    icon:SetSize(80,80)
    icon:SetTexture("Interface\\InventoryItems\\WoWUnknownItem01")

    --Create new ButtonSet on index
    f.MainBtn = core:CreateButton(f, "MainSpecBtn", "Main")
    f.MainBtn:SetPoint("TOPLEFT", f, "TOPLEFT", 85, -40)
    f.SecBtn = core:CreateButton(f, "SecSpecBtn", "Second")
    f.SecBtn:SetPoint("LEFT", f.MainBtn, "RIGHT")
    f.PassBtn = core:CreateButton(f, "PassBtn", "Pass")
    f.PassBtn:SetPoint("LEFT", f.SecBtn, "RIGHT")

    return f
end


ErrorDKP.LootSurvey = LootSurvey