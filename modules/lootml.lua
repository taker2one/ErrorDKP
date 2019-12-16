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
    if core.IsMLooter then
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
end


function ErrorDKP:OnLootOpened()
    if not core.IsMLooter then return; end
    if GetNumLootItems() > 0 then
        ErrorDKP:BuildLootTable()
       
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
    survey["players"] = {}

    -- Items
    for i,v in ipairs(core.LootTable) do
        local item = {
            ["index"] = i,
            ["name"] = v.name,
            ["itemLink"] = v.itemLink,
            ["quality"] = v.quality,
            ["icon"] = v.icon,
            ["responses"] = {}
        }
        table.insert(survey.items, item)
    end
    -- Players
    local cntPlayers = GetNumGroupMembers();
    for i=1, cntPlayers do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
        core:PrintDebug("Add player to survey ", name)
        local player = {
            ["name"] = name,
            ["classFileName"] = fileName,
            ["dkp"] = ErrorDKP:GetPlayerDKP(name)
        }
        table.insert(survey.players, player)
    end

    return survey
end

function ErrorDKP:StartSurvey()
    core:PrintDebug("ErrorDKP:StartSurvey")
    
    if core.SurveyInProgress then
        -- Lootumfrage bereits aktiv, aktuell können wir nur eine gleichzeitig
        core:Print("There is already an active survey, finish or cancel old one to start new")
        return
    end

    local countdown = 120

    core.ActiveSurveyData = BuildSurveyData()
    core.Sync:SendRaid("ErrDKPSurvStart", { ["id"] = core.ActiveSurveyData.id, ["items"] = core.ActiveSurveyData.items, ["countdown"] = countdown })
    core.SurveyInProgress = true
    ErrorDKP.MLResult:Start(countdown+5)
end

function ErrorDKP:OnCommReceived_SurvAnsw(sender, data)
     -- Currently only ML can see result window, change this in a future update but for now ingore 
     if not core.IsMLooter then return end
     -- { ["id"], ["itemIndex"], ["response"]  } 
     if data["id"] ~= core.ActiveSurveyData["id"] then
        core:Print("Got a response from "..sender.." for old survey => drop response, active: "..core.ActiveSurveyData["id"]..", got: "..data["id"])
        return 
     end

     if not core.SurveyInProgress then
        core:Print("Got a response from "..sender.." but there is no active survey")
     end

     if data["response"] == "GOT" then
        -- Client responds survey received
        -- We have multiple items in a survey but only geht one reveived so set it for all items
        for i,v in ipairs(core.ActiveSurveyData["items"]) do
            v.responses[sender] = "PENDING"--data["response"]
        end
        ErrorDKP.MLResult:SetVisualUpdateRequired()
     else
        core.ActiveSurveyData.items[data["itemIndex"]].responses[sender] = data["response"]
        ErrorDKP.MLResult:SetVisualUpdateRequired(data["itemIndex"])
     end

end


