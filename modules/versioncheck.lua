--###############################################
--#  Project: ErrorDKP
--#  File: versioncheck.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 17.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
ErrorDKP.VersionCheck = {}
local VersionCheck = ErrorDKP.VersionCheck
local ScrollingTable = LibStub("ScrollingTable")

local colDef = {
    { ["name"]="", ["width"]=20 },
    { ["name"]="Name", ["width"]=150 },
    { ["name"]="Version", ["width"]=150 }
}

local players = {}

function VersionCheck:Show()
    self:GetFrame():Show()
end

function VersionCheck:Start(group)
    core:PrintDebug("Start Version check in ", group)
    table.wipe(players)
	if group == "GUILD" then
		GuildRoster()
		for i = 1, GetNumGuildMembers() do
            local name, rank, _,_,_,_,_,_, online,_, class = GetGuildRosterInfo(i)
            local name, realm = core:SplitString(name, "-", true)
            core:PrintDebug("VersionCheckGuild", name, realm, online)
			if online then
				self:AddPlayer(name, online)
			end
		end
        core.Sync:Send("VerCheck", " ")
	elseif group == "GROUP" then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, class, _, online = GetRaidRosterInfo(i)
			self:AddPlayer(name, online)
        end
        core.Sync:SendRaid("VerCheck", " ")
    end
    self:UpdateTable(players)
	--self:ScheduleTimer("QueryTimer", 5)
end

function VersionCheck:AddPlayer(name)
    local p = {}
    p["name"] = name
    table.insert(players, p)
end

function VersionCheck:UpdateTable(playerList, online)
    local st = self:GetFrame().ScrollingTable
    local d = {}
    local version = "Offline"
    if online then version = "Pending" end
    

    for i, v in ipairs(playerList) do
        local entry = {
            " ",
            v.name,
            v["version"] or version
        }
        table.insert(d, entry)
    end
    st:SetData(d, true)

end


function VersionCheck:CreateFrame()
    local f = core:CreateDefaultFrame("ErrorDKPVersionCheck", "VersionCheck", 500, 400, true)
    core.UI.VersionCheck = f
    f:SetPoint("CENTER", UIParent, "CENTER")

    f.GroupCheckButton = core:CreateButton(f, "ErrorDKPVersionCheckGroupButton", "Check in Group")
    f.GroupCheckButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 20)
    f.GroupCheckButton:SetScript("OnClick", function() 
        self:Start("GROUP") 
    end)

    f.GuildCheckButton = core:CreateButton(f, "ErrorDKPVersionCheckGuildButton", "Check in Guild")
    f.GuildCheckButton:SetPoint("LEFT", f.GroupCheckButton, "RIGHT", 12, 0)
    f.GuildCheckButton:SetScript("OnClick", function() 
        self:Start("GUILD") 
    end)

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
                VersionCheck:UpdateTable(players)
                visualUpdatePending = false
            end
            self.TimeSinceLastUpdate = 0
        end
    end)

    return f
end

function VersionCheck:GetFrame()
    local f = core.UI.VersionCheck or self:CreateFrame()
    return f
end

function VersionCheck:OnCommResponse(sender, version)
    local n,t = string.match(version, "(%d+)(%a)")
    core:PrintDebug("Got response to version request from ",sender, n,t)
    for i, v in ipairs(players) do
        if v["name"] == sender then
            v["version"] = version
            visualUpdatePending = true
            break;
        end
    end
end
