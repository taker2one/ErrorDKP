--###############################################
--#  Project: ErrorDKP
--#  File: lootmlsetupsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 11.03.2020
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _LS = core._L["ML_SURVEY_RESULT"]
local _L = core._L

ErrorDKP.MLResult = {}
local MLResult = ErrorDKP.MLResult

local ScrollingTable = LibStub("ScrollingTable")

local itemIndex = 0
local itemButtons = {}
local visualUpdatePending = nil
local activeSurvey
local CountdownActive = false
local timerFrame = CreateFrame("Frame")

local responseSortOrder = {
	["PENDING"] = 5,
	["MAIN"] = 1,
	["SECOND"] = 2,
	["PASS"] = 10,
	["TIMEOUT"] = 7,
	["OFFLINE"] = 6,
	["OFFSPEC"] = 3,
	["TWINK"] = 4
}

local RACE_ICON_TCOORDS = {
	["HUMAN_2"]		= {0, 0.25, 0, 0.25},
	["DWARF_2"]		= {0.25, 0.5, 0, 0.25},
	["GNOME_2"]		= {0.5, 0.75, 0, 0.25},
	["NIGHTELF_2"]	= {0.75, 1.0, 0, 0.25},
	
	["TAUREN_2"]		= {0, 0.25, 0.25, 0.5},
	["SCOURGE_2"]	= {0.25, 0.5, 0.25, 0.5},
	["TROLL_2"]		= {0.5, 0.75, 0.25, 0.5},
	["ORC_2"]		= {0.75, 1.0, 0.25, 0.5},

	["HUMAN_3"]	= {0, 0.25, 0.5, 0.75},  
	["DWARF_3"]	= {0.25, 0.5, 0.5, 0.75},
	["GNOME_3"]	= {0.5, 0.75, 0.5, 0.75},
	["NIGHTELF_3"]	= {0.75, 1.0, 0.5, 0.75},
	
	["TAUREN_3"]	= {0, 0.25, 0.75, 1.0},   
	["SCOURGE_3"]	= {0.25, 0.5, 0.75, 1.0}, 
	["TROLL_3"]	= {0.5, 0.75, 0.75, 1.0}, 
	["ORC_3"]		= {0.75, 1.0, 0.75, 1.0}, 
}



function ResponseSort(table, rowa, rowb, sortbycol)

	local column = table.cols[sortbycol]
	local a, b = table:GetRow(rowa), table:GetRow(rowb);
	--a
	if core.ActiveSurveyData.items[itemIndex].responses[a[3]] then
		a = responseSortOrder[core.ActiveSurveyData.items[itemIndex].responses[a[3]][1]]
	else
		a = responseSortOrder["OFFLINE"]
	end
	--b
	if core.ActiveSurveyData.items[itemIndex].responses[b[3]] then
		b = responseSortOrder[core.ActiveSurveyData.items[itemIndex].responses[b[3]][1]]
	else
		b = responseSortOrder["OFFLINE"]
	end

	core:PrintDebug("ResponseSort",a,b)

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
		local direction = column.sort or column.defaultsort or 1
		if direction == 1 then
			return a < b;
		else
			return a > b;
		end
	end
end

