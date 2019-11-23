--###############################################
--#  Project: ErrorDKP
--#  File: itemtooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local UI = core.UI

function ErrorDKP:CreateLootNeedSurveyFrame()
    core:PrintDebug("CreateLootNeedSurveyFrame")
    UI.LootNeedSurvey = CreateFrame("Frame", "ErrorDKPLootSurveyFrame", UIParent)
    local f = UI.LootNeedSurvey

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

    local IconButton = CreateFrame("Button", nil, f)
    IconButton:SetSize(30,30)
    IconButton:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -20)

    local closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    --closeButton:SetSize(18,18)
    closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    --closeButton:SetText("Passen")

    local button1 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    button1:SetSize(109,24)
    button1:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -60)
    button1:SetText("Berdarf")

    local button2 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    button2:SetSize(109,24)
    button2:SetPoint("TOPLEFT", f, "TOPLEFT", 141, -60)
    button2:SetText("Offspec")

    local button3 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    button3:SetSize(109,24)
    button3:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -90)
    button3:SetText("Button1")
    button3:Hide()

    local button4 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    button4:SetSize(109,24)
    button4:SetPoint("TOPLEFT", f, "TOPLEFT", 141, -90)
    button4:SetText("Passen")

    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
end