--###############################################
--#  Project: ErrorDKP
--#  File: gnotedkp.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 28.02.2020
--###############################################

local addonName, core = ...
local ErrorDKP = core.ErrorDKP
ErrorDKP.GNoteDKP = {}
local GNoteDKP = ErrorDKP.GNoteDKP

local OFFICER_NOTE_LENGTH = 31
local GUILD_INFO_LENGTH = 500

local GuildDataAvailable
local updateFrame = CreateFrame("Frame", "GuildRosterUpdateFrame")

--#
--# Public API
--#

function GNoteDKP:GetAll()
    local memberCnt = GetNumGuildMembers()
    local canEdit = CanEditOfficerNote()
    local canView = CanViewOfficerNote()
    local canEditNote = CanEditPublicNote()
    local canEditGuildInfo = CanEditGuildInfo()

    core:PrintDebug("Total guildmembers = ", memberCnt, "Canedit: ", canEdit)


    local dkplist = {}
        for i = 1, memberCnt do
            name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)

            local points = GNoteDKP:ExtractPoints(note)
            --core:Error(name, classFileName)
            if points ~= nil then
                local member = {
                    name = gsub(name, "%-[^|]+", ""), -- remove Realm
                    dkp = points,
                    classFilename = classFileName,
                    classId = core:classFileNameToId(classFileName),
                    GuildRank = rank
                }
                
                table.insert(dkplist, member)
            end
        end
        return dkplist
   
end

function GNoteDKP:GetTimestamp()
    local a = self:GetGInfoData()
    return a and a.timestamp or nil
end

function GNoteDKP:GetPlayerDKP(playerName)
    local memberCnt = GetNumGuildMembers()
  
    if not core:CheckDKPOfficer() then
        core:Error("Cannot update points you are no DKP-Officer")
        return
    end

    for i = 1, memberCnt do
        name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if string.lower(gsub(name, "%-[^|]+", "")) == string.lower(playerName) then
            core:PrintDebug("Found player")
            local points = GNoteDKP:ExtractPoints(note)
            if points == nil then 
                return 0 
            else 
                return points 
            end
        end
    end
    return nil
end

function GNoteDKP:ChangePlayerDKP(playerName, dkp, noInfoUpdate)
    core:PrintDebug("GNoteDKP:ChangePlayerDKP", playerName, dkp)
    local oldPoints = self:GetPlayerDKP(playerName)
    if oldPoints == nil then
        core:Error("Player is not in Guild, cannot update DKP in note.")
        return
    end
    local newPoints = oldPoints + dkp
    local note = self:BuildDKPNote(newPoints)
    self:UpdateNote(playerName, note)

    -- Ignore Update info in case of batch update
    if noInfoUpdate then return end
    self:UpdateDKPInfo()
end

function GNoteDKP:SetPlayerDKP(playerName, dkp, noInfoUpdate)
    core:PrintDebug("GNoteDKP:SetPlayerDKP", playerName, dkp)
    local note = self:BuildDKPNote(dkp)
    self:UpdateNote(playerName, note)

    -- Ignore Update info in case of batch update
    if noInfoUpdate then return end
    self:UpdateDKPInfo()
end

function GNoteDKP:IsUpdateRequired()
    local d = self:GetGInfoData()

    if not tonumber(core:GetLocalDKPDataTimestamp()) then
        return true
    end

    if d and d.timestamp then
        if tonumber(d.timestamp) > tonumber(core:GetLocalDKPDataTimestamp()) then
            return true
        end
    end
end

function GNoteDKP:RefreshLocalTableIfRequired()
    if self:IsUpdateRequired() then
        self:RefreshLocalDKPTable()
    end
end

function GNoteDKP:RefreshLocalDKPTable()
    core:PrintDebug("GNoteDKP:RefreshLocalDKPTable", self:GetTimestamp())
    local dkptable = self:GetAll()
    table.wipe(core.DKPTable)
    
    for k,v in pairs(dkptable) do
        core.DKPTable[k] = v
    end

    core:SetLocalDKPDataTimestamp(self:GetTimestamp())
end

function GNoteDKP:IsGuildDataAvailable()
    if GuildDataAvailable then
        return true
    else
        if GetGuildInfoText() ~= nil and  GetNumGuildMembers() > 0 then
            GuildDataAvailable = true
        end
    end
end

function GNoteDKP:UpdateDKPInfo()
    local d = self:BuildDKPInfo(GetServerTime())
    self:UpdateGInfoData(d)
end

--#
--# Internal Usage
--#

function GNoteDKP:BuildDKPNote(points)
    return "{" .. tostring(points) .. "}"
end

