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
local _LS = core._L.PRICELISTTABLE

local pendingItemRequests = {}

local ScrollingTable = LibStub("ScrollingTable")

function TableSort(table, rowa, rowb, sortbycol)
    local column = table.cols[sortbycol]
    local direction = column.sort or column.defaultsort or 1
    --core:PrintDebug("TableSort", direction)
    --local a, b = table:GetRow(rowa), table:GetRow(rowb);
    
    local a, b = table:GetCell(rowa, 1), table:GetCell(rowb, 1)
    if a==b then
        return false
    else
        local direction = column.sort or column.defaultsort or "asc"
        if direction == "asc" then
			return a < b;
		else
			return a > b;
		end
    end
end

local ItemPriceListTableColDef = {
    { ["name"] = "", ["width"] = 1 }, -- invisible col with itemname just for sort
    { -- coloumn for Item Icon - need to store ID
        ["name"] = _LS["COLNAME"], 
        ["width"] = 30,
        ["comparesort"] = TableSort,
        ["defaultsort"] = "asc",
        ["sort"] = "asc",
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
            local itemLink = self:GetCell(realrow, 3);
            cellFrame:SetScript("OnEnter", function()
                ErrorDKP:ShowItemTooltip(cellFrame, itemLink)
            end)
            cellFrame:SetScript("OnLeave", function()
                ErrorDKP:HideItemTooltip()
            end)
        end,
    },
    {["name"] = "", ["width"] = 179},
    {["name"] = _LS["COLPRICE"], ["width"] = 60},
    {["name"] = _LS["COLPRIO"], ["width"] = 120}
};


local function PriceListTable_OnEvent(self, event, itemId, success)
    if event == "ITEM_DATA_LOAD_RESULT" then
        local itemIdString = tostring(itemId)
        if #pendingItemRequests > 0 then
            --core:PrintDebug(event, #pendingItemRequests, itemId)
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
            --core:PrintDebug("Already chached")
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(k)

            local priceString = v["price"]
            if v["pricebis"] and #v["pricebis"] > 0 then
                priceString = priceString .. "("..v["pricebis"]..")"
            end
            -- TODO: we should get itemdata only once not on every update!
            --core:Print("Does item exist:", C_Item.DoesItemExistByID(k))
            --link = "|cff9d9d9d|Hitem:"..k..":::::::::::::::|h[Fractured Canine]|h|r"
            PriceListTableData[index]= { 
                itemName, k, itemLink, priceString, v["prio"]
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
                --core:PrintDebug("Not in chache do rquest")
                C_Item.RequestLoadItemDataByID(k)
                table.insert(pendingItemRequests,{itemId = k})
            end
        end 
    end
    UI.PriceListTable:ClearSelection()
    UI.PriceListTable:SetData(PriceListTableData, true)
    UI.PriceListTable:SortData()
    UI.PriceListTable:SortData()
end

function ErrorDKP:CreatePriceListTable()
    ---------------------------------------------Defin----#cols-height-?-anchorelement
    UI.PriceListTable  = ScrollingTable:CreateST(ItemPriceListTableColDef, 20, 25, nil, UI.Main)
    UI.PriceListTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 300, -40);
    UI.PriceListTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    UI.PriceListTable.head:SetHeight(15)
    UI.PriceListTable:EnableSelection(false)

    -- Title
    local title = UI.PriceListTable.frame:CreateFontString("test123")
    title:SetFontObject("GameFontNormal")
    title:SetText(_LS["TITLE"])
    title:SetPoint("TOPLEFT", UI.PriceListTable.frame, "TOPLEFT", 0, 30)

    UI.PriceListTable.frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    UI.PriceListTable.frame:SetScript("OnEvent", PriceListTable_OnEvent)

    PriceListTableUpdate()
end