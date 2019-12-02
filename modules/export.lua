--###############################################
--#  Project: ErrorDKP
--#  File: export.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Export Frame and routines
--#  Last Edit: 30.11.2019
--###############################################
local addonName, core = ...
-- This is what erroritemimport wants
-- <items>
-- 			<item>
-- 				<name>Eskhandar's Collar</name>
-- 				<time>1574802838</time>
-- 				<member>disenchanted</member>
-- 				<itemid>18205::::::::60:::::::</itemid>
-- 				<cost>0</cost>
-- 				<boss>Onyxia</boss>
-- 			</item>
-- 		</items>

local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _LS = core._L.EXPORTDIALOG


-- ["ItemId"] = itemId,
-- ["ItemLink"] = itemLink,
-- ["Looter"] = looter,
-- ["Dkp"] = dkp,
-- ["Time"] = lootTime

local function CreateItemString(item)

    -- validate
    if not item
    or not item["ItemId"]
    --or not item["time"]
    or not item["Looter"]
    or not(item["Dkp"] >= 0)
    then
       return nil 
    end

    local xml = '<item>'
    xml = xml .. '<name>'..item["ItemId"]..'</name>'
    xml = xml .. '<member>'..item["Looter"]..'</member>'
    xml = xml .. '<itemid>'..item["ItemId"]..'</itemid>'
    xml = xml .. '<cost>'..item["Dkp"]..'</cost>'

    xml = xml..'</item>'
    return xml
end


local function CreateExportFrame()
    UI.ExportFrame = CreateFrame("frame", "ErrorDKPExportFrame", UIParent)
    local f = UI.ExportFrame;
    f:SetSize(450,250)
    f:SetMovable(true)
    f:SetFrameLevel(15)
    f:EnableMouse(true)
    --f:Hide()
    f:SetPoint("TOP", UIParent, "TOP", 0, -20)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        edgeSize = 32,
        tileSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local texture = f:CreateTexture(nil, "ARTWORK")
    texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    texture:SetSize(300,64)
    texture:SetPoint("TOP", core.UI.ExportFrame, "TOP", 0, 12)

    -- Title
    UI.ExportFrame.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local title = UI.ExportFrame.Title
    title:SetPoint("TOP", UI.ExportFrame, "TOP", 0, -2)
    title:SetText(_LS["TITLE"])

    UI.ExportFrame.ScrollFrame = CreateFrame("ScrollFrame", ErrorDKPExportFrame_Scroll, UI.ExportFrame, "UIPanelScrollFrameTemplate")
    local scrollFrame = UI.ExportFrame.ScrollFrame
    scrollFrame:SetSize(350,150)
    scrollFrame:SetPoint("TOP", UI.ExportFrame, "TOP", -10, -40)

    local editBox = CreateFrame("EditBox", nil, UI.ExportFrame)
    UI.ExportFrame.EditBox = editBox
    editBox:SetSize(350,150)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetScript("OnEscapePressed", function()
        UI.ExportFrame:Hide()
    end)
    editBox:SetText("<item><name>Eskhandar's Collar</name><time>1574802838</time><member>disenchanted</member><itemid>18205::::::::60:::::::</itemid><cost>0</cost><boss>Onyxia</boss></item>")
    --editBox:HighlightText()
    scrollFrame:SetScrollChild(editBox)

    local closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")

    closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)

    local border = CreateFrame("Frame", nil, UI.ExportFrame)
    border:SetSize(386,160)
    border:SetPoint("TOP", UI.ExportFrame, "TOP", 0, -35 )
    border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })

    local helpText = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    helpText:SetPoint("CENTER", UI.ExportFrame, "BOTTOM", 0, 30)
    helpText:SetText(_LS["HELPTEXT"])
    
    --scrollFrame:SetScript("OnEscapePressed", UI.ExportFrame.Hide)
    f:Hide()
    return f
end

function ErrorDKP:GetExportFrame()
    local f = UI.ExportFrame or CreateExportFrame()
    return f
end

function ErrorDKP:ShowExportFrame(xml)
    core:PrintDebug("ShowExportFrame")
    local frame = ErrorDKP:GetExportFrame()

    -- if frame still open append instead of overwrite
    if frame:IsShown() then
        frame.EditBox:SetText( frame.EditBox:GetText()..xml)
    else
        frame.EditBox:SetText(xml)
    end
    frame.EditBox:HighlightText()
    frame:Show()
end

function ErrorDKP:CreatePlusXML(items)
    local xml = ''
    for i=1, #items do
        local ret = CreateItemString(items[i])
        if ret then
            xml = xml..ret
        else
            core:Print("Error exporting item.")
        end
    end
    return xml
end

function ErrorDKP:ExportItems(items)
    local a
    if not items then return; end
    if type(items) ~= table then a = {items}
    else a = items; end

    local xml = ErrorDKP:CreatePlusXML(a)
    ErrorDKP:ShowExportFrame(xml)
end