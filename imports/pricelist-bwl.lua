--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 29.12.2019
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "2.0",
    ["timestamp"] = "1581079091"
}

local pricelist = {
    ["19436"] = { price = "100", prio = "KriegerDPS, EnSchamane, Feral-Druide", bis = "KriegerDPS, EnSchamane, Feral-Druide" },
    ["19358"] = { price = "200", prio = "Feral-Druide", bis = "Feral-Druide" },
    ["19437"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    ["19362"] = { price = "10", prio = "", bis = "" },
    ["19435"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["19434"] = { price = "100", prio = "Hexer, Shadow", bis = "Hexer, Shadow" },
    ["19354"] = { price = "10", prio = "", bis = "" },
    ["19438"] = { price = "100", prio = "Magier", bis = "Magier" },
    
    
    
    
    
    
    ["16926"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16935"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16911"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16959"] = { price = "100", prio = "KriegerTank", bis = "KriegerTank" },
    ["16918"] = { price = "100", prio = "Magier", bis = "" },
    ["16934"] = { price = "5", prio = "Hexer", bis = "" },
    ["16904"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    ["16943"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19337"] = { price = "roll", prio = "Hexer", bis = "" },
    ["19336"] = { price = "roll", prio = "Jäger", bis = "" },
    
    ["19335"] = { price = "5", prio = "", bis = "" },
    ["19369"] = { price = "5", prio = "", bis = "" },
    ["19370"] = { price = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
    ["19334"] = { price = "20", prio = "", bis = "" },
    
    
    
    
    
    ["16910"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16903"] = { price = "5", prio = "Heal Druide", bis = "" },
    ["16960"] = { price = "5", prio = "KriegerTank", bis = "" },
    ["16933"] = { price = "100", prio = "Hexer", bis = "Hexer" },
    ["16818"] = { price = "100", prio = "Magier", bis = "" },
    ["16925"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16936"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16944"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19339"] = { price = "100", prio = "Magier", bis = "Magier" },
    ["19340"] = { price = "5", prio = "Druide", bis = "" },
    
    ["19348"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19371"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19346"] = { price = "20", prio = "", bis = "" },
    ["19372"] = { price = "100", prio = "KriegerTank", bis = "KriegerTank" },
    
    
    
    
    
    ["16965"] = { price = "100", prio = "KriegerTank", bis = "KriegerTank" },
    ["16912"] = { price = "100", prio = "Magier", bis = "Magier" },
    ["16941"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16919"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16927"] = { price = "100", prio = "Hexer", bis = "Hexer" },
    ["16906"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16898"] = { price = "5", prio = "Heal Druide", bis = "" },
    ["16949"] = { price = "5", prio = "Heal Schamane", bis = "" },
    ["19341"] = { price = "5", prio = "KriegerTank > KriegerDPS", bis = "" },
    ["19342"] = { price = "roll", prio = "Schurke", bis = "" },
    
    ["19373"] = { price = "5", prio = "", bis = "" },
    ["19374"] = { price = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
    ["19350"] = { price = "10", prio = "", bis = "" },
    ["19351"] = { price = "100", prio = "Fury KriegerTank > Schwert Schurke", bis = "Fury KriegerTank > Schwert Schurke" },
    
    ["20383"] = { price = "roll", prio = "Heiler die sich die Quest-chain antun wollen & Hexer (Shadow resi gear)", bis = "" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank", bis = "" },
    ["16920"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer", bis = "" },
    ["16913"] = { price = "100", prio = "Magier", bis = "Magier" },
    ["16940"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16907"] = { price = "100", prio = "Schwert Schurke", bis = "Schwert Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    ["16948"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19344"] = { price = "10", prio = "Schamane", bis = "" },
    
    ["19399"] = { price = "10", prio = "", bis = "" },
    ["19400"] = { price = "100", prio = "Shadow", bis = "Shadow" },
    ["19365"] = { price = "10", prio = "", bis = "" },
    ["19398"] = { price = "100", prio = "Fury KriegerTank", bis = "Fury KriegerTank" },
    ["19402"] = { price = "5", prio = "", bis = "" },
    ["19401"] = { price = "5", prio = "", bis = "" },
    
    ["19355"] = { price = "10", prio = "", bis = "" },
    ["19394"] = { price = "100", prio = "Fury & Deff KriegerTank", bis = "Fury & Deff KriegerTank" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "", bis = "" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank", bis = "" },
    ["16920"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer", bis = "" },
    ["16913"] = { price = "100", prio = "Magier", bis = "Magier" },
    ["16940"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16907"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    ["19345"] = { price = "roll", prio = "Priester", bis = "" },
    
    ["19403"] = { price = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
    ["19406"] = { price = "200", prio = "Fury KriegerTank, Deff KriegerTank > Schurke, KriegerDPS, Jäger, Feral-Druide", bis = "Fury KriegerTank, Deff KriegerTank > Schurke, KriegerDPS, Jäger, Feral-Druide" },
    ["19407"] = { price = "100", prio = "Hexer, Shadow", bis = "Hexer, Shadow" },
    ["19405"] = { price = "100", prio = "EnSchamane, Feral-Druide", bis = "" },
    ["19368"] = { price = "10", prio = "", bis = "" },
    
    ["19355"] = { price = "10", prio = "", bis = "" },
    ["19394"] = { price = "100", prio = "Fury und Deff KriegerTank", bis = "Fury und Deff KriegerTank" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "", bis = "" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank", bis = "" },
    ["16920"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer", bis = "" },
    ["16913"] = { price = "100", prio = "Magier", bis = "Magier" },
    ["16940"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16907"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16899"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    ["16948"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    
    ["19430"] = { price = "100", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19432"] = { price = "100", prio = "Fury KriegerTank > EnSchamane, KriegerDPS, Feral-Druide", bis = "Fury KriegerTank > EnSchamane, KriegerDPS, Feral-Druide" },
    ["19433"] = { price = "10", prio = "", bis = "" },
    ["19431"] = { price = "100", prio = "Deff KriegerTank", bis = "Deff KriegerTank" },
    ["19367"] = { price = "5", prio = "", bis = "" },
    ["19357"] = { price = "100", prio = "Non Orc EnSchamane", bis = "Non Orc EnSchamane" },
    
    ["19355"] = { price = "10", prio = "", bis = "" },
    ["19394"] = { price = "100", prio = "Fury und Deff KriegerTank", bis = "Fury und Deff KriegerTank" },
    ["19395"] = { price = "200", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19353"] = { price = "200", prio = "Orc Krieger, Orc EnSchamane", bis = "Orc Krieger, Orc EnSchamane" },
    ["19397"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19396"] = { price = "5", prio = "", bis = "" },
    
    
    
    
    
    ["16917"] = { price = "100", prio = "Magier", bis = "" },
    ["16937"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16961"] = { price = "5", prio = "KriegerTank", bis = "" },
    ["16832"] = { price = "100", prio = "Schwert-Schurke", bis = "Schwert-Schurke" },
    ["16932"] = { price = "5", prio = "Hexer", bis = "" },
    ["16924"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16902"] = { price = "5", prio = "Heal Druide", bis = "" },
    ["16945"] = { price = "5", prio = "Heal Schamane", bis = "" },
    
    ["19352"] = { price = "100", prio = "Schurke, Krieger DPS", bis = "Schurke, Krieger DPS" },
    ["19393"] = { price = "5", prio = "", bis = "" },
    ["19347"] = { price = "20", prio = "", bis = "" },
    ["19361"] = { price = "200", prio = "Jäger", bis = "Jäger" },
    ["19349"] = { price = "100", prio = "Deff KriegerTank", bis = "Deff KriegerTank" },
    ["19388"] = { price = "5", prio = "", bis = "" },
    ["19389"] = { price = "100", prio = "EnSchamane", bis = "EnSchamane" },
    ["19387"] = { price = "100", prio = "Fury KriegerTank > KriegerDPS", bis = "Fury KriegerTank > KriegerDPS" },
    ["19390"] = { price = "5", prio = "", bis = "" },
    ["19391"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    ["19386"] = { price = "5", prio = "", bis = "" },
    ["19392"] = { price = "5", prio = "", bis = "" },
    ["19385"] = { price = "100", prio = "Heal Druide", bis = "Heal Druide" },
    
    
    
    
    
    ["16942"] = { price = "100", prio = "Jäger", bis = "Jäger" },
    ["16916"] = { price = "100", prio = "Magier", bis = "" },
    ["16905"] = { price = "100", prio = "Schurke", bis = "Schurke" },
    ["16966"] = { price = "100", prio = "KriegerTank", bis = "KriegerTank" },
    ["16923"] = { price = "100", prio = "Heal Priester", bis = "Heal Priester" },
    ["16931"] = { price = "100", prio = "Hexer", bis = "Hexer" },
    ["16897"] = { price = "5", prio = "Heal Druide", bis = "" },
    ["16950"] = { price = "100", prio = "Heal Schamane", bis = "Heal Schamane" },
    
    ["19356"] = { price = "200", prio = "Hexer, Magier", bis = "Hexer, Magier" },
    ["19379"] = { price = "200", prio = "Hexer, Magier > Shadow", bis = "Hexer, Magier > Shadow" },
    ["19375"] = { price = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
    ["19377"] = { price = "100", prio = "Schurke, Jäger, Feral-Druide", bis = "Schurke, Jäger, Feral-Druide" },
    ["19382"] = { price = "100", prio = "Heal Priester, Heal Schamane, Heal Druide", bis = "Heal Priester, Heal Schamane, Heal Druide" },
    ["19381"] = { price = "100", prio = "Dolch-Schurke, EnSchamane, FeralDruide", bis = "Dolch-Schurke, EnSchamane, FeralDruide" },
    ["19380"] = { price = "100", prio = "EnSchamane", bis = "EnSchamane" },
    ["19376"] = { price = "5", prio = "", bis = "" },
    ["19378"] = { price = "100", prio = "Hexer, Magier, Shadow", bis = "Hexer, Magier, Shadow" },
    ["19364"] = { price = "200", prio = "Non Orc KriegerDPS", bis = "Non Orc KriegerDPS" },
    ["19363"] = { price = "100", prio = "Orc KriegerDPS", bis = "Orc KriegerDPS" },
    ["19360"] = { price = "100", prio = "Heal Schamane, Heal Druide, Heal Priester, Shadow", bis = "Heal Schamane, Heal Druide, Heal Priester, Shadow" },
    
    ["19003"] = { price = "100", prio = "Deff KriegerTank > Schurke, Shadow, Hunter, EnSchamane, KriegerDPS", bis = "Deff KriegerTank > Schurke, Shadow, Hunter, EnSchamane, KriegerDPS" },
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo