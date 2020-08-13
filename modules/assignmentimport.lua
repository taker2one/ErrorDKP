--###############################################
--#  Project: ErrorDKP
--#  File: export.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Export Frame and routines
--#  Last Edit: 13.08.2020
--###############################################
local addonName, core = ...

local ErrorDKP = core.ErrorDKP
local UI = core.UI
local _LS = core._L.ASSINPUTDIALOG

local AssignmentImport = {}
ErrorDKP.AssignmentImport = AssignmentImport

local Serializer = LibStub:GetLibrary("AceSerializer-3.0")

AssignmentImport.assignments = {}

-- ["ItemId"] = itemId,
-- ["ItemLink"] = itemLink,
-- ["Looter"] = looter,
-- ["Dkp"] = dkp,
-- ["Time"] = lootTime

local function CreateItemString(item)

    -- validate
    if not item
    or not item["ItemId"]
    --or not item["time"]
    or not item["Looter"]
    or not(item["Dkp"] >= 0)
    then
       return nil 
    end

    local xml = '<item>'
    xml = xml .. '<name>'..item["ItemId"]..'</name>'
    xml = xml .. '<member>'..item["Looter"]..'</member>'
    xml = xml .. '<itemid>'..item["ItemId"]..'</itemid>'
    xml = xml .. '<cost>'..item["Dkp"]..'</cost>'

    xml = xml..'</item>'
    return xml
end


local function CreateImportFrame()
    local f = CreateFrame("frame", "ErrorDKPImportAssignmentFrame", UIParent)
    UI.AssignmentImportFrame = f
    f:SetSize(450,250)
    f:SetMovable(true)
    f:SetFrameLevel(15)
    f:EnableMouse(true)
    --f:Hide()
    f:SetPoint("TOP", UIParent, "TOP", 0, -20)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        edgeSize = 32,
        tileSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local texture = f:CreateTexture(nil, "ARTWORK")
    texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    texture:SetSize(300,64)
    texture:SetPoint("TOP", f, "TOP", 0, 12)

    -- Title
    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local title = f.Title
    title:SetPoint("TOP", f, "TOP", 0, -2)
    title:SetText(_LS["TITLE"])

    f.ScrollFrame = CreateFrame("ScrollFrame", "ErrorDKPImportFrame_Scroll", f, "UIPanelScrollFrameTemplate")
    local scrollFrame = f.ScrollFrame
    scrollFrame:SetSize(350,150)
    scrollFrame:SetPoint("TOP", f, "TOP", -10, -40)

    local editBox = CreateFrame("EditBox", nil, f)
    f.EditBox = editBox
    editBox:SetSize(350,150)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetScript("OnEscapePressed", function()
        AssignmentImport:Hide()
    end)
    editBox:SetScript("OnEnterPressed", function(self) 
        AssignmentImport:Import(self:GetText())
        AssignmentImport:Hide()
    end)
    editBox:SetText("<item><name>Eskhandar's Collar</name><time>1574802838</time><member>disenchanted</member><itemid>18205::::::::60:::::::</itemid><cost>0</cost><boss>Onyxia</boss></item>")
    --editBox:HighlightText()
    scrollFrame:SetScrollChild(editBox)

    local closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")

    closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)

    local border = CreateFrame("Frame", nil, f)
    border:SetSize(386,160)
    border:SetPoint("TOP", f, "TOP", 0, -35 )
    border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })

    local helpText = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    helpText:SetPoint("CENTER", f, "BOTTOM", 0, 30)
    helpText:SetText(_LS["HELPTEXT"])
    
    --scrollFrame:SetScript("OnEscapePressed", UI.ExportFrame.Hide)
    f:Hide()
    return f
end

local function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ';'
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

function AssignmentImport:Import(text)

    core:Print("Import")
   
    local t = {}

    -- local i = 1
    -- while true do

    --     local ret = ParseCSVLine(i, t)
    --     core:Print(ret)
    --     if not ret then break 
    --     else table.insert(t, ret) end
    -- end

    text = text:match( "^%s*(.-)%s*$" ) -- remove leading and trailing spaces
    --Excel add quotes at start and end so remove it
    text = string.sub(text, 2, string.len(text)-1)
    
    local title = "";

    local i = 1
    for s in text:gmatch("[^\r\n]+") do
        
        core:PrintDebug("Line",i, s)
        local ret = ParseCSVLine(s,";")

        if i == 1 then
            -- First row is header
            title = ret[1]
        else
            table.insert(t, ret)
        end

        
        i = i+1;
    end

    AssignmentImport.assignments = {
        ["t"] = title,
        ["a"] = t
    }
    
    core.Sync:SendRaid("AssignmentUpdate", AssignmentImport.assignments);
    -- local test = {
    --     {["p"] = "Doktor", ["a"]= "net da dok"}
    -- }
    -- core:Print( Serializer:Serialize(test))
end

function AssignmentImport:Resend()
    if(AssignmentImport.assignments and AssignmentImport.assignments["a"]) then
     core.Sync:SendRaid("AssignmentUpdate", AssignmentImport.assignments);
    end
end

function AssignmentImport:Hide()
    self:GetFrame():Hide()
end

function AssignmentImport:GetFrame()
    local f = core.UI.AssignmentImportFrame or CreateImportFrame()
    return f
end

--Serializer:Deserialize(message)

function AssignmentImport:ShowFrame(xml)
    core:PrintDebug("ShowExportFrame")
    local frame = self:GetFrame()

    -- if frame still open append instead of overwrite
    if frame:IsShown() then
        frame.EditBox:SetText( frame.EditBox:GetText()..xml)
    else
        frame.EditBox:SetText(xml)
    end
    frame.EditBox:HighlightText()
    frame:Show()
end


function AssignmentImport:GotAssignmentUpdate(update)
    AssignmentImport.assignments = update
end
--assignemts move this

ErrorDKP_API = {}

function ErrorDKP_API:GetAssignments()

    return AssignmentImport.assignments

end