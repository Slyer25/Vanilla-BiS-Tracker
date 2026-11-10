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
verified(16710,"dungeon","Scholomance / Stratholme / Blackrock Spire","Several elite trash mobs and Instructor Malicia",nil,"https://www.wowhead.com/classic/item=16710")
verified(16713,"dungeon","Blackrock Spire","Blackhand Assassin, Smolderthorn Shadow Hunter and several other elites",nil,"https://www.wowhead.com/classic/item=16713")
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

-- Source review batch: original Classic sources cross-checked independently.
verified(16708,"dungeon","Stratholme","Cannon Master Willey",nil,"https://classicdb.ch/?item=16708")
verified(16709,"dungeon","Stratholme","Baron Rivendare",nil,"https://classicdb.ch/?item=16709")
verified(16711,"dungeon","Scholomance","Rattlegore",nil,"https://classicdb.ch/?item=16711")
verified(16721,"dungeon","Upper Blackrock Spire","General Drakkisath",nil,"https://classicdb.ch/?item=16721")
verified(18506,"craft","Leatherworking","Pattern: Mongoose Boots","Pattern obtained from Knot Thimblejack's Cache in Dire Maul after Free Knot!; Leatherworking 300; requires 12 Rugged Leather, 6 Essence of Air, 4 Black Diamond, 2 Cured Rugged Hide, 4 Rune Thread","https://www.wowhead.com/classic/item=18515")
verified(18393,"dungeon","Dire Maul West","Tendris Warpwood",nil,"https://classicdb.ch/?item=18393")
verified(19146,"raid","Molten Core","Lucifron / Gehennas / Shazzrah / Sulfuron Harbinger","Drops from these four Flamewaker bosses, not general trash","https://classicdb.ch/?item=19146")
verified(19436,"raid-trash","Blackwing Lair","Death Talon Captain / Seether / Flamescale / Wyrmkin","Raid trash drop, not a boss drop","https://warcraft.wiki.gg/wiki/Cloak_of_Draconic_Might")
verified(19406,"raid","Blackwing Lair","Ebonroc",nil,"https://classicdb.ch/?item=19406")
verified(14637,"dungeon","Scholomance","Lord Alexei Barov / Lorekeeper Polkelt / The Ravenian / Instructor Malicia / Lady Illucia Barov / Doctor Theolen Krastinov","Multiple Scholomance bosses have this item","https://classicdb.ch/?item=14637")
verified(14616,"dungeon","Scholomance","Lord Alexei Barov / Lorekeeper Polkelt / The Ravenian / Instructor Malicia / Lady Illucia Barov / Doctor Theolen Krastinov","Multiple Scholomance bosses have this item","https://classicdb.ch/?item=14616")
verified(11726,"dungeon","Blackrock Depths","Gorosh the Dervish","Random Ring of Law arena boss; only available when Gorosh spawns","https://classicdb.ch/?item=11726")
verified(18500,"dungeon-cache","Dire Maul North","Gordok Tribute chest","Tribute run; requires preserving guards to access the tribute reward","https://classicdb.ch/?item=18500")
verified(18404,"quest","Onyxia's Lair / capital city quest","Head of Onyxia turn-in","Choose Onyxia Tooth Pendant as a quest reward after turning in Head of Onyxia","https://classicdb.ch/?item=18404")
verified(15411,"quest","Western Plaguelands","In Dreams","Tirion Fordring quest chain; choose Mark of Fordring as reward","https://classicdb.ch/?item=15411")
verified(13404,"dungeon","Stratholme","The Unforgiven",nil,"https://classicdb.ch/?item=13404")
verified(17713,"dungeon","Maraudon","Princess Theradras",nil,"https://classicdb.ch/?item=17713")
verified(13340,"dungeon","Stratholme","Baron Rivendare",nil,"https://classicdb.ch/?item=13340")
verified(12651,"dungeon","Lower Blackrock Spire","Shadow Hunter Vosh'gajin",nil,"https://classicdb.ch/?item=12651")
verified(18374,"dungeon","Dire Maul West","Magister Kalendris",nil,"https://classicdb.ch/?item=18374")
verified(19352,"raid","Blackwing Lair","Chromaggus",nil,"https://classicdb.ch/?item=19352")

