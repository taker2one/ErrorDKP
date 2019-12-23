--###############################################
--#  Project: ErrorDKP
--#  File: lootmlsetupsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 06.12.2019
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
        --frame:SetScript("OnEnter", function() addon:CreateHypertip(link) end)
        --frame:SetScript("OnLeave", function() addon:HideTooltip() end)
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
    core:PrintDebug("MLSetupSurvey canceled")
end

function MLSetupSurvey:CreateFrame()
    core.UI.MLSetupSurvey = core:CreateDefaultFrame("ErrorDKPSetupLootSurvey", "Setup", 260, 305)
    local f = core.UI.MLSetupSurvey
    f:SetPoint("CENTER", UIParent, "CENTER")

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
    
	local startButton = core:CreateButton(f, "StartButton", "Start")
	startButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 10, 10)
	startButton:SetScript("OnClick", function()
		
		if not core.LootTable or #core.LootTable == 0 then
			core:Print("Its not possible to start survey with empty list.")
			return
		end
        ErrorDKP:StartSurvey()
		self:Cancel()
	end)
	f.StartButton = startButton

	-- Cancel button
	local cancelButton = core:CreateButton(f, "CancelButton", "Cancel")
	cancelButton:SetPoint("LEFT", startButton, "RIGHT", 15, 0)
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