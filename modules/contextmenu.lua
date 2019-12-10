--###############################################
--#  Project: ErrorDKP
--#  File: contextmenu.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 30.11.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

local function CreateContextMenu()
    core.UI.ContextMenu = CreateFrame("Frame", "ErrDKPContextMenuFrame", UIParent, "UIDropDownMenuTemplate")
    local f = core.UI.ContextMenu
    return f
end

function ErrorDKP:GetContextMenu()
    local menu = core.UI.ContextMenu or CreateContextMenu()
    return menu
end

function ErrorDKP:ConextMenu(menu, xoffset, yoffset)
    local isTrusted = core:CheckSelfTrusted()
    local m = {}
    if not isTrusted then
        for i,v in ipairs(menu) do
            if not v.onlyTrusted then
                tinsert(m, b)
            end
        end
    else
        m = menu
    end


    menuFrame = ErrorDKP:GetContextMenu()
    local x = xoffset or 0
    local y = yoffset or 0

    EasyMenu(m, menuFrame, "cursor", xoffset , yoffset, "MENU")  
end

-- Example menu
-- local menu = {
--     { text = "Select an Option", isTitle = true},
--     { text = "Option 1", func = function() print("You've chosen option 1"); end },
--     { text = "Option 2", func = function() print("You've chosen option 2"); end },
--     { text = "More Options", hasArrow = true,
--         menuList = {
--             { text = "Option 3", func = function() print("You've chosen option 3"); end }
--         } 
--     }
-- }