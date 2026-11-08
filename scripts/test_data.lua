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
DEFAULT_CHAT_FRAME={AddMessage=function() end}
VBTDB={phase=1,includePvP=false}
VBTCharDB={}
dofile("VanillaBiSTracker/Bootstrap.lua")
dofile("VanillaBiSTracker/Core.lua")
dofile("VanillaBiSTracker/data/Phases.lua")
dofile("VanillaBiSTracker/data/Recommendations.lua")
local v=VanillaBiSTracker
v:DetectCharacter()
assert(v:GetSpec()=="Combat", "Failed to infer 16/32/3 Combat build")
local function has(slot,id)
  for _, rec in ipairs(v:GetRecommendations(slot)) do
    if rec.item.id==id then return true end
  end
  return false
end
assert(has("Head",13404))
assert(not has("Shoulders",16823), "MC gear wrongly in pre-raid")
assert(not has("Ring 1",18500), "Dire Maul gear wrongly in pre-raid")
assert(not has("Ring 1",19325), "PvP gear wrongly in pre-raid")
assert(not has("Trinket 1",19406), "BWL gear wrongly in pre-raid")
VBTDB.phase=2
assert(has("Shoulders",16823), "MC gear missing")
assert(not has("Trinket 1",19406), "BWL gear leaked into MC")
VBTDB.phase=3
assert(has("Ring 1",18500), "Dire Maul gear missing")
assert(not has("Ring 1",19325), "PvP rewards wrongly included without toggle")
VBTDB.includePvP=true
assert(has("Ring 1",19325), "PvP gear missing with toggle enabled")
VBTDB.includePvP=false
VBTDB.phase=4
assert(has("Trinket 1",19406), "BWL gear missing")
assert(has("Trinket 1",11815), "Earlier viable gear absent in later phase")
v.class="SHAMAN"
v.detectedSpec="Enhancement"
assert(has("Head",18817))
assert(has("Main Hand",18538))
v.class="ROGUE"
v.detectedSpec="Combat"
v.items[13404].class="SHAMAN"
assert(not has("Head",13404), "Eligibility restriction failed")
v.items[13404].class=nil
VBTCharDB.specOverride="Subtlety"
assert(not has("Head",13404), "Specialization filtering failed")
print("PASS: original item phase filtering, PvP toggle, class eligibility, 16/32/3 talent detection")
