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

        for i = 1, numLootItems do
            if (LootSlotHasItem(i)) then
                local lootSlotLink = GetLootSlotLink(i)
                local lootSlotName = core:ItemStringFromItemLink(lootSlotLink)

                if (not core.LootSlotInfos[i]) or
                   ( lootSlotName == core.LootSlotInfos[i].name )
                then
                    core:PrintDebug("Build Lootslot", i)
                    local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
                    if lootIcon then
                        local itemLink = GetLootSlotLink(i)
                        if lootQuantity == 0 then
                            core.LootSlotInfos[i] = nil
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

                            if lootQuality >= core.ISettings.MasterLootMinQuality then
                                tinsert(core.LootTable, {
                                    name = lootName,
                                    itemLink = itemLink,
                                    quantity =  lootQuantity,
                                    quality = lootQuality,
                                    icon = lootIcon
                                }) 
                            end
                        end
                    else
                        core:ErrorDebug("BuidLootSlotInfo, item hat no icon", GetLootSlotInfo(i))
                    end
                else
                    core:PrintDebug("Item already in lootslotlist")
                end
            else
                core:PrintDebug("No loot in lootslots")
            end
        end
    end
end


function ErrorDKP:OnLootOpened()
    core:PrintDebug("ErrorDKP:OnLootOpened GetNumLootItems()", GetNumLootItems(), #core.LootSlotInfos)
    if not core.IsMLooter then return; end

    if GetNumLootItems() > 0 then
        ErrorDKP:BuidLootSlotInfo()
        --ErrorDKP:BuildLootTable()
       
        if #core.LootTable > 0 and not core.SurveyInProgress then
			ErrorDKP.MLSetupSurvey:Show(core.LootTable)
		end
    end
end

function ErrorDKP:OnLootClosed()
    table.wipe(core.LootSlotInfos)
    table.wipe(core.LootTable)
end

-- Extract relevant items from LootSlotInfos
function ErrorDKP:BuildLootTable()
    table.wipe(core.LootTable)
    core:PrintDebug("ErrorDKP:BuildLootTable() LootSlotInfos", #core.LootSlotInfos)
    for i, v in ipairs(core.LootSlotInfos) do
        core:PrintDebug("ErrorDKP:BuildLootTable()", i, v)
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
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
        local race, raceEn, gender
        if UnitInRaid("PLAYER") then
            race, raceEn = UnitRace("raid"..i)
            gender = UnitSex("raid"..i)
        elseif UnitInParty("PLAYER") then
            race, raceEn = UnitRace("party"..i)
            gender = UnitSex("party"..i)
        end

        core:PrintDebug("Add player to survey ", name)
        local player = {
            ["name"] = name,
            ["classFileName"] = fileName,
            ["race"] = raceEn,
            ["gender"] = gender,
            ["dkp"] = ErrorDKP:GetPlayerDKP(name)
        }
        table.insert(survey.players, player)
    end

    return survey
end

function ErrorDKP:StartSurvey(timeout)
    core:PrintDebug("ErrorDKP:StartSurvey with timeout ".. tostring(timeout))
    
    if core.SurveyInProgress then
        -- Lootumfrage bereits aktiv, aktuell können wir nur eine gleichzeitig
        core:Print("There is already an active survey, finish or cancel old one to start new")
        return
    end

    local countdown = timeout or 120

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
        for i,v in ipairs(core.ActiveSurveyData["items"]) do
            v.responses[sender] = { "PENDING", -1 } --data["response"]
        end
        ErrorDKP.MLResult:SetVisualUpdateRequired()
     else
        core.ActiveSurveyData.items[data["itemIndex"]].responses[sender] = { data["response"], data["hasItem"], data["roll"] or 0 }
        ErrorDKP.MLResult:SetVisualUpdateRequired(data["itemIndex"])
     end

end


