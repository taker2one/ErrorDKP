--###############################################
--#  Project: ErrorDKP
--#  File: lootmlsetupsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 27.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
ErrorDKP.MLSetupSurvey = {}
local MLSetupSurvey = core.ErrorDKP.MLSetupSurvey

local ScrollingTable = LibStub("ScrollingTable")


local surveyInProgress = nil

local colDef = {
    { name = "", width = 30, ["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
        cellFrame:SetNormalTexture("Interface/BUTTONS/UI-GroupLoot-Pass-Up.png")
        cellFrame:SetScript("OnClick", function() 
            core:PrintDebug("Remove Item from LootList")
            MLSetupSurvey:RemoveItem(realrow) 
        end)
        cellFrame:SetSize(20,20)
    end},  -- remove button
    { name = "", width = 40, ["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
        local icon = self:GetCell(realrow, column) or "Interface/ICONS/INV_Sigil_Thorim.png"
        local link = self:GetCell(realrow, 3)
        cellFrame:SetNormalTexture(icon)
        cellFrame:SetScript("OnClick", function()
            if IsModifiedClick() then
               HandleModifiedItemClick(link);
            end
        end)
    end},  -- icon
    { name = "", width = 100 }  -- itemlink/name
}

local function buildDataForTable(data)
    local t = {}

    for i,v in ipairs(data) do
        local row = {
            "",
            v.icon,
            v.itemLink,
        }

        table.insert(t, row)
    end
    return t
end

function MLSetupSurvey:Update()

end

function MLSetupSurvey:Show(lootTable)
    core:PrintDebug("MLSetupSurvey:Show", lootTable)

    local f = self:GetFrame()
    f:Show()

    if lootTable then
        local rows = buildDataForTable(lootTable)
        f.ScrollingTable:SetData(rows, true)
    end
end

function MLSetupSurvey:RemoveItem(index)
    core:PrintDebug("MLSetupSurvey:RemoveItem")
    ErrorDKP:RemoveFromLootTable(index)
    self:Show(core.LootTable)
end

function MLSetupSurvey:Cancel()
    core.UI.MLSetupSurvey:Hide()
    core.UI.MLSetupSurvey.ScrollingTable:SetData({})
    table.wipe(core.LootTable)
    table.wipe(core.LootSlotInfos)
    core:PrintDebug("MLSetupSurvey canceled")
end

function MLSetupSurvey:CreateFrame()
    core.UI.MLSetupSurvey = core:CreateDefaultFrame("ErrorDKPSetupLootSurvey", "Setup", 260, 305, false, true)
    local f = core.UI.MLSetupSurvey
    f:SetPoint("CENTER", UIParent, "CENTER")
    f:SetScript("OnMouseUp", self.OnMouseUp)

    local scrollingTable = ScrollingTable:CreateST(colDef, 5, 40, nil, f)
	scrollingTable.frame:SetPoint("TOPLEFT",f,"TOPLEFT",10,-20)
	scrollingTable:RegisterEvents({
		["OnClick"] = function(_, _, _, _, row, realrow)
			if not (row or realrow) then
				return true
			end
		end
    })
    f.ScrollingTable = scrollingTable
    
    local startButton = core:CreateButton(f, "StartButton", "Start 60 sec")
    startButton:SetWidth(100)
	startButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 15, 50)
	startButton:SetScript("OnClick", function()
		
		if not core.LootTable or #core.LootTable == 0 then
			core:Print("Its not possible to start survey with empty list.")
			return
		end
        ErrorDKP:StartSurvey(60)
		self:Cancel()
	end)
    f.StartButton = startButton
    
    local longStartButton = core:CreateButton(f, "LongStartButton", "Start 120 sec")
    longStartButton:SetWidth(100)
	longStartButton:SetPoint("LEFT", startButton, "RIGHT", 0, 0)
	longStartButton:SetScript("OnClick", function()
		
		if not core.LootTable or #core.LootTable == 0 then
			core:Print("Its not possible to start survey with empty list.")
			return
		end
        ErrorDKP:StartSurvey()
		self:Cancel()
	end)
	f.LongStartButton = longStartButton

	-- Cancel button
    local cancelButton = core:CreateButton(f, "CancelButton", "Cancel")
    cancelButton:SetWidth(80)
	cancelButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -15, 20)
	cancelButton:SetScript("OnClick", function()
		core.LootTable = {}
		self:Cancel()
	end)
	f.cancelButton = cancelButton

    f:SetWidth(scrollingTable.frame:GetWidth()+20)
    
    f:Hide()
    return f
end

function MLSetupSurvey:GetFrame()
    local f = core.UI.MLSetupSurvey or self:CreateFrame()
    return f
end

function MLSetupSurvey:AddCursorItem()
    if CursorHasItem() then
      local infoType, itemID, itemLink = GetCursorInfo()
  
      if (infoType == "item") then
        core:PrintDebug(infoType, itemID, itemLink)
         --self.list:Add(itemID)
         self:AddItemById(itemID)
      end
  
      ClearCursor()
    end
end

function MLSetupSurvey:OnMouseUp()
    MLSetupSurvey:AddCursorItem()
end

function MLSetupSurvey:AddItemById(itemId)
    core:PrintDebug("MLSetupSurvey:AddItemById", itemId)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
    if not itemName then return end -- should not happen

    tinsert(core.LootTable,{
        name = itemName,
        itemLink = itemLink,
        quantity = 1,
        quality = itemRarity,
        icon = itemTexture,
        sourceGuid = "BAG",
        lootframeIndex = 0
    })

    self:Show(core.LootTable)
end