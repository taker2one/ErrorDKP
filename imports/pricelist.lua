--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 22.11.2019
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "1.2",
    ["timestamp"] = "1574779920 "
}

local pricelist = {
    ["16800"]= { price = "50" ,prio = ""},
    ["16829"]= { price = "50" ,prio = ""},
    ["17109"]= { price = "60" ,prio = "Caster"},
    ["16837"]= { price = "50" ,prio = ""},
    ["16805"]= { price = "50" ,prio = ""},
    ["18861"]= { price = "30" ,prio = "Tank"},
    ["16863"]= { price = "50" ,prio = ""},
    ["18879"]= { price = "10" ,prio = "Tank"},
    ["18872"]= { price = "10" ,prio = ""},
    ["19147"]= { price = "80" ,prio = "Caster"},
    ["19145"]= { price = "60" ,prio = "Caster"},
    
    ["18823"]= { price = "40" ,prio = "Dagger Rogue"},
    ["16796"]= { price = "30" ,prio = ""},
    ["16835"]= { price = "30" ,prio = ""},
    ["18829"]= { price = "40" ,prio = "Ele Schami"},
    ["16843"]= { price = "30" ,prio = ""},
    ["17073"]= { price = "100" ,prio = "PVP Weapon"},
    ["18203"]= { price = "60" ,prio = "Tank"},
    ["16810"]= { price = "30" ,prio = ""},
    ["19142"]= { price = "40" ,prio = "Caster & Heals (PVP BIS)"},
    ["19143"]= { price = "60" ,prio = "DPS Warri"},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["16847"]= { price = "30" ,prio = ""},
    ["16867"]= { price = "40" ,prio = ""},
    ["19136"]= { price = "60" ,prio = "Caster"},
    ["17065"]= { price = "40" ,prio = "Tank"},
    ["16822"]= { price = "40" ,prio = ""},
    ["18822"]= { price = "100" ,prio = "DPS Warri"},
    ["16814"]= { price = "30" ,prio = ""},
    ["18821"]= { price = "80" ,prio = "Warri, Schami DPS, Hunter"},
    ["19144"]= { price = "20" ,prio = "Enh Schami (kein BIS)"},
    ["17069"]= { price = "80" ,prio = "Meeles"},
    ["18820"]= { price = "60" ,prio = "Caster"},
    
    
    
    
    ["17077"]= { price = "10" ,prio = ""},
    ["16839"]= { price = "50" ,prio = ""},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["16849"]= { price = "50" ,prio = ""},
    ["16812"]= { price = "50" ,prio = ""},
    ["18879"]= { price = "10" ,prio = "Tank"},
    ["18872"]= { price = "10" ,prio = ""},
    ["16826"]= { price = "50" ,prio = ""},
    ["19147"]= { price = "80" ,prio = "Caster"},
    ["19145"]= { price = "40" ,prio = "Caster"},
    ["16862"]= { price = "50" ,prio = ""},
    ["18875"]= { price = "40" ,prio = "Dudu & Schami Heal"},
    ["18878"]= { price = "30" ,prio = "Caster (übergangswaffe)"},
    ["19146"]= { price = "40" ,prio = "Warri & Schami DPS"},
    
    
    
    
    ["18564"]= { price = "Tank" ,prio = ""},
    ["18823"]= { price = "40" ,prio = "Dagger Rogue"},
    ["16795"]= { price = "30" ,prio = ""},
    ["17105"]= { price = "60" ,prio = "Schami & Dudu Heal"},
    ["18832"]= { price = "60" ,prio = "Non Orc Fury & Rogues & Hunter"},
    ["16834"]= { price = "30" ,prio = ""},
    ["16813"]= { price = "30" ,prio = ""},
    ["18829"]= { price = "40" ,prio = "Ele Schami"},
    ["17066"]= { price = "40" ,prio = "Tank"},
    ["16842"]= { price = "30" ,prio = ""},
    ["16808"]= { price = "30" ,prio = ""},
    ["19142"]= { price = "40" ,prio = "Caster & Heals (PVP BIS)"},
    ["19143"]= { price = "60" ,prio = "Warri DPS"},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["16846"]= { price = "30" ,prio = ""},
    ["17071"]= { price = "40" ,prio = "Non BIS Waffe"},
    ["16866"]= { price = "30" ,prio = ""},
    ["19136"]= { price = "60" ,prio = "Caster"},
    ["16821"]= { price = "30" ,prio = ""},
    ["18822"]= { price = "100" ,prio = "DPS Warri "},
    ["18821"]= { price = "80" ,prio = "Warri, Schami DPS, Hunter"},
    ["18820"]= { price = "60" ,prio = "Caster"},
    
    
    
    
    ["16801"]= { price = "50" ,prio = ""},
    ["16811"]= { price = "50" ,prio = ""},
    ["16831"]= { price = "50" ,prio = ""},
    ["17077"]= { price = "10" ,prio = ""},
    ["16803"]= { price = "50" ,prio = ""},
    ["16852"]= { price = "50" ,prio = ""},
    ["16824"]= { price = "50" ,prio = ""},
    ["19147"]= { price = "80" ,prio = "Caster"},
    ["19145"]= { price = "60" ,prio = "Caster"},
    ["18872"]= { price = "20" ,prio = ""},
    
    
    
    
    ["18564"]= { price = "Tank" ,prio = ""},
    ["18823"]= { price = "40" ,prio = "Dagger Rogue"},
    ["16797"]= { price = "50" ,prio = ""},
    ["16836"]= { price = "50" ,prio = ""},
    ["16844"]= { price = "50" ,prio = ""},
    ["16807"]= { price = "50" ,prio = ""},
    ["19142"]= { price = "40" ,prio = "Caster & Heals (PVP BIS)"},
    ["19143"]= { price = "60" ,prio = "Warri DPS"},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["19136"]= { price = "60" ,prio = ""},
    ["18822"]= { price = "100" ,prio = "Warri DPS"},
    ["18821"]= { price = "80" ,prio = "Warri, Schami DPS, Hunter"},
    ["17110"]= { price = "20" ,prio = "Caster & Heal PVP Item"},
    ["18820"]= { price = "60" ,prio = "Caster"},
    
    
    
    
    
    ["18823"]= { price = "60" ,prio = "Dagger Rogue"},
    ["16798"]= { price = "50" ,prio = ""},
    ["17103"]= { price = "100" ,prio = "Caster"},
    ["17072"]= { price = "60" ,prio = "Tank"},
    ["16865"]= { price = "50" ,prio = ""},
    ["16833"]= { price = "50" ,prio = ""},
    ["16841"]= { price = "50" ,prio = ""},
    ["16809"]= { price = "50" ,prio = ""},
    ["19142"]= { price = "40" ,prio = "Caster & Heals (PVP BIS)"},
    ["19143"]= { price = "60" ,prio = "Warri DPS"},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["16845"]= { price = "50" ,prio = ""},
    ["19136"]= { price = "60" ,prio = "Caster"},
    ["16820"]= { price = "50" ,prio = ""},
    ["18822"]= { price = "100" ,prio = "Warri DPS"},
    ["18821"]= { price = "80" ,prio = "Warri, Schami DPS, Hunter"},
    ["16815"]= { price = "50" ,prio = ""},
    ["18842"]= { price = "120" ,prio = "Caster"},
    ["17203"]= { price = "Gildenbank" ,prio = ""},
    ["18820"]= { price = "60" ,prio = "Caster"},
    
    
    
    
    ["17077"]= { price = "10" ,prio = ""},
    ["18861"]= { price = "40" ,prio = "Tank"},
    ["16848"]= { price = "50" ,prio = ""},
    ["18879"]= { price = "10" ,prio = "Tank"},
    ["18872"]= { price = "20" ,prio = ""},
    ["16816"]= { price = "50" ,prio = ""},
    ["16823"]= { price = "50" ,prio = ""},
    ["16868"]= { price = "50" ,prio = ""},
    ["19147"]= { price = "80" ,prio = "Caster"},
    ["18875"]= { price = "40" ,prio = "Dudu & Schami Heal"},
    ["17074"]= { price = "20" ,prio = ""},
    ["18878"]= { price = "40" ,prio = "Caster (Übergangswaffe)"},
    ["19146"]= { price = "40" ,prio = "Warri & Schami DPS"},
    
    
    
    
    ["18703"]= { price = "150" ,prio = ""},
    ["18805"]= { price = "60" ,prio = "Dagger Rogue & Hunter BIS"},
    ["18811"]= { price = "10" ,prio = "BWL Fire Resi für alle"},
    ["18809"]= { price = "40" ,prio = "Hexer"},
    ["18646"]= { price = "150" ,prio = ""},
    ["18810"]= { price = "40" ,prio = "Dudu & Schami Heal"},
    ["18812"]= { price = "40" ,prio = ""},
    ["19140"]= { price = "80" ,prio = "Heal BIS"},
    ["18803"]= { price = "20" ,prio = "Ret Pala - eher unnötig für horde"},
    
    
    
    
    ["16915"]= { price = "75" ,prio = ""},
    ["16901"]= { price = "75" ,prio = ""},
    ["18816"]= { price = "100" ,prio = ""},
    ["19138"]= { price = "20" ,prio = "PVP?"},
    ["16938"]= { price = "75" ,prio = ""},
    ["16909"]= { price = "75" ,prio = ""},
    ["18817"]= { price = "60" ,prio = "Enh Schami"},
    ["17063"]= { price = "80" ,prio = "Physical DPS"},
    ["17107"]= { price = "40" ,prio = "Tank - Meele PVP"},
    ["18815"]= { price = "10" ,prio = ""},
    ["16922"]= { price = "75" ,prio = ""},
    ["16930"]= { price = "75" ,prio = ""},
    ["16962"]= { price = "75" ,prio = ""},
    ["18814"]= { price = "100" ,prio = "Caster"},
    ["17106"]= { price = "40" ,prio = "Schami heal"},
    ["19137"]= { price = "60" ,prio = "Warri DPS & Tank"},
    ["17082"]= { price = "verrolt" ,prio = "Naxx (Loatheb)"},
    ["17104"]= { price = "150" ,prio = "Schami Enh/Orc Warri"},
    ["17076"]= { price = "150" ,prio = "Fury/MS Warri"},
    ["16946"]= { price = "75" ,prio = ""},
    
    
    
    
    ["16830"]= { price = "30" ,prio = ""},
    ["16819"]= { price = "30" ,prio = ""},
    ["16804"]= { price = "30" ,prio = ""},
    ["16850"]= { price = "30" ,prio = ""},
    ["16828"]= { price = "30" ,prio = ""},
    ["16861"]= { price = "30" ,prio = ""},
    ["16825"]= { price = "30" ,prio = ""},
    ["16802"]= { price = "30" ,prio = ""},
    ["16838"]= { price = "30" ,prio = ""},
    ["16817"]= { price = "30" ,prio = ""},
    ["16827"]= { price = "30" ,prio = ""},
    ["16840"]= { price = "30" ,prio = ""},
    ["16806"]= { price = "30" ,prio = ""},
    ["16864"]= { price = "30" ,prio = ""},
    ["16799"]= { price = "30" ,prio = ""},
    ["16851"]= { price = "30" ,prio = ""},
    
    ["17067"]= { price = "10" ,prio = ""},
    ["16908"]= { price = "75" ,prio = ""},
    ["17068"]= { price = "100" ,prio = "Orc Fury - Orc Tank"},
    ["16939"]= { price = "75" ,prio = ""},
    ["18205"]= { price = "10" ,prio = ""},
    ["16921"]= { price = "75" ,prio = ""},
    ["18423"]= { price = "verrollt" ,prio = "Physical DPS/Tanks"},
    ["16963"]= { price = "75" ,prio = "Tank Warri"},
    ["16947"]= { price = "75" ,prio = ""},
    ["18705"]= { price = "verrollt" ,prio = ""},
    ["16929"]= { price = "75" ,prio = ""},
    ["16914"]= { price = "75" ,prio = ""},
    ["18813"]= { price = "10" ,prio = ""},
    ["17078"]= { price = "40" ,prio = "Caster"},
    ["17064"]= { price = "60" ,prio = "Healer"},
    ["16900"]= { price = "75" ,prio = ""},
    ["17075"]= { price = "100" ,prio = "Sword Rogues, non Orc Fury"},    
    
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo