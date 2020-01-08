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

function ItemCheck:Show()
    self:GetFrame():Show()
end

function ItemCheck:AddPlayer(name)
    local p = {}
    p["name"] = name
    table.insert(players, p)
end

function ItemCheck:Start(item, channel)
    core:PrintDebug("Start Item check in ", channel, item)
    table.wipe(players)
	if not channel or channel == "GUILD" then --DBG
		GuildRoster()
		for i = 1, GetNumGuildMembers() do
            local name, rank, _,_,_,_,_,_, online,_, class = GetGuildRosterInfo(i)
            local name, realm = core:SplitString(name, "-", true)
            core:PrintDebug("VersionCheckGuild", name, realm, online)
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
        --core.Sync:SendRaid("ItemCheck", tostring(item)) DBG
        core.Sync:Send("ItemCheck", tostring(item))
    end
    self:UpdateTable(players)
	--self:ScheduleTimer("QueryTimer", 5)
end

function ItemCheck:CreateFrame()
    local f = core:CreateDefaultFrame("ErrorDKPItemCheck", "ItemCheck", 500, 400, true, true)
    core.UI.ItemCheck = f
    f:SetPoint("CENTER", UIParent, "CENTER")

    f.GroupCheckButton = core:CreateButton(f, "ErrorDKPItemCheckAQ", "Aqual Quintessence")
    f.GroupCheckButton:SetWidth(130)
    f.GroupCheckButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 20)
    f.GroupCheckButton:SetScript("OnClick", function() 
        self:Start(17333) -- Aqual Quintessence
    end)

    f.OnyBagCheckButton = core:CreateButton(f, "ErrorDKPItemCheckAQ", "Ony Bag")
    f.OnyBagCheckButton:SetWidth(100)
    f.OnyBagCheckButton:SetPoint("BOTTOMLEFT", f.GroupCheckButton, "BOTTOMRIGHT", 10, 0)
    f.OnyBagCheckButton:SetScript("OnClick", function() 
        self:Start(17966) -- Onyxia Bag
    end)

    -- f.GuildCheckButton = core:CreateButton(f, "ErrorDKPItemCheckGuildButton", "Check in Guild")
    -- f.GuildCheckButton:SetPoint("LEFT", f.GroupCheckButton, "RIGHT", 12, 0)
    -- f.GuildCheckButton:SetScript("OnClick", function() 
    --     self:Start("GUILD") 
    -- end)

    -- Ony Bag 17966

    local st = ScrollingTable:CreateST(colDef, 12, 20, nil, f)
    st.frame:SetPoint("TOPLEFT",f,"TOPLEFT",12,-50)
    st.frame:SetPoint("TOPRIGHT",f,"TOPRIGHT",-12,-50)
    f:SetWidth(st.frame:GetWidth()+20)
	f.rows = {}
    f.ScrollingTable = st
    
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

function ItemCheck:UpdateTable(playerList, online)
    local st = self:GetFrame().ScrollingTable
    local d = {}
    local amount = "Offline"
    if online then amount = "Pending" end
    

    for i, v in ipairs(playerList) do
        local entry = {
            " ",
            v.name,
            v["amount"] or amount
        }
        table.insert(d, entry)
    end
    st:SetData(d, true)

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