function GNoteDKP:UpdateNote(playerName, dkpnote)
    local memberCnt = GetNumGuildMembers()
    for i = 1, memberCnt do
        name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)

        if string.lower(gsub(name, "%-[^|]+", "")) == string.lower(playerName) then
            -- remove old dkp
            local newNote = string.gsub(note, "{.*}", "")

            if string.len(newNote) + string.len(dkpnote) <= OFFICER_NOTE_LENGTH then
                -- Length is ok
                newNote = newNote .. dkpnote
            else
                -- Cut existing note
                local diff = string.len(newNote) + string.len(dkpnote) - OFFICER_NOTE_LENGTH
                newNote = string.sub(newNote, 1, string.len(newNote)-diff) .. dkpnote
            end

            --GuildRosterSetOfficerNote(i, newNote) Use Public note
            GuildRosterSetPublicNote(i, newNote)
            core:PrintDebug("GNoteDKP:UpdateNote ", newNote)
            return
        end
    end
    -- If We reach this point player is not in guild
end

function GNoteDKP:UpdateOfficersNote(playerName, dkpnote)
    local memberCnt = GetNumGuildMembers()
    for i = 1, memberCnt do
        name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if string.lower(gsub(name, "%-[^|]+", "")) == string.lower(playerName) then
            -- remove old dkp
            local newNote = string.gsub(officernote, "{.*}", "")

            if string.len(newNote) + string.len(dkpnote) <= OFFICER_NOTE_LENGTH then
                -- Length is ok
                newNote = newNote .. dkpnote
            else
                -- Cut existing note
                local diff = string.len(newNote) + string.len(dkpnote) - OFFICER_NOTE_LENGTH
                newNote = string.sub(newNote, 1, string.len(newNote)-diff) .. dkpnote
            end

            GuildRosterSetOfficerNote(i, newNote)
            core:PrintDebug("GNoteDKP:UpdateNote ", newNote)
            return
        end
    end
    -- If We reach this point player is not in guild
end

function GNoteDKP:ExtractPoints(note)
    if not note then return nil end
    local p = string.match(note, "{.*}")

    if p then
        -- remove {} brackets
        local pointString = string.sub(p,2,string.len(p)-1)
        -- convert to number
        local points = tonumber(pointString)

        if points ~= nil then
            -- everything is fine
            return points
        else
            -- error
            core:Error("Error converting points")
        end        
    end
end

function GNoteDKP:GetGInfoData()
    local text = GetGuildInfoText()
    local info = self:ExtractGInfoData(text)
    
    return info
end

function GNoteDKP:BuildDKPInfo(timestamp)
    return "{" .. tostring(timestamp) .. "}"
end

function GNoteDKP:UpdateGInfoData(dkpinfo)
    if not dkpinfo then
        core:Error("UpdateGInfoData: invalid data.")
        return
    end
    local text = GetGuildInfoText()

    local newInfo = string.gsub(text, "{.*}", "")
    if string.len(newInfo) + string.len(dkpinfo) <= GUILD_INFO_LENGTH then
        -- Length is ok
        newInfo = newInfo .. dkpinfo
    else
        -- Cut existing info
        local diff = string.len(newInfo) + string.len(dkpinfo) - GUILD_INFO_LENGTH
        newInfo = string.sub(newInfo, 1, string.len(newInfo)-diff) .. dkpinfo
    end
    SetGuildInfoText(newInfo)
end

function GNoteDKP:ExtractGInfoData(ginfotext)
    core:PrintDebug("ExtractGInfoData", string.len(ginfotext))
    if not ginfotext then return nil end
    local p = string.match(ginfotext, "{.*}")

    if p then
        -- remove {} brackets
        local timeString = string.sub(p,2,string.len(p)-1)
        -- convert to number
        local dkpTime = tonumber(timeString)

        if dkpTime ~= nil then
            -- everything is fine
            return { timestamp = dkpTime }
        else
            -- error
            core:Error("Error getting time")
            -- This means there is currently no
        end
    end
end

local function ExtractNum(str, keys)

    local i1, i2, tmpstr, value, key
  
    for j=1, table.getn(keys) do
      key=keys[j]
    -- find key voice
      i1, i2 = string.find(str, key..QDKP2_NOTE_DASH.."[^%d]*")
      if i1 and i2 then
        i1, i2 = string.find(str, "[%d.]*", i2+1)        -- find digits
        if (i1 == nil or i2 == nil or i2 < i1) then break; end   --control #1
        tmpstr = string.sub(str, i1, i2)
        value = tonumber(tmpstr)
        if not value then return; end
        if (i1 > 1) then
          if (string.sub(str, i1-1, i1-1) == "-") then value = 0 - value; end    -- check for negatives
        end
        break
      end
    end
    return value
end

function GNoteDKP:InitRosterUpdate()
    updateFrame.lastCheck = time() - 10
    updateFrame:SetScript("OnUpdate", function()
        if ((time() - updateFrame.lastCheck) > 10) then
            core:PrintDebug("Call Guildroster()")
            updateFrame.lastCheck = time();
            GuildRoster()
        end
    end)
end

function GNoteDKP:ResetUpdateCycle()
    updateFrame.lastCheck = time()
end