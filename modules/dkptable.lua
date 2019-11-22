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

local ScrollingTable = LibStub("ScrollingTable")

function DKPTable_OnClick(self)   
  local offset = FauxScrollFrame_GetOffset(UI.DKPTable) or 0
  local index, TempSearch;
  SelectedRow = self.index

  if UIDROPDOWNMENU_OPEN_MENU then
    ToggleDropDownMenu(nil, nil, menuFrame)
  end

  if IsShiftKeyDown() then
    if LastSelection < SelectedRow then
      for i=LastSelection+1, SelectedRow do
        TempSearch = MonDKP:Table_Search(core.SelectedData, core.WorkingTable[i].player);
        
        if not TempSearch then
          tinsert(core.SelectedData, core.WorkingTable[i])
        end
      end
    else
      for i=SelectedRow, LastSelection-1 do
        TempSearch = MonDKP:Table_Search(core.SelectedData, core.WorkingTable[i].player);
        
        if not TempSearch then
          tinsert(core.SelectedData, core.WorkingTable[i])
        end
      end
    end

    if MonDKP.ConfigTab2.selectAll:GetChecked() then
      MonDKP.ConfigTab2.selectAll:SetChecked(false)
    end
  elseif IsControlKeyDown() then
    LastSelection = SelectedRow;
    TempSearch = MonDKP:Table_Search(core.SelectedData, core.WorkingTable[SelectedRow].player);
    if TempSearch == false then
      tinsert(core.SelectedData, core.WorkingTable[SelectedRow]);
      PlaySound(808)
    else
      tremove(core.SelectedData, TempSearch[1][1])
      PlaySound(868)
    end
  else
    LastSelection = SelectedRow;
    for i=1, core.TableNumRows do
      TempSearch = MonDKP:Table_Search(core.SelectedData, core.WorkingTable[SelectedRow].player);
      if MonDKP.ConfigTab2.selectAll:GetChecked() then
        MonDKP.ConfigTab2.selectAll:SetChecked(false)
      end
      if (TempSearch == false) then
        tinsert(core.SelectedData, core.WorkingTable[SelectedRow]);
        PlaySound(808)
      else
        core.SelectedData = {}
      end
    end
  end

  DKPTable_Update()
  --MonDKPSelectionCount_Update()
end

local function CreateRow(parent, id, width, rowHeight)
    local f = CreateFrame("Button", "$parentLine"..id, parent)
    f.DKPInfo = {}
    f:SetSize(width, rowHeight)
    --f:SetHighlightTexture("Interface\\AddOns\\MonolithDKP\\Media\\Textures\\ListBox-Highlight");
    f:SetNormalTexture("Interface\\COMMON\\talent-blue-glow")
    f:GetNormalTexture():SetAlpha(0.2)
    f:SetScript("OnClick", DKPTable_OnClick)
    for i=1, 3 do
      f.DKPInfo[i] = f:CreateFontString(nil, "OVERLAY");
      f.DKPInfo[i]:SetFontObject("GameFontNormal")
      f.DKPInfo[i]:SetTextColor(1, 1, 1, 1);
      if (i==1) then
        f.DKPInfo[i].rowCounter = f:CreateFontString(nil, "OVERLAY");
        f.DKPInfo[i].rowCounter:SetFontObject("GameFontNormal")
        f.DKPInfo[i].rowCounter:SetTextColor(1, 1, 1, 0.3);
        f.DKPInfo[i].rowCounter:SetPoint("LEFT", f, "LEFT", 3, -1);
      end
      if (i==3) then
        f.DKPInfo[i]:SetFontObject("GameFontNormal")
        f.DKPInfo[i].adjusted = f:CreateFontString(nil, "OVERLAY");
        f.DKPInfo[i].adjusted:SetFontObject("GameFontNormal")
        f.DKPInfo[i].adjusted:SetScale("0.8")
        f.DKPInfo[i].adjusted:SetTextColor(1, 1, 1, 0.6);
        f.DKPInfo[i].adjusted:SetPoint("LEFT", f.DKPInfo[3], "RIGHT", 3, -1);

        -- if MonDKP_DB.modes.mode == "Roll Based Bidding" then
        --   f.DKPInfo[i].rollrange = f:CreateFontString(nil, "OVERLAY");
        --   f.DKPInfo[i].rollrange:SetFontObject("MonDKPSmallOutlineLeft")
        --   f.DKPInfo[i].rollrange:SetScale("0.8")
        --   f.DKPInfo[i].rollrange:SetTextColor(1, 1, 1, 0.6);
        --   f.DKPInfo[i].rollrange:SetPoint("CENTER", 115, -1);
        -- end

        -- f.DKPInfo[i].adjustedArrow = f:CreateTexture(nil, "OVERLAY", nil, -8);
        -- f.DKPInfo[i].adjustedArrow:SetPoint("RIGHT", f, "RIGHT", -10, 0);
        -- f.DKPInfo[i].adjustedArrow:SetColorTexture(0, 0, 0, 0.5)
        -- f.DKPInfo[i].adjustedArrow:SetSize(8, 12);
      end
    end
    f.DKPInfo[1]:SetPoint("LEFT", 30, 0)
    f.DKPInfo[2]:SetPoint("CENTER")
    f.DKPInfo[3]:SetPoint("RIGHT", -80, 0)


    f:SetScript("OnMouseDown", function(self, button)
      if button == "RightButton" then
        RightClickMenu(self)
      end
    end)

    return f
