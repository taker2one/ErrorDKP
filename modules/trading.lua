--###############################################
--#  Project: ErrorDKP
--#  File: trading.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 27.04.2020
--###############################################
local addonName, core = ...
local UI = core.UI
local ErrorDKP = core.ErrorDKP
local Trading = {}
ErrorDKP.Trading = Trading
local _L = core._L

local playerItems = {}
local partnerItems = {}
local playerGold = ""
local partnerGold = ""
local partnerName = ""
local partnerGuild = ""

local specificListener = {}

local function UpdateItemInfo(id, unit, items)
    local name, texture, numItems, quality, isUsable, enchantment, itemLink
  
    if(unit=="PARTNER") then
      name, texture, numItems, quality, isUsable, enchantment = GetTradeTargetItemInfo(id);
      itemLink =  GetTradeTargetItemLink(id);
    else
      name, texture, numItems, quality, enchantment = GetTradePlayerItemInfo(id);
      itemLink = GetTradePlayerItemLink(id);
    end
  
    if(not name) then
      items[id] = nil;
      return;
    end
    

    items[id] = {
        name = name,
        enchantment = enchantment,
        itemLink = itemLink
    }
end



local function ResetInfo()
    playerGold = ""
    playerItems = {}
    partnerGold = ""
    partnerItems = {}
    partnerName = ""
    partnerGuild = ""

    table.wipe(specificListener)
end

function Trading:AddSpecificListener(item, callback)

    for i,v in ipairs(specificListener) do
        if v.item == item and callback == callback then 
            core:PrintDebug("Callback for item already added => skip")
            return
        end
    end
    core:PrintDebug("Add callback for item", item)
    table.insert(specificListener, { item = item, callback = callback })
end

function Trading:HandleEvent(event, ...)
    core:PrintDebug("Trading:HandleEvent", event)
    local arg1, arg2, arg3 = ...

    if event == "TRADE_TARGET_ITEM_CHANGED" then
        UpdateItemInfo(arg1, "PARTNER", partnerItems)
    elseif event == "TRADE_SHOW" then
        partnerName = GetUnitName("npc", false) -- For some reason this gives us the name of the trade partner
        partnerGuild = GetGuildInfo("npc")
        core:PrintDebug("Trading with", partnerName, partnerGuild)
    elseif (event=="TRADE_ACCEPT_UPDATE") then
        local tradeSlot
        for tradeSlot = 1, 7 do
          UpdateItemInfo(tradeSlot, "PLAYER", playerItems);
          UpdateItemInfo(tradeSlot, "PARTNER", partnerItems);
        end
        playerGold = GetPlayerTradeMoney()
        partnerGold = GetTargetTradeMoney()
    elseif event == "ERR_TRADE_CANCELLED" then
        ResetInfo()
    elseif event == "ERR_TRADE_COMPLETE" then
        if #specificListener > 0 then
            for i,v in ipairs(specificListener) do

                for key,item in pairs(playerItems) do
                    if item.itemLink == specificListener[i].item then
                        core:PrintDebug("Found listener for item:", item.itemLink, specificListener[i].item)
                        specificListener[i].callback(partnerName, partnerGuild, item.itemLink, playerGold, partnerGold, playerItems, partnerItems)
                    end
                end

            end
            table.wipe(specificListener)
        end
    end
end