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

local function tableFilter(self, row)
    if UI.PriceListTable then
        local searchText = UI.PriceListTable.SearchInput:GetText()
        if searchText then 
            searchText = string.lower(searchText)
            return string.find(string.lower(row[3]), searchText)
        else
            return true
        end
    end

    return true
end

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
    local f = UI.PriceListTable.frame
    f:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 300, -40);
    f:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 25);
    UI.PriceListTable.head:SetHeight(15)
    UI.PriceListTable:EnableSelection(false)

    -- Title
    local title = f:CreateFontString("test123")
    title:SetFontObject("GameFontNormal")
    title:SetText(_LS["TITLE"])
    title:SetPoint("TOPLEFT", UI.PriceListTable.frame, "TOPLEFT", 0, 30)

    f:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    f:SetScript("OnEvent", PriceListTable_OnEvent)

    -- Search
    local searchLabel = f:CreateFontString()
    searchLabel:SetFontObject("GameFontNormal")
    searchLabel:SetText(_LS["SEARCH"])
    searchLabel:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 2, -5)

    local searchInput = CreateFrame("EditBox","EDKP_PriceTable_SearchInput", f, "InputBoxTemplate")
    searchInput:SetPoint("LEFT", searchLabel, "RIGHT", 15, 0)
    searchInput:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, 5)
    searchInput:SetSize(250, 32)
    searchInput:SetMultiLine(false)
    searchInput:SetAutoFocus(false)
    --looterInput:EnableMouse(true)
    --looterInput:EnableKeyboard(true)
    searchInput:SetScript("OnEnterPressed", function()
        PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    searchInput:SetScript("OnEscapePressed", function()
        PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    searchInput:SetScript("OnEditFocusLost", function()
        PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    -- looterInput:SetScript("OnTabPressed", function()
    --     priceInput:SetFocus()
    -- end)
    UI.PriceListTable.SearchInput = searchInput
    UI.PriceListTable:SetFilter(tableFilter)

    UI.PriceListTable:RegisterEvents({
        ["OnMouseDown"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
            local button = ...

            if button == "LeftButton" then
                if IsShiftKeyDown() then
                    local cell = scrollingTable:GetCell(realrow, 3)
                    core:PrintDebug(button, cell)
                    core:PutInChatbox( cell )
                elseif IsControlKeyDown() then
                    local cell = scrollingTable:GetCell(realrow, 3)
                    core:PrintDebug(button, cell)
                    DressUpItemLink(cell)
                end
            end
    
            --[[ return true to have your event override the default one
                 return false, or nothing at all to have the deafult handler 
                    processed after yours.
                 The default OnClick handler for example, handles column sorting clicks.
                 if row and realrow are nil, then this is a column header cell ]]--
            
        end
      })

    PriceListTableUpdate()
end