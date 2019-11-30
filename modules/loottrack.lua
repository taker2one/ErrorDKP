--###############################################
--#  Project: ErrorDKP
--#  File: loottrack.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Brodacast/Receive to/from other clients
--#  Last Edit: 23.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _L = core._L

local deformat = LibStub("LibDeformat-3.0")
local ScrollingTable = LibStub("ScrollingTable")

-- Table definition for the drop down menu for the DKPFrame
local LCD_DropDownTableColDef = {
    {["name"] = "", ["width"] = 100},
};


local function DecomposeItemLink(link)
    core:PrintDebug("DecomposeItemLink", link)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(link);
    if (not itemLink) then 
        core:Debug('DecomposeItemLink: No itemLink')
        return nil; 
    end
    local _, itemString, _ = deformat(itemLink, "|c%s|H%s|h%s|h|r");
    local itemId, _ = deformat(itemString, "item:%d:%s");
    local itemColor = MRT_ItemColors[itemRarity + 1];
    core:PrintDebug("Demposed: ", itemRarity)
    return itemName, itemLink, itemId, itemString, itemRarity, itemColor, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
end

-- process first queue entry
local function ErrorDKP_LCD_AskCost()
    -- if there are no entries in the queue, then return
    if (#core.LootQueue == 0) then
        core.AskCostQueueRunning = nil;
        return; 
    end

    local LootInfo = core.LootQueue[1]

    -- Make Sure LootConfirmDialog exists
    ErrorDKP:GetLootConfirmDialog()

    -- else format text and show "Enter Cost" frame
    -- local raidNum = core.AskCostQueue[1]["RaidNum"];
    -- local itemNum = core.AskCostQueue[1]["ItemNum"];
    -- local itemLink = core.AskCostQueue[1]["ItemLink"]
    -- gather playerdata and fill drop down menu
    local playerData = {};
    local numRaidMembers = GetNumGroupMembers()
    
    for i=1, numRaidMembers do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
        playerData[i] = { name }
    end
    if numRaidMembers==0  then 
        core:PrintDebug("Add to dd list:", LootInfo.Looter)
        playerData[1] = { LootInfo.Looter }
    end

    -- for i, val in ipairs(MRT_RaidLog[raidNum]["Bosskills"][MRT_NumOfLastBoss]["Players"]) do
    --     playerData[i] = { val };
    -- end

    table.sort(playerData, function(a, b) return (a[1] < b[1]); end )

    local ddt = core.UI.LCDDropDownTable or ErrorDKP:CreateDropDownTable()
    ddt:SetData(playerData, true);
    if (#playerData < 8) then
        ddt:SetDisplayRows(#playerData, 15);
    else
        ddt:SetDisplayRows(8, 15);
    end
    ddt.frame:Hide();

    -- set up rest of the frame
    local lcd = core.UI.LootConfirmDialog or ErrorDKP:CreateLootConfirmDialog()
    lcd.Textline1:SetText(_L["LCD_ENTERCOSTFOR"])
    lcd.Textline2:SetText(LootInfo["ItemLink"])
    lcd.Textline3:SetText(string.format(_L["LCD_LOOTETBY"], LootInfo["Looter"]))
    UI.LootConfirmDialog.ttarea:SetWidth(lcd.Textline2:GetWidth())
    if (LootInfo["DKPValue"] == 0) then
        UI.LootConfirmDialog.PriceInput:SetText("");
    else
        UI.LootConfirmDialog.PriceInput:SetText(tostring(LootInfo["DKPValue"]));
    end
    if (LootInfo["Note"]) then
        UI.LootConfirmDialog.NoteInput:SetText(LootInfo["Note"]);
    else
        UI.LootConfirmDialog.NoteInput:SetText("");
    end
    UI.LootConfirmDialog.Looter = LootInfo["Looter"];
    -- set autoFocus of EditBoxes
    --if (MRT_Options["Tracking_AskCostAutoFocus"] == 3 or (MRT_Options["Tracking_AskCostAutoFocus"] == 2 and UnitAffectingCombat("player")) ) then
        --MRT_GetDKPValueFrame_EB:SetAutoFocus(false);
    --else
        UI.LootConfirmDialog.NoteInput:SetAutoFocus(true);
    --end
    -- show DKPValue Frame
    ErrorDKP:GetLootConfirmDialog():Show();  
end

---------------------------
--  loot cost functions  --
---------------------------
-- basic idea: add looted items to a little queue and ask cost for each item in the queue 
--             this should avoid missing dialogs for fast looted items
-- note: standard dkpvalue is already 0
local function ErrorDKP_LCD_AddToItemCostQueue(LootInfo)
    tinsert(core.LootQueue, LootInfo);
    if (core.AskCostQueueRunning) then return; end
    core.AskCostQueueRunning = true;
    ErrorDKP_LCD_AskCost();
end

local function ErrorDKPAutoAddLootItem(playerName, itemLink, itemCount)
	if (not playerName) then return; end
	if (not itemLink) then return; end
	if (not itemCount) then return; end
    core:PrintDebug("ErrorDKPAutoAddLootItem called - playerName: "..playerName.." - itemLink: "..itemLink.." - itemCount: "..itemCount);
    local itemName, _, itemId, itemString, itemRarity, itemColor, itemLevel, _, itemType, itemSubType, _, _, _, _, itemClassID, itemSubClassID = DecomposeItemLink(itemLink);
    if (not itemName == nil) then core:PrintDebug("Panic! Item information lookup failed horribly. Source: ErrorDKPAutoAddLootItem()"); return; end
    -- check options, if this item should be tracked
    if (core.ISettings.ItemTracking_MinItemQualityToLog > itemRarity) then core:PrintDebug("Item not tracked - quality is too low."); return; end
    if (core.ISettings["ItemTracking_IgnoreEnchantingMats"] and itemClassID == 7 and itemSubClassID == 12) then core:PrintDebug("Item not tracked - it is a enchanting material and the corresponding ignore option is on."); return; end
    --if (MRT_IgnoredItemIDList[itemId]) then core:PrintDebug("Item not tracked - ItemID is listed on the ignore list"); return; end
    
    local dkpValue = 0;
    local lootAction = nil;
    local itemNote = nil;
    local supressCostDialog = nil;
    local gp1, gp2 = nil, nil;
  
    -- TODO: DKP Price from Pricelist

    -- if code reach this point, we should have valid item information, an active raid and at least one boss kill entry - make a table!
    local LootInfo = {
        ["ItemLink"] = itemLink,
        ["ItemString"] = itemString,
        ["ItemId"] = itemId,
        ["ItemName"] = itemName,
        ["ItemColor"] = itemColor,
        ["ItemCount"] = itemCount,
        ["Looter"] = playerName,
        ["DKPValue"] = dkpValue,
        ["Time"] = time(),
        ["Note"] = itemNote,
    };
    -- ask the player for item cost
    ErrorDKP_LCD_AddToItemCostQueue(LootInfo);
end

local function ErrorDKP_LCD_Handler(button)
    core:PrintDebug("LCDFrame: "..button.." pressed.");
    -- if OK was pressed, check input data
    local LootInfo = core.LootQueue[1]
    local dkpValue = nil;
    local lootNote = UI.LootConfirmDialog.NoteText:GetText();

    if (button == "OK" or button == "BANK") then
        if (UI.LootConfirmDialog.PriceInput:GetText() == "") then
            dkpValue = 0;
        else
            dkpValue = tonumber(UI.LootConfirmDialog.PriceInput:GetText(), 10);
        end
        if (dkpValue == nil) then return; end
    end
    if (lootNote == "" or lootNote == " ") then
        lootNote = nil;
    end

    -- hide frame
    UI.LootConfirmDialog:Hide();

    local looter = UI.LootConfirmDialog.Looter
    if (button == "OK") then
        --Add to loot
        local historyEntry = ErrorDKP:AddToLootHistory(LootInfo.ItemLink, LootInfo.ItemId , looter, dkpValue)
        ErrorDKP:AdjustDKPWithItem(looter, -dkpValue, historyEntry)
    elseif (button == "Cancel") then
    elseif (button == "Delete") then
    elseif (button == "BANK") then
        local historyEntry = ErrorDKP:AddToLootHistory(LootInfo.ItemLink, LootInfo.ItemId, "Errorbank", dkpValue)
        ErrorDKP:AdjustDKPWithItem("Errorbank", -dkpValue, historyEntry)
    elseif (button == "DISENCHANTED") then
        core:PrintDebug("ErrorDKP_LCD_Handler: DISENCHANTED")
        ErrorDKP:AddToLootHistory(LootInfo.ItemLink, LootInfo.ItemId, "disenchanted", 0, true)
    end
  
    -- done with handling item - proceed to next one
    table.remove(core.LootQueue, 1);
    if (#core.LootQueue == 0) then
        core.AskCostQueueRunning = nil;
    else
        ErrorDKP_LCD_AskCost();
    end    
end

local function ErrorDKP_LCD_DropDownList_Toggle()
    local ddt = core.UI.LCDDropDownTable or ErrorDKP:CreateDropDownTable()
    if (ddt.frame:IsShown()) then
        ddt.frame:Hide();
    else
        ddt.frame:Show();
        ddt.frame:SetPoint("TOPRIGHT", UI.LootConfirmDialog.DdButton, "BOTTOMRIGHT", 0, 0);
    end
end

local function CreateLootConfirmDialog()
    core.UI.LootConfirmDialog = CreateFrame("Frame", "ErrorDKP_LootConfirmDialog", UIParent)
    local f = core.UI.LootConfirmDialog;
    f:SetSize(365,285)
    f:SetMovable(true)
    f:EnableMouse(true)
    --f:Hide()
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        edgeSize = 32,
        tileSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local texture = f:CreateTexture(nil, "ARTWORK")
    texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    texture:SetSize(300,64)
    texture:SetPoint("TOP", core.UI.LootConfirmDialog, "TOP", 0, 12)

    -- Title
    core.UI.LootConfirmDialog.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local title = core.UI.LootConfirmDialog.Title
    title:SetPoint("TOP", core.UI.LootConfirmDialog, "TOP", 0, -2)
    title:SetText("Title")

    -- Textlines
    core.UI.LootConfirmDialog.Textline1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local textline1 = core.UI.LootConfirmDialog.Textline1
    textline1:SetPoint("TOP", core.UI.LootConfirmDialog, "TOP", 0, -32)
    textline1:SetText("Line1")

    core.UI.LootConfirmDialog.Textline2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local textline2 = core.UI.LootConfirmDialog.Textline2
    textline2:SetPoint("TOP", textline1, "BOTTOM")
    textline2:SetText("Line2")

    core.UI.LootConfirmDialog.Textline3 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local textline3 = core.UI.LootConfirmDialog.Textline3
    textline3:SetPoint("TOP", textline2, "BOTTOM")
    textline3:SetText("Line3")

    --price
    core.UI.LootConfirmDialog.PriceText = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local pricetext = core.UI.LootConfirmDialog.PriceText
    pricetext:SetPoint("LEFT", f, "TOPLEFT", 50, -90)
    pricetext:SetText("Price")

    --note
    core.UI.LootConfirmDialog.NoteText = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local notetext = core.UI.LootConfirmDialog.NoteText
    notetext:SetPoint("TOPLEFT", pricetext, "TOPLEFT", 0, -48)
    notetext:SetText("Note")

    -- price input
    core.UI.LootConfirmDialog.PriceInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local priceinput = core.UI.LootConfirmDialog.PriceInput
    priceinput:SetPoint("TOPLEFT", pricetext, "BOTTOMLEFT", 8)
    priceinput:SetSize(250, 32)
    priceinput:SetMultiLine(false)
    priceinput:SetScript("OnEnterPressed", function()
        ErrorDKP_LCD_Handler("OK")
    end)
    priceinput:SetScript("OnEscapePressed", function()
        ErrorDKP_LCD_Handler("CANCEL")
    end)
    priceinput:SetScript("OnTabPressed", function()
        core.UI.LootConfirmDialog.NoteInput:SetFocus()
    end)

    -- note input
    core.UI.LootConfirmDialog.NoteInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local noteinput = core.UI.LootConfirmDialog.NoteInput
    noteinput:SetPoint("TOPLEFT", notetext, "BOTTOMLEFT", 8)
    noteinput:SetSize(250, 32)
    noteinput:SetMultiLine(false)
    noteinput:SetScript("OnEnterPressed", function()
        ErrorDKP_LCD_Handler("OK")
    end)
    noteinput:SetScript("OnEscapePressed", function()
        ErrorDKP_LCD_Handler("CANCEL")
    end)
    noteinput:SetScript("OnTabPressed", function()
        core.UI.LootConfirmDialog.PriceInput:SetFocus()
    end)

    --Buttons
    local okButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    UI.LootConfirmDialog.OkButton = okButton
    okButton:SetSize(95,22)
    okButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 62)
    okButton:SetText(_L["OK"])
    okButton:SetScript("OnClick", function() 
        ErrorDKP_LCD_Handler("OK") 
    end)

    local cancelButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    UI.LootConfirmDialog.CancelButton = cancelButton
    cancelButton:SetSize(95,22)
    cancelButton:SetPoint("LEFT", okButton, "RIGHT", 15, 0)
    cancelButton:SetText(_L["CANCEL"])
    cancelButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("CANCEL") 
    end)

    local deleteButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    UI.LootConfirmDialog.DeleteButton = deleteButton
    deleteButton:SetSize(95,22)
    deleteButton:SetPoint("LEFT", cancelButton, "RIGHT", 15, 0)
    deleteButton:SetText("Delete")
    deleteButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("DELETE") 
    end)

    local bankButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    UI.LootConfirmDialog.BankButton = bankButton
    bankButton:SetSize(95,22)
    bankButton:SetPoint("TOP", cancelButton, "BOTTOM", 0, -15)
    bankButton:SetText("Bank")
    bankButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("BANK") 
    end)

    local dissButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    UI.LootConfirmDialog.DissButton = dissButton
    dissButton:SetSize(95,22)
    dissButton:SetPoint("LEFT", bankButton, "RIGHT", 15, 0)
    dissButton:SetText("Disenchanted")
    dissButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("DISENCHANTED") 
    end)

    local ddButton = CreateFrame("Button", nil, f)
    UI.LootConfirmDialog.DdButton = ddButton
    ddButton:SetSize(16,16)
    ddButton:SetPoint("LEFT", textline3, "RIGHT")
    ddButton:SetScript("OnClick", ErrorDKP_LCD_DropDownList_Toggle)
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

    --for tooltip
    local ttarea = CreateFrame("FRAME", nil, f)
    UI.LootConfirmDialog.ttarea = ttarea
    ttarea:SetSize(100,12)
    ttarea:EnableMouse(true)
    ttarea:SetPoint("CENTER", textline2, "CENTER")
    ttarea:SetScript("OnEnter", function(self)
        ErrorDKP:ShowItemTooltip(self, core.UI.LootConfirmDialog.Textline2:GetText())
    end)
    ttarea:SetScript("OnLeave", function()
        ErrorDKP:HideItemTooltip()
    end)

    return f
