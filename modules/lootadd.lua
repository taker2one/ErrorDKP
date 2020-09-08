--###############################################
--#  Project: ErrorDKP
--#  File: lootadd.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Manually add loot to lootlist
--#  Last Edit: 19.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L
ErrorDKP.LootTracker = {}
local LootTracker = ErrorDKP.LootTracker

local ScrollingTable = LibStub("ScrollingTable")

local PlayerDropDownTableColDef = {
    {["name"] = "", ["width"] = 100},
};

function LootTracker:OnChatEdit_InsertLink(link)
    if core.UI.LootAddFrame and core.UI.LootAddFrame:IsVisible() then
        if core.UI.LootAddFrame.ItemInput:HasFocus() then
            LootTracker:InsertItemLink(link)
        end
    end
end

function LootTracker:InsertItemLink(itemLink, paidwithgold)
   
            core:PrintDebug("LootTracker:InsertItemLink", itemLink)
            core.UI.LootAddFrame.ItemInput:SetText(itemLink)

            local _, _, itemId = core:ItemInfo(itemLink);

            local priceListItem = core.ItemPriceList[tostring(itemId)]
            if paidwithgold then
                core:PrintDebug("Item paid with gold so set dkp to 0")
                core.UI.LootAddFrame.PriceInput:SetText(0)
            elseif priceListItem then
                local priceListPrice = tonumber(priceListItem.price)
                -- if priceListPrice then
                --     dkpValue = priceListPrice
                -- else
                --     dkpvalue = 0
                -- end
        
                -- if priceListPrice > 5 then
                --     offspecValue = 5
                -- else
                --     offspecValue = priceListPrice
                -- end

                core.UI.LootAddFrame.PriceInput:SetText(priceListPrice)

            else
                core.UI.LootAddFrame.PriceInput:SetText("")
            end
end

function LootTracker:InsertLooter(playerName)
    local frame = self:GetAddFrame()
    frame.Looter = playerName;
    frame.LooterInput:SetText(playerName);
end

function LootTracker:Handler(t)
    if t == "CANCEL" then
        self:GetAddFrame():Hide()
        self:ClearInputs()
        return
    end

    core:PrintDebug(" LootTracker:OnChatEdit_InsertLink("..t..")");
    
    local f = self:GetAddFrame()

    -- if OK was pressed, check input data
    local player = f.LooterInput:GetText()
    local price = f.PriceInput:GetText()
    local item = f.ItemInput:GetText()

    if not tonumber(price) then 
        price = 0 
    else
        price = tonumber(price)
    end

    -- First check item cause this is need in any case
    local itemName, itemLink, itemId, itemString, itemRarity, itemColor, itemLevel, itemMinLevel, itemType, 
          itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = core:ItemInfo(item)

    if not itemLink then
        core:Print(string.format("Item: %s doesnt exist", item))
        return
    end

    if t == "OK" then
        if ErrorDKP:GetPlayerDKP(player) ~= nil then
            local historyEntry = ErrorDKP:AddToLootHistory(itemLink, itemId , player, price)
            ErrorDKP:AdjustDKPWithItem(player, -price, historyEntry)
        else
            core:Print(string.format("Player: %s not in DKP List", player))
            return
        end
    elseif (button == "BANK") then
        local historyEntry = ErrorDKP:AddToLootHistory(LootInfo.ItemLink, LootInfo.ItemId, "bank", 0, true)
        --ErrorDKP:AdjustDKPWithItem("Errorbank", -dkpValue, historyEntry)
    elseif t == "DISENCHANTED" then
        ErrorDKP:AddToLootHistory(itemLink, itemId, "disenchanted", 0, true)
    end

    self:GetAddFrame():Hide()
    self:ClearInputs()
end

function LootTracker:ClearInputs()
    local f = self:GetAddFrame()

    f.LooterInput:SetText("")
    f.PriceInput:SetText("")
    f.ItemInput:SetText("")
end