local colDef = {
	{ ["name"] = "", ["width"] = 20,
	["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...) 
		if fShow then
			local class = self:GetCell(realrow, column)
			if class then
				cellFrame:SetNormalTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES") 	-- this is the image containing all class icons
				local coords = CLASS_ICON_TCOORDS[class]														-- get the coordinates of the class icon we want
				cellFrame:GetNormalTexture():SetTexCoord(unpack(coords)) 										-- cut out the region with our class icon according to coords
			else -- if there's no class
				cellFrame:SetNormalTexture("Interface/ICONS/INV_Sigil_Thorim.png")
			end
		end
	end}, -- classIcon
	{ ["name"] = "", ["width"] = 20,
	["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...) 
		if fShow then
			local racegender = self:GetCell(realrow, column)
			core:PrintDebug("racegender", racegender[1], racegender[2] )
			if racegender and racegender[1] and racegender[2] then
				local genderText
				cellFrame:SetNormalTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-RACES") 	-- this is the image containing all race icons
				local coords = RACE_ICON_TCOORDS[strupper(racegender[1]).."_"..racegender[2]]							-- get the coordinates of the race icon we want

				if coords then
					cellFrame:GetNormalTexture():SetTexCoord(unpack(coords)) 	-- cut out the region with our class icon according to coords
				else
					cellFrame:SetNormalTexture("Interface/ICONS/INV_Misc_QuestionMark")
				end
			else -- if there's no class
				cellFrame:SetNormalTexture("Interface/ICONS/INV_Misc_QuestionMark")
			end
		end
	end}, -- raceIcon
    { ["name"] = _LS["COLPLAYER"], ["width"] = 150 }, -- PlayerName
   -- { ["name"] = "", ["width"] = 20 }, -- Guild Rank
    { ["name"] = "", ["width"] = 1}, -- ResponseType
	{ ["name"] = _LS["COLRESPONSE"], ["width"] = 200, ["comparesort"]=ResponseSort, ["sortnext"] = 6, ["defaultsort"] = "asc"  }, -- Answer
	{ ["name"] = _LS["COLDKP"], ["width"] = 60 },
	{ ["name"] = _LS["COLHASITEM"], ["width"] = 60,
	["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...) 
		if fShow then
			local hasItem = self:GetCell(realrow, column)
			if tonumber(hasItem) > 0 then 
				cellFrame.text:SetText(_LS["HASITEM"])
			elseif tonumber(hasItem) == 0 then
				cellFrame.text:SetText(_LS["HASNOTITEM"])
			else
				cellFrame.text:SetText(" ")
			end
		end
	end 
	},
	{ ["name"] = _LS["COLROLL"], ["width"] = 60 }
}

MLResult.DemoSurveyData = {
    id = "157564448499",
	items = {
		{
            ["index"] = 1,
            ["name"] = "Arcanist Crown",
            ["itemLink"] = "|cffa335ee|Hitem:16795::::::::60:::::::|h[Arcanist Crown]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_pants_07",
			["responses"] = {
				["Rassputin"] = { "OFFSPEC", 0, 99 },
			},
			["closed"] = nil
        },
        {
            ["index"] = 2,
            ["name"] = "Giantstalker's Gloves",
            ["itemLink"] = "|cffa335ee|Hitem:16852::::::::60:::::::|h[Giantstalker's Gloves]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_gauntlets_10",
			["responses"] = {
				["Rassputin"] = { "MAIN", 1 },
				["Doktorwho"] = { "SECOND", 0 }
			},
			["closed"] = true
        },
        {
            ["index"] = 3,
            ["name"] = "Mageweave Cloth",
            ["itemLink"] = "|cffffffff|Hitem:4338::::::::60:::::::|h[Mageweave Cloth]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_fabric_mageweave_01",
			["responses"] = {
				["Doktorwho"] = { "OFFSPEC", 0, 55 },
				["Rassputin"] = { "SECOND", 1 },
			},
			["closed"] = nil
        },

	},
	players = {
		{
			["name"] = "Doktorwho",
			["classFileName"] = "PRIEST",
			["race"] = "Troll",
			["gender"] = "2"
		},
		{
			["name"] = "Repa",
			["classFileName"] = "MAGE",
			["race"] = "Scourge",
			["gender"] = "2"
		},
		{
			["name"] = "Rassputin",
			["classFileName"] = "MAGE",
			["race"] = "Scourge",
			["gender"] = "2"
		},
		{
			["name"] = "Repawareff",
			["classFileName"] = "MAGE",
			["race"] = "Scourge",
			["gender"] = "2"
		},
	}
}

core.ActiveSurveyData = MLResult.DemoSurveyData --DBG

function MLResult:Show(index, test)
	-- currently only masterlooter can show this, this is just a temp solution
	if not core.IsMLooter and not test then
		StaticPopupDialogs["MLRESULT_ONLYML"] = {
			text = "Currently only the Masterlooter can view this window, this will change in a future update.",
			button1 = "Ok",
			OnAccept = function()
				StaticPopup_Hide ("MLRESULT_ONLYML")
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
		}
		StaticPopup_Show("MLRESULT_ONLYML")
		return
	end

    local f = self:GetFrame() 

	local i = index or 1
	if core.ActiveSurveyData.items[i] then
		f:Show()
		self:SwitchItem(i)
	else
		core:Print("No items in loottable")
	end
end

function MLResult:Start(countdown)
	itemIndex = 0

	if core.ActiveSurveyData.items[1] then
		--self:SetupTimerBar(countdown)
		self:EnableTimerFrame(countdown)
		self:Show()
	else
		core:Print("No items in loottable")
	end
end

function MLResult:UpdateItemButtons()
	-- Hide all first
	local highestIndex = 0

    for i, v in ipairs(core.ActiveSurveyData.items) do
        core:PrintDebug("UpdateButton:", i, v.icon)
		itemButtons[i] = self:UpdateItemButton(i, v.icon, v.itemLink, v.closed)
		highestIndex = i
	end

	if highestIndex < #itemButtons then
		core:PrintDebug("There are more buttons already created => hide them", highestIndex, #itemButtons)
		for i=highestIndex+1, #itemButtons do
			itemButtons[i]:Hide()
		end
	end
end

function MLResult:UpdateItemButton(i, icon, itemLink, closed)
    local f = self:GetFrame()
    local btn = itemButtons[i]
    
    -- Create Button of not exists
    if not btn then 
        core:PrintDebug("Create:", i, icon)
        btn = ErrorDKP:CreateIconButton(f.ItemToggleFrame, nil, icon)
		if i == 1 then
			btn:SetPoint("TOPLEFT", f.ItemToggleFrame, "TOPLEFT",-100)
		else
			btn:SetPoint("TOP", itemButtons[i-1], "BOTTOM", 0, -2)
		end
		btn:SetScript("OnClick", function() MLResult:SwitchItem(i); end)
    end
    
	-- Update Button
	btn:SetNormalTexture(icon or "Interface\\InventoryItems\\WoWUnknownItem01")
	btn:Show()
		
	if closed then
		btn:SetBorderColor("green")
	elseif i == itemIndex then
		btn:SetBorderColor("purple")
	else
		btn:SetBorderColor("white")
	end
	return btn
end

function MLResult:SwitchItem(i)
	core:PrintDebug("MLResult:SwitchItem", i)
	--if itemIndex == i then retirn
    
	local old = itemIndex
	itemIndex = i
	local item = core.ActiveSurveyData.items[i]
	local players = core.ActiveSurveyData.players
    local f = self:GetFrame()

	f.ItemIcon:SetNormalTexture(item.icon)
	f.ItemName:SetText(item.itemLink)
	f.GiveLootBtn:SetEnabled(false)
	f.TakeAllBtn:SetEnabled(false)

    -- Set a proper item type text
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemLink)
	f.ItemType:SetText(itemType)
	if itemSubType then f.ItemType:SetText(f.ItemType:GetText()..', '..itemSubType); end

	-- FauxScrollFrame_OnVerticalScroll(self.frame.st.scrollframe, 0, self.frame.st.rowHeight, function() self.frame.st:Refresh() end) -- Reset scrolling to 0
	self:Update(players, item.responses)
	self:UpdateScrollTable(players, item.responses, old ~= itemIndex)
end

local function CountResponses(players, responses)
	local totalPlayers = core:tcount(players)

	local responseCount = 0
	if responses then
		for k,v in pairs(responses) do 
			if v[1] ~= "PENDING" then
				-- Pending is not a final respone 
				responseCount = responseCount + 1
			end
		end
	end
    return totalPlayers, responseCount
end

function MLResult:Update(players, responses)
	--Update Repsone Fontstring upper right corner
	local f = self:GetFrame()
	local totalPlayers, responseCnt = CountResponses(players, responses)
	f.ResponseFontString:SetText( _LS["RESPONSES"].." "..responseCnt.."/"..totalPlayers )
	MLResult:UpdateItemButtons()
	if core.SurveyInProgress and not self:CheckResponsesMissing() then
		-- We are done
		self:FinishSurvey()
	end
end

function MLResult:UpdateScrollTable(players, responses, resetSorting)
	local rows = {}
	local st = MLResult:GetFrame().ScrollingTable

	for i, v in ipairs(players) do
		local responseType, hasItem, roll
		if responses[v.name] then
			responseType = responses[v.name][1]
			hasItem =  responses[v.name][2] or -1
			roll = responses[v.name][3] or ""
		else
			responseType = "OFFLINE"
			hasItem = -1
			roll = ""
		end

		local row = {
			v.classFileName, --icon
			{v.race, v.gender},
			v.name,
			responseType,
			_LS["RESPONSE_"..responseType] or responseType,
			ErrorDKP:GetPlayerDKP(v.name) or 0,
			hasItem,
			roll
		}
		table.insert(rows, row)
	end

	if resetSorting then
		core:PrintDebug("Reset table sorting")
		-- reset sorting to response
		for i in ipairs(st.cols) do
			st.cols[i].sort = nil
		end
		st.cols[5].sort = 1	
		st:ClearSelection()
	end

	st:SetData(rows, true)
	st:SortData()
end

function MLResult:SetVisualUpdateRequired(index)

	if index == itemIndex or index == nil then
		core:PrintDebug("MLResult:SetVisualUpdateRequired", index, itemIndex)
		visualUpdatePending = true
	end
	-- We get so many data updates that its required to bulk the drawing
	
end

function MLResult:CheckResponsesMissing()
	-- check if everybody has answered 
	local totalPlayers = core:tcount(core.ActiveSurveyData["players"])
	for i,v in ipairs(core.ActiveSurveyData.items) do
		if not v["closed"] then
			local cnt = 0
			for k, v1 in pairs(v["responses"]) do
				if v1[1] ~= "PENDING" then
					cnt = cnt + 1
				end 
			end
			if cnt == totalPlayers then
				v["closed"] = true
			else
				return true
			end
		end
	end
	return nil
end

function MLResult:CreateFrame()
	local f = core:CreateDefaultFrame("MLResultFrame", _LS["TITLE"], 310, 530, true, true)
	core.UI.MLResult = f

	local st = ScrollingTable:CreateST(colDef, 16, 21, nil, f)
	st:EnableSelection(true)
    f.ScrollingTable = st
	st.frame:SetPoint("TOPLEFT", f, "TOPLEFT", 22, -130)

	local item = CreateFrame("Button", nil, f)
    item:SetNormalTexture("Interface/ICONS/INV_Misc_QuestionMark")
	item:SetPoint("TOPLEFT", f, "TOPLEFT", 22, -30)
	item:SetSize(50,50)
	item:EnableMouse(true)
	item:RegisterForClicks("AnyUp")
	item:SetScript("OnEnter", function(self)
        ErrorDKP:ShowItemTooltip(self, f.ItemName:GetText())
    end)
    item:SetScript("OnLeave", function(self)
        ErrorDKP:HideItemTooltip()
    end)
    f.ItemIcon = item
    
	local itemName = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	itemName:SetPoint("TOPLEFT", item, "TOPRIGHT", 10, 0)
	itemName:SetText("Itemname")
	f.ItemName = itemName

	local itemType = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	itemType:SetPoint("TOPLEFT", itemName, "BOTTOMLEFT", 0, -4)
	itemType:SetTextColor(0.5, 1, 1)
	itemType:SetText("")
	f.ItemType = itemType

	-- Number of votes
	local rf = CreateFrame("Frame", nil, f)
	rf:SetWidth(100)
	rf:SetHeight(20)

	local responseFontString = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	responseFontString:SetPoint("TOPRIGHT", f, "TOPRIGHT", -22, -35)
	responseFontString:SetText(_LS["RESPONSES"])
	responseFontString:SetTextColor(0,1,0,1) -- Green
	f.ResponseFontString = responseFontString

	local closeSurveyButton = core:CreateButton(f, "CloseSurveYbtn", "Close survey")
	closeSurveyButton:SetPoint("TOPRIGHT", responseFontString, "BOTTOMRIGHT", 0, -5)
	closeSurveyButton:SetScript("OnClick", function()
        MLResult:CloseSurvey()
	end)
	f.CloseSurveyBtn = closeSurveyButton

	local giveLootButton = core:CreateButton(f, "GiveLootBtn", "Give loot")
	giveLootButton:SetPoint("RIGHT", closeSurveyButton, "LEFT", 0, 0)
	giveLootButton:SetScript("OnClick", function()
		local selection = core.UI.MLResult.ScrollingTable:GetSelection()
		if selection then
		   MLResult:GiveLoot(core.UI.MLResult.ScrollingTable:GetCell(selection, 3), itemIndex)
		end
	end)
	giveLootButton:SetEnabled(false)
	f.GiveLootBtn = giveLootButton

	local takeAllButton = core:CreateButton(f, "TakeAllBtn", "Loot all")
	takeAllButton:SetPoint("BOTTOMRIGHT", giveLootButton, "TOPRIGHT", 0, 0)
	takeAllButton:SetScript("OnClick", function()
		MLResult:TakeAll()
	end)
	f.TakeAllBtn = takeAllButton

	local tradeItemButton = core:CreateButton(f, "TradeItem", "TradeItem")
	tradeItemButton:SetPoint("TOPRIGHT", giveLootButton, "BOTTOMRIGHT", 0, 0)
	tradeItemButton:SetScript("OnClick", function()
		local selection = core.UI.MLResult.ScrollingTable:GetSelection()
		local surveyItem = core.ActiveSurveyData.items[itemIndex]
		local selectedPlayer = nil
		if selection then
			selectedPlayer = core.UI.MLResult.ScrollingTable:GetCell(selection, 3)
		end

		MLResult:TradeItem(surveyItem.itemLink, selectedPlayer)
	end)
	tradeItemButton:SetEnabled(false)
	f.TradeItemBtn = tradeItemButton

	local addItemToHistBtn = core:CreateButton(f, "AddItemToHistBtn", "Add Item to History")
	addItemToHistBtn:SetPoint("TOPRIGHT", giveLootButton, "TOPLEFT", 0, 0)
	addItemToHistBtn:SetScript("OnClick", function()
		local selection = core.UI.MLResult.ScrollingTable:GetSelection()
		local surveyItem = core.ActiveSurveyData.items[itemIndex]
		local selectedPlayer = nil
		if selection then
			selectedPlayer = core.UI.MLResult.ScrollingTable:GetCell(selection, 3)
		end

		ErrorDKP.LootTracker:Show(surveyItem.itemLink, selectedPlayer)
	end)
	f.AddItemToHistBtn = addItemToHistBtn


	-- Item toggle
	local itemToggle = CreateFrame("Frame", nil, f)
	itemToggle:SetWidth(40)
	itemToggle:SetHeight(f:GetHeight()-24)
	itemToggle:SetPoint("TOPRIGHT", f, "TOPLEFT", -2, -12)
	--itemToggle:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 0)
	f.ItemToggleFrame = itemToggle
    f.TtemToggleButtons = {}

	f:SetWidth(st.frame:GetWidth() + 44)
	f:SetScript("OnUpdate", function(self, elapsed)
        self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed
		if (self.TimeSinceLastUpdate >= 1 and visualUpdatePending) then
			core.PrintDebug("Apply pending visual update")
			visualUpdatePending = false
			local item = core.ActiveSurveyData.items[itemIndex]
			local players = core.ActiveSurveyData.players
			MLResult:Update(players, item["responses"])
			MLResult:UpdateScrollTable(players, item.responses)
        end
	end)
	
	 -- Timer bar  
	 local bar = CreateFrame("StatusBar", nil, f)
	 f.CountdownBar = bar
	 bar:SetSize(128, 25)
	 bar:SetPoint("BOTTOMLEFT", f , "BOTTOMLEFT", 12, 15)
	 bar:SetPoint("BOTTOMRIGHT", f , "BOTTOMRIGHT", -12, 15)
	 bar:SetBackdrop({bgFile = [[Interface\ChatFrame\ChatFrameBackground]]})
	 bar:SetBackdropColor(0, 0, 0, 0.7)
	 bar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
	 bar:SetStatusBarColor(0.98, 0.9, 0.01)
	 bar:SetMinMaxValues(0, 60)
	 bar.TimeSinceLastUpdate = 0
	 local countdown = bar:CreateFontString(nil, "OVERLAY")
	 countdown:SetFontObject("GameFontNormal")
	 countdown:SetText(0)
	 countdown:SetSize(200,30)
	 countdown:SetPoint("CENTER", bar, "CENTER", 0, 0)
	 bar.countdownString = countdown
	 bar.countdown = 0

	st:RegisterEvents({
		["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
				if button == "LeftButton" then	-- LS: only handle on LeftButton click (right passes thru)
					if not (row or realrow) then
						for i, col in ipairs(st.cols) do
							if i ~= column then -- clear out all other sort marks
								cols[i].sort = nil;
							end
						end
						local sortorder = ScrollingTable.SORT_DSC;
						if not cols[column].sort and cols[column].defaultsort then
							sortorder = cols[column].defaultsort; -- sort by columns default sort first;
						elseif cols[column].sort and cols[column].sort == ScrollingTable.SORT_DSC then
							sortorder = ScrollingTable.SORT_ASC;
						end
						cols[column].sort = sortorder;
						scrollingTable:SortData();

					else
						if scrollingTable:GetSelection() == realrow then
							scrollingTable:ClearSelection();
							scrollingTable.frame:GetParent().GiveLootBtn:SetEnabled(false)
							scrollingTable.frame:GetParent().TradeItemBtn:SetEnabled(false)
						else
							scrollingTable:SetSelection(realrow);
							scrollingTable.frame:GetParent().GiveLootBtn:SetEnabled(true)
							scrollingTable.frame:GetParent().TradeItemBtn:SetEnabled(true)
						end
					end
					return true;
				end
		end
	})

    f:Hide()
	return f;
end

function MLResult:GetFrame()
    local f = core.UI.MLResult or self:CreateFrame()
    return f
end

function MLResult:SetupTimerBar(countdown)
	local f = self:GetFrame()
	if not countdown or countdown == 0 then
		f.CountdownBar:SetValue(0)
		CountdownActive = false
		return
	end 
    f.CountdownBar:SetMinMaxValues(0, countdown)
    f.CountdownBar.countdown = countdown
    CountdownActive = true
end

function MLResult:UpdateCountdownBar(value)
	local bar = MLResult:GetFrame().CountdownBar
	if bar:IsShown() then
		bar.countdownString:SetText(math.floor(value))
		bar:SetValue(value)
	end
end

function MLResult:EnableTimerFrame(countdown)
	MLResult:SetupTimerBar(countdown)
	timerFrame:Show()
	timerFrame.TimeSinceLastUpdate = 0
	timerFrame.countdown = countdown
	timerFrame:SetScript("OnUpdate", function(self, elapsed)
		if not CountdownActive then self:Hide();return; end
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 	
		local countdownBar = MLResult:GetFrame().CountdownBar
		self.countdown = self.countdown - elapsed;

		if (self.TimeSinceLastUpdate >= 1 ) then
			MLResult:UpdateCountdownBar(self.countdown)
			self.TimeSinceLastUpdate = 0
		end
		
		local statusMin, statusMax = countdownBar:GetMinMaxValues()
		if self.countdown <= statusMin then
			CountdownActive = false
			MLResult:OnCountdownExpired()
		end
	end)
end

function MLResult:DisableTimerFrame()
	timerFrame:Hide()
	self:SetupTimerBar(0)
end

function MLResult:OnCountdownExpired()
	core:PrintDebug("SurveyTimeout, send closed" )
	self:DisableTimerFrame()
	self:CloseSurvey()
end

function MLResult:FinishSurvey()
	core:PrintDebug("MLResult:FinishSurvey()")
	core.SurveyInProgress = false
	self:GetFrame().CountdownBar.countdownString:SetText(_LS["SURVEYCLOSED"])
	MLResult:DisableTimerFrame()

	-- set pending results to timeout
	for i,v in  ipairs(core.ActiveSurveyData["items"]) do
		for i1,v1 in ipairs(core.ActiveSurveyData["players"]) do
			local resp = v["responses"][v1["name"]]
			if resp and resp[1] == "PENDING" then
				v["responses"][v1["name"]][1] = "TIMEOUT"
			end
		end
	end
	visualUpdatePending = true
end

function MLResult:CloseSurvey()
	for i,v in ipairs(core.ActiveSurveyData.items) do
		v["closed"] = true
	end
	self:UpdateItemButtons()
	self:GetFrame().CountdownBar.countdownString:SetText(_LS["SURVEYCLOSED"])
	self:FinishSurvey()
	core.Sync:SendRaid("ErrDKPSurvClosed", core.ActiveSurveyData["id"])
end

function MLResult:GetLootSlot(itemLink)
	if not GetNumLootItems() then return end

	for i = 1, GetNumLootItems() do
		local link = GetLootSlotLink(i)

		if link == itemLink then
			return i
		end
	end
end

function MLResult:TakeAll()
	core:PrintDebug("Loot everything.")

	local itemCount = GetNumLootItems()
	if itemCount == 0 then 
		core:Print("Nothing to loot")
		return 
	end

	for ci = 1, GetNumGroupMembers() do
		if (GetMasterLootCandidate(lootFrameIndex, ci) == playerName) then

			StaticPopupDialogs["MLRESULT_GIVELOOT"] = {
				text = string.format("Do you really want to give %s to player %s", lootSlotItemlink , playerName),
				button1 = "Yes",
				button2 = "No",
				OnAccept = function()
					GiveMasterLoot(lootFrameIndex, ci);
					StaticPopup_Hide ("MLRESULT_GIVELOOT")
				end,
				OnCancel = function()
				    StaticPopup_Hide ("MLRESULT_GIVELOOT")
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				enterClicksFirstButton = true
			}
			StaticPopup_Show("MLRESULT_GIVELOOT")
		end
   	end
end

function MLResult:GiveLoot(playerName, itemIndex, lootFrameIndex)
	
	local surveyItem = core.ActiveSurveyData.items[itemIndex]


	if surveyItem["lfi"] == 0 or surveyItem["lfi"] == nil then
		core:Print("This item was added from bag and is not distrebutable via Masterlooter.")
		return
	end

	if not GetNumLootItems() then
		core:Error("Lootframe needs to be open!")
		return
	end

	local sourceGuiD = GetLootSourceInfo(surveyItem["lfi"])
	if not lootFrameIndex then 
		lootFrameIndex = surveyItem["lfi"] 
	end

	core:PrintDebug("Lootframeindex",lootFrameIndex)

	local lootSlotItemlink = GetLootSlotLink(lootFrameIndex)
	if not lootSlotItemlink or lootSlotItemlink ~= core.ActiveSurveyData.items[itemIndex].itemLink then
		local foundSlot = self:GetLootSlot(core.ActiveSurveyData.items[itemIndex].itemLink)
		if not foundSlot then
			core:Error("Item in Lootwindow doesn't match survey item, is the correct lootwindow open?")
			return
		end
		-- Seems as the Lootwindows was closed in the meantime so call with new index
		core:PrintDebug("IndemIndex in Lootframe has changed, call MLResult:GiveLoot with fixed index")
		self:GiveLoot(playerName, itemIndex, foundSlot)
		return
	end
	for ci = 1, GetNumGroupMembers() do
		if (GetMasterLootCandidate(lootFrameIndex, ci) == playerName) then

			StaticPopupDialogs["MLRESULT_GIVELOOT"] = {
				text = string.format("Do you really want to give %s to player %s", lootSlotItemlink , playerName),
				button1 = "Yes",
				button2 = "No",
				OnAccept = function()
					GiveMasterLoot(lootFrameIndex, ci);
					StaticPopup_Hide ("MLRESULT_GIVELOOT")
				end,
				OnCancel = function()
				    StaticPopup_Hide ("MLRESULT_GIVELOOT")
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				enterClicksFirstButton = true
			}
			StaticPopup_Show("MLRESULT_GIVELOOT")


	  		
		end
   	end
end

local function GetItemBagAndSlot(itemLink)
	for bag = 0,4 do
		 for slotIndex=1, GetContainerNumSlots(bag) do
			local bagItem = GetContainerItemLink(bag,slotIndex)
			if bagItem == itemLink then
			    return bag, slotIndex
			end
		 end
	end
end

local function TradeCallback(partnerName, partnerGuild, itemLink, playerGold, partnerGold, playerItems, partnerItems)
	core:PrintDebug("TradeCallback", partnerName, partnerGuild, itemLink, playerGold, partnerGold, playerItems, partnerItems)
	
	ErrorDKP.LootTracker:Show(itemLink, partnerName, tonumber(partnerGold) > 0)
end

function MLResult:TradeItem(item, playerName)

	-- Find player
	local unit = nil
	local numRaidMembers = GetNumGroupMembers()
    for i=1, numRaidMembers do
        if IsInRaid() then
            name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name == playerName then
                unit = string.format("raid%d", i)
            end
        elseif IsInGroup() then
            local name = UnitName(string.format("party%d",i))
            if name == playerName then
                unit = string.format("party%d",i)
            end
        end
	end
	
	if unit == nil then
		core:Print("Unit not in Raid/Group")
		return
	end

	local bag, slot = GetItemBagAndSlot(item)
	core:PrintDebug("Item ", item, "in ", bag, slot)
	--InitiateTrade(unit)

	if bag ~= nil and slot ~= nil then
		local inRange = CheckInteractDistance(unit, 2) -- Check i unit is in range for trade
		if inRange then
			ErrorDKP.Trading:AddSpecificListener(item, function(...) TradeCallback(...) end)
		    PickupContainerItem(bag, slot)
			DropItemOnUnit(unit)
		else
			core:Print(playerName, "is not in range for trading")
		end
	end

	core:PrintDebug("MLResult:TradeItem", "item:", item, "playername:", playerName)
end

