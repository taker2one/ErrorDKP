--###############################################
--#  Project: ErrorDKP
--#  File: itemcheck.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 08.01.2020
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

ErrorDKP.ItemCheck = {}
local ItemCheck = ErrorDKP.ItemCheck

local ScrollingTable = LibStub("ScrollingTable")

local colDef = {
    { ["name"]="", ["width"]=20 },
    { ["name"]="Name", ["width"]=150 },
    { ["name"]="Amount", ["width"]=150 }
}

local players = {}
local currentItemId = "";

function ItemCheck:Show()
    self:GetFrame():Show()
end

function ItemCheck:AddPlayer(name)
    local p = {}
    p["name"] = name
    table.insert(players, p)
end

function ItemCheck:Start(item, channel, itemText)
    core:PrintDebug("Start Item check in ", channel, item)
    table.wipe(players)
	if channel == "GUILD" then
		GuildRoster()
		for i = 1, GetNumGuildMembers() do
            local name, rank, _,_,_,_,_,_, online,_, class = GetGuildRosterInfo(i)
            local name, realm = core:SplitString(name, "-", true)
            core:PrintDebug("ItemCheck Guild", name, realm, online)
			if online then
				self:AddPlayer(name, online)
			end
		end
        core.Sync:Send("ItemCheck", " ")
	elseif not channel or channel == "GROUP"  then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, class, _, online = GetRaidRosterInfo(i)
			self:AddPlayer(name, online)
        end
        core.Sync:SendRaid("ItemCheck", tostring(item))
    end
    self:UpdateTable(players, itemText)
end