function LootTracker:CreateAddFrame()
    core.UI.LootAddFrame = core:CreateDefaultFrame("ErrorDKP_LootAddFrame", "Add Loot", 365, 250, true)
    local f = core.UI.LootAddFrame;
    f:SetPoint("CENTER", UIParent, "CENTER")
    f:SetFrameLevel(25)
    f:EnableMouse(true)
    f:EnableKeyboard(true)
    f:Hide()
    f:SetScript("OnHide", function(self) 
        LootTracker:Handler("CANCEL")
        -- self:Hide()
    end)

    --Item
    f.ItemLabel = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local itemLabel = f.ItemLabel
    itemLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 50, -20)
    itemLabel:SetText(_L["ITEM"])

    f.ItemInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local itemInput = f.ItemInput
    itemInput:SetPoint("TOPLEFT", itemLabel, "BOTTOMLEFT", 8)
    itemInput:SetSize(250, 32)
    itemInput:SetMultiLine(false)
    itemInput:EnableMouse(true)
    itemInput:EnableKeyboard(true)
    itemInput:SetScript("OnEnterPressed", function()
        LootTracker:Handler("OK")
    end)
    itemInput:SetScript("OnEscapePressed", function()
        LootTracker:Handler("CANCEL")
    end)
    itemInput:SetScript("OnTabPressed", function()
        priceInput:SetFocus()
    end)

    --Player/Looter
    f.LooterLabel = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local looterLabel = f.LooterLabel
    looterLabel:SetPoint("TOPLEFT", itemInput, "BOTTOMLEFT", 0, -10)
    looterLabel:SetText(_L["LOOTER"])

    f.LooterInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local looterInput = f.LooterInput
    looterInput:SetPoint("TOPLEFT", looterLabel, "BOTTOMLEFT", 8)
    looterInput:SetSize(250, 32)
    looterInput:SetMultiLine(false)
    looterInput:EnableMouse(true)
    looterInput:EnableKeyboard(true)
    looterInput:SetScript("OnEnterPressed", function()
        LootTracker:Handler("OK")
    end)
    looterInput:SetScript("OnEscapePressed", function()
        LootTracker:Handler("CANCEL")
    end)
    looterInput:SetScript("OnTabPressed", function()
        priceInput:SetFocus()
    end)

    --price
    f.PriceLabel = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local priceLabel = f.PriceLabel
    priceLabel:SetPoint("TOPLEFT", looterInput, "BOTTOMLEFT", 0, -10)
    priceLabel:SetText(_L["PRICE"])

    -- price input
    f.PriceInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local priceInput = f.PriceInput
    priceInput:SetPoint("TOPLEFT", priceLabel, "BOTTOMLEFT", 8)
    priceInput:SetSize(250, 32)
    priceInput:SetMultiLine(false)
    priceInput:SetScript("OnEnterPressed", function()
        LootTracker:Handler("OK")
    end)
    priceInput:SetScript("OnEscapePressed", function()
        LootTracker:Handler("CANCEL")
    end)
    priceInput:SetScript("OnTabPressed", function()
        itemInput:SetFocus()
    end)

    --Buttons
    local okButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.OkButton = okButton
    okButton:SetSize(95,22)
    okButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 45)
    okButton:SetText(_L["OK"])
    okButton:SetScript("OnClick", function() 
        LootTracker:Handler("OK")
    end)

    local cancelButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.CancelButton = cancelButton
    cancelButton:SetSize(95,22)
    cancelButton:SetPoint("LEFT", okButton, "RIGHT", 15, 0)
    cancelButton:SetText(_L["CANCEL"])
    cancelButton:SetScript("OnClick", function()
        LootTracker:Handler("CANCEL")
    end)

    local dissButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.DissButton = dissButton
    dissButton:SetSize(95,22)
    dissButton:SetPoint("LEFT", cancelButton, "RIGHT", 15, 0)
    dissButton:SetText("Disenchanted")
    dissButton:SetScript("OnClick", function()
        LootTracker:Handler("DISENCHANTED") 
    end)

    local bankButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.BankButton = bankButton
    bankButton:SetSize(95,22)
    bankButton:SetPoint("TOP", dissButton, "BOTTOM", 0, -5)
    bankButton:SetText("Bank")
    bankButton:SetScript("OnClick", function()
        LootTracker:Handler("BANK") 
    end)

    --Toggle Dropdown button
    local ddButton = CreateFrame("Button", nil, f)
    f.DdButton = ddButton
    ddButton:SetSize(16,16)
    ddButton:SetPoint("LEFT", looterInput, "RIGHT")
    ddButton:SetScript("OnClick", function()
        self:ToggleAddDropDown(ddButton)
    end)
    ddButton:CreateTexture()
    ddButton.normalTexture = ddButton:CreateTexture(nil)
    ddButton.normalTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    ddButton.normalTexture:SetSize(16,16)
    ddButton.normalTexture:SetPoint("RIGHT")
    ddButton.pushedTexture = ddButton:CreateTexture(nil)
    ddButton.pushedTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    ddButton.pushedTexture:SetSize(16,16)
    ddButton.pushedTexture:SetPoint("RIGHT")
    ddButton.highlightTexture = ddButton:CreateTexture(nil)
    ddButton.highlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    ddButton.highlightTexture:SetSize(16,16)
    ddButton.highlightTexture:SetPoint("RIGHT")

    ddButton:SetNormalTexture(ddButton.normalTexture)
    ddButton:SetPushedTexture(ddButton.pushedTexture)
    ddButton:SetHighlightTexture(ddButton.highlightTexture)

    return f
