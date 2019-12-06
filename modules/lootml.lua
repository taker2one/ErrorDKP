--###############################################
--#  Project: ErrorDKP
--#  File: lootml.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 06.12.2019
--###############################################
local addonName, core = ...
local ErrorDKP = core.ErrorDKP

-- Needed events 

function ErrorDKP:BuidLootSlotInfo()
    local numLootItems = GetNumLootItems()

    if numLootItems <= 0 then return end

    table.wipe(core.LootSlotInfos)
    for i = 1, numLootItems do
        if LootSlotHasItem(i) then
            local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
            --local guid = self.Utils:ExtractCreatureID((GetLootSourceInfo(i)))
            --if guid and self.lootGUIDToIgnore[guid] then return self:Debug("Ignoring loot from ignored source", guid) end
            if lootIcon then
                local itemLink = GetLootSlotLink(i)
                if lootQuantity == 0 then
                    core:PrintDebug("Ignore coins")
                --elseif not self.Utils:IsItemBlacklisted(link) then
                else
                    core:PrintDebug("Save info",i, itemLink, lootQuality, lootQuantity, GetLootSourceInfo(i))
                    core.LootSlotInfos[i] = {
                        icon = lootIcon,
                        name = lootName,
                        itemLink = itemLink,
                        quantity = lootQuantity,
                        quality = lootQuality,
                    }
                end
            else
                core:ErrorDebug("BuidLootSlotInfo, item hat no icon", GetLootSlotInfo(i))
            end
        end
    end
end


function ErrorDKP:OnLootOpened()
    --if not core:CheckMasterLooter() then return; end --DBG
    if GetNumLootItems() > 0 then
        ErrorDKP:BuildLootTable()
        -- for i = 1, GetNumLootItems() do
        --     if core.LootSlotInfos[i] then
        --         local item = core.LootSlotInfos[i].itemLink
        --         local quantity = core.LootSlotInfos[i].quantity
        --         local quality = core.LootSlotInfos[i].quality
        --     end
        -- end

        if #core.LootTable > 0 and not core.SurveyInProgress then
			ErrorDKP.MLSetupSurvey:Show(core.LootTable)
		end
    end
end

-- Extract relevant items from LootSlotInfos
function ErrorDKP:BuildLootTable()
    table.wipe(core.LootTable)
    for i, v in ipairs(core.LootSlotInfos) do
        if v.quality >= core.ISettings.MasterLootMinQuality then
            tinsert(core.LootTable, {
                name = v.name,
                itemLink = v.itemLink,
                quantity = v.quantity,
                quality = v.quality,
                icon = v.icon
            }) 
        end
    end
end

function ErrorDKP:RemoveFromLootTable(index)
    table.remove(core.LootTable, index)
end

function BuildSurveyData()
    local id = core:GenUniqueId()
    local survey = {}
    survey["id"] = id
    survey["items"] = {}

    for i,v in ipairs(core.LootTable) do
        local item = {
            ["index"] = i,
            ["name"] = v.name,
            ["itemLink"] = v.itemLink,
            ["quality"] = v.quality,
            ["icon"] = v.icon
        }
        table.insert(survey.items, item)
    end

    return survey
end

function ErrorDKP:StartSurvey()
    core:PrintDebug("ErrorDKP:StartSurvey")
    
    if core.SurveyInProgress then
        -- Lootumfrage bereits aktiv, aktuell können wir nur eine gleichzeitig
        core:Print("There is already an aktive survey, finish old one to start new")
        return
    end

    core.ActiveSurveyData = BuildSurveyData()
    core.Sync:SendRaid("ErrDKPSurvStart", core.ActiveSurveyData)

    core.SurveyInProgress = true
end