function ItemCheck:CreateFrame()
    local f = core:CreateDefaultFrame("ErrorDKPItemCheck", "ItemCheck", 500, 420, true, true)
    core.UI.ItemCheck = f
    tinsert(UISpecialFrames, "ErrorDKPItemCheck")  


    -- Input
    local searchInput = CreateFrame("EditBox","EDKP_ItemCheck_Input", f, "InputBoxTemplate")
    searchInput:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 60)
    --searchInput:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", 0, 5)
    searchInput:SetSize(100, 32)
    searchInput:SetMultiLine(false)
    searchInput:SetAutoFocus(false)
    --looterInput:EnableMouse(true)
    --looterInput:EnableKeyboard(true)
    searchInput:SetScript("OnEnterPressed", function(btn)
        --local text = btn:GetText()
        --core:Print(text);
        --PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    searchInput:SetScript("OnEscapePressed", function()
        --PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    searchInput:SetScript("OnEditFocusLost", function()
        --PriceListTableUpdate()
        searchInput:ClearFocus()
    end)
    f.SearchInput = searchInput

    f.DoCheckBtutton = core:CreateButton(f, "ErrorDKPItemCheckDoCheck", "Start check")
    f.DoCheckBtutton:SetWidth(130)
    f.DoCheckBtutton:SetPoint("BOTTOMLEFT", f.SearchInput, "BOTTOMRIGHT", 20, 5)
    f.DoCheckBtutton:SetScript("OnClick", function(button) 
        local text = f.SearchInput:GetText();
        if(not text) then
            core:Error("Textfield is empty")
            return
        end
        local exists = C_Item.DoesItemExistByID(text)
        if not exists then
            core:Error("Item doesnt exists")
            return
        end

        -- Just do a request if not already in cache
        if not C_Item.IsItemDataCachedByID(text) then
            C_Item.RequestLoadItemDataByID(text)
        end;

        currentItemId = text;

        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(text)
        if not itemLink then
            itemLink = text;
        end

        --core.Print("Via Button", text);
        self:Start(text, nil, itemLink) -- Aqual Quintessence
    end)


    f.GroupCheckButton = core:CreateButton(f, "ErrorDKPItemCheckAQ", "Aqual Quintessence")
    f.GroupCheckButton:SetWidth(130)
    f.GroupCheckButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 20)
    f.GroupCheckButton:SetScript("OnClick", function(button) 
        self:Start(17333, nil, button:GetText()) -- Aqual Quintessence
    end)

    f.OnyBagCheckButton = core:CreateButton(f, "ErrorDKPItemCheckOB", "Ony Bag")
    f.OnyBagCheckButton:SetWidth(100)
    f.OnyBagCheckButton:SetPoint("BOTTOMLEFT", f.GroupCheckButton, "BOTTOMRIGHT", 10, 0)
    f.OnyBagCheckButton:SetScript("OnClick", function(button) 
        self:Start(17966, nil, button:GetText()) -- Onyxia Bag
    end)

    f.OnyCloakCheckButton = core:CreateButton(f, "ErrorDKPItemCheckOC", "Ony Cloak")
    f.OnyCloakCheckButton:SetWidth(100)
    f.OnyCloakCheckButton:SetPoint("BOTTOMLEFT", f.OnyBagCheckButton, "BOTTOMRIGHT", 10, 0)
    f.OnyCloakCheckButton:SetScript("OnClick", function(button) 
        self:Start(15138, nil, button:GetText()) -- Onyxia Scale CLoak
    end)

    f.NatureResiPotsCheckButton = core:CreateButton(f, "ErrorDKPItemCheckNr", "Greater NR Pots")
    f.NatureResiPotsCheckButton:SetWidth(100)
    f.NatureResiPotsCheckButton:SetPoint("BOTTOMLEFT", f.OnyCloakCheckButton, "BOTTOMRIGHT", 10, 0)
    f.NatureResiPotsCheckButton:SetScript("OnClick", function(button) 
        self:Start(13458, nil, button:GetText()) 
    end)

    -- f.GuildCheckButton = core:CreateButton(f, "ErrorDKPItemCheckGuildButton", "Check in Guild")
    -- f.GuildCheckButton:SetPoint("LEFT", f.GroupCheckButton, "RIGHT", 12, 0)
    -- f.GuildCheckButton:SetScript("OnClick", function() 
    --     self:Start("GUILD") 
    -- end)

    -- Ony Bag 17966

    local st = ScrollingTable:CreateST(colDef, 12, 20, nil, f)
    st.frame:SetPoint("TOPLEFT",f,"TOPLEFT",12,-80)
    st.frame:SetPoint("TOPRIGHT",f,"TOPRIGHT",-12,-80)
    f:SetWidth(st.frame:GetWidth()+20)
	f.rows = {}
    f.ScrollingTable = st

    st.Title = st.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    st.Title:SetPoint("BOTTOMLEFT", st.frame, "TOPLEFT", 5, 25)
    st.Title:SetText("No check active")

    local sum = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	sum:SetPoint("TOPLEFT", st.Title, "TOPRIGHT", 0, 0)
	sum:SetText("(0)")
	f.Sum = sum
    
    
    f:SetScript("OnUpdate", function(self, elapsed) 
        self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed
        if self.TimeSinceLastUpdate >= 1 then
            if visualUpdatePending then
                ItemCheck:UpdateTable(players)
                visualUpdatePending = false
            end
            self.TimeSinceLastUpdate = 0
        end
    end)

    return f
end

function ItemCheck:UpdateTable(playerList, itemText)
    local st = self:GetFrame().ScrollingTable
    if itemText then
        st.Title:SetText(itemText)
    end

    if st.Title:GetText() == currentItemId then
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItemId)
        if itemLink then
            st.Title:SetText(itemLink)
        end
    end

    local d = {}
    local sum = 0
    

    for i, v in ipairs(playerList) do
        local entry = {
            " ",
            v.name,
            v["amount"] or "Offline"
        }
        table.insert(d, entry)
        sum = sum + ( tonumber(entry[3]) or 0 )
    end
    st:SetData(d, true)
    self:GetFrame().Sum:SetText("(" .. sum .. ")")
end

function ItemCheck:GetFrame()
    local f = core.UI.ItemCheck or self:CreateFrame()
    return f
end

function ItemCheck:OnCommResponse(sender, amount)
    --local n,t = string.match(version, "(%d+)(%a)")
    core:PrintDebug("Got response to itemcheck request from ",sender, amount)
    for i, v in ipairs(players) do
        if v["name"] == sender then
            v["amount"] = amount
            visualUpdatePending = true
            break;
        end
    end
end
