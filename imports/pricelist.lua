--###############################################
--#  Project: ErrorDKP
--#  File: pricelist.lua
--#  Author: Manuel "Doktorwho@Venoxis" Ebner
--#  Last Edit: 26.03.2020
--###############################################
local addonName, core = ...

local pricelistInfo = {
    ["version"] = "3.0",
    ["timestamp"] = "1586263575"
}

local pricelist = {


    --
    -- AQ
    --
    ["21692"] = { price = "10", prio = "" },
    ["21693"] = { price = "10", prio = "" },
    ["21694"] = { price = "20", prio = "" },
    ["21695"] = { price = "10", prio = "" },
    ["21696"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21697"] = { price = "10", prio = "" },
    ["21232"] = { price = "120", prio = "1Tanks 2 AP Classes" },
    ["21237"] = { price = "150", prio = "Caster,Healer,Feral" },
    ["21579"] = { price = "10", prio = "" },
    ["21581"] = { price = "100", prio = "" },
    ["21582"] = { price = "80", prio = "" },
    ["21583"] = { price = "60", prio = "" },
    ["21585"] = { price = "80", prio = "" },
    ["21586"] = { price = "100", prio = "Meele" },
    ["21596"] = { price = "5", prio = "" },
    ["22730"] = { price = "100", prio = "" },
    ["22731"] = { price = "60", prio = "" },
    ["22732"] = { price = "5", prio = "" },
    ["21126"] = { price = "120", prio = "" },
    ["21134"] = { price = "200", prio = "" },
    ["21839"] = { price = "250", prio = "" },
    ["21221"] = { price = "100", prio = "Caster, Healer, Hunter" },
    ["20929"] = { price = "50", prio = "" },
    ["20933"] = { price = "50", prio = "" },
    ["21128"] = { price = "20", prio = "wenns keiner kauft verrollt" },
    ["21698"] = { price = "10", prio = "" },
    ["21699"] = { price = "10", prio = "" },
    ["21700"] = { price = "10", prio = "" },
    ["21701"] = { price = "60", prio = "" },
    ["21702"] = { price = "10", prio = "Tanks haben vorrang - wenns keiner kauft wirds verrollt" },
    ["21703"] = { price = "10", prio = "" },
    ["21704"] = { price = "x", prio = "allianz" },
    ["21705"] = { price = "10", prio = "" },
    ["21706"] = { price = "10", prio = "" },
    ["21707"] = { price = "40", prio = "" },
    ["21708"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21814"] = { price = "80", prio = "" },
    ["22396"] = { price = "10", prio = "" },
    ["22402"] = { price = "0", prio = "allianz" },
    ["21627"] = { price = "0", prio = "LC Hexer" },
    ["21635"] = { price = "20", prio = "" },
    ["21639"] = { price = "10", prio = "" },
    ["21645"] = { price = "10", prio = "" },
    ["21647"] = { price = "20", prio = "" },
    ["21650"] = { price = "120", prio = "" },
    ["21651"] = { price = "100", prio = "Enhancer" },
    ["21652"] = { price = "10", prio = "Tanks zuerst wenn sie wollen" },
    ["21663"] = { price = "60", prio = "" },
    ["21664"] = { price = "30", prio = "" },
    ["21665"] = { price = "10", prio = "" },
    ["21597"] = { price = "80", prio = "" },
    ["21598"] = { price = "10", prio = "" },
    ["21599"] = { price = "10", prio = "" },
    ["21600"] = { price = "20", prio = "" },
    ["21601"] = { price = "10", prio = "" },
    ["21602"] = { price = "60", prio = "" },
    ["20930"] = { price = "50", prio = "" },
    ["21604"] = { price = "60", prio = "" },
    ["21605"] = { price = "10", prio = "" },
    ["21606"] = { price = "0", prio = "allianz" },
    ["21607"] = { price = "20", prio = "" },
    ["21608"] = { price = "80", prio = "" },
    ["21609"] = { price = "40", prio = "" },
    ["21679"] = { price = "100", prio = "" },
    ["20926"] = { price = "50", prio = "" },
    ["21603"] = { price = "50", prio = "" },
    ["21680"] = { price = "10", prio = "" },
    ["21681"] = { price = "40", prio = "" },
    ["21685"] = { price = "20", prio = "Tank, Hexer " },
    ["21610"] = { price = "20", prio = "" },
    ["21611"] = { price = "40", prio = "" },
    ["21615"] = { price = "100", prio = "" },
    ["23557"] = { price = "20", prio = "" },
    ["23558"] = { price = "10", prio = "" },
    ["23570"] = { price = "120", prio = "" },
    ["20927"] = { price = "50", prio = "" },
    ["20931"] = { price = "50", prio = "" },
    ["21616"] = { price = "10", prio = "" },
    ["21617"] = { price = "80", prio = "" },
    ["21618"] = { price = "80", prio = "" },
    ["21619"] = { price = "20", prio = "" },
    ["21620"] = { price = "100", prio = "" },
    ["21621"] = { price = "10", prio = "" },
    ["21682"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21683"] = { price = "0", prio = "Allianz" },
    ["21684"] = { price = "10", prio = "" },
    ["21686"] = { price = "40", prio = "" },
    ["21687"] = { price = "0", prio = "LC Hexer" },
    ["21648"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21666"] = { price = "30", prio = "" },
    ["21667"] = { price = "0", prio = "Allianz" },
    ["21668"] = { price = "10", prio = "" },
    ["21669"] = { price = "40", prio = "" },
    ["21670"] = { price = "100", prio = "" },
    ["21671"] = { price = "50", prio = "" },
    ["21672"] = { price = "60", prio = "" },
    ["21673"] = { price = "50", prio = "" },
    ["21674"] = { price = "20", prio = "" },
    ["21675"] = { price = "10", prio = "" },
    ["21676"] = { price = "40", prio = "" },
    ["21678"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21688"] = { price = "50", prio = "" },
    ["21689"] = { price = "10", prio = "" },
    ["21690"] = { price = "20", prio = "" },
    ["21691"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21622"] = { price = "120", prio = "" },
    ["21624"] = { price = "40", prio = "Enhancer" },
    ["21625"] = { price = "20", prio = "" },
    ["21626"] = { price = "10", prio = "wenns keiner kauft verrollt" },
    ["21677"] = { price = "60", prio = "" },
    ["22399"] = { price = "40", prio = "" },
    ["20928"] = { price = "50", prio = "" },
    ["20932"] = { price = "50", prio = "" },
    ["21838"] = { price = "40", prio = "Hexer prio" },
    ["21837"] = { price = "10", prio = "" },
    ["21888"] = { price = "5", prio = "" },
    ["21856"] = { price = "40", prio = "" },
    ["21836"] = { price = "60", prio = "" },
    ["21891"] = { price = "10", prio = "" },

    -- 
    -- BWL
    --
    ["19436"] = { price = "20", prio = "Meele" },
    ["19358"] = { price = "5", prio = "Meele" },
    ["19437"] = { price = "50", prio = "Healer" },
    ["19362"] = { price = "50", prio = "Meele" },
    ["19435"] = { price = "20", prio = "Healer" },
    ["19434"] = { price = "10", prio = "Range" },
    ["19354"] = { price = "5", prio = "Meele" },
    ["19438"] = { price = "0", prio = "Range" },
    
    
    
    
    
    
    ["16926"] = { price = "20", prio = "Healer" },
    ["16935"] = { price = "5", prio = "Jäger" },
    ["16911"] = { price = "5", prio = "Schurke" },
    ["16959"] = { price = "5", prio = "Tank" },
    ["16918"] = { price = "5", prio = "Magier" },
    ["16934"] = { price = "5", prio = "Hexer" },
    ["16904"] = { price = "20", prio = "Healer" },
    ["16943"] = { price = "20", prio = "Healer" },
    ["19337"] = { price = "roll", prio = "Hexer" },
    ["19336"] = { price = "roll", prio = "Jäger" },
    
    ["19335"] = { price = "0", prio = "Tank" },
    ["19369"] = { price = "0", prio = "Healer" },
    ["19370"] = { price = "50", prio = "Range" },
    ["19334"] = { price = "50", prio = "Meele" },
    
    
    
    
    
    ["16910"] = { price = "20", prio = "Schurke" },
    ["16903"] = { price = "5", prio = "Healer" },
    ["16960"] = { price = "5", prio = "Tank" },
    ["16933"] = { price = "20", prio = "Hexer" },
    ["16818"] = { price = "5", prio = "Magier" },
    ["16925"] = { price = "5", prio = "Healer" },
    ["16936"] = { price = "5", prio = "Jäger" },
    ["16944"] = { price = "20", prio = "Healer" },
    ["19339"] = { price = "50", prio = "Magier" },
    ["19340"] = { price = "roll", prio = "Druide" },
    
    ["19348"] = { price = "0", prio = "Healer" },
    ["19371"] = { price = "0", prio = "Healer" },
    ["19346"] = { price = "20", prio = "Tank" },
    ["19372"] = { price = "0", prio = "Tank" },
    
    
    
    
    
    ["16965"] = { price = "5", prio = "Tank" },
    ["16912"] = { price = "5", prio = "Magier" },
    ["16941"] = { price = "5", prio = "Jäger" },
    ["16919"] = { price = "5", prio = "Healer" },
    ["16927"] = { price = "5", prio = "Hexer" },
    ["16906"] = { price = "20", prio = "Schurke" },
    ["16898"] = { price = "5", prio = "Healer" },
    ["16949"] = { price = "5", prio = "Healer" },
    ["19341"] = { price = "0", prio = "1st Tank" },
    ["19342"] = { price = "0", prio = "Schurke" },
    
    ["19373"] = { price = "0", prio = "Healer" },
    ["19374"] = { price = "20", prio = "Range" },
    ["19350"] = { price = "0", prio = "Meele" },
    ["19351"] = { price = "60", prio = "Tank (beide Bindings & Edgemasters) > Meeles (rotiert)" },
    
    ["20383"] = { price = "0", prio = "Heiler die sich die Quest-chain antun wollen & Hexer (Shadow resi gear)" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "Tank" },
    ["16920"] = { price = "20", prio = "Healer" },
    ["16928"] = { price = "5", prio = "Hexer" },
    ["16913"] = { price = "20", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "20", prio = "Schurke" },
    ["16899"] = { price = "20", prio = "Healer" },
    ["16948"] = { price = "20", prio = "Healer" },
    ["19344"] = { price = "0", prio = "Schamane" },
    
    ["19399"] = { price = "0", prio = "Healer, Range" },
    ["19400"] = { price = "20", prio = "Range" },
    ["19365"] = { price = "0", prio = "Meele" },
    ["19398"] = { price = "20", prio = "Tank" },
    ["19402"] = { price = "0", prio = "Meele" },
    ["19401"] = { price = "0", prio = "Healer, Range" },
    
    ["19355"] = { price = "0", prio = "Healer, Range" },
    ["19394"] = { price = "20", prio = "Tank, Meele" },
    ["19395"] = { price = "120", prio = "Healer" },
    ["19353"] = { price = "50", prio = "Meele" },
    ["19397"] = { price = "10", prio = "Healer" },
    ["19396"] = { price = "0", prio = "Meele" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "Tank" },
    ["16920"] = { price = "20", prio = "Healer" },
    ["16928"] = { price = "20", prio = "Hexer" },
    ["16913"] = { price = "20", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "20", prio = "Schurke" },
    ["16899"] = { price = "20", prio = "Healer" },
    ["19345"] = { price = "0", prio = "Priester" },
    
    ["19403"] = { price = "50", prio = "Range" },
    ["19406"] = { price = "120", prio = "1.Tank > rotiert Meeles > Jäger > Feral" },
    ["19407"] = { price = "0", prio = "Range" },
    ["19405"] = { price = "0", prio = "Meele" },
    ["19368"] = { price = "0", prio = "Meele" },
    
    ["19355"] = { price = "0", prio = "Healer, Range" },
    ["19394"] = { price = "20", prio = "Tank, Meele" },
    ["19395"] = { price = "120", prio = "Healer" },
    ["19353"] = { price = "50", prio = "Meele" },
    ["19397"] = { price = "10", prio = "Healer" },
    ["19396"] = { price = "0", prio = "Meele" },
    
    
    
    
    
    ["16964"] = { price = "5", prio = "KriegerTank" },
    ["16920"] = { price = "20", prio = "Heal Priester" },
    ["16928"] = { price = "5", prio = "Hexer" },
    ["16913"] = { price = "20", prio = "Magier" },
    ["16940"] = { price = "5", prio = "Jäger" },
    ["16907"] = { price = "20", prio = "Schurke" },
    ["16899"] = { price = "20", prio = "Heal Druide" },
    ["16948"] = { price = "20", prio = "Heal Schamane" },
    
    ["19430"] = { price = "10", prio = "Healer" },
    ["19432"] = { price = "20", prio = "Tank, Meele" },
    ["19433"] = { price = "0", prio = "Healer, Meele, Range" },
    ["19431"] = { price = "0", prio = "Tank" },
    ["19367"] = { price = "0", prio = "Healer, Range" },
    ["19357"] = { price = "10", prio = "Meele" },
    
    ["19355"] = { price = "0", prio = "Healer, Range" },
    ["19394"] = { price = "20", prio = "Tank, Meele" },
    ["19395"] = { price = "120", prio = "Healer" },
    ["19353"] = { price = "50", prio = "Meele" },
    ["19397"] = { price = "10", prio = "Healer" },
    ["19396"] = { price = "0", prio = "Meele" },
    
    
    
    
    
    ["16917"] = { price = "5", prio = "Magier" },
    ["16937"] = { price = "5", prio = "Jäger" },
    ["16961"] = { price = "5", prio = "Tank" },
    ["16832"] = { price = "20", prio = "Schurke" },
    ["16932"] = { price = "5", prio = "Hexer" },
    ["16924"] = { price = "20", prio = "Healer" },
    ["16902"] = { price = "5", prio = "Healer" },
    ["16945"] = { price = "5", prio = "Healer" },
    
    ["19352"] = { price = "60", prio = "rotiert Meele" },
    ["19393"] = { price = "0", prio = "Healer, Range, Meele" },
    ["19347"] = { price = "20", prio = "Healer > Range" },
    ["19361"] = { price = "120", prio = "Hunter" },
    ["19349"] = { price = "10", prio = "Tank" },
    ["19388"] = { price = "0", prio = "Range" },
    ["19389"] = { price = "10", prio = "Meele" },
    ["19387"] = { price = "50", prio = "Tank, Meele" },
    ["19390"] = { price = "0", prio = "Healer, Range" },
    ["19391"] = { price = "10", prio = "Healer" },
    ["19386"] = { price = "0", prio = "Tank" },
    ["19392"] = { price = "0", prio = "Meele" },
    ["19385"] = { price = "50", prio = "Healer" },
    
    
    
    
    
    ["16942"] = { price = "5", prio = "Jäger" },
    ["16916"] = { price = "5", prio = "Magier" },
    ["16905"] = { price = "20", prio = "Schurke" },
    ["16966"] = { price = "5", prio = "Tank" },
    ["16923"] = { price = "5", prio = "Healer" },
    ["16931"] = { price = "5", prio = "Hexer" },
    ["16897"] = { price = "5", prio = "Healer" },
    ["16950"] = { price = "5", prio = "Healer" },
    
    ["19356"] = { price = "60", prio = "Range" },
    ["19379"] = { price = "120", prio = "Range > Shadow" },
    ["19375"] = { price = "50", prio = "Range" },
    ["19377"] = { price = "60", prio = "Meele" },
    ["19382"] = { price = "80", prio = "Healer" },
    ["19381"] = { price = "20", prio = "Meele" },
    ["19380"] = { price = "10", prio = "Meele" },
    ["19376"] = { price = "0", prio = "Meele" },
    ["19378"] = { price = "10", prio = "Range" },
    ["19364"] = { price = "100", prio = "Meele" },
    ["19363"] = { price = "50", prio = "Meele" },
    ["19360"] = { price = "50", prio = "Healer" },
    
    ["19003"] = { price = "20", prio = "Meele > Range" },
--------------
--MC
--------------
["17067"] = { price = "0", prio = "DKP" },
["16908"] = { price = "0", prio = "Schurke" },
["17068"] = { price = "0", prio = "Orc KriegerDPS" },
["16939"] = { price = "0", prio = "Jäger" },
["18205"] = { price = "0", prio = "Meele" },
["16921"] = { price = "0", prio = "Heal Priester" },
["18423"] = { price = "0", prio = "KriegerDPS, Fury KriegerTank, Deff KriegerTank, EnSchamane" },
["16963"] = { price = "0", prio = "Krieger Tank" },
["16947"] = { price = "0", prio = "Heal Schamane" },
["18705"] = { price = "0", prio = "Jäger" },
["16929"] = { price = "0", prio = "Hexer" },
["16914"] = { price = "0", prio = "Magier" },
["18813"] = { price = "0", prio = "DKP" },
["17078"] = { price = "0", prio = "Caster, Heiler" },
["17064"] = { price = "0", prio = "HealPriester, HealSchamane, HealDruide" },
["16900"] = { price = "0", prio = "HealDruide" },
["17075"] = { price = "0", prio = "Non Orc Krieger, Schurke" },




["16800"] = { price = "0", prio = "Magier" },
["16829"] = { price = "0", prio = "Heal Druide" },
["17109"] = { price = "0", prio = "Caster" },
["16837"] = { price = "0", prio = "Heal Schamane" },
["16805"] = { price = "0", prio = "Hexer" },
["18861"] = { price = "0", prio = "Tank" },
["16863"] = { price = "0", prio = "Deff KriegerTank" },
["18879"] = { price = "0", prio = "DKP" },
["18872"] = { price = "0", prio = "DKP" },
["19147"] = { price = "20", prio = "Magier" },
["19145"] = { price = "20", prio = "Magier" },



["18823"] = { price = "20", prio = "DolchSchurke, KriegerDPS" },
["16796"] = { price = "0", prio = "Magier" },
["16835"] = { price = "0", prio = "Heal Druide" },
["18829"] = { price = "0", prio = "Ele > Schami" },
["16843"] = { price = "0", prio = "Ele, Heal Schami" },
["17073"] = { price = "0", prio = "Meele" },
["18203"] = { price = "0", prio = "Meele, Tank" },
["16810"] = { price = "0", prio = "Hexer" },
["19142"] = { price = "0", prio = "Caster, Healer" },
["19143"] = { price = "20", prio = "KriegerDPS" },
["18861"] = { price = "0", prio = "Tank" },
["16847"] = { price = "0", prio = "Jäger" },
["16867"] = { price = "0", prio = "Krieger Tank" },
["19136"] = { price = "20", prio = "Magier" },
["17065"] = { price = "0", prio = "Tank" },
["16822"] = { price = "0", prio = "Schurke" },
["18822"] = { price = "0", prio = "Meele" },
["16814"] = { price = "0", prio = "Priester" },
["18821"] = { price = "20", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["19144"] = { price = "0", prio = "Meele, Hunter" },
["17069"] = { price = "20", prio = "Schurke, KriegerDPS" },
["18820"] = { price = "20", prio = "Hexer, ShadowPriester" },



["17077"] = { price = "0", prio = "DKP" },
["16839"] = { price = "0", prio = "Heal Schamane" },
["18861"] = { price = "0", prio = "Krieger Tank" },
["16849"] = { price = "30", prio = "Jäger" },
["16812"] = { price = "0", prio = "Priester" },
["18879"] = { price = "0", prio = "DKP" },
["18872"] = { price = "0", prio = "DKP" },
["16826"] = { price = "0", prio = "Rogue" },
["19147"] = { price = "20", prio = "Magier" },
["19145"] = { price = "20", prio = "Caster " },
["16862"] = { price = "0", prio = "Krieger Tank" },
["18875"] = { price = "20", prio = "HealSchamane" },
["18878"] = { price = "0", prio = "Caster " },
["19146"] = { price = "20", prio = "KriegerDPS, EnSchamane" },



["18564"] = { price = "LootCouncil", prio = "Lootcouncil" },
["18823"] = { price = "20", prio = "DolchSchurke, KriegerDPS" },
["16795"] = { price = "0", prio = "Magier" },
["17105"] = { price = "0", prio = "Priester, Druide, Schamane" },
["18832"] = { price = "20", prio = "KriegerDPS, Jäger" },
["16834"] = { price = "0", prio = "Druide" },
["16813"] = { price = "0", prio = "Priester" },
["18829"] = { price = "0", prio = "Ele > Schami" },
["17066"] = { price = "0", prio = "Krieger Tank" },
["16842"] = { price = "0", prio = "Schami" },
["16808"] = { price = "0", prio = "Hexer" },
["19142"] = { price = "0", prio = "Caster, Healer" },
["19143"] = { price = "20", prio = "KriegerDPS" },
["18861"] = { price = "0", prio = "Tank Krieger" },
["16846"] = { price = "0", prio = "Jäger" },
["17071"] = { price = "0", prio = "Warri, Schurke" },
["16866"] = { price = "0", prio = "Krieger Tank" },
["19136"] = { price = "20", prio = "Magier" },
["16821"] = { price = "0", prio = "Rogue" },
["18822"] = { price = "0", prio = "Krieger DPS" },
["18821"] = { price = "20", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["18820"] = { price = "20", prio = "Hexer, ShadowPriester" },



["16801"] = { price = "0", prio = "Magier" },
["16811"] = { price = "0", prio = "Priester Heal" },
["16831"] = { price = "0", prio = "Druide Heal" },
["17077"] = { price = "0", prio = "DKP" },
["16803"] = { price = "0", prio = "Hexer" },
["16852"] = { price = "0", prio = "Jäger" },
["16824"] = { price = "0", prio = "Schurke" },
["19147"] = { price = "20", prio = "Magier" },
["19145"] = { price = "0", prio = "Caster" },
["18878"] = { price = "0", prio = "Caster" },
["18872"] = { price = "0", prio = "DKP" },



["18564"] = { price = "LootCouncil", prio = "Lootcouncil" },
["18823"] = { price = "20", prio = "DolchSchurke, KriegerDPS" },
["16797"] = { price = "0", prio = "Magier" },
["16836"] = { price = "0", prio = "Druide Heal" },
["16844"] = { price = "0", prio = "Schami Heal" },
["16807"] = { price = "0", prio = "Hexer" },
["19142"] = { price = "0", prio = "Caster" },
["19143"] = { price = "20", prio = "KriegerDPS" },
["18861"] = { price = "0", prio = "Krieger Tank" },
["19136"] = { price = "20", prio = "Magier" },
["18822"] = { price = "0", prio = "Krieger DPS" },
["18821"] = { price = "20", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["17110"] = { price = "0", prio = "DKP" },
["18820"] = { price = "20", prio = "Hexer, ShadowPriester" },



["18823"] = { price = "20", prio = "DolchSchurke, KriegerDPS" },
["16798"] = { price = "0", prio = "Magier" },
["17103"] = { price = "20", prio = "Magier, Hexer" },
["17072"] = { price = "0", prio = "Meele" },
["16865"] = { price = "0", prio = "Krieger Tank" },
["16833"] = { price = "0", prio = "Druide Heal" },
["16841"] = { price = "0", prio = "Schami Heal" },
["16809"] = { price = "0", prio = "Hexer" },
["19142"] = { price = "0", prio = "Caster" },
["19143"] = { price = "20", prio = "KriegerDPS" },
["18861"] = { price = "0", prio = "Krieger Tank" },
["16845"] = { price = "0", prio = "Jäger" },
["19136"] = { price = "20", prio = "Magier" },
["16820"] = { price = "0", prio = "Schurke" },
["18822"] = { price = "0", prio = "Meele" },
["18821"] = { price = "20", prio = "KriegerDPS, FeralDruide, EnSchamane" },
["16815"] = { price = "0", prio = "Priester" },
["18842"] = { price = "20", prio = "Caster, Healer" },
["17203"] = { price = "0", prio = "Bank" },
["18820"] = { price = "20", prio = "Hexer, ShadowPriester" },



["17077"] = { price = "0", prio = "Caster, Healer" },
["18861"] = { price = "0", prio = "Tank" },
["16848"] = { price = "0", prio = "Jäger" },
["18879"] = { price = "0", prio = "Tank" },
["18872"] = { price = "0", prio = "Caster, Healer" },
["16816"] = { price = "0", prio = "Priester" },
["16823"] = { price = "0", prio = "Schurke" },
["16868"] = { price = "0", prio = "KriegerTank" },
["19147"] = { price = "20", prio = "Magier" },
["18875"] = { price = "20", prio = "HealSchamane" },
["17074"] = { price = "0", prio = "DKP" },
["18878"] = { price = "0", prio = "Caster, Healer" },
["19146"] = { price = "20", prio = "KriegerDPS, EnSchamane" },



["18703"] = { price = "0", prio = "Jäger" },
["18805"] = { price = "20", prio = "DolchKrieger, DolchSchurke, Jäger" },
["18811"] = { price = "0", prio = "Caster, Healer" },
["18809"] = { price = "0", prio = "Hexer, Shadow" },
["18646"] = { price = "0", prio = "Priester" },
["18810"] = { price = "20", prio = "HealSchamane, HealDruide" },
["18812"] = { price = "20", prio = "Fury KriegerTank, Jäger" },
["19140"] = { price = "20", prio = "HealPriester, HealSchamane, HealDruide" },
["18803"] = { price = "0", prio = "DKP" },
["18806"] = { price = "0", prio = "Tank" },



["16915"] = { price = "5", prio = "Magier" },
["16901"] = { price = "5", prio = "Druide" },
["18816"] = { price = "20", prio = "DolchSchurke, KriegerDPS (gloves)" },
["19138"] = { price = "0", prio = "Caster, Healer" },
["16938"] = { price = "5", prio = "Jäger" },
["16909"] = { price = "5", prio = "Schurke" },
["18817"] = { price = "0", prio = "EnSchamane" },
["17063"] = { price = "40", prio = "Fury KriegerTank -> KriegerDPS, Schurke, EnSchamane, Hunter, FeralDruide" },
["17107"] = { price = "3", prio = "Meele" },
["18815"] = { price = "0", prio = "Tank" },
["16922"] = { price = "5", prio = "HealPriester" },
["16930"] = { price = "5", prio = "Hexer" },
["16962"] = { price = "5", prio = "Deff KriegerTank" },
["18814"] = { price = "30", prio = "Magier, Hexer, ShadowPriester" },
["17106"] = { price = "0", prio = "Healer" },
["19137"] = { price = "50", prio = "Fury KriegerTank, Deff KriegerTank -> KriegerDPS" },
["17082"] = { price = "0", prio = "DKP" },
["17104"] = { price = "40", prio = "Orc Meele" },
["17076"] = { price = "50", prio = "Meele" },
["16946"] = { price = "5", prio = "Ele, HealSchamane" },
["17102"] = { price = "0", prio = "Meele" },



["16830"] = { price = "0", prio = "Druid" },
["16819"] = { price = "0", prio = "Priest" },
["16804"] = { price = "0", prio = "Hexer" },
["16850"] = { price = "0", prio = "Jäger" },
["16861"] = { price = "0", prio = "Krieger" },
["16825"] = { price = "0", prio = "Schurke" },
["16802"] = { price = "0", prio = "Magier" },
["16838"] = { price = "0", prio = "Schami" },
}

core.Imports.ItemPriceList = pricelist
core.Imports.ItemPriceListInfo = pricelistInfo