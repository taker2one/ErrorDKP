--###############################################
--#  Project: ErrorDKP
--#  File: tooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 27.04.2020
--###############################################
local addonName, core = ...
local UI = core.UI
local ErrorDKP = core.ErrorDKP
local Tooltip = {}
ErrorDKP.Tooltip = Tooltip
local _L = core._L

function Tooltip:ShowTooltipBottom(owner, title, ...)
    Tooltip:ShowTooltip(owner, "ANCHOR_BOTTOM", title, ...)
end

function Tooltip:ShowTooltipRight(owner, title, ...)
    Tooltip:ShowTooltip(owner, "ANCHOR_RIGHT", title, ...)
end

function Tooltip:ShowTooltip(owner, anchorType, title, ...)
    GameTooltip:SetOwner(owner, anchorType)
    GameTooltip:SetText(title, 1.0, 0.82, 0)
    
    for i=1, select("#", ...) do
      local line = select(i, ...)
      if (type(line) == "function") then line = line() end
      if (type(line) == "table") then line = unpack(line) end
      GameTooltip:AddLine(line, 1, 1, 1, true)
    end
    
    GameTooltip:Show()
end

function Tooltip:Hide()
    GameTooltip:Hide()
end
  