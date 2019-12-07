--###############################################
--#  Project: ErrorDKP
--#  File: lootmlsetupsurvey.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 06.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

ErrorDKP.MLResult = {}
local MLResult = ErrorDKP.MLResult

local ScrollingTable = LibStub("ScrollingTable")

local itemIndex = 1
local itemButtons = {}

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
    { ["name"] = "Name", ["width"] = 150 }, -- PlayerName
   -- { ["name"] = "", ["width"] = 20 }, -- Guild Rank
    { ["name"] = "Answer", ["width"] = 150 } -- Answer
}

local DemoSurveyData = {
    id = "157564448499",
    items = {
        {
            ["index"] = 1,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01",
			["answers"] = {}
        },
        {
            ["index"] = 2,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01",
			["answers"] = {}
        },
        {
            ["index"] = 3,
            ["name"] = "Nemesis Leggings",
            ["itemLink"] = "|cffa335ee|Hitem:16930::::::::60:::::::|h[Nemesis Leggings]|h|r",
            ["quality"] = 4,
			["icon"] = "Interface\\InventoryItems\\WoWUnknownItem01",
			["answers"] = {
				["Doktorwho"] = "MAIN"
			}
        }
	},
	players = {
		{
			["name"] = "Doktorwho",
			["classFileName"] = "PRIEST",
			["answerState"] = "None"
		},
		{
			["name"] = "Repa",
			["classFileName"] = "MAGE",
			["answerState"] = "None"
		},
		{
			["name"] = "Rassputin",
			["classFileName"] = "MAGE",
			["answerState"] = "None"
		},
	}
}

local DemoPlayerData = {
	
}

core.ActiveSurveyData = DemoSurveyData --DBG

function MLResult:Show()
    local f = self:GetFrame() 

	if core.ActiveSurveyData.items[itemIndex] then
		f:Show()
		self:SwitchItem(itemIndex)
	else
		core:Print("No items in loottable")
	end
end

function MLResult:Setup(table)
	for session, t in ipairs(table) do
		if not t.added then
			self:SetupSession(session, t)
		end
	end
	-- Hide unused session buttons
	for i = #lootTable+1, #sessionButtons do
		sessionButtons[i]:Hide()
	end
	session = 1
	self:BuildST()
	self:SwitchSession(session)
	if addon.isMasterLooter and db.autoAddRolls then
		self:DoAllRandomRolls()
	end
end

function MLResult:UpdateItemButtons()
    for i, v in ipairs(core.ActiveSurveyData.items) do
        core:PrintDebug("UpdateButton:", i, v.icon)
		itemButtons[i] = self:UpdateItemButton(i, v.icon, v.itemLink, v.awarded)
	end
end

function MLResult:UpdateItemButton(i, icon, itemLink, awarded)
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
	--local lines = { format(L["Click to switch to 'item'"], link) }
	if i == itemIndex then
		btn:SetBorderColor("yellow")
	elseif awarded then
		btn:SetBorderColor("green")
		--tinsert(lines, L["This item has been awarded"])
	else
		btn:SetBorderColor("white") -- white
	end
	--btn:SetScript("OnEnter", function() addon:CreateTooltip(unpack(lines)) end)
	return btn
end

function MLResult:SwitchItem(i)
    core:PrintDebug("MLResult:SwitchItem", i)
    
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

	self:UpdateItemButtons()

	local j = 1
	-- for i in ipairs(self.frame.st.cols) do
	-- 	self.frame.st.cols[i].sort = nil
	-- 	if self.frame.st.cols[i].colName == "response" then j = i end
	-- end
	-- self.frame.st.cols[j].sort = 1
	-- FauxScrollFrame_OnVerticalScroll(self.frame.st.scrollframe, 0, self.frame.st.rowHeight, function() self.frame.st:Refresh() end) -- Reset scrolling to 0
	self:Update(true)
	self:UpdateScrollTable(players, item.answers)
	--self:UpdatePeopleToVote()
	-- addon:SendMessage("RCSessionChangedPost", s)
end

