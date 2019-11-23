--###############################################
--#  Project: ErrorDKP
--#  File: pricelisttable.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Create and manage the dkp table
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _L = core._L.PRICELISTTABLE

local pendingItemRequests = {}

local ScrollingTable = LibStub("ScrollingTable")

local ItemPriceListTableColDef = {
    { -- coloumn for Item Icon - need to store ID
        ["name"] = "Icon", 
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
            local itemLink = self:GetCell(realrow, 5);
            cellFrame:SetScript("OnEnter", function()
                ErrorDKP:ShowItemTooltip(cellFrame, itemLink)
            end)
            cellFrame:SetScript("OnLeave", function()
                ErrorDKP:HideItemTooltip()
            end)
        end,
    },
    {["name"] = _L["COLNAME"], ["width"] = 179},
    {["name"] = _L["COLPRICE"], ["width"] = 30},
    {["name"] = _L["COLPRIO"], ["width"] = 150},
    {["name"] = "", ["width"] = 1} -- invisible column for itemString (needed for tooltip)
};


local function PriceListTable_OnEvent(self, event, itemId, success)
    if event == "ITEM_DATA_LOAD_RESULT" then
        local itemIdString = tostring(itemId)
        if #pendingItemRequests > 0 then
            core:PrintDebug(event, #pendingItemRequests, itemId)
            for i,v in ipairs(pendingItemRequests) do
                if itemIdString == v.itemId then
                    core:PrintDebug(event, itemId, success)
                    if #pendingItemRequests == 1 then
                        PriceListTableUpdate()
                    end
                    table.remove(pendingItemRequests, i)
                end
            end
        end
    end
end

function PriceListTableUpdate()
    local PriceListTableData = {};
    local index = 1
    for k,v in pairs(core.ItemPriceList) do

        if C_Item.IsItemDataCachedByID(k) then
            core:PrintDebug("Already chached")
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(k)

            -- TODO: we should get itemdata only once not on every update!
            --core:Print("Does item exist:", C_Item.DoesItemExistByID(k))
            --link = "|cff9d9d9d|Hitem:"..k..":::::::::::::::|h[Fractured Canine]|h|r"
            PriceListTableData[index]= { 
                k, itemLink, v["price"], v["prio"], itemLink
            }
            index = index + 1
        else
            local alreadyIn = false
            if #pendingItemRequests > 0 then
                for i,v in ipairs(pendingItemRequests) do
                    if itemId == v.itemId then
                        alreadyIn = true
                    end
                end
            end
            if not alreadyIn then
                core:PrintDebug("Not in chache do rquest")
                C_Item.RequestLoadItemDataByID(k)
                table.insert(pendingItemRequests,{itemId = k})
            end
        end 
    end
    UI.PriceListTable:ClearSelection()
    UI.PriceListTable:SetData(PriceListTableData, true)
end

function ErrorDKP:CreatePriceListTable()
    ---------------------------------------------Defin----#cols-height-?-anchorelement
    UI.PriceListTable  = ScrollingTable:CreateST(ItemPriceListTableColDef, 20, 25, nil, UI.Main)
    UI.PriceListTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 300, -40);
    UI.PriceListTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    UI.PriceListTable.head:SetHeight(15)
    UI.PriceListTable:EnableSelection(true)

    -- Title
    local title = UI.PriceListTable.frame:CreateFontString("test123")
    title:SetFontObject("GameFontNormal")
    title:SetText(_L["TITLE"])
    title:SetPoint("TOPLEFT", UI.PriceListTable.frame, "TOPLEFT", 0, 30)

    UI.PriceListTable.frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    UI.PriceListTable.frame:SetScript("OnEvent", PriceListTable_OnEvent)

    PriceListTableUpdate()
end