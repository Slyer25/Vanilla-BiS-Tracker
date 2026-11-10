-- Executable Lua 5.1 harness for the addon core/data (Vanilla 1.12 uses 5.0).
-- In-game API and rendering still require user testing on the actual client.
SlashCmdList = {}
function CreateFrame()
  local f = {}
  function f:RegisterEvent() end
  function f:SetScript() end
  return f
end
function GetNumTalentTabs() return 3 end
function GetTalentTabInfo(tab)
  local names={"Assassination","Combat","Subtlety"}
  local points={16,32,3}
  return names[tab], nil, points[tab]
end
function UnitClass() return "Rogue","ROGUE" end
function UnitRace() return "Night Elf","NIGHTELF" end
function UnitFactionGroup() return "Alliance" end
function UnitName() return "TestRogue" end
function GetRealmName() return "Test" end
local rogueSwordRank, rogueDaggerRank, shamanTwoHandRank=2,0,1
function GetNumTalents(tree) return tree==2 and 3 or 0 end
function GetTalentInfo(tree,index)
  if tree~=2 then return nil,nil,nil,nil,0 end
  if index==1 then return "Sword Specialization",nil,nil,nil,rogueSwordRank end
  if index==2 then return "Dagger Specialization",nil,nil,nil,rogueDaggerRank end
  return "Two-Handed Axes and Maces",nil,nil,nil,shamanTwoHandRank
end
DEFAULT_CHAT_FRAME={AddMessage=function() end}
VBTDB={phase=1,includePvP=false}
VBTCharDB={}
dofile("VanillaBiSTracker/Bootstrap.lua")
dofile("VanillaBiSTracker/Core.lua")
dofile("VanillaBiSTracker/data/Phases.lua")
dofile("VanillaBiSTracker/data/Recommendations.lua")
dofile("VanillaBiSTracker/data/GearRules.lua")
dofile("VanillaBiSTracker/data/SourceAudit.lua")
dofile("VanillaBiSTracker/GearEngine.lua")
local v=VanillaBiSTracker
v:DetectCharacter()
assert(v:GetSpec()=="Combat", "Failed to infer 16/32/3 Combat build")
local function has(slot,id)
  for _, rec in ipairs(v:GetRecommendations(slot)) do
    if rec.item.id==id then return true end
  end
  return false
end
assert(v:GetWeaponBuild()=="Sword","Combat spec should default to swords")
assert(not has("Main Hand",18816),"Dagger should be hidden from sword build")
rogueDaggerRank=4
assert(v:GetWeaponBuild()=="Dagger","Talent-based Combat Daggers detection failed")
assert(has("Main Hand",18816)==false,"MC dagger leaked into pre-raid")
VBTCharDB.weaponBuildOverride="Sword"
assert(v:GetWeaponBuild()=="Sword","Manual sword override failed")
VBTCharDB.weaponBuildOverride=nil
rogueDaggerRank=0
assert(has("Head",13404))
assert(not has("Shoulders",16823), "MC gear wrongly in pre-raid")
assert(not has("Ring 1",18500), "Dire Maul gear wrongly in pre-raid")
assert(not has("Ring 1",19325), "PvP gear wrongly in pre-raid")
assert(not has("Trinket 1",19406), "BWL gear wrongly in pre-raid")
assert(not has("Head",16908), "Onyxia Bloodfang hood leaked into pre-raid")
assert(not has("Main Hand",19352), "BWL sword leaked into pre-raid")
assert(not has("Feet",18506), "Dire Maul-only Mongoose Boots leaked into pre-raid")
VBTDB.phase=2
assert(has("Shoulders",16823), "MC gear missing")
assert(has("Head",16908), "Onyxia Bloodfang Hood missing")
assert(has("Main Hand",17075), "Onyxia sword missing")
rogueDaggerRank=4
assert(has("Main Hand",18816), "Perdition dagger missing for Combat Daggers")
assert(has("Off Hand",18805), "Core Hound Tooth missing for Combat Daggers")
assert(not has("Main Hand",17075), "Sword leaked into Combat Daggers")
rogueDaggerRank=0
assert(has("Ring 1",17063), "Band of Accuria missing")
assert(not has("Wrists",16911), "BWL bracers leaked into MC")
assert(not has("Trinket 1",19406), "BWL gear leaked into MC")
VBTDB.phase=3
assert(has("Ring 1",18500), "Dire Maul gear missing")
assert(has("Feet",18506), "Mongoose Boots missing after Dire Maul unlock")
assert(not has("Ring 1",19325), "PvP rewards wrongly included without toggle")
VBTDB.includePvP=true
assert(has("Ring 1",19325), "PvP gear missing with toggle enabled")
VBTDB.includePvP=false
VBTDB.phase=4
assert(has("Trinket 1",19406), "BWL gear missing")
assert(has("Main Hand",19352), "BWL sword missing")
assert(has("Off Hand",19351), "BWL off-hand missing")
assert(has("Chest",16905), "BWL Bloodfang chest missing")
assert(has("Trinket 1",11815), "Earlier viable gear absent in later phase")
v.class="SHAMAN"
v.detectedSpec="Enhancement"
assert(has("Head",18817))
shamanTwoHandRank=0
assert(not has("Main Hand",18538),"Shaman 2H item not restricted by actual talent")
shamanTwoHandRank=1
assert(has("Main Hand",18538))
assert(not has("Main Hand",19323), "Alterac Valley weapon must be PvP gated")
VBTDB.includePvP=true
assert(has("Main Hand",19323), "Alterac Valley weapon unavailable with PvP enabled")
VBTDB.includePvP=false
assert(has("Chest",11726), "Savage Gladiator Chain missing")
assert(has("Waist",18393), "Dire Maul waist missing")
assert(has("Feet",16984), "Crafted raid-material boots missing")
-- Planned loadout: unique items must not be duplicated in two ring slots.
local ok,why=v:PlanItem("Ring 1",17063)
assert(ok and v:IsPlanned("Ring 1",17063))
ok,why=v:PlanItem("Ring 2",17063)
assert(ok and v:IsPlanned("Ring 2",17063) and not v:IsPlanned("Ring 1",17063),
  "Unique ring selected in both slots")
