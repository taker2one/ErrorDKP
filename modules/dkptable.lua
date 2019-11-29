--###############################################
--#  Project: ErrorDKP
--#  File: dkptable.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Create and manage the dkp table
--#  Last Edit: 21.11.2019
--###############################################
local addonName, core = ...;
local ErrorDKP = core.ErrorDKP;
local UI = core.UI;
local _L = core._L.DKPLISTTABLE

local ScrollingTable = LibStub("ScrollingTable")



function ErrorDKP:DKPTableUpdate()
  if not UI.DKPTable then return end -- UI not created yet, no need to update table

  local DKPTableData = {}
  local index = 1
  for i, v in ipairs(core.DKPTable) do
    local classInfo = C_CreatureInfo.GetClassInfo(v.classId)
    local classColor = core.ClassColors[v["classFilename"]].hex
    local classString = string.format("|cFF%s%s|r", classColor, classInfo.className)
    local playerNameColored = string.format("|cFF%s%s|r", classColor, v["name"])
    

    DKPTableData[index] = { index,  playerNameColored, v.name, classString , v.dkp}
    index = index + 1
  end
  table.sort(DKPTableData, function(a, b) return (a[5] > b[5]); end);
  UI.DKPTable:ClearSelection()
  UI.DKPTable:SetData(DKPTableData, true)
end

local tableDef = {
  { ["name"] = "", ["width"] = 1 },
  { ["name"] = _L["COLNAME"], ["width"] = 100 },
  { ["name"] = "", ["width"] = 1}, -- pure playername to append to other dialogs
  { ["name"] = "Class", ["width"] = 80},
  { ["name"] = _L["COLDKP"], ["width"] = 50, ["defaultsort"] = "dsc" }
}

function ErrorDKP:CreateDKPScrollingTable()
    UI.DKPTable = ScrollingTable:CreateST(tableDef, 33, nil, nil, UI.Main)
    UI.DKPTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 10, -40);
    UI.DKPTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    UI.DKPTable:EnableSelection(true)

    -- Title
    local title = UI.DKPTable.frame:CreateFontString("$parent_title")
    title:SetFontObject("GameFontNormal")
    title:SetText(_L["TITLE"])
    title:SetPoint("TOPLEFT", UI.DKPTable.frame, "TOPLEFT", 0, 30)


    local adjustDKPButton = CreateFrame("Button", nil, UI.DKPTable.frame, "UIPanelButtonTemplate")
    adjustDKPButton:SetSize(109,24)
    adjustDKPButton:SetPoint("TOPLEFT", UI.DKPTable.frame, "BOTTOMLEFT", 0,0)
    adjustDKPButton:SetText("Adjust")
    adjustDKPButton:SetScript("OnClick", function(self, ...)
      local selection = UI.DKPTable:GetSelection()
      if selection then
        ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 3))
      end
    end)

    if not core:IsOfficer() then
      adjustDKPButton:Hide()
    end

    --MRT_GUI_RaidLogTable:GetCell()
    --:GetSelection

    ErrorDKP:DKPTableUpdate()
end

-- function ErrorDKP:CreateDKPTable()
--     UI.DKPTable = CreateFrame("ScrollFrame", "ErrorDKPTableScrollFrame", UI.Main, "UIPanelScrollFrameTemplate")
--     local dkptable = UI.DKPTable
--     local tableSettings = core.ISettings.DKPTable

--     --dkptable:SetSize(tableSettings.Width, tableSettings.RowHeight*tableSettings.RowCount);
--     dkptable:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 4, -8)
--     dkptable:SetPoint("BOTTOMRIGHT", ErrorDKPMainDialogBG, "BOTTOMRIGHT", -3, 4)    
--     dkptable:SetClipsChildren(false)

--     --Scrollchild
--     local child = CreateFrame("Frame", nil, dkptable)
--     child:SetSize(tableSettings.Width, tableSettings.RowHeight*tableSettings.RowCount)
    
--     child.bg = child:CreateTexture(nil, "BACKGROUND")
--     child.bg:SetAllPoints(true)
--     child.bg:SetColorTexture(0.2,0.6,0,0.8);
--     dkptable:SetScrollChild(child)

--     --dkptable.ScrollBar = 

--     dkptable.Rows = {}
--     for i=1, tableSettings.RowCount do
--         dkptable.Rows[i] = CreateRow(dkptable, i, tableSettings.Width, tableSettings.RowHeight)
--         if i==1 then
--             dkptable.Rows[i]:SetPoint("TOPLEFT", dkptable, "TOPLEFT", 0, -2)
--         else  
--             dkptable.Rows[i]:SetPoint("TOPLEFT", dkptable.Rows[i-1], "BOTTOMLEFT")
--         end
--       end
--       dkptable:SetScript("OnVerticalScroll", function(self, offset)
--        core.PrintDebug("OnVerticalScroll", offset)
--        core.PrintDebug(self:GetVerticalScroll())
--        --FauxScrollFrame_OnVerticalScroll(self, offset, core.TableRowHeight, DKPTable_Update)
--       end)

--     -- UIConfig.ScrollFrame:SetPoint("TOPLEFT", ERRORDKPListFrameDialogBG, "TOPLEFT", 4, -8)
--     -- UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", ERRORDKPListFrameDialogBG, "BOTTOMRIGHT", -3, 4)
--     -- 

--     -- -- Scroll child
--     -- local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame)
--     -- child:SetSize(308,500)
--     -- --UIConfig.ScrollFrame.Scroll
--     -- UIConfig.ScrollFrame:SetScrollChild(child)

--     -- UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
--     -- UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12,-18)
--     -- UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7,18)
-- end