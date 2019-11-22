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
    core:PrintDebug("Toogle Main Window")
    core.UI.Main = core.UI.Main or ErrorDKP:CreateMain()
    core.UI.Main:SetShown(not core.UI.Main:IsShown())
    core.UI.Main:SetClampedToScreen(true)
end

function ErrorDKP:CreateMain()
    --
    -- Create The Main Windows
    --
    ErrorDKP.UIMain = CreateFrame("Frame", "ErrorDKPMain", UIParent, "UIPanelDialogTemplate")
    local uiMain = ErrorDKP.UIMain


    ErrorDKP.UIMain:SetSize(550, 590);
    ErrorDKP.UIMain:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    ErrorDKP.UIMain:SetMovable(true);
    ErrorDKP.UIMain:EnableMouse(true);
    ErrorDKP.UIMain:RegisterForDrag("LeftButton");
    ErrorDKP.UIMain:SetScript("OnDragStart", ErrorDKP.UIMain.StartMoving);
    ErrorDKP.UIMain:SetScript("OnDragStop", ErrorDKP.UIMain.StopMovingOrSizing);

    -- Add Title
    uiMain.Title:ClearAllPoints()
    uiMain.Title:SetFontObject("GameFontHighlight")
    uiMain.Title:SetPoint("LEFT", ErrorDKPMainTitleBG, "LEFT", 5 , 0)
    uiMain.Title:SetText("WoW Error Venoxis DKP")

    ---
    -- Append DKP Table
    --
    ErrorDKP:CreateDKPScrollingTable()

    uiMain:Hide()
    return ErrorDKP.UIMain

end