-- Two-handed weapons clear any off-hand candidate.
v:GetPlannedItems()["Off Hand"]=12939
ok,why=v:PlanItem("Main Hand",18538)
assert(ok and v:GetPlannedItems()["Off Hand"]==nil,"Two-handed weapon did not clear offhand")
-- The warning engine flags conflicts if a pre-existing SavedVariable plan is invalid.
v:GetPlannedItems()["Off Hand"]=12939
assert(table.getn(v:GetPlanWarnings())>0,"2H/off-hand conflict warning missing")
v:GetPlannedItems()["Off Hand"]=nil
v:GetPlannedItems()["Ring 1"]=17063
assert(table.getn(v:GetPlanWarnings())>0,"Unique ring warning missing")
v:GetPlannedItems()["Ring 1"]=nil
assert(v.items[18805].sourceStatus=="verified","Known item source audit was not loaded")
assert(v.items[18506].sourceStatus=="verified" and v.items[18506].phase==3, "Mongoose Boots source/phase audit missing")
assert(v.items[19436].sourceType=="raid-trash", "BWL trash cloak must not be boss-classified")
assert(v.items[19146].boss and string.find(v.items[19146].boss, "Lucifron",1,true), "Wristguards of Stability source incomplete")
assert(v.items[18538].sourceStatus=="verified","Gordok Tribute source review missing")
for id,item in pairs(v.items) do
  assert(item.sourceStatus=="verified","Unreviewed item source: "..id)
  assert(item.sourceRef and string.find(item.sourceRef,"https://",1,true),
    "Missing evidence link for item "..id)
end
v:GetPlannedItems()["Main Hand"]=nil
-- Devilsaur 2-piece bonus recognition.
v:GetPlannedItems()["Hands"]=15063
local impact=v:GetSetImpact("Legs",15062)
assert(impact and string.find(impact,"+2% melee hit",1,true),"Set threshold missing")

v.class="ROGUE"
v.detectedSpec="Combat"
v.items[13404].class="SHAMAN"
assert(not has("Head",13404), "Eligibility restriction failed")
v.items[13404].class=nil
VBTCharDB.specOverride="Subtlety"
assert(not has("Head",13404), "Specialization filtering failed")
print("PASS: phase gating, weapon builds, Shaman 2H talent, unique rings, set synergy, sources")
