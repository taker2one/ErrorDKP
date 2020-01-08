
--###############################################
--#  Project: ErrorDKP
--#  File: config.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Description: Config window and stuff
--#  Last Edit: 21.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L


-------------------------------------------------
--
-- Minimap Icon
--
-------------------------------------------------

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local menu = {
    { text = _L["MINIMAP"]["MENU_SELECT"], isTitle = true, notCheckable = true},
    { text = _L["MINIMAP"]["MENU_TOGGLE_ERRORDKP"], notCheckable = true, func = function() ErrorDKP:Toggle() end },
    { text = _L["MINIMAP"]["MENU_ML_VOTE"], notCheckable = true, func = function() ErrorDKP.MLResult:Show() end, onlyTrusted = true },
    { text = _L["MINIMAP"]["MENU_VERSIONCHECK"], notCheckable = true, func = function() ErrorDKP.VersionCheck:Show() end, onlyTrusted = true },
    { text = _L["MINIMAP"]["MENU_ITEMCHECK"], notCheckable = true, func = function() ErrorDKP.ItemCheck:Show() end, onlyTrusted = true }
}

local function IconMoveButton(self)
	if self.dragMode == "free" then
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		core.Settings.IconMiniMapLeft = x
		core.Settings.IconMiniMapTop = y
	else
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = Minimap:GetEffectiveScale()
		px, py = px / scale, py / scale
		
		local angle = math.atan2(py - my, px - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x, y = x*80, y*80
		else
			local diagRadius = 103.13708498985
			x = math.max(-80, math.min(x*diagRadius, 80))
			y = math.max(-80, math.min(y*diagRadius, 80))
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		core.Settings.IconMiniMapLeft = x
		core.Settings.IconMiniMapTop = y
	end
end

local function MiniMapIconOnClick(self, button)
    if button == "RightButton" then
        core:PrintDebug("MiniMapIconOnClick", button)
        ErrorDKP:ConextMenu(menu,10,-15)
    elseif button == "LeftButton" then
        core:PrintDebug("MiniMapIconOnClick", button)
		ErrorDKP:Toggle()
	end
end

local function RegisterMiniMapScripts()
    core.UI.MiniMapIcon:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", IconMoveButton)
        self.isMoving = true
        GameTooltip:Hide()
    end)
    core.UI.MiniMapIcon:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
        self.isMoving = false
    end)
    core.UI.MiniMapIcon:SetScript("OnMouseUp", MiniMapIconOnClick)
end

function ErrorDKP:CreateMiniMapIcon()
    core:PrintDebug("Create Minimap Icon")
    if core.UI.MiniMapIcon then return end
    core.UI.MiniMapIcon = CreateFrame("Button", "LibDBIcon10_ErrorDKP", Minimap)
    local MiniMapIcon = core.UI.MiniMapIcon
    ErrorDKP.MiniMapIcon = MiniMapIcon
    MiniMapIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") 
    MiniMapIcon:SetSize(32,32) 
    MiniMapIcon:SetFrameStrata("MEDIUM")
    MiniMapIcon:SetFrameLevel(8)
    MiniMapIcon:SetPoint("CENTER", -12, -80)
    MiniMapIcon:SetDontSavePosition(true)
    MiniMapIcon:RegisterForDrag("LeftButton")
    MiniMapIcon.icon = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
    MiniMapIcon.icon:SetTexture("Interface\\AddOns\\ErrorDKP\\media\\MiniMap")
    MiniMapIcon.icon:SetSize(32,32)
    MiniMapIcon.icon:SetPoint("CENTER", 0, 0)
    MiniMapIcon.border = MiniMapIcon:CreateTexture(nil, "ARTWORK")
    MiniMapIcon.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    MiniMapIcon.border:SetTexCoord(0,0.6,0,0.6)
    MiniMapIcon.border:SetAllPoints()
    MiniMapIcon:RegisterForClicks("anyUp")
    MiniMapIcon:SetScript("OnEnter",function(self) 
        GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
        GameTooltip:AddLine("WoW Error DKP") 
        GameTooltip:AddLine(_L["MINIMAP"]["DESCRLCLICK"],1,1,1) 
        --GameTooltip:AddLine(L.minimaptooltiprmp,1,1,1) 
        GameTooltip:Show() 
    end)
    MiniMapIcon:SetScript("OnLeave", function(self)    
        GameTooltip:Hide()
    end)

    -- Apply position from settings
    if core.Settings.IconMiniMapLeft and core.Settings.IconMiniMapTop then
        MiniMapIcon:ClearAllPoints()
        MiniMapIcon:SetPoint("CENTER", core.Settings.IconMiniMapLeft, core.Settings.IconMiniMapTop)
    end

    RegisterMiniMapScripts()
end

