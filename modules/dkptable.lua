--###############################################
--#  Project: ErrorDKP
--#  File: dkptable.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Create and manage the dkp table
--#  Last Edit: 11.03.2020
--###############################################
local addonName, core = ...;
local ErrorDKP = core.ErrorDKP;
local UI = core.UI;
local _L = core._L
local _LS = _L.DKPLISTTABLE

local ScrollingTable = LibStub("ScrollingTable")

local TableUpdatePending = true

function ErrorDKP:DKPTableUpdateIfPending()
    if TableUpdatePending then
        TableUpdatePending = false
        ErrorDKP:DKPTableUpdate()
    end
end

function ErrorDKP:DKPTableUpdate()
    if not UI.DKPTable or not UI.DKPTable.frame:IsShown() then 
        TableUpdatePending = true
        return 
    end -- UI not created yet, no need to update table
    core:PrintDebug("ErrorDKP:DKPTableUpdate")
    local DKPTableData = {}
    local index = 1
    for i, v in ipairs(core.DKPTable) do
        local classInfo = C_CreatureInfo.GetClassInfo(v.classId)
        local classColor = core.ClassColors[v["classFilename"]].hex
        local classString = string.format("|cFF%s%s|r", classColor, classInfo.className)
        local playerNameColored = string.format("|cFF%s%s|r", classColor, v["name"])
        

        DKPTableData[index] = { index,  classInfo.classFile, playerNameColored, v.name, classString , v.dkp}
        index = index + 1
    end
    --table.sort(DKPTableData, function(a, b) return (a[6] > b[6]); end);
    UI.DKPTable:ClearSelection()
    UI.DKPTable:SetData(DKPTableData, true)
    UI.DKPTable:SortData()

    -- Update Time string on top
    UI.DKPTable.DataTime:SetText(' - ' .. core:ToDateString(core:GetLocalDKPDataTimestamp()))

end

local menu = {
      { text = "Select an Option", isTitle = true, notCheckable = true},
      { text = "Adjust DKP", notCheckable = true, func = function() 
        local selection = UI.DKPTable:GetSelection()
        if selection then
          ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 4))
        end
      end }
  }


--  We need to sort by name cause name is colored
function NameSort(table, rowa, rowb, sortbycol)
    local column = table.cols[sortbycol]
    
    local a, b = string.lower(table:GetCell(rowa, 4)), string.lower(table:GetCell(rowb, 4))
    if a==b then
        return false
    else
        local direction = column.sort or column.defaultsort or ScrollingTable.SORT_ASC
        if direction == ScrollingTable.SORT_ASC then
			return a < b;
		else
			return a > b;
		end
    end
end

function ClassSort(table, rowa, rowb, sortbycol)

    local column = table.cols[sortbycol]
    core:Error("ClassSort", column.sort, column.defaultsort)
    local direction = column.sort or column.defaultsort or "asc"
    
    -- local a, b = string.lower(table:GetCell(rowa, 4)), string.lower(table:GetCell(rowb, 4))
    -- if a==b then
    --     return false
    -- else
    --     local direction = column.sort or column.defaultsort or "asc"
    --     if direction == "asc" then
	-- 		    return a < b;
	-- 	else
	-- 		return a > b;
	-- 	end
    -- end

    local a, b = string.lower(table:GetCell(rowa, sortbycol)), string.lower(table:GetCell(rowb, sortbycol))
    if a == b then
		if column.sortnext then
			local nextcol = table.cols[column.sortnext];
			if nextcol and not(nextcol.sort) then
				if nextcol.comparesort then
					return nextcol.comparesort(table, rowa, rowb, column.sortnext);
				else
					return table:CompareSort(rowa, rowb, column.sortnext);
				end
			end
		end
		return false
	elseif not a or not b then return true
	else
		if direction == "asc" then
			return a < b;
		else
			return a > b;
		end
	end
end

