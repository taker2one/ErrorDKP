--###############################################
--#  Project: ErrorDKP
--#  File: ErrorDKP.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 21.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

-- Toggle Main Window
function ErrorDKP:Toggle()
    core:PrintDebug("Toggle Main Window")
    core.UI.Main = core.UI.Main or ErrorDKP:CreateMain()
    core.UI.Main:SetShown(not core.UI.Main:IsShown())
    core.UI.Main:SetClampedToScreen(true)
end

function ErrorDKP:CreateMain()
    --
    -- Create The Main Windows
    --
    core.UI.Main = CreateFrame("Frame", "ErrorDKPMain", UIParent, "UIPanelDialogTemplate")
    tinsert(UISpecialFrames, "ErrorDKPMain")  
    local uiMain = core.UI.Main

    uiMain:SetFrameLevel(9)
    uiMain:SetSize(1165, 590) --1000
    uiMain:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    uiMain:SetMovable(true)
    uiMain:EnableMouse(true)
    uiMain:RegisterForDrag("LeftButton")
    uiMain:SetScript("OnDragStart", uiMain.StartMoving)
    uiMain:SetScript("OnDragStop", uiMain.StopMovingOrSizing)
    uiMain:SetScript("OnShow", function() 
        PlaySound(567440) 
        core:PrintDebug("ErrorDKPMain", "OnShow")
    end)
    uiMain:SetScript("OnHide", function() 
        PlaySound(567496)
    end)

    -- Add Title
    uiMain.Title:ClearAllPoints()
    uiMain.Title:SetFontObject("GameFontHighlight")
    uiMain.Title:SetPoint("CENTER", ErrorDKPMainTitleBG, "CENTER", 5 , 0)
    uiMain.Title:SetText("WoW Error - Venoxis DKP")

    ---
    -- Append DKP Table
    --
    ErrorDKP:CreateDKPScrollingTable()

    --
    -- Append Price List Table
    --
    ErrorDKP:CreatePriceListTable()

    --
    -- Append Loot History Table
    --
    ErrorDKP:GetLootHistoryTable()

    uiMain:Hide()
    return uiMain

end