end

function DKPTableUpdate()
  local DKPTableData = {}
  local index = 1
  for k, v in pairs(core.DKPTableWorkingEntries) do
    DKPTableData[index] = { index,  v.name, v.dkp}
    index = index + 1
  end
  table.sort(DKPTableData, function(a, b) return (a[3] > b[3]); end);
  UI.DKPTable:ClearSelection()
  UI.DKPTable:SetData(DKPTableData, true)
end

function DKPTable_Update()
  if not UI.Main:IsShown() then     -- does not update list if DKP window is closed. Gets done when /dkp is used anyway.
    return;
  end

  local numOptions = #core.DKPTableWorkingEntries
  local index, row, c
  local offset = FauxScrollFrame_GetOffset(MonDKP.DKPTable) or 0
  local rank, rankIndex;

  for i=1, core.ISettings.DKPSettings.RowCount do     -- hide all rows before displaying them 1 by 1 as they show values
    row = UI.DKPTable.Rows[i];
    row:Hide();
  end

  for i=1, core.ISettings.DKPSettings.RowCount do     -- show rows if they have values
    row = UI.DKPTable.Rows[i]
    index = offset + i
    if core.DKPTableWorkingEntries[index] then

      c = MonDKP:GetCColors(core.DKPTableWorkingEntries[index].class);
      row:Show()
      row.index = index
      local CurPlayer = core.DKPTableWorkingEntries[index].name;
      
      -- if core.CenterSort == "rank" then
      --   local SetRank = MonDKP:Table_Search(MonDKP_DKPTable, core.WorkingTable[index].player)
      --   rank, rankIndex = MonDKP:GetGuildRank(core.WorkingTable[index].player)
      --   MonDKP_DKPTable[SetRank[1][1]].rank = rankIndex or 20;
      --   MonDKP_DKPTable[SetRank[1][1]].rankName = rank or "None";
      -- end
      row.DKPInfo[1]:SetText(core.DKPTableWorkingEntries[index].name)
      row.DKPInfo[1].rowCounter:SetText(index)
      row.DKPInfo[1]:SetTextColor(c.r, c.g, c.b, 1)
      
      -- if core.CenterSort == "class" then
      --   row.DKPInfo[2]:SetText(core.LocalClass[core.WorkingTable[index].class])
      -- elseif core.CenterSort == "rank" then
      --   row.DKPInfo[2]:SetText(rank)
      -- elseif core.CenterSort == "spec" then
      --   if core.WorkingTable[index].spec then
      --     row.DKPInfo[2]:SetText(core.WorkingTable[index].spec)
      --   else
      --     row.DKPInfo[2]:SetText("No Spec Reported")
      --   end
      -- elseif core.CenterSort == "role" then
      --   row.DKPInfo[2]:SetText(core.WorkingTable[index].role)
      -- end
      
      -- row.DKPInfo[3]:SetText(MonDKP_round(core.WorkingTable[index].dkp, MonDKP_DB.modes.rounding))
      -- local CheckAdjusted = core.WorkingTable[index].dkp - core.WorkingTable[index].previous_dkp;
      -- if(CheckAdjusted > 0) then 
      --   CheckAdjusted = strjoin("", "+", CheckAdjusted) 
      --   row.DKPInfo[3].adjustedArrow:SetTexture("Interface\\AddOns\\MonolithDKP\\Media\\Textures\\green-up-arrow.png");
      -- elseif (CheckAdjusted < 0) then
      --   row.DKPInfo[3].adjustedArrow:SetTexture("Interface\\AddOns\\MonolithDKP\\Media\\Textures\\red-down-arrow.png");
      -- else
      --   row.DKPInfo[3].adjustedArrow:SetTexture(nil);
      -- end        
      -- row.DKPInfo[3].adjusted:SetText("("..MonDKP_round(CheckAdjusted, MonDKP_DB.modes.rounding)..")");

      -- local a = MonDKP:Table_Search(core.SelectedData, core.DKPTableWorkingEntries[index].name);  -- searches selectedData for the player name indexed.
      -- if(a==false) then
      --   MonDKP.DKPTable.Rows[i]:SetNormalTexture("Interface\\COMMON\\talent-blue-glow")
      --   MonDKP.DKPTable.Rows[i]:GetNormalTexture():SetAlpha(0.2)
      -- else
      --   MonDKP.DKPTable.Rows[i]:SetNormalTexture("Interface\\AddOns\\MonolithDKP\\Media\\Textures\\ListBox-Highlight")
      --   MonDKP.DKPTable.Rows[i]:GetNormalTexture():SetAlpha(0.7)
      -- end
      -- if core.WorkingTable[index].player == UnitName("player") and #core.SelectedData == 0 then
      --   row.DKPInfo[2]:SetText("|cff00ff00"..row.DKPInfo[2]:GetText().."|r")
      --   row.DKPInfo[3]:SetText("|cff00ff00"..MonDKP_round(core.WorkingTable[index].dkp, MonDKP_DB.modes.rounding).."|r")
      --   MonDKP.DKPTable.Rows[i]:GetNormalTexture():SetAlpha(0.7)
      -- end
      -- MonDKP.DKPTable.Rows[i]:SetScript("OnEnter", function(self)
      --   DisplayUserHistory(self, CurPlayer)
      -- end)
      -- MonDKP.DKPTable.Rows[i]:SetScript("OnLeave", function()
      --   GameTooltip:Hide()
      -- end)
    else
      row:Hide()
    end
  end
  -- MonDKP.DKPTable.counter.t:SetText(#core.WorkingTable.." "..L["ENTRIESSHOWN"]);    -- updates "Entries Shown" at bottom of DKPTable
  -- MonDKP.DKPTable.counter.t:SetFontObject("MonDKPSmallLeft")

  FauxScrollFrame_Update(MonDKP.DKPTable, numOptions, core.TableNumRows, core.TableRowHeight, nil, nil, nil, nil, nil, nil, true) -- alwaysShowScrollBar= true to stop frame from hiding
end

local tableDef = {
  { ["name"] = "", ["width"] = 1 },
  { ["name"] = "Name", ["width"] = 150 },
  { ["name"] = "DKP", ["width"] = 80, ["defaultsort"] = "dsc" }
}

function ErrorDKP:CreateDKPScrollingTable()
    UI.DKPTable = ScrollingTable:CreateST(tableDef, 34, nil, nil, UI.Main)
    UI.DKPTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 10, -25);
    UI.DKPTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    UI.DKPTable:EnableSelection(true)

    DKPTableUpdate()
