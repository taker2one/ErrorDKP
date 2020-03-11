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

function GNoteDKP:GetAll()
    local memberCnt = GetNumGuildMembers()
    local canEdit = CanEditOfficerNote()
    local canView = CanViewOfficerNote()
    local canEditGuildInfo = CanEditGuildInfo()

    core:PrintDebug("Total guildmembers = ", memberCnt, "Canedit: ", canEdit)


    local dkplist = {}
    if canView then
        for i = 1, memberCnt do
            name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)

            local points = GNoteDKP:ExtractPoints(officernote)
            core:Error(name, classFileName)
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
            if name == "Dichterin-Venoxis" then --DBG
                core:Error("Dichterin-Venoxis", points)
            end
        end
        return dkplist
    else
        return nil
    end
   
end

function GNoteDKP:BuildDKPNote(points)
    return "{" .. tostring(points) .. "}"
end

function GNoteDKP:UpdateNote(playerName, dkpnote)
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

function GNoteDKP:GetTimestamp()
    local a = self:GetGInfoData()
    return a and a.Timestamp or nil
end

function GNoteDKP:IsUpdateRequired()
    local d = self:GetGInfoData()

    if d and d.timestamp then
        if tonumber(d.timestamp) > tonumber(core.DKPDataInfo.DKPInfo.timestamp) then
            return true
        end
    end
end

function GNoteDKP:ExtractGInfoData(ginfotext)
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

  function QDKP2_MakeNote(incNet, incTotal, incSpent, incHours)
    --puts the data back into a note
    
      incNet=RoundNum(incNet)
      incTotal=RoundNum(incTotal)
      incSpent=RoundNum(incSpent)
      incHours=RoundNum(incHours*10)/10
    
      local out=''
      local netLabel='Net'
      local optLabel, optValue='Tot', incTotal
      local hrsLabel='Hrs'
      if QDKP2_TotalOrSpent==2 then
        optLabel = 'Spt'
        optValue = incSpent
      end
      if QDKP2_CompactNoteMode then
        netLabel='N'
        hrsLabel='H'
        optLabel=string.sub(optLabel,1,1)
      end
    
      local limitMax,limitMin=QDKP2_GetMaximumFieldNumber()
      if incNet>limitMax then incNet=limitMax
      elseif incNet<limitMin then incNet=limitMin
      end
      if optValue>limitMax then optValue=limitMax
      elseif optValue<limitMin then optValue=limitMin
      end
      if incHours>9999.9 then incHours='9999.9'
      elseif incHours<0 then incHours='0'
      end
    
      local out=netLabel..QDKP2_NOTE_DASH..tostring(incNet)..QDKP2_NOTE_BREAK..optLabel..QDKP2_NOTE_DASH..tostring(optValue)
      if QDKP2_StoreHours then
        out=out..QDKP2_NOTE_BREAK..hrsLabel..QDKP2_NOTE_DASH..tostring(incHours)
      end
      return out
    end


    function QDKP2_ParseNote(incParse)
        -- Given string str, find and return net,total,spent,hours
        -- returns 0 on not found.
        -- does NOT rely on outputformat for the parsing.
        
          local nettemp=0
          local spenttemp=0
          local totaltemp=0
          local hourstemp=0
        
          nettemp   = ExtractNum(incParse, {"Net", "DKP", "N"})     -- Net is any number following n=, net=
          totaltemp = ExtractNum(incParse, {"Total","Tot","T","G"}) -- Total is any number following g=, t=, tot=, total=
          spenttemp = ExtractNum(incParse, {"Spent", "Spt","S"})   -- Spent is any number following s=,spt=,spent=
          hourstemp = ExtractNum(incParse, {"Hours","Hrs","H"})   -- Hours is any number following hours=, hrs=, h=
        
          --if there isn't any compatible QDKP2 text in the note, return all 0
          if not spenttemp and not totaltemp and not nettemp then
            nettemp=0
            totaltemp=0
            spenttemp=0
          end
        
          --this is to fix output format with only NET field (DKP:xx)
          if not spenttemp and not totaltemp then
            totaltemp=nettemp
          end
        
          --this is to fix output format with only total
          if not nettemp and not spenttemp then
            nettemp=totaltemp
          end
        
          --this is to fix output formats with only spent (????)
          if not nettemp and not totaltemp then
            totaltemp=spenttemp
          end
        
          --fixups for empty fields
          nettemp=nettemp or totaltemp - spenttemp
          spenttemp=spenttemp or totaltemp - nettemp
          totaltemp=totaltemp or nettemp + spenttemp
          hourstemp=hourstemp or 0
        
          return nettemp, totaltemp, spenttemp, hourstemp
        end
