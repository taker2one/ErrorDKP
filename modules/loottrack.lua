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

function DecomposeItemLink(link)
    core:PrintDebug("DecomposeItemLink", link)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(link);
    if (not itemLink) then return nil; end
    local _, itemString, _ = deformat(itemLink, "|c%s|H%s|h%s|h|r");
    local itemId, _ = deformat(itemString, "item:%d:%s");
    local itemColor = MRT_ItemColors[itemRarity + 1];
    return itemName, itemLink, itemId, itemString, itemRarity, itemColor, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID;
end

function ErrorDKP:AutoAddLoot(chatmsg)
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
        -- MRT_Debug("No valid loot event received."); 
        return; 
    end
	-- if code reaches this point, we should have a valid looter and a valid itemLink
    core:PrintDebug("Item looted - Looter is "..playerName.." and loot is "..itemLink);
	ErrorDKPAutoAddLootItem(playerName, itemLink, itemCount);
end	

local function ErrorDKPAutoAddLootItem(playerName, itemLink, itemCount)
	if (not playerName) then return; end
	if (not itemLink) then return; end
	if (not itemCount) then return; end
	core:PrintDebug("MRT_AutoAddLootItem called - playerName: "..playerName.." - itemLink: "..itemLink.." - itemCount: "..itemCount);
    -- example itemLink: |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r (outdated!)
    local itemName, _, itemId, itemString, itemRarity, itemColor, itemLevel, _, itemType, itemSubType, _, _, _, _, itemClassID, itemSubClassID = MRT_GetDetailedItemInformation(itemLink);
    if (not itemName == nil) then MRT_Debug("Panic! Item information lookup failed horribly. Source: MRT_AutoAddLootItem()"); return; end
    -- check options, if this item should be tracked
    if (MRT_Options["Tracking_MinItemQualityToLog"] > itemRarity) then MRT_Debug("Item not tracked - quality is too low."); return; end
    if (MRT_Options["Tracking_OnlyTrackItemsAboveILvl"] > itemLevel) then MRT_Debug("Item not tracked - iLvl is too low."); return; end
    -- itemClassID 3 = "Gem", itemSubClassID 11 = "Artifact Relic"; itemClassID 7 = "Tradeskill", itemSubClassID 4 = "Jewelcrafting", 12 = Enchanting
    if (MRT_Options["ItemTracking_IgnoreGems"] and itemClassID == 3 and itemSubClassID ~= 11) then MRT_Debug("Item not tracked - it is a gem and the corresponding ignore option is on."); return; end
    if (MRT_Options["ItemTracking_IgnoreGems"] and itemClassID == 7 and itemSubClassID == 4) then MRT_Debug("Item not tracked - it is a gem and the corresponding ignore option is on."); return; end
    if (MRT_Options["ItemTracking_IgnoreEnchantingMats"] and itemClassID == 7 and itemSubClassID == 12) then MRT_Debug("Item not tracked - it is a enchanting material and the corresponding ignore option is on."); return; end
    if (MRT_IgnoredItemIDList[itemId]) then MRT_Debug("Item not tracked - ItemID is listed on the ignore list"); return; end
    local dkpValue = 0;
    local lootAction = nil;
    local itemNote = nil;
    local supressCostDialog = nil;
    local gp1, gp2 = nil, nil;
    -- if EPGP GP system is enabled, get GP values
    if (MRT_Options["ItemTracking_UseEPGPValues"]) then
        gp1, gp2 = LibGP:GetValue(itemLink);
        if (not gp1) then
            dkpValue = 0
        elseif (not gp2) then
            dkpValue = gp1
        else
            dkpValue = gp1
            itemNote = string.format("%d or %d", gp1, gp2)
        end
    end
    -- if an external function handles item data, notify it
    if (MRT_ExternalItemCostHandler.func) then
        local notifierInfo = {
            ["ItemLink"] = itemLink,
            ["ItemString"] = itemString,
            ["ItemId"] = itemId,
            ["ItemName"] = itemName,
            ["ItemColor"] = itemColor,
            ["ItemCount"] = itemCount,
            ["Looter"] = playerName,
            ["DKPValue"] = dkpValue,
            ["Time"] = MRT_GetCurrentTime(),
        };
        local retOK, dkpValue_tmp, playerName_tmp, itemNote_tmp, lootAction_tmp, supressCostDialog_tmp = pcall(MRT_ExternalItemCostHandler.func, notifierInfo);
        if (retOK) then
            dkpValue = dkpValue_tmp;
            playerName = playerName_tmp;
            itemNote = itemNote_tmp;
            lootAction = lootAction_tmp;
            supressCostDialog = supressCostDialog_tmp;
        end
        if (lootAction == MRT_LOOTACTION_BANK) then
            playerName = "bank";
        elseif (lootAction == MRT_LOOTACTION_DISENCHANT) then
            playerName = "disenchanted";
        elseif (lootAction == MRT_LOOTACTION_DELETE) then
            playerName = "_deleted_";
        end
    end
    -- Quick&Dirty for trash drops before first boss kill
    if (MRT_NumOfLastBoss == nil) then 
        MRT_AddBosskill(MRT_L.Core["Trash Mob"], "N");
    end
    -- if code reach this point, we should have valid item information, an active raid and at least one boss kill entry - make a table!
    local MRT_LootInfo = {
        ["ItemLink"] = itemLink,
        ["ItemString"] = itemString,
        ["ItemId"] = itemId,
        ["ItemName"] = itemName,
        ["ItemColor"] = itemColor,
        ["ItemCount"] = itemCount,
        ["Looter"] = playerName,
        ["DKPValue"] = dkpValue,
        ["BossNumber"] = MRT_NumOfLastBoss,
        ["Time"] = MRT_GetCurrentTime(),
        ["Note"] = itemNote,
    };
    tinsert(MRT_RaidLog[MRT_NumOfCurrentRaid]["Loot"], MRT_LootInfo);
    -- get current loot mode
    local isPersonal = select(1, GetLootMethod()) == "personalloot"
    -- check if we should ask the player for item cost
    if (supressCostDialog or (not MRT_Options["Tracking_AskForDKPValue"]) or (isPersonal and not MRT_Options["Tracking_AskForDKPValuePersonal"])) then 
        -- notify registered, external functions
        local itemNum = #MRT_RaidLog[MRT_NumOfCurrentRaid]["Loot"];
        if (#MRT_ExternalLootNotifier > 0) then
            local itemInfo = {};
            for key, val in pairs(MRT_RaidLog[MRT_NumOfCurrentRaid]["Loot"][itemNum]) do
                itemInfo[key] = val;
            end
            if (itemInfo.Looter == "bank") then
                itemInfo.Action = MRT_LOOTACTION_BANK;
            elseif (itemInfo.Looter == "disenchanted") then
                itemInfo.Action = MRT_LOOTACTION_DISENCHANT;
            elseif (itemInfo.Looter == "_deleted_") then
                itemInfo.Action = MRT_LOOTACTION_DELETE;
            else
                itemInfo.Action = MRT_LOOTACTION_NORMAL;
            end
            for i, val in ipairs(MRT_ExternalLootNotifier) do
                pcall(val, itemInfo, MRT_NOTIFYSOURCE_ADD_SILENT, MRT_NumOfCurrentRaid, itemNum);
            end
        end
        return; 
    end
    if (MRT_Options["Tracking_MinItemQualityToGetDKPValue"] > MRT_ItemColorValues[itemColor]) then return; end
    -- ask the player for item cost
    MRT_DKPFrame_AddToItemCostQueue(MRT_NumOfCurrentRaid, #MRT_RaidLog[MRT_NumOfCurrentRaid]["Loot"]);
end

---------------------------
--  loot cost functions  --
---------------------------
-- basic idea: add looted items to a little queue and ask cost for each item in the queue 
--             this should avoid missing dialogs for fast looted items
-- note: standard dkpvalue is already 0
function MRT_DKPFrame_AddToItemCostQueue(raidnum, itemnum)
    local MRT_DKPCostQueueItem = {
        ["RaidNum"] = raidnum,
        ["ItemNum"] = itemnum,
    }
    tinsert(MRT_AskCostQueue, MRT_DKPCostQueueItem);
    if (MRT_AskCostQueueRunning) then return; end
    MRT_AskCostQueueRunning = true;
    MRT_DKPFrame_AskCost();
end

-- process first queue entry
function MRT_DKPFrame_AskCost()
    -- if there are no entries in the queue, then return
    if (#MRT_AskCostQueue == 0) then
        MRT_AskCostQueueRunning = nil;
        return; 
    end
    -- else format text and show "Enter Cost" frame
    local raidNum = MRT_AskCostQueue[1]["RaidNum"];
    local itemNum = MRT_AskCostQueue[1]["ItemNum"];
    -- gather playerdata and fill drop down menu
    local playerData = {};
    for i, val in ipairs(MRT_RaidLog[raidNum]["Bosskills"][MRT_NumOfLastBoss]["Players"]) do
        playerData[i] = { val };
    end
    table.sort(playerData, function(a, b) return (a[1] < b[1]); end );
    MRT_DKPFrame_DropDownTable:SetData(playerData, true);
    if (#playerData < 8) then
        MRT_DKPFrame_DropDownTable:SetDisplayRows(#playerData, 15);
    else
        MRT_DKPFrame_DropDownTable:SetDisplayRows(8, 15);
    end
    MRT_DKPFrame_DropDownTable.frame:Hide();
    -- set up rest of the frame
    MRT_GetDKPValueFrame_TextFirstLine:SetText(MRT_L.Core["DKP_Frame_EnterCostFor"]);
    MRT_GetDKPValueFrame_TextSecondLine:SetText(MRT_RaidLog[raidNum]["Loot"][itemNum]["ItemLink"]);
    MRT_GetDKPValueFrame_TextThirdLine:SetText(string.format(MRT_L.Core.DKP_Frame_LootetBy, MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"]));
    MRT_GetDKPValueFrame_TTArea:SetWidth(MRT_GetDKPValueFrame_TextSecondLine:GetWidth());
    if (MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"] == 0) then
        MRT_GetDKPValueFrame_EB:SetText("");
    else
        MRT_GetDKPValueFrame_EB:SetText(tostring(MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"]));
    end
    if (MRT_RaidLog[raidNum]["Loot"][itemNum]["Note"]) then
        MRT_GetDKPValueFrame_EB2:SetText(MRT_RaidLog[raidNum]["Loot"][itemNum]["Note"]);
    else
        MRT_GetDKPValueFrame_EB2:SetText("");
    end
    MRT_GetDKPValueFrame.Looter = MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"];
    -- set autoFocus of EditBoxes
    if (MRT_Options["Tracking_AskCostAutoFocus"] == 3 or (MRT_Options["Tracking_AskCostAutoFocus"] == 2 and UnitAffectingCombat("player")) ) then
        MRT_GetDKPValueFrame_EB:SetAutoFocus(false);
    else
        MRT_GetDKPValueFrame_EB:SetAutoFocus(true);
    end
    -- show DKPValue Frame
    MRT_GetDKPValueFrame:Show();  
end

function MRT_DKPFrame_Handler(button)
    MRT_Debug("DKPFrame: "..button.." pressed.");
    -- if OK was pressed, check input data
    local dkpValue = nil;
    local lootNote = MRT_GetDKPValueFrame_EB2:GetText();
    if (button == "OK") then
        if (MRT_GetDKPValueFrame_EB:GetText() == "") then
            dkpValue = 0;
        else
            dkpValue = tonumber(MRT_GetDKPValueFrame_EB:GetText(), 10);
        end
        if (dkpValue == nil) then return; end
    end
    if (lootNote == "" or lootNote == " ") then
        lootNote = nil;
    end
    -- hide frame
    MRT_GetDKPValueFrame:Hide();
    -- this line is solely for debug purposes 
    -- if (button == "Cancel") then return; end
    -- process item
    local raidNum = MRT_AskCostQueue[1]["RaidNum"];
    local itemNum = MRT_AskCostQueue[1]["ItemNum"];
    local looter = MRT_GetDKPValueFrame.Looter;
    if (button == "OK") then
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"] = looter;
        MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"] = dkpValue;
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Note"] = lootNote;
    elseif (button == "Cancel") then
    elseif (button == "Delete") then
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"] = "_deleted_";
        MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"] = 0;
    elseif (button == "Bank") then
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"] = "bank";
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Note"] = lootNote;
        MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"] = 0;
    elseif (button == "Disenchanted") then
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Looter"] = "disenchanted";
        MRT_RaidLog[raidNum]["Loot"][itemNum]["Note"] = lootNote;
        MRT_RaidLog[raidNum]["Loot"][itemNum]["DKPValue"] = 0;
    end
    -- notify registered, external functions
    if (#MRT_ExternalLootNotifier > 0) then
        local itemInfo = {};
        for key, val in pairs(MRT_RaidLog[raidNum]["Loot"][itemNum]) do
            itemInfo[key] = val;
        end
        if (itemInfo.Looter == "bank") then
            itemInfo.Action = MRT_LOOTACTION_BANK;
        elseif (itemInfo.Looter == "disenchanted") then
            itemInfo.Action = MRT_LOOTACTION_DISENCHANT;
        elseif (itemInfo.Looter == "_deleted_") then
            itemInfo.Action = MRT_LOOTACTION_DELETE;
        else
            itemInfo.Action = MRT_LOOTACTION_NORMAL;
        end
        for i, val in ipairs(MRT_ExternalLootNotifier) do
            pcall(val, itemInfo, MRT_NOTIFYSOURCE_ADD_POPUP, raidNum, itemNum);
        end
    end
    -- done with handling item - proceed to next one
    table.remove(MRT_AskCostQueue, 1);
    if (#MRT_AskCostQueue == 0) then
        MRT_AskCostQueueRunning = nil;
        -- queue finished, delete itemes which were marked as deleted - FIXME!
    else
        MRT_DKPFrame_AskCost();
    end    
end

function ErrorDKP_LCD_DropDownList_Toggle()
    -- if (ErrorDKP_LCD_DropDownList.frame:IsShown()) then
    --     ErrorDKP_LCD_DropDownList.frame:Hide();
    -- else
    --     ErrorDKP_LCD_DropDownList.frame:Show();
    --     ErrorDKP_LCD_DropDownList.frame:SetPoint("TOPRIGHT", UI.LootConfirmDialog.DdButton, "BOTTOMRIGHT", 0, 0);
    -- end
end

local function ErrorDKP_LCD_Handler()

end

function ErrorDKP:CreateLootConfirmDialog()
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
        core:PrintDebug("OnEnterPressed")
    end)
    priceinput:SetScript("OnEscapePressed", function()
        core:PrintDebug("OnEscapePressed")
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
        core:PrintDebug("OnEnterPressed")
    end)
    noteinput:SetScript("OnEscapePressed", function()
        core:PrintDebug("OnEscapePressed")
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
    dissButton:SetText("Disentchanted")
    dissButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("DISENTCHANTED") 
    end)

    local ddButton = CreateFrame("Button", nil, f)
    UI.LootConfirmDialog.DdButton = ddButton
    ddButton:SetSize(16,16)
    ddButton:SetPoint("LEFT", textline3, "RIGHT")
    --ddButton:SetText("Disentchanted")
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
    local ttarea = CreateFrame("FRAME", nil, IUParent)
    ttarea:SetSize(100,12)
    ttarea:EnableMouse(true)
    ttarea:SetPoint("CENTER", textline2, "CENTER")
    ttarea:SetScript("OnEnter", function()
        core:PrintDebug("ttarea onenter")
    end)
    ttarea:SetScript("OnLeave", function()
        core:PrintDebug("ttarea onleave")
    end)


end