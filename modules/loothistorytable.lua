--###############################################
--#  Project: ErrorDKP
--#  File: loothistorytable.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Create and manage the dkp table
--#  Last Edit: 27.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _L = core._L
local _LS = _L.LOOTHISTORYTABLE
local ScrollingTable = LibStub("ScrollingTable")

local pendingItemRequests = {}

local contextMenuItems = {
    { text = "Select an Option", isTitle = true, notCheckable = true},
    { text = "Export", notCheckable = true, func = function() 
            local selection = ErrorDKP:GetLootHistoryTable():GetSelection()
            if selection then
                ErrorDKP:ExportItems(core.LootLog[selection])
                -- ErrorDKP:ExportItems(items)
                -- ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 3))
            end
        end 
    },
    {
        text = "Add to MRT", notCheckable = true, onlyTrusted = true, func = function()
            local selection = ErrorDKP:GetLootHistoryTable():GetSelection()
            if selection then
                local loot = core.LootLog[selection]
                core.MrtI:AddItem(loot.ItemLink, loot.Looter, loot.Dkp)
                
                -- ErrorDKP:ExportItems(items)
                -- ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 3))
            end
        end
    }
}

local LootHistoryTableColDef = {
    { -- coloumn for Item Icon - need to store ID
        ["name"] = _LS["COLITEMLINK"], 
        ["width"] = 30,
        ["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
            -- icon handling
            if fShow then 
                local itemId = self:GetCell(realrow, column);
                local itemTexture = GetItemIcon(itemId); 
                if not (cellFrame.cellItemTexture) then
                    cellFrame.cellItemTexture = cellFrame:CreateTexture();
                end
                cellFrame.cellItemTexture:SetTexture(itemTexture);
                cellFrame.cellItemTexture:SetTexCoord(0, 1, 0, 1);
                cellFrame.cellItemTexture:Show();
                cellFrame.cellItemTexture:SetPoint("CENTER", cellFrame.cellItemTexture:GetParent(), "CENTER");
                cellFrame.cellItemTexture:SetWidth(25);
                cellFrame.cellItemTexture:SetHeight(25);
            end
            -- tooltip handling
            local itemLink = self:GetCell(realrow, 2);
            cellFrame:SetScript("OnEnter", function()
                ErrorDKP:ShowItemTooltip(cellFrame, itemLink)
            end)
            cellFrame:SetScript("OnLeave", function()
                ErrorDKP:HideItemTooltip()
            end)
        end,
    },
    {["name"] = "", ["width"] = 179, ["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
        local itemLink = self:GetCell(realrow, column);
        local timeStamp = self:GetCell(realrow, 5);
        if not cellFrame.ItemLinkString then
            cellFrame.ItemLinkString = cellFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            cellFrame.ItemLinkString:SetPoint("TOPLEFT", cellFrame, "TOPLEFT", 0, -2)
        end
        cellFrame.ItemLinkString:SetText(itemLink)

        if not cellFrame.DateString then
            cellFrame.DateString = cellFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            cellFrame.DateString:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMLEFT", 0, 2)
        end
        cellFrame.DateString:SetText(date("%d/%m/%Y %H:%M", timeStamp))
    end},
    {["name"] = _LS["COLLOOTER"], ["width"] = 100},
    {["name"] = _LS["COLDKP"], ["width"] = 50},
    {["name"] = "", ["width"] = 1} -- invisible Time
};

local function UpdateDataTimestamp()
    core.DKPDataInfo["LootInfo"]["timestamp"] = core:GenerateTimestamp()
    return core.DKPDataInfo["LootInfo"]["timestamp"]
end

local function tableFilter(self, row)
    if not core.Settings.ShowOnlyItemsToday then return true end
    if core.Settings.ShowOnlyItemsToday and row[5] >= GetServerTime() - 86400 -- 24h
    then
        return true
    end
end

function ErrorDKP:LootHistoryTableUpdate()
    if not UI.LootHistoryTable then return end

    local TableData = {};
    local index = 1
    for i,v in ipairs(core.LootLog) do

            TableData[index]= { 
                v.ItemId, v.ItemLink, v.Looter, v.Dkp, v.Time
            }
            index = index + 1
    end
    ErrorDKP:GetLootHistoryTable():ClearSelection()
    ErrorDKP:GetLootHistoryTable():SetData(TableData, true)
end

local function Table_OnEvent(self, event, itemId, success)
    if event == "ITEM_DATA_LOAD_RESULT" then
        local itemIdString = tostring(itemId)
        if #pendingItemRequests > 0 then
            core:PrintDebug(event, #pendingItemRequests, itemId)
            for i,v in ipairs(pendingItemRequests) do
                if itemIdString == v.itemId then
                    core:PrintDebug(event, itemId, success)
                    if #pendingItemRequests == 1 then
                        ErrorDKP:LootHistoryTableUpdate()
                    end
                    table.remove(pendingItemRequests, i)
                end
            end
        end
    end
end

local function CreateLootHistoryTable()
    ---------------------------------------------Defin----#cols-height-?-anchorelement
    UI.LootHistoryTable  = ScrollingTable:CreateST(LootHistoryTableColDef, 20, 25, nil, UI.Main)
    local t = UI.LootHistoryTable
    t.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 745, -40);
    t.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 25);
    t.head:SetHeight(15)
    t:EnableSelection(true)

    -- Title
    local title = t.frame:CreateFontString("test123")
    title:SetFontObject("GameFontNormal")
    title:SetText(_LS["TITLE"])
    title:SetPoint("TOPLEFT", t.frame, "TOPLEFT", 0, 30)

    t.frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    t.frame:SetScript("OnEvent", Table_OnEvent)

    t:RegisterEvents({
        ["OnMouseDown"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
            local button = ...

            if button == "LeftButton" then
                local shift_key = IsShiftKeyDown()
                if shift_key then
                    local cell = scrollingTable:GetCell(realrow, 2)
                    core:PrintDebug(button, shift_key, cell)
                    core:PutInChatbox( cell )
                elseif IsControlKeyDown() then
                    local cell = scrollingTable:GetCell(realrow, 2)
                    core:PrintDebug(button, cell)
                    DressUpItemLink(cell)
                end
            elseif button == "RightButton" then
                core:PrintDebug("DKPTable RightButton clicked")
                scrollingTable:SetSelection(realrow)
                -- There is currently ony one entry so do it the easy way and hide whole menu
                if core:CheckSelfTrusted() then
                    ErrorDKP:ConextMenu(contextMenuItems)
                end
            end
    
            --[[ return true to have your event override the default one
                 return false, or nothing at all to have the deafult handler 
                    processed after yours.
                 The default OnClick handler for example, handles column sorting clicks.
                 if row and realrow are nil, then this is a column header cell ]]--
            
        end
      })

    if core:CheckSelfTrusted() then
        local lootAddBtn = CreateFrame("Button", nil, t.frame, "UIPanelButtonTemplate")
        lootAddBtn:SetSize(109,24)
        lootAddBtn:SetPoint("TOPRIGHT", t.frame, "BOTTOMRIGHT", 0,0)
        lootAddBtn:SetText("Add Item")
        lootAddBtn:SetScript("OnClick", function(self, ...)
            ErrorDKP.LootTracker:Show()
        end)
    end

    local checkBtnToday = CreateFrame("CheckButton", nil, t.frame, "UICheckButtonTemplate")
    t.CheckButtonToday = checkBtnToday
    checkBtnToday:SetPoint("TOPLEFT", t.frame, "BOTTOMLEFT", 0, 4);
    checkBtnToday.text:SetText(_LS["CHECKBTN_SHOWONLYTODAY"])
    checkBtnToday:SetChecked(core.Settings.ShowOnlyItemsToday)
    checkBtnToday:SetScript("OnClick", function(self)
        core.Settings.ShowOnlyItemsToday = self:GetChecked()
        ErrorDKP:LootHistoryTableUpdate()
    end)

    t:SetFilter(tableFilter)

    ErrorDKP:LootHistoryTableUpdate()
    return t
end

function ErrorDKP:GetLootHistoryTable()
    local t = core.UI.LootHistoryTable or CreateLootHistoryTable()
    return t
end

function ErrorDKP:AddItemToHistory(itemLink, itemId, looter, dkp, lootTime, broadcast)
    local historyEntry, oldTimestamp, newTimestamp;
    oldTimestamp = core:GetLootDataTimestamp()
    local historyEntry = {
        ["ItemId"] = itemId,
        ["ItemLink"] = itemLink,
        ["Looter"] = looter,
        ["Dkp"] = dkp,
        ["Time"] = lootTime
    }
    table.insert(core.LootLog, 1, historyEntry)
    while #core.LootLog > 50 do
        table.remove(core.LootLog, #core.LootLog)
    end
    newTimestamp = UpdateDataTimestamp()
    if UI.LootHistoryTable then ErrorDKP:LootHistoryTableUpdate() end
    if broadcast then
        core.Sync:Send("ErrDKPAddLoot", { PTS = oldTimestamp, ATS = newTimestamp, Item = historyEntry })
        if historyEntry.Looter == "disenchanted" then 
            core:Print(string.format(_L["MSG_LOOT_DISENCHANTED"], historyEntry.ItemLink))
        else
            core:Print(string.format(_L["MSG_LOOT_ADDED"], historyEntry.ItemLink))
        end
        -- Add to MRT if installed, only do when broadcasting cause if not it will be added by DKP-Adjustment with item
        core.MrtI:AddItem(historyEntry.ItemLink, historyEntry.Looter, historyEntry.Dkp) --historyEntry
    end
    return historyEntry
end

function ErrorDKP:BroadcastLootTable()
    if core:CheckSelfTrusted() then
        core.Sync:Send("ErrDKPLootSync", {ATS=core:GetLootDataTimestamp(), DataSet=core.LootLog })
        ---core.Sync:SendTo("ErrDKPLootSync", {ATS=core:GetLootDataTimestamp(), DataSet=core.LootLog }, "Karaffe")
    else
        core:Print(_L["MSG_NOT_ALLOWED"])
    end
end