-- Final initial-catalog source-review batch: encounter drops and crafting recipes.
verified(16905,"raid","Blackwing Lair","Nefarian",nil,"https://classicdb.ch/?itemset=213")
verified(16911,"raid","Blackwing Lair","Razorgore the Untamed",nil,"https://classicdb.ch/?item=16911")
verified(16910,"raid","Blackwing Lair","Vaelastrasz the Corrupt",nil,"https://classicdb.ch/?item=16910")
verified(16909,"raid","Molten Core","Ragnaros",nil,"https://www.wowhead.com/classic/item=16909")
verified(16906,"raid","Blackwing Lair","Broodlord Lashlayer",nil,"https://classicdb.ch/?npc=12017")
verified(17075,"raid","Onyxia's Lair","Onyxia",nil,"https://classicdb.ch/?item=17075")
verified(18832,"raid","Molten Core","Garr",nil,"https://classicdb.ch/?item=18832")
verified(19351,"raid","Blackwing Lair","Broodlord Lashlayer",nil,"https://classicdb.ch/?item=19351")
verified(15052,"craft","Leatherworking","Black Dragonscale Leggings","Pattern: Black Dragonscale Leggings (15781) drops from Anvilrage Captain in Blackrock Depths; Dragonscale Leatherworking 300, requires 40 Rugged Leather, 60 Black Dragonscale, 4 Enchanted Leather, 1 Cured Rugged Hide and 2 Rune Thread","https://classicdb.ch/?item=15781")
verified(12784,"craft","Blacksmithing","Arcanite Reaper","Plans: Arcanite Reaper (12838) dropped by Bannok Grimaxe in Lower Blackrock Spire; Master Axesmith, Blacksmithing 300, requires 20 Arcanite Bars, 6 Enchanted Leather, 2 Dense Grinding Stones","https://classicdb.ch/?item=12838")
verified(12587,"dungeon","Upper Blackrock Spire","Warchief Rend Blackhand",nil,"https://warcraft.wiki.gg/wiki/Eye_of_Rend")
verified(15063,"craft","Leatherworking","Devilsaur Gauntlets","Pattern: Devilsaur Gauntlets (15758) sold by Nergal in Un'Goro Crater; Tribal Leatherworking 290, requires 30 Rugged Leather, 8 Devilsaur Leather, 1 Rune Thread","https://classicdb.ch/?item=15758")
verified(11815,"dungeon","Blackrock Depths","Emperor Dagran Thaurissan","Final 1.12 loot table; historical boss changes need patch-specific validation","https://classicdb.ch/?item=11815")
verified(13965,"quest","Upper Blackrock Spire","For The Horde! (Horde) / General Drakkisath's Demise (Alliance)","Choose Blackhand's Breadth from the faction-specific raid quest rewards","https://classicdb.ch/?item=13965")
verified(12940,"dungeon","Upper Blackrock Spire","Warchief Rend Blackhand","One part of Dal'Rend's Arms set, pair with Tribal Guardian","https://warcraft.wiki.gg/wiki/Dal%27Rend%27s_Sacred_Charge")
verified(12939,"dungeon","Upper Blackrock Spire","Warchief Rend Blackhand","One part of Dal'Rend's Arms set, pair with Sacred Charge","https://warcraft.wiki.gg/wiki/Dal%27Rend%27s_Tribal_Guardian")
verified(15051,"craft","Leatherworking","Black Dragonscale Shoulders","Pattern: Black Dragonscale Shoulders (15770) dropped by Anvilrage Marshal in Blackrock Depths; Dragonscale Leatherworking 300, requires 44 Rugged Leather, 45 Black Dragonscale, 2 Enchanted Leather, Cured Rugged Hide, Rune Thread","https://classicdb.ch/?item=15770")
verified(16823,"raid","Molten Core","Sulfuron Harbinger",nil,"https://classicdb.ch/?item=16823")
verified(16820,"raid","Molten Core","Golemagg the Incinerator",nil,"https://classicdb.ch/?item=16820")
verified(18817,"raid","Molten Core","Ragnaros",nil,"https://warcraft.wiki.gg/wiki/Crown_of_Destruction_(item)")
verified(18538,"dungeon-cache","Dire Maul North","Gordok Tribute chest","Tribute run: defeat King Gordok while preserving guards, then talk to Mizzle the Crafty to spawn chest","https://www.wowhead.com/classic/object=179564")
verified(19377,"raid","Blackwing Lair","Nefarian",nil,"https://warcraft.wiki.gg/wiki/Prestor%27s_Talisman_of_Connivery")
verified(19380,"raid","Blackwing Lair","Nefarian",nil,"https://www.wowhead.com/classic/item=19380")
