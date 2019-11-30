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
local _L = core._L
local _LS = _L.DKPLISTTABLE

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

local menu = {
      { text = "Select an Option", isTitle = true, notCheckable = true},
      { text = "Adjust DKP", notCheckable = true, func = function() 
        local selection = UI.DKPTable:GetSelection()
        if selection then
          ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 3))
        end
      end }
  }

local tableDef = {
  { ["name"] = "", ["width"] = 1 },
  { ["name"] = _LS["COLNAME"], ["width"] = 100,
  -- ["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
  --   cellFrame:SetScript("OnMouseUp", function(self, button)
  --       if button == 'RightButton' then 
  --             core:PrintDebug(RightButton)
  --             ErrorDKP:ConextMenu(menu)
  --       end
  --   end)
  -- end,
  },
  { ["name"] = "", ["width"] = 1}, -- pure playername to append to other dialogs
  { ["name"] = _LS["COLCLASS"], ["width"] = 80},
  { ["name"] = _LS["COLDKP"], ["width"] = 50, ["defaultsort"] = "dsc" }
}

function ErrorDKP:CreateDKPScrollingTable()
    UI.DKPTable = ScrollingTable:CreateST(tableDef, 33, nil, nil, UI.Main)
    UI.DKPTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 10, -40);
    UI.DKPTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 10);
    UI.DKPTable:EnableSelection(true)

    -- Title
    local title = UI.DKPTable.frame:CreateFontString("$parent_title")
    title:SetFontObject("GameFontNormal")
    title:SetText(_LS["TITLE"])
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

    -- Register ContextMenu
    UI.DKPTable:RegisterEvents({
      ["OnMouseDown"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
          local button = ...
          if button == "RightButton" then
              core:PrintDebug("DKPTable RightButton clicked")
              scrollingTable:SetSelection(realrow)
              -- There is currently ony one entry so do it the easy way and hide whole menu
              if core:CheckSelfTrusted() then
                  ErrorDKP:ConextMenu(menu)
              end
          end
  
          --[[ return true to have your event override the default one
               return false, or nothing at all to have the deafult handler 
                  processed after yours.
               The default OnClick handler for example, handles column sorting clicks.
               if row and realrow are nil, then this is a column header cell ]]--
          
      end
    })

    if not core:CheckSelfTrusted() then
      adjustDKPButton:Hide()
    end

    ErrorDKP:DKPTableUpdate()
end

function ErrorDKP:BroadcastDKPTable()
  if core:CheckSelfTrusted() then
    core.Sync:Send("ErrDKPDKPSync", {ATS=core:GetDKPDataTimestamp(), DataSet=core.DKPTable })
  else
    core:Print(_L["MSG_NOT_ALLOWED"])
  end
end