local tableDef = {
  { ["name"] = "", ["width"] = 1 },
  { ["name"] = "", ["width"] = 15, 
	["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...) 
		if fShow then
			local class = self:GetCell(realrow, column)
			if class then
				cellFrame:SetNormalTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"); -- this is the image containing all class icons
				local coords = CLASS_ICON_TCOORDS[class]; -- get the coordinates of the class icon we want
				cellFrame:GetNormalTexture():SetTexCoord(unpack(coords)); -- cut out the region with our class icon according to coords
			else -- if there's no class
				cellFrame:SetNormalTexture("Interface/ICONS/INV_Sigil_Thorim.png")
			end
		end
    end}, -- classIcon
  { ["name"] = _LS["COLNAME"], ["width"] = 100, ["comparesort"] = NameSort},
  { ["name"] = "", ["width"] = 1}, -- pure playername to append to other dialogs
  { ["name"] = _LS["COLCLASS"], ["width"] = 80, ["sortnext"] = 6, ["defaultsort"] = ScrollingTable.SORT_ASC},
  { ["name"] = _LS["COLDKP"], ["width"] = 50, ["defaultsort"] = ScrollingTable.SORT_DSC, ["sort"] =  ScrollingTable.SORT_DSC}
}

local function tableFilter(self, row)
    if not core.Settings.ShowOnlyRaidmembers then return true end 
    if core.Settings.ShowOnlyRaidmembers
    then
        if not UnitInRaid("player") and not UnitInParty("player") then return false end
        local cnt = GetNumGroupMembers()
        local i = 1
        while i <= cnt do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
            i = i + 1
            if string.lower(name) == string.lower(row[4]) then return true end
            
        end
    end
end

function ErrorDKP:CreateDKPScrollingTable()
    UI.DKPTable = ScrollingTable:CreateST(tableDef, 33, nil, nil, UI.Main)
    UI.DKPTable.frame:SetPoint("TOPLEFT", ErrorDKPMainDialogBG, "TOPLEFT", 10, -40);
    UI.DKPTable.frame:SetPoint("BOTTOMLEFT", ErrorDKPMainDialogBG, "BOTTOMLEFT", 0, 27);
    UI.DKPTable:EnableSelection(true)

    -- Title
    local title = UI.DKPTable.frame:CreateFontString(nil)
    title:SetFontObject("GameFontNormal")
    title:SetText(_LS["TITLE"])
    title:SetPoint("TOPLEFT", UI.DKPTable.frame, "TOPLEFT", 0, 30)

    local dataTime = UI.DKPTable.frame:CreateFontString("DKPSTDataTime")
    dataTime:SetFontObject("GameFontWhite")
    dataTime:SetText("- None")
    dataTime:SetPoint("TOPLEFT", title, "TOPRIGHT", 0, 0)
    UI.DKPTable.DataTime = dataTime


    local adjustDKPButton = CreateFrame("Button", nil, UI.DKPTable.frame, "UIPanelButtonTemplate")
    adjustDKPButton:SetSize(109,24)
    adjustDKPButton:SetPoint("TOPRIGHT", UI.DKPTable.frame, "BOTTOMRIGHT", 0,0)
    adjustDKPButton:SetText("Adjust")
    adjustDKPButton:SetScript("OnClick", function(self, ...)
      local selection = UI.DKPTable:GetSelection()
      if selection then
        ErrorDKP:StartAdjustment(UI.DKPTable:GetCell(selection, 4))
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

    local checkBtnRaid = CreateFrame("CheckButton", nil, UI.DKPTable.frame, "UICheckButtonTemplate")
    UI.DKPTable.CheckBtnShowOnlyRaidmembers = checkBtnRaid
    checkBtnRaid:SetPoint("TOPLEFT", UI.DKPTable.frame, "BOTTOMLEFT", 0, 4);
    checkBtnRaid.text:SetText(_LS["CHECKBTN_SHOWONLYRAIDMEMBERS"])
    checkBtnRaid:SetChecked(core.Settings.ShowOnlyRaidmembers)
    checkBtnRaid:SetScript("OnClick", function(self)
        core.Settings.ShowOnlyRaidmembers = self:GetChecked()
        ErrorDKP:DKPTableUpdate()
    end)

    if not core:CheckSelfTrusted() then
      adjustDKPButton:Hide()
    end
    UI.DKPTable:SetFilter(tableFilter)
    ErrorDKP:DKPTableUpdate()

    return UI.DKPTable
end

function ErrorDKP:BroadcastDKPTable()
  if core:CheckSelfTrusted() then
    core.Sync:Send("ErrDKPDKPSync", {ATS=core:GetDKPDataTimestamp(), DataSet=core.DKPTable })
    --core.Sync:SendTo("ErrDKPDKPSync", {ATS=core:GetDKPDataTimestamp(), DataSet=core.DKPTable }, "Karaffe")
  else
    core:Print(_L["MSG_NOT_ALLOWED"])
  end
end

function ErrorDKP:GetPlayerDKP(playerName)
  for i, v in ipairs(core.DKPTable) do
      if string.lower(v.name) == string.lower(playerName) then return v.dkp end
  end
  return nil
end