end

function ErrorDKP:CreateDKPTable()
    UI.DKPTable = CreateFrame("ScrollFrame", "ErrorDKPTableScrollFrame", UI.Main, "UIPanelScrollFrameTemplate")
    local dkptable = UI.DKPTable
    local tableSettings = core.ISettings.DKPTable

    --dkptable:SetSize(tableSettings.Width, tableSettings.RowHeight*tableSettings.RowCount);
    dkptable:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 4, -8)
    dkptable:SetPoint("BOTTOMRIGHT", ErrorDKPMainDialogBG, "BOTTOMRIGHT", -3, 4)    
    dkptable:SetClipsChildren(false)

    --Scrollchild
    local child = CreateFrame("Frame", nil, dkptable)
    child:SetSize(tableSettings.Width, tableSettings.RowHeight*tableSettings.RowCount)
    
    child.bg = child:CreateTexture(nil, "BACKGROUND")
    child.bg:SetAllPoints(true)
    child.bg:SetColorTexture(0.2,0.6,0,0.8);
    dkptable:SetScrollChild(child)

    --dkptable.ScrollBar = 

    dkptable.Rows = {}
    for i=1, tableSettings.RowCount do
        dkptable.Rows[i] = CreateRow(dkptable, i, tableSettings.Width, tableSettings.RowHeight)
        if i==1 then
            dkptable.Rows[i]:SetPoint("TOPLEFT", dkptable, "TOPLEFT", 0, -2)
        else  
            dkptable.Rows[i]:SetPoint("TOPLEFT", dkptable.Rows[i-1], "BOTTOMLEFT")
        end
      end
      dkptable:SetScript("OnVerticalScroll", function(self, offset)
       core.PrintDebug("OnVerticalScroll", offset)
       core.PrintDebug(self:GetVerticalScroll())
       --FauxScrollFrame_OnVerticalScroll(self, offset, core.TableRowHeight, DKPTable_Update)
      end)

    -- UIConfig.ScrollFrame:SetPoint("TOPLEFT", ERRORDKPListFrameDialogBG, "TOPLEFT", 4, -8)
    -- UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", ERRORDKPListFrameDialogBG, "BOTTOMRIGHT", -3, 4)
    -- 

    -- -- Scroll child
    -- local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame)
    -- child:SetSize(308,500)
    -- --UIConfig.ScrollFrame.Scroll
    -- UIConfig.ScrollFrame:SetScrollChild(child)

    -- UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
    -- UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12,-18)
    -- UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7,18)
end