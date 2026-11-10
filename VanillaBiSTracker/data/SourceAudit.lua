-- Acquisition facts audited separately from recommendations.
-- Unreviewed entries remain visible with an explicit uncertainty indicator.
-- Item IDs can have valid stats but historically different unlock/drop tables.
local VBT=VanillaBiSTracker
for id,item in pairs(VBT.items) do
  item.sourceStatus="needs-review"
end
local function verified(id,kind,location,actor,requirement,url)
  local item=VBT.items[id]
  if not item then error("Acquisition audit references missing item "..id) end
  item.sourceStatus="verified"
  item.sourceType=kind
  item.source=location
  item.boss=actor
  item.acquisitionRequirement=requirement
  item.sourceRef=url
end
-- Evidence points to original WoW Classic item pages, not retail or custom servers.
verified(16908,"raid","Onyxia's Lair","Onyxia",nil,"https://www.wowhead.com/classic/item=16908")
verified(17063,"raid","Molten Core","Ragnaros",nil,"https://www.wowhead.com/classic/item=17063")
verified(18816,"raid","Molten Core","Ragnaros",nil,"https://www.wowhead.com/classic/item=18816")
verified(18805,"raid","Molten Core","Majordomo Executus",nil,"https://www.wowhead.com/classic/item=18805")
verified(18812,"raid","Molten Core","Majordomo Executus",nil,"https://www.wowhead.com/classic/item=18812")
verified(17069,"raid","Molten Core","Magmadar",nil,"https://www.wowhead.com/classic/item=17069")
verified(12927,"dungeon","Upper Blackrock Spire","Pyroguard Emberseer",nil,"https://www.wowhead.com/classic/item=12927")
verified(16710,"dungeon","Scholomance","Multiple mobs including Instructor Malicia",nil,"https://www.wowhead.com/classic/item=16710")
verified(16713,"dungeon","Blackrock Spire","Multiple mobs including Smolderthorn Shadow Hunter",nil,"https://www.wowhead.com/classic/item=16713")
verified(12553,"dungeon","Blackrock Depths","Princess Moira Bronzebeard",
  "Loot eligibility may vary with Princess Moira quest state; verify on original 1.12 client",
  "https://www.wowhead.com/classic/item=12553")
verified(19325,"reputation","Alterac Valley","Stormpike Guard / Frostwolf Clan",
  "Exalted; PvP rewards must be enabled","https://www.wowhead.com/classic/item=19325")
verified(15062,"craft","Leatherworking","Devilsaur Armor",
  "Pair with Devilsaur Gauntlets for +2% hit","https://www.wowhead.com/classic/item=15062")
verified(15050,"craft","Leatherworking","Black Dragon Mail",nil,"https://www.wowhead.com/classic/item=15050")
verified(16984,"craft","Leatherworking","Black Dragon Mail",
  "Raid materials required; available no earlier than Molten Core",
  "https://www.wowhead.com/classic/item=16984")
-- Additional source verification is tracked in docs/SOURCE_AUDIT.md.
-- Do not label the remaining records verified based only on a source string.

-- Original Classic records explicitly checked:
verified(19323,"reputation","Alterac Valley","Frostwolf Clan / Stormpike Guard",
  "Exalted reputation; PvP rewards toggle required",
  "https://www.wowhead.com/classic/item=19323")
verified(18805,"raid","Molten Core","Majordomo Executus",nil,
  "https://www.wowhead.com/classic/item=18805")
