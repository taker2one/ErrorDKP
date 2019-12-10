--###############################################
--#  Project: ErrorDKP
--#  File: itemtooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 10.12.2019
--###############################################
local addonName, core = ...
local UI = core.UI
local ErrorDKP = core.ErrorDKP
local _L = core._L

local function CreateItemToolTip()
    core:PrintDebug("CreateItemToolTip")
    UI.ItemTooltip = CreateFrame("GameTooltip", "ErrorDKPItemToolTip", UIParent, "GameTooltipTemplate")
    return UI.ItemTooltip
end

function ErrorDKP:GetItemTooltip()
    local tt  = UI.ItemTooltip  or CreateItemToolTip()
    return tt 
end

function ErrorDKP:ShowItemTooltip(newOwner, itemLink)
    local tt = ErrorDKP:GetItemTooltip()

    tt:SetOwner(newOwner, "ANCHOR_RIGHT")
    tt:SetHyperlink(itemLink)
    tt:Show()
end

function ErrorDKP:HideItemTooltip()
    local tt = ErrorDKP:GetItemTooltip()
    tt:Hide()
    tt:SetOwner(UIParent, "ANCHOR_NONE")
end