-- Shared metadata for original Vanilla 1.12 gear rules.
-- Keep item facts, equip restrictions, and set interactions independent from BiS rankings.
local VBT = VanillaBiSTracker
VBT.gearSets = {
  Devilsaur = { name="Devilsaur Armor", bonuses={
    {pieces=2,description="+2% melee hit (requires both gloves and legs)"}
  }},
  Shadowcraft = { name="Shadowcraft Armor", bonuses={
    {pieces=2,description="+200 armor"},{pieces=4,description="+40 attack power"},
    {pieces=6,description="Chance on melee attack to restore 35 energy"},
    {pieces=8,description="+8 all resistances"}
  }},
  Bloodfang = { name="Bloodfang Armor", bonuses={
    {pieces=3,description="+5% chance to apply poisons"},
    {pieces=5,description="Improved Feint threat reduction"},
    {pieces=8,description="On-hit damage and healing effect"}
  }},
  BlackDragonMail = { name="Black Dragon Mail", bonuses={
    {pieces=2,description="+1% hit"},
    {pieces=3,description="+2% critical strike"},
    {pieces=4,description="+10 fire resistance"}
  }},
  DalRend = { name="Dal'Rend's Arms", bonuses={
    {pieces=2,description="+50 attack power with both swords"}
  }}
}
local function set(setName, ids)
  for _, id in ipairs(ids) do
    if VBT.items[id] then VBT.items[id].set = setName end
  end
end
set("Devilsaur", {15062,15063})
set("Shadowcraft", {16708,16709,16710,16711,16713,16721})
set("Bloodfang", {16905,16906,16908,16909,16910,16911})
set("BlackDragonMail", {15050,15051,15052,16984})
set("DalRend", {12939,12940})

local function weapons(weaponType, ids)
  for _, id in ipairs(ids) do
    if VBT.items[id] then VBT.items[id].weaponType=weaponType end
  end
end
weapons("Sword", {12939,12940,17075,18832,19351,19352})
weapons("Dagger", {18816,18805})
weapons("Two-Handed Axe", {12784,18538})
weapons("Two-Handed Mace", {19323})

-- Classic version shows 'Unique' (not retail's later 'Unique-Equipped').
-- Prevent choosing the same ID for both ring slots; don't automatically ban
-- different items from the same set.
for _, id in ipairs({17063,19325,18816,18805}) do
  if VBT.items[id] then VBT.items[id].unique=true end
end

for _, id in ipairs({12784,18538,19323}) do
  if VBT.items[id] then
    VBT.items[id].twoHanded=true
    VBT.items[id].requiresTalent="Two-Handed Axes and Maces"
    VBT.items[id].requiresTalentTree=2
  end
end

-- Profession/quest/race requirements may be added independently of the rank.
-- Missing requirements metadata must not be interpreted as proof of eligibility.
