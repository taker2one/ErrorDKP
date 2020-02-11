--###############################################
--#  Project: ErrorDKP
--#  File: itempricetooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP
local _L = core._L

local pendingItemRequests = {}
local timer

local function addHeadLine(tooltip, text)
  if not text or text == "" then return end

  local line = "|cff75DAFF" .. text .. "|r"
  tooltip:AddLine(line)
end

local function addLine(tooltip, value, description)
    if not value or value == "" then return end

    local left, right
    if description and description ~= "" then
        left = NORMAL_FONT_COLOR_CODE .. description .. ":" .. FONT_COLOR_CODE_CLOSE
    else
        left = " "
    end
    right = HIGHLIGHT_FONT_COLOR_CODE .. value .. FONT_COLOR_CODE_CLOSE
  
    tooltip:AddDoubleLine(left, right)
    tooltip:Show()
end

local function redrawTooltip(self)
    --self:ClearLines()
    --AttachErrorDKPItemTooltip(self)
    core:PrintDebug("redrawTooltip", self:GetItem(), self:NumLines())

    --ErrorDKP:ShowItemTooltip(cellFrame, itemLink)
    if self:IsShown() then
        _, link = self:GetItem()
        self:ClearLines()
        self:SetHyperlink(link)
    end
    --self:Show()
end

local function addEdkpTooltip(self, id)
    if id and core.ItemPriceList[id] then
        local prio = core.ItemPriceList[id].prio
        local bis = core.ItemPriceList[id].bis
        local alt = core.ItemPriceList[id].alt
        addHeadLine(self, " ")
        addHeadLine(self, "Error DKP")
        addLine(self, core.ItemPriceList[id].price, core._L["DKPPRICE"])

        if prio and #prio > 0 then
            -- Check for > in prios
            local prioSeqTable = core:SplitString(prio, ">")
            if #prioSeqTable > 1 then
                for i, v in ipairs(prioSeqTable) do
                    local prioTable = core:SplitString(v, ",")
                    for i1, v1 in ipairs(prioTable) do
                        if i1 == 1 then
                            addLine(self, core:ltrim(v1) or _L["TOOLTIP_PRIO_NONE"], _L["TOOLTIP_PRIO_LABEL"] )
                        else
                            addLine(self, i..". "..core:ltrim(v1))
                        end
                    end
                end
            else
                local prioTable = core:SplitString(prio, ",")
                for i, v in ipairs(prioTable) do
                    if i == 1 then
                        addLine(self, core:ltrim(v) or _L["TOOLTIP_PRIO_NONE"], _L["TOOLTIP_PRIO_LABEL"] )
                    else
                        addLine(self, core:ltrim(v) or _L["TOOLTIP_PRIO_NONE"], "" )
                    end
                end
            end
        else
            addLine(self, _L["TOOLTIP_PRIO_NONE"], _L["TOOLTIP_PRIO_LABEL"] )
        end

        --BiS
        if bis and #bis > 0 then
            local bisTable = core:SplitString(bis, ",")
            for i, v in ipairs(bisTable) do
                if i == 1 then
                    addLine(self, core:ltrim(v) or _L["TOOLTIP_PRIO_NONE"], "BiS" )
                else
                    addLine(self, core:ltrim(v) or _L["TOOLTIP_PRIO_NONE"], "" )
                end
            end
        else
            addLine(self, _L["TOOLTIP_PRIO_NONE"], "BiS" )
        end

        -- Alternate not needed at the moment
        -- if alt then
        --     local altTable = core:SplitString(alt, ",")
        --     for i, v in ipairs(altTable) do
        --         if timer and C_Item.IsItemDataCachedByID(v) then
        --             core:PrintDebug("Already chached")
        --             local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v)
        --             if i == 1 then
        --                 addLine(self, itemLink, "Alternate")
        --             else
        --                 addLine(self, itemLink)
        --             end
        --         else
        --             C_Item.RequestLoadItemDataByID(v)
        --             if not timer or timer._cancelled then
        --                 core:PrintDebug("New Timer ")
        --                 timer = C_Timer.NewTimer(1, function()
        --                     redrawTooltip(self)
        --                 end)
        --             elseif timer then
        --                 core:PrintDebug("Cancel and New Timer ", timer._cancelled)
        --                 timer:Cancel()
        --                 timer = C_Timer.NewTimer(1, function()
        --                     redrawTooltip(self)
        --                 end)
        --             end

        --             if i == 1 then
        --                 addLine(self, v, "Alternate")
        --             else
        --                 addLine(self, v, "")
        --             end
        --         end 
        --     end
        -- else 
        --     addLine(self, _L["TOOLTIP_PRIO_NONE"], "Alternate")
        -- end
    end
end

function AttachErrorDKPItemTooltip(self)
    local link = select(2, self:GetItem())
    if not link then return end
  
    local itemString = string.match(link, "item:([%-?%d:]+)")
    if not itemString then return end
  
    local enchantid = ""
    local bonusid = ""
    local gemid = ""
    local bonuses = {}
    local itemSplit = {}
  
    for v in string.gmatch(itemString, "(%d*:?)") do
      if v == ":" then
        itemSplit[#itemSplit + 1] = 0
      else
        itemSplit[#itemSplit + 1] = string.gsub(v, ":", "")
      end
    end
  
    
  
    local id = string.match(link, "item:(%d*)")
    if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
      local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
      for i = 1, 8 do
        if GetMouseFocus().reagentIndex == i then
          id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d*)") or nil
          break
        end
      end
    end
  
    addEdkpTooltip(self, id)
end

local function onSetHyperlink(self, link)
    
    local kind, id = string.match(link,"^(%a+):(%d+)")
    --core:PrintDebug("onSetHyperlink", link, kind)
    if kind == "item" then
        addEdkpTooltip(self,id)
    end
end

--hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
--hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink) --ErrorDKPItemToolTip

-- To register scripts on a central place this will be called from init.lua
function ErrorDKP:RegisterItemPriceTooltip()
    GameTooltip:HookScript("OnTooltipSetItem", AttachErrorDKPItemTooltip)
    ItemRefTooltip:HookScript("OnTooltipSetItem", AttachErrorDKPItemTooltip)
    ErrorDKP:GetItemTooltip():HookScript("OnTooltipSetItem", AttachErrorDKPItemTooltip)
end

function ErrorDKP:OnSetHyperlink()
  onSetHyperlink(self, link)
end