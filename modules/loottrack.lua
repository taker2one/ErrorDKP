--###############################################
--#  Project: ErrorDKP
--#  File: loottrack.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Brodacast/Receive to/from other clients
--#  Last Edit: 23.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

local deformat = LibStub("LibDeformat-3.0");

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