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

local function UpdateDataTimestamp()
    core.DKPDataInfo["DKPInfo"]["timestamp"] = core:GenerateTimestamp()
    return core.DKPDataInfo["DKPInfo"]["timestamp"]
end



function AdjustDKP(player, dkp)
    core:PrintDebug("AdjustDKP", player, dkp) 
    -- only allowed for officers
    if core:CheckSelfTrusted() then
        --Validate that player exists
        local entry, oldTimestamp, newTimestamp;
        for i, v in ipairs(core.DKPTable) do
            if v["name"] == player then
                v["dkp"] = v["dkp"] + dkp
                entry = v
                oldTimestamp = core:GetDKPDataTimestamp()
                newTimestamp = UpdateDataTimestamp()
                break
            end
        end
        if entry then
            core:PrintDebug("send: ", oldTimestamp, newTimestamp)
            core.Sync:Send("ErrDKPAdjP", { PTS = oldTimestamp, ATS = newTimestamp, DataSet = entry, Details = { DKP = dkp } })
            ErrorDKP:DKPTableUpdate()
        else 
            core:Print(string.format(_L["MSG_PLAYER_NOT_FOUND_DKP"], player)) 
        end
    end
end

function ErrorDKP:AutoAdjustDKP(player, dkp, itemLink)
    if core:CheckSelfTrusted() then
        --Validate that player exists
        local entry, oldTimestamp, newTimestamp;
        for i, v in ipairs(core.DKPTable) do
            if v["name"] == player then
                v["dkp"] = v["dkp"] + dkp
                entry = v
                oldTimestamp = core:GetDKPDataTimestamp()
                newTimestamp = UpdateDataTimestamp()
                break
            end
        end
        if entry then
            core.Sync:Send("ErrDKPAdjPA", { PTS = oldTimestamp, ATS = newTimestamp, DataSet = entry, Details = { DKP = dkp, ItemLink = itemLink }})
            core:Print(string.format(_L["MSG_DKP_ADJUST_AUTO"], player, dkp, itemLink ))
            ErrorDKP:DKPTableUpdate()
        else 
            core:Print(string.format(_L["MSG_PLAYER_NOT_FOUND_DKP"], player)) 
        end
    end
end

function DKPAdjustmentDialog_OnOk()
    local val = UI.DKPAdjustment.DkpInput:GetNumber()
    if val > 0 or val < 0 then
        local player = UI.DKPAdjustment.player:GetText()
        core:PrintDebug(UI.DKPAdjustment.player:GetText(), val)
        AdjustDKP(player, val)
        UI.DKPAdjustment:Hide()
    else
        core:PrintDebug("Input is not a number")
    end
end

function ErrorDKP:StartAdjustment(player)
    local dialog = UI.DKPAdjustment or ErrorDKP:CreateDKPAdjustmentDialog()
    dialog.player:SetText(player)
    dialog.DkpInput:SetText("")
    dialog:Show()
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
    f:SetFrameLevel(15)

    -- local title = f:CreateFontString(nil)
    -- title:SetFontObject("GameFontNormal")
    -- title:SetText("Text")
    -- title:SetSize(200,30)
    -- title:SetPoint("TOPLEFT", f, "TOPLEFT", 60, -18)

    local player = f:CreateFontString(nil)
    UI.DKPAdjustment.player = player
    player:SetFontObject("GameFontNormal")
    player:SetText("Text")
    player:SetSize(270,30)
    player:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -15)

    local input = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    UI.DKPAdjustment.DkpInput = input
    input:SetPoint("TOPLEFT", f, "TOPLEFT", 23,-60)
    input:SetSize(225, 25)
    input:SetMultiLine(false)
    input:SetScript("OnEnterPressed", function()
        UI.DKPAdjustment.OkButton:Click()
    end)

    local okButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    UI.DKPAdjustment.OkButton = okButton
    okButton:SetSize(109,24)
    okButton:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -100)
    okButton:SetText(_L["OK"])
    okButton:SetScript("OnClick", DKPAdjustmentDialog_OnOk)

    local cancelButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    cancelButton:SetSize(109,24)
    cancelButton:SetPoint("TOPLEFT", f, "TOPLEFT", 141, -100)
    cancelButton:SetText(_L["CANCEL"])
    cancelButton:SetScript("OnClick", function(self, ...)
        f:Hide()
        core:PrintDebug("Cancel Button Pressed")
    end)

    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()

    return f
end