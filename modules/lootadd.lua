--###############################################
--#  Project: ErrorDKP
--#  File: lootadd.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Manually add loot to lootlist
--#  Last Edit: 19.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L
ErrorDKP.LootTracker = {}
local LootTracker = ErrorDKP.LootTracker

local function test()
    ErrorDKP:GetDropDownTable()
end

function LootTracker:OnChatEdit_InsertLink(link)
    if core.UI.LootAddFrame and core.UI.LootAddFrame:IsVisible() then
        if core.UI.LootAddFrame.ItemInput:HasFocus() then
            core:PrintDebug("LootTracker:OnChatEdit_InsertLink", link)
            core.UI.LootAddFrame.ItemInput:SetText(link)
        end
    end
end

function LootTracker:Handler(t)
    if t == "CANCEL" then
        self:GetAddFrame():Hide()
    end
end

function LootTracker:CreateAddFrame()
    core.UI.LootAddFrame = core:CreateDefaultFrame("ErrorDKP_LootAddFrame", "Add Loot", 365, 285, true)
    local f = core.UI.LootAddFrame;
    f:SetPoint("CENTER", UIParent, "CENTER")
    f:SetFrameLevel(25)
    f:EnableMouse(true)
    f:EnableKeyboard(true)

    --Item
    f.ItemLabel = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local itemLabel = f.ItemLabel
    itemLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 50, -90)
    itemLabel:SetText(_L["ITEM"])

    f.ItemInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local itemInput = f.ItemInput
    itemInput:SetPoint("TOPLEFT", itemLabel, "BOTTOMLEFT", 8)
    itemInput:SetSize(250, 32)
    itemInput:SetMultiLine(false)
    itemInput:EnableMouse(true)
    itemInput:EnableKeyboard(true)
    itemInput:SetScript("OnEnterPressed", function()
        LootTracker:Handler("OK")
    end)
    itemInput:SetScript("OnEscapePressed", function()
        LootTracker:Handler("CANCEL")
    end)
    itemInput:SetScript("OnTabPressed", function()
        priceInput:SetFocus()
    end)

    --price
    f.PriceLabel = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    local priceLabel = f.PriceLabel
    priceLabel:SetPoint("LEFT", itemInput, "TOPLEFT", 0, -40)
    priceLabel:SetText(_L["PRICE"])

    -- price input
    f.PriceInput = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    local priceInput = f.PriceInput
    priceInput:SetPoint("TOPLEFT", priceLabel, "BOTTOMLEFT", 8)
    priceInput:SetSize(250, 32)
    priceInput:SetMultiLine(false)
    priceInput:SetScript("OnEnterPressed", function()
        LootTracker:Handler("OK")
    end)
    priceInput:SetScript("OnEscapePressed", function()
        LootTracker:Handler("CANCEL")
    end)
    priceInput:SetScript("OnTabPressed", function()
        itemInput:SetFocus()
    end)

    --Buttons
    local okButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.OkButton = okButton
    okButton:SetSize(95,22)
    okButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 62)
    okButton:SetText(_L["OK"])
    okButton:SetScript("OnClick", function() 
        LootTracker:Handler("OK")
    end)

    local cancelButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.CancelButton = cancelButton
    cancelButton:SetSize(95,22)
    cancelButton:SetPoint("LEFT", okButton, "RIGHT", 15, 0)
    cancelButton:SetText(_L["CANCEL"])
    cancelButton:SetScript("OnClick", function()
        LootTracker:Handler("CANCEL")
    end)

    local bankButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.BankButton = bankButton
    bankButton:SetSize(95,22)
    bankButton:SetPoint("TOP", cancelButton, "BOTTOM", 0, -15)
    bankButton:SetText("Bank")
    bankButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("BANK") 
    end)

    local dissButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    f.DissButton = dissButton
    dissButton:SetSize(95,22)
    dissButton:SetPoint("LEFT", bankButton, "RIGHT", 15, 0)
    dissButton:SetText("Disenchanted")
    dissButton:SetScript("OnClick", function()
         ErrorDKP_LCD_Handler("DISENCHANTED") 
    end)

    local ddButton = CreateFrame("Button", nil, f)
    f.DdButton = ddButton
    ddButton:SetSize(16,16)
    ddButton:SetPoint("LEFT", textline3, "RIGHT")
    ddButton:SetScript("OnClick", ErrorDKP_LCD_DropDownList_Toggle)
    ddButton:CreateTexture()
    ddButton.normalTexture = ddButton:CreateTexture(nil)
    ddButton.normalTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    ddButton.normalTexture:SetSize(16,16)
    ddButton.normalTexture:SetPoint("RIGHT")
    ddButton.pushedTexture = ddButton:CreateTexture(nil)
    ddButton.pushedTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    ddButton.pushedTexture:SetSize(16,16)
    ddButton.pushedTexture:SetPoint("RIGHT")
    ddButton.highlightTexture = ddButton:CreateTexture(nil)
    ddButton.highlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    ddButton.highlightTexture:SetSize(16,16)
    ddButton.highlightTexture:SetPoint("RIGHT")

    ddButton:SetNormalTexture(ddButton.normalTexture)
    ddButton:SetPushedTexture(ddButton.pushedTexture)
    ddButton:SetHighlightTexture(ddButton.highlightTexture)

    --for tooltip
    local ttarea = CreateFrame("FRAME", nil, f)
    f.ttarea = ttarea
    ttarea:SetSize(100,12)
    ttarea:EnableMouse(true)
    ttarea:SetPoint("CENTER", textline2, "CENTER")
    ttarea:SetScript("OnEnter", function(self)
        ErrorDKP:ShowItemTooltip(self, f.Textline2:GetText())
    end)
    ttarea:SetScript("OnLeave", function()
        ErrorDKP:HideItemTooltip()
    end)

    return f
end

function LootTracker:GetAddFrame()
    local f = core.UI.LootAddFrame or self:CreateAddFrame()
    return f
end

