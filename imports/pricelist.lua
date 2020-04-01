--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 26.03.2020
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "2.5",
    ["timestamp"] = "1585642644"
}

local pricelist = {
    ["19436"] = { price = "100", prio = "KriegerDPS, EnSchamane, Feral-Druide" },
    ["19358"] = { price = "200", prio = "Feral-Druide" },
    ["19437"] = { price = "100", prio = "Heal Druide" },
    ["19362"] = { price = "60", prio = "Meele" },
    ["19435"] = { price = "100", prio = "Heal Priester" },
    ["19434"] = { price = "100", prio = "Hexer, Shadow" },
    ["19354"] = { price = "10", prio = "Meele" },
    ["19438"] = { price = "100", prio = "Magier" },
    
    
    ["16926"] = { price = "100", prio = "Heal Priester" },
    ["16935"] = { price = "5", prio = "Jäger" },
    ["16911"] = { price = "100", prio = "Schurke" },
    ["16959"] = { price = "5", prio = "KriegerTank" },
    ["16918"] = { price = "5", prio = "Magier" },
    ["16934"] = { price = "5", prio = "Hexer" },
    ["16904"] = { price = "100", prio = "Heal Druide" },
    ["16943"] = { price = "100", prio = "Heal Schamane" },
    ["19337"] = { price = "roll", prio = "Hexer" },
    ["19336"] = { price = "roll", prio = "Jäger" },
    
    ["19335"] = { price = "5", prio = "Tank" },
    ["19369"] = { price = "5", prio = "Healer" },
    ["19370"] = { price = "100", prio = "Hexer, Magier, Shadow" },
    ["19334"] = { price = "60", prio = "Meele" },
  
    
    ["16910"] = { price = "100", prio = "Schurke" },
    ["16903"] = { price = "5", prio = "Heal Druide" },
    ["16960"] = { price = "5", prio = "KriegerTank" },
    ["16933"] = { price = "100", prio = "Hexer" },
    ["16818"] = { price = "5", prio = "Magier" },
    ["16925"] = { price = "100", prio = "Heal Priester" },
    ["16936"] = { price = "5", prio = "Jäger" },
    ["16944"] = { price = "100", prio = "Heal Schamane" },
    ["19339"] = { price = "100", prio = "Magier" },
    ["19340"] = { price = "roll", prio = "Druide" },
    
    ["19348"] = { price = "100", prio = "Heal Schamane" },
    ["19371"] = { price = "100", prio = "Heal Schamane" },
    ["19346"] = { price = "100", prio = "Krieger Tank (gloves)" },
    ["19372"] = { price = "5", prio = "KriegerTank" },
    
    
    
    
    
    ["16965"] = { price = "5", prio = "KriegerTank" },
    ["16912"] = { price = "5", prio = "Magier" },
    ["16941"] = { price = "5", prio = "Jäger" },
    ["16919"] = { price = "100", prio = "Heal Priester" },
    ["16927"] = { price = "100", prio = "Hexer" },
    ["16906"] = { price = "100", prio = "Schurke" },
    ["16898"] = { price = "5", prio = "Heal Druide" },
    ["16949"] = { price = "5", prio = "Heal Schamane" },
    ["19341"] = { price = "1.Tank - roll", prio = "KriegerTank > KriegerDPS" },
    ["19342"] = { price = "roll", prio = "Schurke" },
    
    ["19373"] = { price = "5", prio = "Schami" },
    ["19374"] = { price = "100", prio = "Hexer, Magier, Shadow" },
    ["19350"] = { price = "5", prio = "Meele" },
    ["19351"] = { price = "100", prio = "FuryTank Warri (beide Bindings & Edgemasters)> Sword Rogue, nonOrc Warri (rotiert)" },
    
    ["20383"] = { price = "roll", prio = "Heiler die sich die Quest-chain antun wollen & Hexer (Shadow resi gear)" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank" },
    ["16920"] = { price = "100", prio = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer" },
    ["16913"] = { price = "100", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "100", prio = "Schwert Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide" },
    ["16948"] = { price = "100", prio = "Heal Schamane" },
    ["19344"] = { price = "roll", prio = "Schamane" },
    
    ["19399"] = { price = "5", prio = "Caster" },
    ["19400"] = { price = "100", prio = "Shadow" },
    ["19365"] = { price = "10", prio = "Meele" },
    ["19398"] = { price = "100", prio = "Fury KriegerTank" },
    ["19402"] = { price = "5", prio = "Meele" },
    ["19401"] = { price = "5", prio = "Ele > Schami" },
    
    ["19355"] = { price = "10", prio = "Caster & Healer" },
    ["19394"] = { price = "100", prio = "Fury und Deff KriegerTank, KriegerDPS" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "Meele" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank" },
    ["16920"] = { price = "100", prio = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer" },
    ["16913"] = { price = "100", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "100", prio = "Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide" },
    ["19345"] = { price = "roll", prio = "Priester" },
    
    ["19403"] = { price = "100", prio = "Hexer, Magier, Shadow" },
    ["19406"] = { price = "200", prio = "1.Tank > rotiert > 2. Schurke, KriegerDPS, Jäger, Feral-Druide" },
    ["19407"] = { price = "100", prio = "Hexer, Shadow" },
    ["19405"] = { price = "100", prio = "EnSchamane, Feral-Druide" },
    ["19368"] = { price = "5", prio = "Physical DPS" },
    
    ["19355"] = { price = "10", prio = "Caster & Healer" },
    ["19394"] = { price = "100", prio = "Fury und Deff KriegerTank, KriegerDPS" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "Meele" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank" },
    ["16920"] = { price = "100", prio = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer" },
    ["16913"] = { price = "100", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "100", prio = "Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide" },
    ["16948"] = { price = "100", prio = "Heal Schamane" },
    
    ["19430"] = { price = "100", prio = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19432"] = { price = "100", prio = "Fury KriegerTank > EnSchamane, KriegerDPS, Feral-Druide" },
    ["19433"] = { price = "5", prio = "" },
    ["19431"] = { price = "5", prio = "Deff KriegerTank" },
    ["19367"] = { price = "5", prio = "Caster & Healer" },
    ["19357"] = { price = "100", prio = "Non Orc EnSchamane" },
    
    ["19355"] = { price = "10", prio = "Caster & Healer" },
    ["19394"] = { price = "100", prio = "Fury und Deff KriegerTank, KriegerDPS" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "Meele" },
    
    
    
    
    
    ["16917"] = { price = "5", prio = "Magier" },
    ["16937"] = { price = "5", prio = "Jäger" },
    ["16961"] = { price = "5", prio = "KriegerTank" },
    ["16832"] = { price = "100", prio = "Schwert-Schurke" },
    ["16932"] = { price = "5", prio = "Hexer" },
    ["16924"] = { price = "100", prio = "Heal Priester" },
    ["16902"] = { price = "5", prio = "Heal Druide" },
    ["16945"] = { price = "5", prio = "Heal Schamane" },
    
    ["19352"] = { price = "100", prio = "Schurke, non Orc Krieger DPS (rotiert)" },
    ["19393"] = { price = "5", prio = "Ele > Schami" },
    ["19347"] = { price = "100", prio = "1. Schami Heal & Shadow 2.Caster" },
    ["19361"] = { price = "200", prio = "Jäger" },
    ["19349"] = { price = "60", prio = "Deff KriegerTank" },
    ["19388"] = { price = "5", prio = "Caster" },
    ["19389"] = { price = "100", prio = "EnSchamane" },
    ["19387"] = { price = "100", prio = "Fury KriegerTank > KriegerDPS" },
    ["19390"] = { price = "5", prio = "Caster & Heal" },
    ["19391"] = { price = "100", prio = "Heal Schamane" },
    ["19386"] = { price = "5", prio = "Tank" },
    ["19392"] = { price = "5", prio = "Meele" },
    ["19385"] = { price = "5", prio = "Heal Druide" },
    
    
    
    
    
    ["16942"] = { price = "5", prio = "Jäger" },
    ["16916"] = { price = "5", prio = "Magier" },
    ["16905"] = { price = "100", prio = "Schurke" },
    ["16966"] = { price = "5", prio = "KriegerTank" },
    ["16923"] = { price = "100", prio = "Heal Priester" },
    ["16931"] = { price = "5", prio = "Hexer" },
    ["16897"] = { price = "5", prio = "Heal Druide" },
    ["16950"] = { price = "100", prio = "Heal Schamane" },
    
    ["19356"] = { price = "200", prio = "Hexer, Magier" },
    ["19379"] = { price = "200", prio = "Hexer, Magier > Shadow" },
    ["19375"] = { price = "100", prio = "Hexer, Magier, Shadow" },
    ["19377"] = { price = "100", prio = "Schurke, Jäger, Feral-Druide" },
    ["19382"] = { price = "100", prio = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19381"] = { price = "100", prio = "Dolch-Schurke, EnSchamane, FeralDruide" },
    ["19380"] = { price = "100", prio = "EnSchamane" },
    ["19376"] = { price = "5", prio = "Meele" },
    ["19378"] = { price = "100", prio = "Hexer, Magier, Shadow" },
    ["19364"] = { price = "200", prio = "Non Orc KriegerDPS > Hunter" },
    ["19363"] = { price = "100", prio = "Orc KriegerDPS" },
    ["19360"] = { price = "100", prio = "Heal Schamane, Heal Druide, Heal Priester, Shadow" },
    
    ["19003"] = { price = "100", prio = "Schurke, Shadow, Hunter, EnSchamane, KriegerDPS" },
--------------
--MC
--------------
["17067"] = { price = "1", prio = "DKP" },
["16908"] = { price = "75", prio = "Schurke" },
["17068"] = { price = "100", prio = "Orc KriegerDPS" },
["16939"] = { price = "5", prio = "Jäger" },
["18205"] = { price = "1", prio = "Meele" },
["16921"] = { price = "75", prio = "Heal Priester" },
["18423"] = { price = "roll", prio = "KriegerDPS, Fury KriegerTank, Deff KriegerTank, EnSchamane" },
["16963"] = { price = "5", prio = "Krieger Tank" },
["16947"] = { price = "75", prio = "Heal Schamane" },
["18705"] = { price = "roll", prio = "Jäger" },
["16929"] = { price = "5", prio = "Hexer" },
["16914"] = { price = "5", prio = "Magier" },
["18813"] = { price = "1", prio = "DKP" },
["17078"] = { price = "3", prio = "Caster, Heiler" },
["17064"] = { price = "60", prio = "HealPriester, HealSchamane, HealDruide" },
["16900"] = { price = "75", prio = "HealDruide" },
["17075"] = { price = "40", prio = "Non Orc Krieger, Schurke" },




["16800"] = { price = "3",  },
["16829"] = { price = "3", prio = "Heal Druide" },
["17109"] = { price = "3", prio = "Caster" },
["16837"] = { price = "3", prio = "Heal Schamane" },
["16805"] = { price = "3", prio = "Hexer" },
["18861"] = { price = "3", prio = "Tank" },
["16863"] = { price = "3", prio = "Deff KriegerTank" },
["18879"] = { price = "1", prio = "DKP" },
["18872"] = { price = "1", prio = "DKP" },
["19147"] = { price = "80", prio = "Magier" },
["19145"] = { price = "60", prio = "Magier" },



["18823"] = { price = "60", prio = "DolchSchurke, KriegerDPS" },
["16796"] = { price = "3", prio = "Magier" },
["16835"] = { price = "3", prio = "Heal Druide" },
["18829"] = { price = "3", prio = "Ele > Schami" },
["16843"] = { price = "3", prio = "Ele, Heal Schami" },
["17073"] = { price = "3", prio = "Meele" },
["18203"] = { price = "3", prio = "Meele, Tank" },
["16810"] = { price = "3", prio = "Hexer" },
["19142"] = { price = "3", prio = "Caster, Healer" },
["19143"] = { price = "60", prio = "KriegerDPS" },
["18861"] = { price = "3", prio = "Tank" },
["16847"] = { price = "30", prio = "Jäger" },
["16867"] = { price = "3", prio = "Krieger Tank" },
["19136"] = { price = "60", prio = "Magier" },
["17065"] = { price = "3", prio = "Tank" },
["16822"] = { price = "3", prio = "Schurke" },
["18822"] = { price = "3", prio = "Meele" },
["16814"] = { price = "3", prio = "Priester" },
["18821"] = { price = "80", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["19144"] = { price = "3", prio = "Meele, Hunter" },
["17069"] = { price = "80", prio = "Schurke, KriegerDPS" },
["18820"] = { price = "60", prio = "Hexer, ShadowPriester" },



["17077"] = { price = "1", prio = "DKP" },
["16839"] = { price = "3", prio = "Heal Schamane" },
["18861"] = { price = "3", prio = "Krieger Tank" },
["16849"] = { price = "30", prio = "Jäger" },
["16812"] = { price = "3", prio = "Priester" },
["18879"] = { price = "1", prio = "DKP" },
["18872"] = { price = "1", prio = "DKP" },
["16826"] = { price = "3", prio = "Rogue" },
["19147"] = { price = "80", prio = "Magier" },
["19145"] = { price = "60", prio = "Caster " },
["16862"] = { price = "3", prio = "Krieger Tank" },
["18875"] = { price = "40", prio = "HealSchamane" },
["18878"] = { price = "3", prio = "Caster " },
["19146"] = { price = "40", prio = "KriegerDPS, EnSchamane" },



["18564"] = { price = "LootCouncil", prio = "Lootcouncil" },
["18823"] = { price = "60", prio = "DolchSchurke, KriegerDPS" },
["16795"] = { price = "3", prio = "Magier" },
["17105"] = { price = "3", prio = "Priester, Druide, Schamane" },
["18832"] = { price = "60", prio = "KriegerDPS, Jäger" },
["16834"] = { price = "3", prio = "Druide" },
["16813"] = { price = "3", prio = "Priester" },
["18829"] = { price = "3", prio = "Ele > Schami" },
["17066"] = { price = "3", prio = "Krieger Tank" },
["16842"] = { price = "3", prio = "Schami" },
["16808"] = { price = "3", prio = "Hexer" },
["19142"] = { price = "3", prio = "Caster, Healer" },
["19143"] = { price = "60", prio = "KriegerDPS" },
["18861"] = { price = "3", prio = "Tank Krieger" },
["16846"] = { price = "30", prio = "Jäger" },
["17071"] = { price = "3", prio = "Warri, Schurke" },
["16866"] = { price = "3", prio = "Krieger Tank" },
["19136"] = { price = "60", prio = "Magier" },
["16821"] = { price = "3", prio = "Rogue" },
["18822"] = { price = "3", prio = "Krieger DPS" },
["18821"] = { price = "80", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["18820"] = { price = "60", prio = "Hexer, ShadowPriester" },



["16801"] = { price = "3", prio = "Magier" },
["16811"] = { price = "3", prio = "Priester Heal" },
["16831"] = { price = "3", prio = "Druide Heal" },
["17077"] = { price = "1", prio = "DKP" },
["16803"] = { price = "3", prio = "Hexer" },
["16852"] = { price = "30", prio = "Jäger" },
["16824"] = { price = "3", prio = "Schurke" },
["19147"] = { price = "80", prio = "Magier" },
["19145"] = { price = "3", prio = "Caster" },
["18878"] = { price = "3", prio = "Caster" },
["18872"] = { price = "1", prio = "DKP" },



["18564"] = { price = "LootCouncil", prio = "Lootcouncil" },
["18823"] = { price = "60", prio = "DolchSchurke, KriegerDPS" },
["16797"] = { price = "3", prio = "Magier" },
["16836"] = { price = "3", prio = "Druide Heal" },
["16844"] = { price = "3", prio = "Schami Heal" },
["16807"] = { price = "3", prio = "Hexer" },
["19142"] = { price = "3", prio = "Caster" },
["19143"] = { price = "60", prio = "KriegerDPS" },
["18861"] = { price = "3", prio = "Krieger Tank" },
["19136"] = { price = "60", prio = "Magier" },
["18822"] = { price = "3", prio = "Krieger DPS" },
["18821"] = { price = "80", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["17110"] = { price = "1", prio = "DKP" },
["18820"] = { price = "60", prio = "Hexer, ShadowPriester" },



["18823"] = { price = "60", prio = "DolchSchurke, KriegerDPS" },
["16798"] = { price = "3", prio = "Magier" },
["17103"] = { price = "40", prio = "Magier, Hexer" },
["17072"] = { price = "3", prio = "Meele" },
["16865"] = { price = "3", prio = "Krieger Tank" },
["16833"] = { price = "3", prio = "Druide Heal" },
["16841"] = { price = "3", prio = "Schami Heal" },
["16809"] = { price = "3", prio = "Hexer" },
["19142"] = { price = "3", prio = "Caster" },
["19143"] = { price = "60", prio = "KriegerDPS" },
["18861"] = { price = "3", prio = "Krieger Tank" },
["16845"] = { price = "30", prio = "Jäger" },
["19136"] = { price = "60", prio = "Magier" },
["16820"] = { price = "3", prio = "Schurke" },
["18822"] = { price = "3", prio = "Meele" },
["18821"] = { price = "80", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["16815"] = { price = "3", prio = "Priester" },
["18842"] = { price = "20", prio = "Caster, Healer" },
["17203"] = { price = "0", prio = "Bank" },
["18820"] = { price = "60", prio = "Hexer, ShadowPriester" },



["17077"] = { price = "1", prio = "Caster, Healer" },
["18861"] = { price = "3", prio = "Tank" },
["16848"] = { price = "30", prio = "Jäger" },
["18879"] = { price = "1", prio = "Tank" },
["18872"] = { price = "1", prio = "Caster, Healer" },
["16816"] = { price = "3", prio = "Priester" },
["16823"] = { price = "3", prio = "Schurke" },
["16868"] = { price = "3", prio = "KriegerTank" },
["19147"] = { price = "80", prio = "Magier" },
["18875"] = { price = "40", prio = "HealSchamane" },
["17074"] = { price = "1", prio = "DKP" },
["18878"] = { price = "3", prio = "Caster, Healer" },
["19146"] = { price = "40", prio = "KriegerDPS, EnSchamane" },



["18703"] = { price = "20", prio = "Jäger" },
["18805"] = { price = "60", prio = "DolchKrieger, DolchSchurke, Jäger" },
["18811"] = { price = "1", prio = "Caster, Healer" },
["18809"] = { price = "3", prio = "Hexer, Shadow" },
["18646"] = { price = "20", prio = "Priester" },
["18810"] = { price = "40", prio = "HealSchamane, HealDruide" },
["18812"] = { price = "40", prio = "Fury KriegerTank, Jäger" },
["19140"] = { price = "80", prio = "HealPriester, HealSchamane, HealDruide" },
["18803"] = { price = "1", prio = "DKP" },
["18806"] = { price = "3", prio = "Tank" },



["16915"] = { price = "75", prio = "Magier" },
["16901"] = { price = "5", prio = "Druide" },
["18816"] = { price = "100", prio = "DolchSchurke, KriegerDPS (gloves)" },
["19138"] = { price = "1", prio = "Caster, Healer" },
["16938"] = { price = "5", prio = "Jäger" },
["16909"] = { price = "75", prio = "Schurke" },
["18817"] = { price = "60", prio = "EnSchamane" },
["17063"] = { price = "80", prio = "Fury KriegerTank -> KriegerDPS, Schurke, EnSchamane, Hunter, FeralDruide" },
["17107"] = { price = "3", prio = "Meele" },
["18815"] = { price = "1", prio = "Tank" },
["16922"] = { price = "75", prio = "HealPriester" },
["16930"] = { price = "75", prio = "Hexer" },
["16962"] = { price = "75", prio = "Deff KriegerTank" },
["18814"] = { price = "100", prio = "Magier, Hexer, ShadowPriester" },
["17106"] = { price = "3", prio = "Healer" },
["19137"] = { price = "60", prio = "Fury KriegerTank, Deff KriegerTank -> KriegerDPS" },
["17082"] = { price = "1", prio = "DKP" },
["17104"] = { price = "75", prio = "Orc Meele" },
["17076"] = { price = "75", prio = "Meele" },
["16946"] = { price = "5", prio = "Ele, HealSchamane" },
["17102"] = { price = "3", prio = "Meele" },



["16830"] = { price = "3", prio = "Druid" },
["16819"] = { price = "3", prio = "Priest" },
["16804"] = { price = "3", prio = "Hexer" },
["16850"] = { price = "30", prio = "Jäger" },
["16861"] = { price = "3", prio = "Krieger" },
["16825"] = { price = "3", prio = "Schurke" },
["16802"] = { price = "3", prio = "Magier" },
["16838"] = { price = "3", prio = "Schami" },
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo