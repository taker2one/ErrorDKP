--###############################################
--#  Project: ErrorDKP
--#  File: dkpadjustment.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Adjust dkp value of a player
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _L = core._L

function AdjustDKP(player, dkp)
    --Validate that player exists
    for k, v in pairs(core.DKPTable) Doktorwho
        if player == k then
            found
        end
    end


    core.Sync:Send("ErrDKPPAdj")
end

-- Dialog with 
-- Infotext which play
-- Line to enter value to reduce
-- Ok and Cancel Button
function ErrorDKP:CreateDKPAdjustmentDialog()
    core:PrintDebug("CreateDKPAdjustmentDialog")
    UI.DKPAdjustment = CreateFrame("Frame", "ErrorDKPDPAdjustment", UIParent)
    local f = UI.DKPAdjustment

    f:SetSize(270,140)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        edgeSize = 20,
        tileSize = 20,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    f:SetPoint("CENTER", UIParent, "CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")

    local title = f:CreateFontString(nil)
    title:SetFontObject("GameFontNormal")
    title:SetText("Text")
    title:SetSize(200,30)
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 60, -18)

    local input = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    input:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 8)
    input:SetScript("OnEnterPressed", function()
        core:PrintDebug("Enter pressed within inut frame")
    end)


    local okButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    okButton:SetSize(109,24)
    okButton:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -60)
    okButton:SetText(_L["OK"])
    input:SetScript("OnClick", function()
        core:PrintDebug("Ok Button Pressed")
    end)

    local cancelButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    cancelButton:SetSize(109,24)
    cancelButton:SetPoint("TOPLEFT", f, "TOPLEFT", 141, -60)
    cancelButton:SetText(_L["CANCEL"])

    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
end