end

function LootTracker:GetAddFrame()
    local f = core.UI.LootAddFrame or self:CreateAddFrame()
    return f
end

function LootTracker:SetupPlayerDropDown()
    local playerData = {};
    local numRaidMembers = GetNumGroupMembers()
    
    for i=1, numRaidMembers do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
        playerData[i] = { name }
    end
    if numRaidMembers==0  then 
        playerData[1] = { "Not in raid/group" }
    end

    table.sort(playerData, function(a, b) return (a[1] < b[1]); end )

    local ddt = self:GetAddDropDownTable()
    ddt:SetData(playerData, true);
    if (#playerData < 8) then
        ddt:SetDisplayRows(#playerData, 15);
    else
        ddt:SetDisplayRows(8, 15);
    end
    ddt.frame:Hide();
end

function LootTracker:ResetAddFrame()
    f = self:GetAddFrame()
    f.ItemInput:SetText("")
    f.PriceInput:SetText("")
    f.LooterInput:SetText("")
end

-- DropdownTable
function LootTracker:CreateAddDropDownTable()
    core.UI.LootAddFrameDDT = ScrollingTable:CreateST(PlayerDropDownTableColDef, 9, nil, nil, core.UI.LootAddFrame)
    local ddt = core.UI.LootAddFrameDDT

    ddt.head:SetHeight(1);
    ddt.frame:SetFrameLevel(26);
    ddt.frame:Hide();
    ddt:EnableSelection(false);
    ddt:RegisterEvents({
        ["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
            if (not realrow) then return true; end
            local playerName = scrollingTable:GetCell(realrow, column);
            core:PrintDebug("set ",playerName, " as looter")
            if (playerName) then
                core.UI.LootAddFrame.Looter = playerName;
                core.UI.LootAddFrame.LooterInput:SetText(playerName);
                LootTracker:ToggleAddDropDown(nil)
            end
            return true;
        end
    });
    ddt.head:SetHeight(1);

    return ddt
end

function LootTracker:GetAddDropDownTable()
    local f = core.UI.LootAddFrameDDT or self:CreateAddDropDownTable()
    return f
end

function LootTracker:ToggleAddDropDown(parent)
    core:PrintDebug("LootTracker:ToggleAddDropDown()", parent)
    local ddt = self:GetAddDropDownTable()
    if (ddt.frame:IsShown()) then
        core:PrintDebug("LootTracker:ToggleAddDropDown()", "Hide")
        ddt.frame:Hide()
    else
        ddt.frame:Show()
        ddt.frame:SetPoint("TOPRIGHT", core.UI.LootAddFrame.DdButton, "BOTTOMRIGHT", 0, 0)
        core:PrintDebug("LootTracker:ToggleAddDropDown()", "Show")
    end
end

--Setup dialog an show
function LootTracker:Show(itemLink, player, paidwithgold)
    local f = self:GetAddFrame()
    if f:IsShown() then core:PrintDebug("LootTracker:Show()", "Dialog already opened"); return; end

    core:PrintDebug("LootTracker:Show()", "itemLink:", itemLink, "player:", player)

    LootTracker:SetupPlayerDropDown()

    f:Show()
    if(player) then self:InsertLooter(player) end
    if(itemLink) then self:InsertItemLink(itemLink, paidwithgold) end
end