end

function ErrorDKP:AddToLootHistory(itemLink, itemId, looter, dkp, broadcast)
    return ErrorDKP:AddItemToHistory(itemLink, itemId, looter, dkp, time(), broadcast)
end

function ErrorDKP:AutoAddLoot(chatmsg)
    if core.IsMLooter ~= true then
        -- only Masterlooter tracks items
        core:PrintDebug("AutoAddLoot ignored cause you are not the MasterLooter")
        return
    end
    core:PrintDebug("Adding Loot")
    -- patterns LOOT_ITEM / LOOT_ITEM_SELF are also valid for LOOT_ITEM_MULTIPLE / LOOT_ITEM_SELF_MULTIPLE - but not the other way around - try these first
    -- first try: somebody else received multiple loot (most parameters)
    local playerName, itemLink, itemCount = deformat(chatmsg, LOOT_ITEM_MULTIPLE);
    -- next try: somebody else received single loot
    if (playerName == nil) then
        itemCount = 1;
        playerName, itemLink = deformat(chatmsg, LOOT_ITEM);
    end
    -- if player == nil, then next try: player received multiple loot
    if (playerName == nil) then
        playerName = UnitName("player");
        itemLink, itemCount = deformat(chatmsg, LOOT_ITEM_SELF_MULTIPLE);
    end
    -- if itemLink == nil, then last try: player received single loot
    if (itemLink == nil) then
        itemCount = 1;
        itemLink = deformat(chatmsg, LOOT_ITEM_SELF);
    end
    -- if itemLink == nil, then there was neither a LOOT_ITEM, nor a LOOT_ITEM_SELF message
    if (itemLink == nil) then 
        core:PrintDebug("No valid loot event received."); 
        return; 
    end
	-- if code reaches this point, we should have a valid looter and a valid itemLink
    core:PrintDebug("Item looted - Looter is "..playerName.." and loot is "..itemLink);
	ErrorDKPAutoAddLootItem(playerName, itemLink, itemCount);