function MLResult:Update(forceUpdate)
	needUpdate = false
	if not forceUpdate and noUpdateTimeRemaining > 0 then needUpdate = true; return end
	if not self.frame then return end -- No updates when it doesn't exist
	if not lootTable[session] then return addon:Debug("VotingFrame:Update() without lootTable!!") end -- No updates if lootTable doesn't exist.
	noUpdateTimeRemaining = MIN_UPDATE_INTERVAL
	self.frame.st:SortData()
	self.frame.st:SortData() -- It appears that there is a bug in lib-st that only one SortData() does not use the "sortnext" to correct sort the rows.
	-- update awardString
	if lootTable[session] and lootTable[session].awarded then
		self.frame.awardString:SetText(L["Item was awarded to"])
		self.frame.awardString:Show()
		local name = lootTable[session].awarded
		self.frame.awardStringPlayer:SetText(addon.Ambiguate(name))
		local c = addon:GetClassColor(lootTable[session].candidates[name].class)
		self.frame.awardStringPlayer:SetTextColor(c.r,c.g,c.b,c.a)
		self.frame.awardStringPlayer:Show()
		-- Hack-reuse the SetCellClassIcon function
		addon.SetCellClassIcon(nil,self.frame.awardStringPlayer.classIcon,nil,nil,nil,nil,nil,nil,nil, lootTable[session].candidates[name].class)
		self.frame.awardStringPlayer.classIcon:Show()
	elseif lootTable[session] and lootTable[session].baggedInSession then
		self.frame.awardString:SetText(L["The item will be awarded later"])
		self.frame.awardString:Show()
		self.frame.awardStringPlayer:Hide()
		self.frame.awardStringPlayer.classIcon:Hide()
	else
		self.frame.awardString:Hide()
		self.frame.awardStringPlayer:Hide()
		self.frame.awardStringPlayer.classIcon:Hide()
	end
	-- This only applies to the ML
	if addon.isMasterLooter then
		-- Update close button text
		if active then
			self.frame.abortBtn:SetText(L["Abort"])
		else
			self.frame.abortBtn:SetText(_G.CLOSE)
		end
		self.frame.disenchant:Show()
	else -- Non-MLs:
		self.frame.abortBtn:SetText(_G.CLOSE)
		self.frame.disenchant:Hide()
	end
	if #self.frame.st.filtered < #self.frame.st.data then -- Some row is filtered in this session
		self.frame.filter.Text:SetTextColor(0.86,0.5,0.22) -- #db8238
	else
		self.frame.filter.Text:SetTextColor(_G.NORMAL_FONT_COLOR:GetRGB()) --#ffd100
	end
	if db.modules["RCVotingFrame"].alwaysShowTooltip then
		self.frame.itemTooltip:SetOwner(self.frame.content, "ANCHOR_NONE")
		self.frame.itemTooltip:SetHyperlink(lootTable[session].link)
		self.frame.itemTooltip:Show()
		self.frame.itemTooltip:SetPoint("TOP", self.frame, "TOP", 0, 0)
		self.frame.itemTooltip:SetPoint("RIGHT", sessionButtons[#lootTable], "LEFT", 0, 0)
	else
		self.frame.itemTooltip:Hide()
	end
end

function MLResult:UpdateScrollTable(players, answers)
	local rows = {}

	for i, v in ipairs(players) do
		local answerState = answers[v.name] or "None"
		local row = {
			v.classFileName, --icon
			v.name,
			answerState --v.answerState 
		}
		table.insert(rows, row)
	end
	MLResult:GetFrame().ScrollingTable:SetData(rows, true)
end

function MLResult:CreateFrame()
	local f = core:CreateDefaultFrame("MLResultFrame", "Result", 250, 440)
	core.UI.MLResult = f
    f:SetPoint("CENTER", UIParent, "CENTER")

    local st = ScrollingTable:CreateST(colDef, 15, 20, nil, f)
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
	if b2 then rf:SetPoint("RIGHT", b2, "LEFT", -10, 0) else rf:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -20) end
	rf:SetScript("OnLeave", function()
		addon:HideTooltip()
	end)
	local rft = rf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rft:SetPoint("CENTER", rf, "CENTER")
	rft:SetText(" ")
	rft:SetTextColor(0,1,0,1) -- Green
	rf.text = rft
	rf:SetWidth(rft:GetStringWidth())
	f.rollResult = rf


	-- Item toggle
	local itemToggle = CreateFrame("Frame", nil, f)
	itemToggle:SetWidth(40)
	itemToggle:SetHeight(f:GetHeight()-24)
	itemToggle:SetPoint("TOPRIGHT", f, "TOPLEFT", -2, -12)
	--itemToggle:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 0)
	f.ItemToggleFrame = itemToggle
    itemToggleButtons = {}
    
    itemToggle.bg = itemToggle:CreateTexture(nil, "BACKGROUND")
    itemToggle.bg:SetAllPoints(itemToggle)
	itemToggle.bg:SetTexture(1,0.5,0.5,0.5)

    f:SetWidth(st.frame:GetWidth() + 44)
    f:Hide()
	return f;
end

function MLResult:GetFrame()
    local f = core.UI.MLResult or self:CreateFrame()
    return f
end