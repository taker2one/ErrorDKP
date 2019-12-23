--###############################################
--#  Project: ErrorDKP
--#  File: lootmlsetupsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 06.12.2019
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
	["PENDING"] = 3,
	["MAIN"] = 1,
	["SECOND"] = 2,
	["PASS"] = 10,
	["TIMEOUT"] = 5,
	["OFFLINE"] = 4
}

function ResponseSort(table, rowa, rowb, sortbycol)
	--core:PrintDebug("ResponseSort")

	local column = table.cols[sortbycol]
	local a, b = table:GetRow(rowa), table:GetRow(rowb);
	a, b = responseSortOrder[core.ActiveSurveyData.items[itemIndex].responses[a[2]] or "OFFLINE"],
			responseSortOrder[core.ActiveSurveyData.items[itemIndex].responses[b[2]] or "OFFLINE"]
	core:PrintDebug("ResponseSort:", a, b)

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
				cellFrame:SetNormalTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"); -- this is the image containing all class icons
				local coords = CLASS_ICON_TCOORDS[class]; -- get the coordinates of the class icon we want
				cellFrame:GetNormalTexture():SetTexCoord(unpack(coords)); -- cut out the region with our class icon according to coords
			else -- if there's no class
				cellFrame:SetNormalTexture("Interface/ICONS/INV_Sigil_Thorim.png")
			end
		end
	end}, -- classIcon
    { ["name"] = _LS["COLPLAYER"], ["width"] = 150 }, -- PlayerName
   -- { ["name"] = "", ["width"] = 20 }, -- Guild Rank
    { ["name"] = "", ["width"] = 1}, -- ResponseType
	{ ["name"] = _LS["COLRESPONSE"], ["width"] = 200, ["comparesort"]=ResponseSort, ["sortnext"] = 5, ["defaultsort"] = "asc"  }, -- Answer
	{ ["name"] = _LS["COLDKP"], ["width"] = 60 }
}

local DemoSurveyData = {
    id = "157564448499",
	items = {
		{
            ["index"] = 1,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_pants_07",
			["responses"] = {},
			["closed"] = nil
        },
        {
            ["index"] = 2,
            ["name"] = "Giantstalker's Gloves",
            ["itemLink"] = "|cffa335ee|Hitem:16852::::::::60:::::::|h[Giantstalker's Gloves]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_gauntlets_10",
			["responses"] = {
				["Rassputin"] = "MAIN",
				["Doktorwho"] = "SECOND"
			},
			["closed"] = true
        },
        {
            ["index"] = 3,
            ["name"] = "Seal of the Archmagus",
            ["itemLink"] = "|cffa335ee|Hitem:17110::::::::60:::::::|h[Seal of the Archmagus]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\Icons\\inv_jewelry_ring_21",
			["responses"] = {
				["Doktorwho"] = "MAIN"
			},
			["closed"] = nil
        },

	},
	players = {
		{
			["name"] = "Doktorwho",
			["classFileName"] = "PRIEST",
		},
		{
			["name"] = "Repa",
			["classFileName"] = "MAGE",
		},
		{
			["name"] = "Rassputin",
			["classFileName"] = "MAGE",
		},
	}
}

core.ActiveSurveyData = DemoSurveyData --DBG

function MLResult:Show(index)
	-- currently only masterlooter can show this, this is just a temp solution
	if not core.IsMLooter then
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

    -- Set a proper item type text
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemLink)
	f.ItemType:SetText(itemType)
	if itemSubType then f.ItemType:SetText(f.ItemType:GetText()..', '..itemSubType); end

	-- FauxScrollFrame_OnVerticalScroll(self.frame.st.scrollframe, 0, self.frame.st.rowHeight, function() self.frame.st:Refresh() end) -- Reset scrolling to 0
	self:Update(players, item.responses)
	self:UpdateScrollTable(players, item.responses, old ~= itemIndex)
end

function MLResult:Update(players, responses)
	--Update Repsone Fontstring upper right corner
	local f = self:GetFrame()
	local totalPlayers = core:tcount(players)
	local responseCnt = core:tcount(responses)
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
		local responseType = responses[v.name] or "OFFLINE"
		local row = {
			v.classFileName, --icon
			v.name,
			responseType,
			_LS["RESPONSE_"..responseType] or responseType,
			ErrorDKP:GetPlayerDKP(v.name) or 0
		}
		table.insert(rows, row)
	end

	if resetSorting then
		core:PrintDebug("Reset table sorting")
		-- reset sorting to response
		for i in ipairs(st.cols) do
			st.cols[i].sort = nil
		end
		st.cols[4].sort = 1	
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
			for k, v in pairs(v["responses"]) do
				if v ~= "PENDING" then
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
	local f = core:CreateDefaultFrame("MLResultFrame", "Result", 250, 480)
	core.UI.MLResult = f
    f:SetPoint("CENTER", UIParent, "CENTER", 550, 0)

    local st = ScrollingTable:CreateST(colDef, 16, 20, nil, f)
    f.ScrollingTable = st
	st.frame:SetPoint("TOPLEFT", f, "TOPLEFT", 22, -100)
	
	local closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)

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
			if resp and resp == "PENDING" then
				v["responses"][v1["name"]] = "TIMEOUT"
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