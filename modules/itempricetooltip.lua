--###############################################
--#  Project: ErrorDKP
--#  File: itempricetooltip.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

local function addLine(tooltip, value, description)
    if not value or value == "" then return end

    local left, right
    left = NORMAL_FONT_COLOR_CODE .. description .. ":" .. FONT_COLOR_CODE_CLOSE
    right = HIGHLIGHT_FONT_COLOR_CODE .. value .. FONT_COLOR_CODE_CLOSE
  
    tooltip:AddDoubleLine(left, right)
    tooltip:Show()
end

local function attachItemTooltip(self)
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
  
    if id then
      --Check if item is in pricelist
      if core.ItemPriceList[id] then
        addLine(self, core.ItemPriceList[id].price, core._L["DKPPRICE"] )
      end
    end
end

local function onSetHyperlink(self, link)
    local kind, id = string.match(link,"^(%a+):(%d+)")
    if kind == "item" then
        if id and core.ItemPriceList[id] then
            addLine(self, core.ItemPriceList[id].price, core._L["DKPPRICE"])
        end
    end
end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)



-- To register scripts on a central place this will be called from init.lua
function ErrorDKP:RegisterItemPriceTooltip()
    GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
end