end	

function ErrorDKP:AskItemCost()
    ErrorDKP_LCD_AskCost()
end

function ErrorDKP:CreateDropDownTable()
    core.UI.LCDDropDownTable = ScrollingTable:CreateST(LCD_DropDownTableColDef, 9, nil, nil, core.UI.LootConfirmDialog)
    local ddt = core.UI.LCDDropDownTable
    --MRT_DKPFrame_DropDownTable = ScrollingTable:CreateST(MRT_DKPFrame_DropDownTableColDef, 9, nil, nil, MRT_GetDKPValueFrame);
    ddt.head:SetHeight(1);
    ddt.frame:SetFrameLevel(3);
    ddt.frame:Hide();
    ddt:EnableSelection(false);
    ddt:RegisterEvents({
        ["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
            if (not realrow) then return true; end
            local playerName = core.UI.LCDDropDownTable:GetCell(realrow, column);
            core:PrintDebug("set ",playerName, " as looter")
            if (playerName) then
                core.UI.LootConfirmDialog.Looter = playerName;
                core.UI.LootConfirmDialog.Textline3:SetText(string.format(_L["LCD_LOOTETBY"], playerName));
                ErrorDKP_LCD_DropDownList_Toggle();
            end
            return true;
        end
    });
    ddt.head:SetHeight(1);

    return ddt
end

function ErrorDKP:GetLootConfirmDialog()
    return core.UI.LootConfirmDialog or CreateLootConfirmDialog()
end
