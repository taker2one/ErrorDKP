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
local _L = core._L.LOOTHISTORYTABLE

local pendingItemRequests = {}

local ScrollingTable = LibStub("ScrollingTable")

local LootHistoryTableColDef = {
    { -- coloumn for Item Icon - need to store ID
        ["name"] = "Item", 
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
    {["name"] = "", ["width"] = 179},
    {["name"] = _L["COLLOOTER"], ["width"] = 100},
    {["name"] = _L["COLDKP"], ["width"] = 50},
    {["name"] = "", ["width"] = 1} -- invisible column for itemString (needed for tooltip)
};

local function TableUpdate()
    local TableData = {};
    local index = 1
    for i,v in ipairs(core.LootLog) do

        -- if C_Item.IsItemDataCachedByID(k) then
        --     core:PrintDebug("Already chached")
        --     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)

            TableData[index]= { 
                v.ItemId, v.ItemLink, v.Looter, v.Dkp, v.Time
            }
            index = index + 1
        -- else
        --     local alreadyIn = false
        --     if #pendingItemRequests > 0 then
        --         for i,v in ipairs(pendingItemRequests) do
        --             if itemId == v.itemId then
        --                 alreadyIn = true
        --             end
        --         end
        --     end
        --     if not alreadyIn then
        --         core:PrintDebug("Not in chache do rquest")
        --         C_Item.RequestLoadItemDataByID(k)
        --         table.insert(pendingItemRequests,{itemId = k})
        --     end
        -- end 
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
                        TableUpdate()
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
    t.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    t.head:SetHeight(15)
    t:EnableSelection(true)

    -- Title
    local title = t.frame:CreateFontString("test123")
    title:SetFontObject("GameFontNormal")
    title:SetText(_L["TITLE"])
    title:SetPoint("TOPLEFT", t.frame, "TOPLEFT", 0, 30)

    t.frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    t.frame:SetScript("OnEvent", Table_OnEvent)
    TableUpdate()
    return t
end

function ErrorDKP:GetLootHistoryTable()
    local t = core.UI.LootHistoryTable or CreateLootHistoryTable()
    return t
end

function ErrorDKP:AddItemToHistory(itemLink, itemId, looter, dkp, lootTime)
    table.insert(core.LootLog, 1, {
        ["ItemId"] = itemId,
        ["ItemLink"] = itemLink,
        ["Looter"] = looter,
        ["Dkp"] = dkp,
        ["Time"] = lootTime
    })
    while #core.LootLog > 50 do
        table.remove(core.LootLog, #core.LootLog)
    end
    if UI.LootHistoryTable then TableUpdate() end
end