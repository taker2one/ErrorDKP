--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 29.12.2019
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "2.0",
    ["timestamp"] = "1581079095"
}

local pricelist = {
    ["19436"] = { price = "5", pricebis = "100", prio = "KriegerDPS, EnSchamane, Feral-Druide", bis = "KriegerDPS, EnSchamane, Feral-Druide" },
["19358"] = { price = "20", pricebis = "200", prio = "Feral-Druide", bis = "Feral-Druide" },
["19437"] = { price = "5", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },
["19362"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["19435"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["19434"] = { price = "10", pricebis = "100", prio = "Hexer, Shadow", bis = "Hexer, Shadow" },
["19354"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["19438"] = { price = "5", pricebis = "100", prio = "Magier", bis = "Magier" },






["16926"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16935"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16911"] = { price = "5", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16959"] = { price = "5", pricebis = "100", prio = "KriegerTank", bis = "KriegerTank" },
["16918"] = { price = "5", pricebis = "100", prio = "Magier", bis = "" },
["16934"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["16904"] = { price = "5", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },
["16943"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19337"] = { price = "roll", pricebis = "", prio = "Hexer", bis = "" },
["19336"] = { price = "roll", pricebis = "", prio = "Jäger", bis = "" },

["19335"] = { price = "5", pricebis = "", prio = "Tank", bis = "" },
["19369"] = { price = "5", pricebis = "", prio = "Healer", bis = "" },
["19370"] = { price = "5", pricebis = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
["19334"] = { price = "20", pricebis = "", prio = "Meele", bis = "" },





["16910"] = { price = "5", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16903"] = { price = "5", pricebis = "", prio = "Heal Druide", bis = "" },
["16960"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16933"] = { price = "5", pricebis = "100", prio = "Hexer", bis = "Hexer" },
["16818"] = { price = "5", pricebis = "", prio = "Magier", bis = "" },
["16925"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16936"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16944"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19339"] = { price = "10", pricebis = "100", prio = "Magier", bis = "Magier" },
["19340"] = { price = "5", pricebis = "", prio = "Druide", bis = "" },

["19348"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19371"] = { price = "10", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19346"] = { price = "20", pricebis = "100", prio = "Krieger Tank (gloves)", bis = "Krieger Tank (gloves)" },
["19372"] = { price = "5", pricebis = "100", prio = "KriegerTank", bis = "KriegerTank" },





["16965"] = { price = "5", pricebis = "100", prio = "KriegerTank", bis = "KriegerTank" },
["16912"] = { price = "5", pricebis = "", prio = "Magier", bis = "" },
["16941"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16919"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16927"] = { price = "5", pricebis = "100", prio = "Hexer", bis = "Hexer" },
["16906"] = { price = "5", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16898"] = { price = "5", pricebis = "", prio = "Heal Druide", bis = "" },
["16949"] = { price = "5", pricebis = "", prio = "Heal Schamane", bis = "" },
["19341"] = { price = "5", pricebis = "", prio = "KriegerTank > KriegerDPS", bis = "" },
["19342"] = { price = "roll", pricebis = "", prio = "Schurke", bis = "" },

["19373"] = { price = "5", pricebis = "", prio = "Schami", bis = "" },
["19374"] = { price = "5", pricebis = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
["19350"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["19351"] = { price = "10", pricebis = "100", prio = "FuryTank Warri (beide Bindings & Edgemasters)> Sword Rogue,nonOrc Warri (rotiert)", bis = "FuryTank Warri (beide Bindings & Edgemasters)> Sword Rogue,nonOrc Warri (rotiert)" },

["20383"] = { price = "roll", pricebis = "", prio = "Heiler die sich die Quest-chain antun wollen & Hexer (Shadow resi gear)", bis = "" },





["16964"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16920"] = { price = "100", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16928"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["16913"] = { price = "100", pricebis = "100", prio = "Magier", bis = "Magier" },
["16940"] = { price = "100", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16907"] = { price = "100", pricebis = "100", prio = "Schwert Schurke", bis = "Schwert Schurke" },
["16899"] = { price = "100", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },
["16948"] = { price = "100", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19344"] = { price = "10", pricebis = "", prio = "Schamane", bis = "" },

["19399"] = { price = "10", pricebis = "", prio = "Caster", bis = "" },
["19400"] = { price = "5", pricebis = "100", prio = "Shadow", bis = "Shadow" },
["19365"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["19398"] = { price = "5", pricebis = "100", prio = "Fury KriegerTank", bis = "Fury KriegerTank" },
["19402"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },
["19401"] = { price = "5", pricebis = "", prio = "Ele > Schami", bis = "" },

["19355"] = { price = "10", pricebis = "", prio = "Caster & Healer", bis = "" },
["19394"] = { price = "5", pricebis = "100", prio = "Fury und Deff KriegerTank, KriegerDPS", bis = "Fury und Deff KriegerTank, KriegerDPS" },
["19395"] = { price = "20", pricebis = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
["19353"] = { price = "20", pricebis = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
["19397"] = { price = "10", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19396"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },





["16964"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16920"] = { price = "100", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16928"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["16913"] = { price = "100", pricebis = "100", prio = "Magier", bis = "Magier" },
["16940"] = { price = "100", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16907"] = { price = "100", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16899"] = { price = "100", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },
["19345"] = { price = "roll", pricebis = "", prio = "Priester", bis = "" },

["19403"] = { price = "10", pricebis = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
["19406"] = { price = "20", pricebis = "200", prio = "1.Tank > rotiert > 2. Schurke, KriegerDPS, Jäger, Feral-Druide", bis = "1.Tank > rotiert > 2. Schurke, KriegerDPS, Jäger, Feral-Druide" },
["19407"] = { price = "5", pricebis = "100", prio = "Hexer, Shadow", bis = "Hexer, Shadow" },
["19405"] = { price = "100", pricebis = "", prio = "EnSchamane, Feral-Druide", bis = "" },
["19368"] = { price = "10", pricebis = "", prio = "Physical DPS", bis = "" },

["19355"] = { price = "10", pricebis = "", prio = "Caster & Healer", bis = "" },
["19394"] = { price = "5", pricebis = "100", prio = "Fury und Deff KriegerTank, KriegerDPS", bis = "Fury und Deff KriegerTank, KriegerDPS" },
["19395"] = { price = "20", pricebis = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
["19353"] = { price = "20", pricebis = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
["19397"] = { price = "10", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19396"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },





["16964"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16920"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16928"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["16913"] = { price = "5", pricebis = "100", prio = "Magier", bis = "Magier" },
["16940"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16907"] = { price = "5", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16899"] = { price = "5", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },
["16948"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },

["19430"] = { price = "5", pricebis = "100", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
["19432"] = { price = "10", pricebis = "100", prio = "Fury KriegerTank > EnSchamane, KriegerDPS, Feral-Druide", bis = "Fury KriegerTank > EnSchamane, KriegerDPS, Feral-Druide" },
["19433"] = { price = "10", pricebis = "", prio = "meiste DKP", bis = "" },
["19431"] = { price = "10", pricebis = "", prio = "Deff KriegerTank", bis = "" },
["19367"] = { price = "5", pricebis = "", prio = "Caster & Healer", bis = "" },
["19357"] = { price = "10", pricebis = "100", prio = "Non Orc EnSchamane", bis = "Non Orc EnSchamane" },

["19355"] = { price = "10", pricebis = "", prio = "Caster & Healer", bis = "" },
["19394"] = { price = "5", pricebis = "100", prio = "Fury und Deff KriegerTank, KriegerDPS", bis = "Fury und Deff KriegerTank, KriegerDPS" },
["19395"] = { price = "20", pricebis = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
["19353"] = { price = "20", pricebis = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
["19397"] = { price = "10", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19396"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },





["16917"] = { price = "5", pricebis = "", prio = "Magier", bis = "" },
["16937"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16961"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16832"] = { price = "5", pricebis = "100", prio = "Schwert-Schurke", bis = "Schwert-Schurke" },
["16932"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["16924"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16902"] = { price = "5", pricebis = "", prio = "Heal Druide", bis = "" },
["16945"] = { price = "5", pricebis = "", prio = "Heal Schamane", bis = "" },

["19352"] = { price = "10", pricebis = "100", prio = "Schurke, non Orc Krieger DPS (rotiert)", bis = "Schurke, non Orc Krieger DPS (rotiert)" },
["19393"] = { price = "5", pricebis = "", prio = "Ele > Schami", bis = "" },
["19347"] = { price = "20", pricebis = "", prio = "Caster & Healer", bis = "" },
["19361"] = { price = "20", pricebis = "200", prio = "Jäger", bis = "Jäger" },
["19349"] = { price = "10", pricebis = "", prio = "Deff KriegerTank", bis = "" },
["19388"] = { price = "5", pricebis = "", prio = "Caster", bis = "" },
["19389"] = { price = "5", pricebis = "100", prio = "EnSchamane", bis = "EnSchamane" },
["19387"] = { price = "5", pricebis = "100", prio = "Fury KriegerTank > KriegerDPS", bis = "Fury KriegerTank > KriegerDPS" },
["19390"] = { price = "5", pricebis = "", prio = "Caster & Heal", bis = "" },
["19391"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
["19386"] = { price = "5", pricebis = "", prio = "Tank", bis = "" },
["19392"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },
["19385"] = { price = "5", pricebis = "100", prio = "Heal Druide", bis = "Heal Druide" },





["16942"] = { price = "5", pricebis = "100", prio = "Jäger", bis = "Jäger" },
["16916"] = { price = "5", pricebis = "100", prio = "Magier", bis = "Magier" },
["16905"] = { price = "5", pricebis = "100", prio = "Schurke", bis = "Schurke" },
["16966"] = { price = "5", pricebis = "", prio = "KriegerTank", bis = "" },
["16923"] = { price = "5", pricebis = "100", prio = "Heal Priester", bis = "Heal Priester" },
["16931"] = { price = "5", pricebis = "100", prio = "Hexer", bis = "Hexer" },
["16897"] = { price = "5", pricebis = "", prio = "Heal Druide", bis = "" },
["16950"] = { price = "5", pricebis = "100", prio = "Heal Schamane", bis = "Heal Schamane" },

["19356"] = { price = "20", pricebis = "200", prio = "Hexer, Magier", bis = "Hexer, Magier" },
["19379"] = { price = "20", pricebis = "200", prio = "Hexer, Magier > Shadow", bis = "Hexer, Magier > Shadow" },
["19375"] = { price = "5", pricebis = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
["19377"] = { price = "10", pricebis = "100", prio = "Schurke, Jäger, Feral-Druide", bis = "Schurke, Jäger, Feral-Druide" },
["19382"] = { price = "10", pricebis = "100", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
["19381"] = { price = "5", pricebis = "100", prio = "Dolch-Schurke, EnSchamane, FeralDruide", bis = "Dolch-Schurke, EnSchamane, FeralDruide" },
["19380"] = { price = "5", pricebis = "100", prio = "EnSchamane", bis = "EnSchamane" },
["19376"] = { price = "5", pricebis = "", prio = "Meele", bis = "" },
["19378"] = { price = "5", pricebis = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
["19364"] = { price = "20", pricebis = "200", prio = "Non Orc KriegerDPS", bis = "Non Orc KriegerDPS" },
["19363"] = { price = "10", pricebis = "100", prio = "Orc KriegerDPS", bis = "Orc KriegerDPS" },
["19360"] = { price = "10", pricebis = "100", prio = "Heal Schamane, Heal Druide, Heal Priester, Shadow", bis = "Heal Schamane, Heal Druide, Heal Priester, Shadow" },

["19003"] = { price = "10", pricebis = "100", prio = "Tank,Schurke, Shadow, Hunter, EnSchamane, KriegerDPS", bis = "Tank,Schurke, Shadow, Hunter, EnSchamane, KriegerDPS" },

--------------
--MC
--------------
["17067"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["16908"] = { price = "75", pricebis = "75", prio = "Schurke", bis = "Schurke" },
["17068"] = { price = "100", pricebis = "100", prio = "Orc KriegerDPS", bis = "Orc KriegerDPS" },
["16939"] = { price = "75", pricebis = "75", prio = "Jäger", bis = "Jäger" },
["18205"] = { price = "1", pricebis = "", prio = "Meele", bis = "" },
["16921"] = { price = "75", pricebis = "75", prio = "Heal Priester", bis = "Heal Priester" },
["18423"] = { price = "verrollt", pricebis = "", prio = "KriegerDPS, Fury KriegerTank, Deff KriegerTank, EnSchamane", bis = "KriegerDPS, Fury KriegerTank, Deff KriegerTank, EnSchamane" },
["16963"] = { price = "4", pricebis = "", prio = "Krieger Tank", bis = "" },
["16947"] = { price = "75", pricebis = "75", prio = "Heal Schamane", bis = "Heal Schamane" },
["18705"] = { price = "verrollt", pricebis = "", prio = "Jäger", bis = "" },
["16929"] = { price = "4", pricebis = "", prio = "Hexer", bis = "" },
["16914"] = { price = "4", pricebis = "", prio = "Magier", bis = "Magier" },
["18813"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["17078"] = { price = "4", pricebis = "", prio = "Caster, Heiler", bis = "" },
["17064"] = { price = "60", pricebis = "60", prio = "HealPriester, HealSchamane, HealDruide", bis = "HealPriester, HealSchamane, HealDruide" },
["16900"] = { price = "75", pricebis = "75", prio = "HealDruide", bis = "HealDruide" },
["17075"] = { price = "10", pricebis = "", prio = "Non Orc Krieger, Schurke", bis = "" },




["16800"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["16829"] = { price = "3", pricebis = "", prio = "Heal Druide", bis = "" },
["17109"] = { price = "5", pricebis = "", prio = "Caster", bis = "" },
["16837"] = { price = "3", pricebis = "", prio = "Heal Schamane", bis = "" },
["16805"] = { price = "3", pricebis = "", prio = "Hexer", bis = "" },
["18861"] = { price = "3", pricebis = "", prio = "Tank", bis = "" },
["16863"] = { price = "3", pricebis = "", prio = "Deff KriegerTank", bis = "" },
["18879"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["18872"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["19147"] = { price = "8", pricebis = "80", prio = "Magier", bis = "Magier" },
["19145"] = { price = "6", pricebis = "60", prio = "Magier", bis = "Magier" },


["18823"] = { price = "6", pricebis = "60", prio = "DolchSchurke, KriegerDPS", bis = "DolchSchurke, KriegerDPS" },
["16796"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["16835"] = { price = "3", pricebis = "", prio = "Heal Druide", bis = "" },
["18829"] = { price = "4", pricebis = "", prio = "Ele > Schami", bis = "" },
["16843"] = { price = "3", pricebis = "", prio = "Ele, Heal Schami", bis = "" },
["17073"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["18203"] = { price = "6", pricebis = "", prio = "Meele, Tank", bis = "" },
["16810"] = { price = "3", pricebis = "", prio = "Hexer", bis = "" },
["19142"] = { price = "4", pricebis = "", prio = "Caster, Healer", bis = "" },
["19143"] = { price = "60", pricebis = "60", prio = "KriegerDPS", bis = "KriegerDPS" },
["18861"] = { price = "4", pricebis = "", prio = "Tank", bis = "" },
["16847"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["16867"] = { price = "3", pricebis = "", prio = "Krieger Tank", bis = "" },
["19136"] = { price = "60", pricebis = "60", prio = "Magier", bis = "Magier" },
["17065"] = { price = "4", pricebis = "", prio = "Tank", bis = "" },
["16822"] = { price = "3", pricebis = "", prio = "Schurke", bis = "" },
["18822"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["16814"] = { price = "3", pricebis = "", prio = "Priester", bis = "" },
["18821"] = { price = "8", pricebis = "80", prio = "KriegerDPS, FeralDruide, EnSchamane", bis = "KriegerDPS, FeralDruide, EnSchamane" },
["19144"] = { price = "3", pricebis = "", prio = "Meele, Hunter", bis = "" },
["17069"] = { price = "8", pricebis = "80", prio = "Schurke, KriegerDPS", bis = "Schurke, KriegerDPS" },
["18820"] = { price = "6", pricebis = "60", prio = "Hexer, ShadowPriester", bis = "Hexer, ShadowPriester" },


["17077"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["16839"] = { price = "3", pricebis = "", prio = "Heal Schamane", bis = "" },
["18861"] = { price = "4", pricebis = "", prio = "Krieger Tank", bis = "" },
["16849"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["16812"] = { price = "3", pricebis = "", prio = "Priester", bis = "" },
["18879"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["18872"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["16826"] = { price = "3", pricebis = "", prio = "Rogue", bis = "" },
["19147"] = { price = "8", pricebis = "80", prio = "Magier", bis = "Magier" },
["19145"] = { price = "6", pricebis = "", prio = "Caster ", bis = "" },
["16862"] = { price = "5", pricebis = "", prio = "Krieger Tank", bis = "" },
["18875"] = { price = "4", pricebis = "40", prio = "HealSchamane", bis = "HealSchamane" },
["18878"] = { price = "3", pricebis = "", prio = "Caster ", bis = "" },
["19146"] = { price = "4", pricebis = "40", prio = "KriegerDPS, EnSchamane", bis = "KriegerDPS, EnSchamane" },


["18564"] = { price = "LootCouncil", pricebis = "", prio = "Lootcouncil", bis = "" },
["18823"] = { price = "6", pricebis = "60", prio = "DolchSchurke, KriegerDPS", bis = "DolchSchurke, KriegerDPS" },
["16795"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["17105"] = { price = "6", pricebis = "", prio = "Priester, Druide, Schamane", bis = "" },
["18832"] = { price = "6", pricebis = "60", prio = "KriegerDPS, Jäger", bis = "KriegerDPS, Jäger" },
["16834"] = { price = "3", pricebis = "", prio = "Druide", bis = "" },
["16813"] = { price = "3", pricebis = "", prio = "Priester", bis = "" },
["18829"] = { price = "4", pricebis = "", prio = "Ele > Schami", bis = "" },
["17066"] = { price = "4", pricebis = "", prio = "Krieger Tank", bis = "" },
["16842"] = { price = "3", pricebis = "", prio = "Schami", bis = "" },
["16808"] = { price = "3", pricebis = "", prio = "Hexer", bis = "" },
["19142"] = { price = "4", pricebis = "", prio = "Caster, Healer", bis = "" },
["19143"] = { price = "6", pricebis = "60", prio = "KriegerDPS", bis = "KriegerDPS" },
["18861"] = { price = "4", pricebis = "", prio = "Tank Krieger", bis = "" },
["16846"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["17071"] = { price = "4", pricebis = "", prio = "Warri, Schurke", bis = "" },
["16866"] = { price = "3", pricebis = "", prio = "Krieger Tank", bis = "" },
["19136"] = { price = "6", pricebis = "60", prio = "Magier", bis = "Magier" },
["16821"] = { price = "3", pricebis = "", prio = "Rogue", bis = "" },
["18822"] = { price = "10", pricebis = "", prio = "Krieger DPS", bis = "" },
["18821"] = { price = "8", pricebis = "80", prio = "KriegerDPS, FeralDruide, EnSchamane", bis = "KriegerDPS, FeralDruide, EnSchamane" },
["18820"] = { price = "6", pricebis = "60", prio = "Hexer, ShadowPriester", bis = "Hexer, ShadowPriester" },


["16801"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["16811"] = { price = "3", pricebis = "", prio = "Priester Heal", bis = "" },
["16831"] = { price = "3", pricebis = "", prio = "Druide Heal", bis = "" },
["17077"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["16803"] = { price = "3", pricebis = "", prio = "Hexer", bis = "" },
["16852"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["16824"] = { price = "3", pricebis = "", prio = "Meele", bis = "" },
["19147"] = { price = "80", pricebis = "", prio = "Magier", bis = "Magier" },
["19145"] = { price = "6", pricebis = "", prio = "Caster", bis = "" },
["18878"] = { price = "3", pricebis = "", prio = "Caster", bis = "" },
["18872"] = { price = "2", pricebis = "", prio = "DKP", bis = "" },


["18564"] = { price = "LootCouncil", pricebis = "", prio = "Lootcouncil", bis = "" },
["18823"] = { price = "4", pricebis = "40", prio = "DolchSchurke, KriegerDPS", bis = "DolchSchurke, KriegerDPS" },
["16797"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["16836"] = { price = "3", pricebis = "", prio = "Druide Heal", bis = "" },
["16844"] = { price = "3", pricebis = "", prio = "Schami Heal", bis = "" },
["16807"] = { price = "5", pricebis = "", prio = "Hexer", bis = "" },
["19142"] = { price = "4", pricebis = "", prio = "Caster", bis = "" },
["19143"] = { price = "6", pricebis = "60", prio = "KriegerDPS", bis = "KriegerDPS" },
["18861"] = { price = "4", pricebis = "", prio = "Krieger Tank", bis = "" },
["19136"] = { price = "6", pricebis = "60", prio = "Magier", bis = "Magier" },
["18822"] = { price = "10", pricebis = "", prio = "Krieger DPS", bis = "" },
["18821"] = { price = "8", pricebis = "80", prio = "KriegerDPS, FeralDruide, EnSchamane", bis = "KriegerDPS, FeralDruide, EnSchamane" },
["17110"] = { price = "2", pricebis = "", prio = "DKP", bis = "" },
["18820"] = { price = "6", pricebis = "60", prio = "Hexer, ShadowPriester", bis = "Hexer, ShadowPriester" },


["18823"] = { price = "6", pricebis = "60", prio = "DolchSchurke, KriegerDPS", bis = "DolchSchurke, KriegerDPS" },
["16798"] = { price = "3", pricebis = "", prio = "Magier", bis = "" },
["17103"] = { price = "10", pricebis = "", prio = "Magier, Hexer", bis = "" },
["17072"] = { price = "6", pricebis = "", prio = "Meele", bis = "" },
["16865"] = { price = "3", pricebis = "", prio = "Krieger Tank", bis = "" },
["16833"] = { price = "3", pricebis = "", prio = "Druide Heal", bis = "" },
["16841"] = { price = "3", pricebis = "", prio = "Schami Heal", bis = "" },
["16809"] = { price = "3", pricebis = "", prio = "Hexer", bis = "" },
["19142"] = { price = "4", pricebis = "", prio = "Caster", bis = "" },
["19143"] = { price = "6", pricebis = "60", prio = "KriegerDPS", bis = "KriegerDPS" },
["18861"] = { price = "4", pricebis = "", prio = "Krieger Tank", bis = "" },
["16845"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["19136"] = { price = "6", pricebis = "60", prio = "Magier", bis = "" },
["16820"] = { price = "3", pricebis = "", prio = "Schurke", bis = "" },
["18822"] = { price = "10", pricebis = "", prio = "Meele", bis = "" },
["18821"] = { price = "8", pricebis = "80", prio = "KriegerDPS, FeralDruide, EnSchamane", bis = "KriegerDPS, FeralDruide, EnSchamane" },
["16815"] = { price = "3", pricebis = "", prio = "Priester", bis = "" },
["18842"] = { price = "12", pricebis = "", prio = "Caster, Healer", bis = "" },
["17203"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["18820"] = { price = "6", pricebis = "60", prio = "Hexer, ShadowPriester", bis = "Hexer, ShadowPriester" },


["17077"] = { price = "2", pricebis = "", prio = "Caster, Healer", bis = "" },
["18861"] = { price = "4", pricebis = "", prio = "Tank", bis = "" },
["16848"] = { price = "3", pricebis = "", prio = "Jäger", bis = "" },
["18879"] = { price = "1", pricebis = "", prio = "Tank", bis = "" },
["18872"] = { price = "2", pricebis = "", prio = "Caster, Healer", bis = "" },
["16816"] = { price = "3", pricebis = "", prio = "Priester", bis = "" },
["16823"] = { price = "3", pricebis = "", prio = "Schurke", bis = "" },
["16868"] = { price = "3", pricebis = "", prio = "KriegerTank", bis = "" },
["19147"] = { price = "8", pricebis = "80", prio = "Magier", bis = "Magier" },
["18875"] = { price = "4", pricebis = "40", prio = "HealSchamane", bis = "HealSchamane" },
["17074"] = { price = "2", pricebis = "", prio = "DKP", bis = "" },
["18878"] = { price = "3", pricebis = "", prio = "Caster, Healer", bis = "" },
["19146"] = { price = "4", pricebis = "40", prio = "KriegerDPS, EnSchamane", bis = "KriegerDPS, EnSchamane" },


["18703"] = { price = "15", pricebis = "", prio = "Jäger", bis = "" },
["18805"] = { price = "6", pricebis = "60", prio = "DolchKrieger, DolchSchurke, Jäger", bis = "DolchKrieger, DolchSchurke, Jäger" },
["18811"] = { price = "1", pricebis = "", prio = "Caster, Healer", bis = "" },
["18809"] = { price = "4", pricebis = "", prio = "Hexer, Shadow", bis = "" },
["18646"] = { price = "15", pricebis = "", prio = "Priester", bis = "" },
["18810"] = { price = "4", pricebis = "40", prio = "HealSchamane, HealDruide", bis = "HealSchamane, HealDruide" },
["18812"] = { price = "4", pricebis = "40", prio = "Fury KriegerTank", bis = "Fury KriegerTank" },
["19140"] = { price = "8", pricebis = "80", prio = "HealPriester, HealSchamane, HealDruide", bis = "HealPriester, HealSchamane, HealDruide" },
["18803"] = { price = "2", pricebis = "", prio = "DKP", bis = "" },
["18806"] = { price = "4", pricebis = "", prio = "Tank", bis = "" },


["16915"] = { price = "4", pricebis = "75", prio = "Magier", bis = "Magier" },
["16901"] = { price = "5", pricebis = "", prio = "Druide", bis = "" },
["18816"] = { price = "10", pricebis = "100", prio = "DolchSchurke, KriegerDPS", bis = "DolchSchurke, KriegerDPS" },
["19138"] = { price = "2", pricebis = "", prio = "Caster, Healer", bis = "" },
["16938"] = { price = "4", pricebis = "75", prio = "Jäger", bis = "Jäger" },
["16909"] = { price = "4", pricebis = "75", prio = "Schurke", bis = "Schurke" },
["18817"] = { price = "6", pricebis = "60", prio = "EnSchamane", bis = "EnSchamane" },
["17063"] = { price = "8", pricebis = "80", prio = "Fury KriegerTank -> KriegerDPS, Schurke, EnSchamane, Hunter, FeralDruide", bis = "Fury KriegerTank -> KriegerDPS, Schurke, EnSchamane, Hunter, FeralDruide" },
["17107"] = { price = "4", pricebis = "", prio = "Meele", bis = "" },
["18815"] = { price = "1", pricebis = "", prio = "Tank", bis = "" },
["16922"] = { price = "4", pricebis = "75", prio = "HealPriester", bis = "HealPriester" },
["16930"] = { price = "4", pricebis = "75", prio = "Hexer", bis = "Hexer" },
["16962"] = { price = "4", pricebis = "75", prio = "Deff KriegerTank", bis = "Deff KriegerTank" },
["18814"] = { price = "10", pricebis = "100", prio = "Magier, Hexer, ShadowPriester", bis = "Magier, Hexer, ShadowPriester" },
["17106"] = { price = "4", pricebis = "", prio = "Healer", bis = "" },
["19137"] = { price = "6", pricebis = "60", prio = "Fury KriegerTank, Deff KriegerTank -> KriegerDPS", bis = "Fury KriegerTank, Deff KriegerTank -> KriegerDPS" },
["17082"] = { price = "1", pricebis = "", prio = "DKP", bis = "" },
["17104"] = { price = "15", pricebis = "", prio = "Orc Meele", bis = "" },
["17076"] = { price = "15", pricebis = "", prio = "Meele", bis = "" },
["16946"] = { price = "5", pricebis = "", prio = "Ele, HealSchamane", bis = "" },
["17102"] = { price = "4", pricebis = "", prio = "Meele", bis = "" },


["16830"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16819"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16804"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16850"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16828"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16861"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16825"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16802"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16838"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16817"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16827"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16840"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16806"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16864"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16799"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
["16851"] = { price = "0", pricebis = "", prio = "Bank", bis = "" },
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo