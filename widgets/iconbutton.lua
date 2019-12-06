--###############################################
--#  Project: ErrorDKP
--#  File: iconbutton.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 06.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

local function Desaturate(button)
    return button:GetNormalTexture():SetDesaturated(true)
 end

local function SetBorderColor(button, color)
    if color == "green" then
        button:SetBackdropBorderColor(0,1,0,1) -- green
        button:GetNormalTexture():SetVertexColor(0.8,0.8,0.8)
    elseif color == "yellow" then
        button:SetBackdropBorderColor(1,1,0,1) -- yellow
        button:GetNormalTexture():SetVertexColor(1,1,1)
    elseif color == "grey" or color == "gray" then
        button:SetBackdropBorderColor(0.75,0.75,0.75,1)
        button:GetNormalTexture():SetVertexColor(1,1,1)
    elseif color == "red" then
        button:SetBackdropBorderColor(1,0,0,1)
        button:GetNormalTexture():SetVertexColor(1,1,1)
    elseif color == "purple" then
        button:SetBackdropBorderColor(0.65,0.4,1,1)
        button:GetNormalTexture():SetVertexColor(1,1,1)
    else -- Default to white
        button:SetBackdropBorderColor(1,1,1,1) -- white
        button:GetNormalTexture():SetVertexColor(0.5,0.5,0.5)
    end
end
 

function ErrorDKP:CreateIconButton(parent, name, texture)
    core:PrintDebug("CreateIconButton")
    local b = CreateFrame("Button", name, parent)
    b:SetSize(40,40)
    b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    b:GetHighlightTexture():SetBlendMode("ADD")
    b:SetNormalTexture(texture or "Interface\\InventoryItems\\WoWUnknownItem01")
    b:GetNormalTexture():SetDrawLayer("BACKGROUND")
    b:SetBackdrop({
        bgFile = "",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 18,
    })
    --b:SetScript("OnLeave", addon.UI.HideTooltip)
    b:EnableMouse(true)
    b:RegisterForClicks("AnyUp")
    b.SetBorderColor = function(self, color) 
            SetBorderColor(self, color)
    end
    b.Desaturate = function(self)
        Desaturate(self)
    end

	return b
end