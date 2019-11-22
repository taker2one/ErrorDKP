--###############################################
--#  Project: ErrorDKP
--#  File: itemtooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local UI = core.UI
local ErrorDKP = core.ErrorDKP

local function CreateItemToolTip()
    core:PrintDebug("CreateItemToolTip")
    UI.ItemTooltip = CreateFrame("GameTooltip", "ErrorDKPItemToolTip", UIParent, "GameTooltipTemplate")
    return UI.ItemTooltip
end

function ErrorDKP:ShowItemTooltip(newOwner, itemLink)
    local tt = UI.ItemTooltip or CreateItemToolTip()

    tt:SetOwner(newOwner, "ANCHOR_RIGHT")
    tt:SetHyperlink(itemLink)
    tt:Show()
end

function ErrorDKP:HideItemTooltip()
    local tt = UI.ItemTooltip or CreateItemToolTip()
    tt:Hide()
    tt:SetOwner(UIParent, "ANCHOR_NONE")
end