--###############################################
--#  Project: ErrorDKP
--#  File: itemtooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local UI = core.UI
local ErrorDKP = core.ErrorDKP
local _L = core._L

local function CreateItemToolTip()
    core:PrintDebug("CreateItemToolTip")
    UI.ItemTooltip = CreateFrame("GameTooltip", "ErrorDKPItemToolTip", UIParent, "GameTooltipTemplate")
    --hooksecurefunc(core.UI.ItemTooltip, "SetHyperlink", ErrorDKP:OnSetHyperlink )
    return UI.ItemTooltip
end
CreateItemToolTip()

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