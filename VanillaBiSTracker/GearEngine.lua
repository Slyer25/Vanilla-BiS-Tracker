-- Shared 1.12-compatible recommendation and loadout logic.
-- Planned items are user choices, not automatically optimized or equipped items.
local VBT = VanillaBiSTracker

function VBT:GetTalentRank(name, tree)
  if not GetNumTalents or not GetTalentInfo then return nil end
  for i=1,GetNumTalents(tree) do
    local talentName, icon, tier, column, rank = GetTalentInfo(tree,i)
    if talentName==name then return tonumber(rank) or 0 end
  end
  return nil
end

function VBT:GetWeaponBuild()
  if self.class ~= "ROGUE" or self:GetSpec() ~= "Combat" then return nil end
  if VBTCharDB and (VBTCharDB.weaponBuildOverride=="Sword"
      or VBTCharDB.weaponBuildOverride=="Dagger") then
    return VBTCharDB.weaponBuildOverride
  end
  local swords=self:GetTalentRank("Sword Specialization",2) or 0
  local daggers=self:GetTalentRank("Dagger Specialization",2) or 0
  if daggers>swords then return "Dagger" end
  return "Sword" -- fallback when talents are unavailable or tied
end

function VBT:GetWeaponBuildMode()
  return (VBTCharDB and VBTCharDB.weaponBuildOverride) or "Auto"
end

function VBT:CycleWeaponBuild()
  if not VBTCharDB then VBTCharDB={} end
  local cur=VBTCharDB.weaponBuildOverride
  if not cur then VBTCharDB.weaponBuildOverride="Sword"
  elseif cur=="Sword" then VBTCharDB.weaponBuildOverride="Dagger"
  else VBTCharDB.weaponBuildOverride=nil end
end

function VBT:MeetsTalentRequirement(item)
  if not item.requiresTalent or self.class~="SHAMAN" then return true end
  local rank=self:GetTalentRank(item.requiresTalent,item.requiresTalentTree or 2)
  if rank==nil then return true end -- unknown API state; do not silently discard
  return rank>0
end

function VBT:MeetsBuildRequirement(item, slot)
  if self.class=="ROGUE" and self:GetSpec()=="Combat"
    and (slot=="Main Hand" or slot=="Off Hand") and item.weaponType then
    return item.weaponType==self:GetWeaponBuild()
  end
  return true
end

-- Preserve the original availability, faction, race and class checks from Core.
function VBT:PassesGearRequirements(item,slot)
  return self:Eligible(item) and self:MeetsTalentRequirement(item)
    and self:MeetsBuildRequirement(item,slot)
end

function VBT:GetPlannedItems()
  if not VBTCharDB then VBTCharDB={} end
  if type(VBTCharDB.plannedItems)~="table" then VBTCharDB.plannedItems={} end
  return VBTCharDB.plannedItems
end

function VBT:IsPlanned(slot,id)
  return self:GetPlannedItems()[slot]==id
end

function VBT:PlanItem(slot,id)
  local item=self.items[id]
  if not item or not self:PassesGearRequirements(item,slot) then return false,"Not eligible for this build" end
  local planned=self:GetPlannedItems()
  if planned[slot]==id then planned[slot]=nil; return true,"Removed from plan" end
  local realSlot=slot
  if string.sub(slot,1,5)=="Ring " then realSlot="Finger" end
  if string.sub(slot,1,8)=="Trinket " then realSlot="Trinket" end
  if item.slot~=realSlot then return false,"Item does not fit this slot" end
  if slot=="Off Hand" and planned["Main Hand"] then
    local main=self.items[planned["Main Hand"]]
    if main and main.twoHanded then return false,"Two-handed weapon occupies both hand slots" end
  end
  if item.unique then
    -- Reassign the unique item instead of allowing two identical equipped copies.
    for other, oldId in pairs(planned) do
      if other~=slot and oldId==id then planned[other]=nil end
    end
  end
  if slot=="Main Hand" and item.twoHanded then planned["Off Hand"]=nil end
  planned[slot]=id
  return true,"Added to plan"
end

function VBT:GetSetCounts(planned)
  local counts,seen={},{}
  for slot,id in pairs(planned or self:GetPlannedItems()) do
    local item=self.items[id]
    if item and item.set and not seen[id] then
      seen[id]=true
      counts[item.set]=(counts[item.set] or 0)+1
    end
  end
  return counts
end

function VBT:GetSetImpact(slot,id)
  local item=self.items[id]
  if not item or not item.set then return nil end
  local current=self:GetSetCounts()
  local scenario={}
  for key,val in pairs(self:GetPlannedItems()) do scenario[key]=val end
  scenario[slot]=id
  if slot=="Main Hand" and item.twoHanded then scenario["Off Hand"]=nil end
  if item.unique then
    for key,val in pairs(scenario) do
      if key~=slot and val==id then scenario[key]=nil end
    end
  end
  local projected=self:GetSetCounts(scenario)
  local setInfo=self.gearSets[item.set]
  if not setInfo then return nil end
  local lines={}
  for _,bonus in ipairs(setInfo.bonuses) do
    if (projected[item.set] or 0)>=bonus.pieces then
      local prefix=(current[item.set] or 0)<bonus.pieces and "Unlocks " or "Active "
      table.insert(lines,prefix..bonus.pieces.."p: "..bonus.description)
    end
  end
  return setInfo.name..": "..(current[item.set] or 0).." -> "..
    (projected[item.set] or 0).." planned"..
    (table.getn(lines)>0 and ("; "..table.concat(lines,", ")) or "")
end

function VBT:GetPlanWarnings()
  local planned=self:GetPlannedItems()
  local warnings={}
  if planned["Off Hand"] and planned["Main Hand"] then
    local main=self.items[planned["Main Hand"]]
    if main and main.twoHanded then table.insert(warnings,"2H main-hand conflicts with off-hand") end
  end
  local seen={}
  for slot,id in pairs(planned) do
    local item=self.items[id]
    if not item then table.insert(warnings,"Unknown item in plan: "..tostring(id)) end
    if item and item.unique and seen[id] then
      table.insert(warnings,item.name.." selected twice")
    end
    seen[id]=true
  end
  return warnings
end
