# Acquisition source audit — v0.5.1

## Scope and interpretation

The addon contains **59 unique original Vanilla item IDs** (from v0.4.0's 57 plus Perdition's Blade and Core Hound Tooth). Every item has a nonempty `source` entry and a basic `boss` or acquisition label, but this is **not the same as confirming its exact source**.

`data/SourceAudit.lua` currently makes source confidence explicit:
- **59 reviewed source records** have an identified acquisition type, acquisition reference, and a WoW Classic source link.
- **0 catalog items** remain without a reviewed acquisition record. All 59 item IDs have an acquisition type, source reference and requirements where applicable.
- Earliest historical patch availability is a separate question: a reviewed source is **not** a guarantee that the item existed or dropped from that source in every Vanilla patch.

**Do not interpret source review as BiS-ranking validation.** Item rankings still depend on an actual build and potentially on gear combinations; the planning engine does not simulate DPS.

## Acquisition records currently cross-checked

| Item ID | Item | Acquisition / source | Reference |
|---:|---|---|---|
| 16908 | Bloodfang Hood | Onyxia, Onyxia's Lair | https://www.wowhead.com/classic/item=16908 |
| 17063 | Band of Accuria | Ragnaros, Molten Core | https://www.wowhead.com/classic/item=17063 |
| 18816 | Perdition's Blade | Ragnaros, Molten Core | https://www.wowhead.com/classic/item=18816 |
| 18805 | Core Hound Tooth | Majordomo Executus, Molten Core | https://www.wowhead.com/classic/item=18805 |
| 18812 | Wristguards of True Flight | Majordomo Executus, Molten Core | https://www.wowhead.com/classic/item=18812 |
| 17069 | Striker's Mark | Magmadar, Molten Core | https://www.wowhead.com/classic/item=17069 |
| 12927 | Truestrike Shoulders | Pyroguard Emberseer, UBRS | https://www.wowhead.com/classic/item=12927 |
| 16710 | Shadowcraft Bracers | Scholomance trash and bosses, including Instructor Malicia | https://www.wowhead.com/classic/item=16710 |
| 16713 | Shadowcraft Belt | Blackrock Spire mobs, including Quartermaster Zigris | https://www.wowhead.com/classic/item=16713 |
| 12553 | Swiftwalker Boots | Princess Moira Bronzebeard, BRD | https://classicdb.ch/?item=12553 |
| 19325 | Don Julio's Band | Alterac Valley reputation reward, Exalted | https://www.wowhead.com/classic/item=19325 |
| 15062 | Devilsaur Leggings | Leatherworking | https://www.wowhead.com/classic/item=15062 |
| 15050 | Black Dragonscale Breastplate | Leatherworking | https://www.wowhead.com/classic/item=15050 |
| 16984 | Black Dragonscale Boots | Leatherworking; Molten Core materials required | https://www.wowhead.com/classic/item=16984 |
| 19323 | The Unstoppable Force | Alterac Valley, Exalted reputation vendor; PvP toggle | https://www.wowhead.com/classic/item=19323 |

The item tooltip is the in-game reference for final Vanilla 1.12 stats; do not copy tooltip text from retail versions. For sets, validate against original Classic [Black Dragon Mail](https://www.wowhead.com/classic/item-set=489/black-dragon-mail) and [Bloodfang](https://www.wowhead.com/classic/item-set=213/bloodfang-armor) pages.

## Second source-verification batch: 21 additional items

Each reviewed entry is recorded in `data/SourceAudit.lua` with acquisition type, location, actor or container, and an evidence URL. The following were checked against original Classic records:

| Item IDs | Acquisition verification | Evidence |
|---|---|---|
| 16708, 16709, 16711, 16721 | Shadowcraft shoulders: Cannon Master Willey; pants: Baron Rivendare; boots: Rattlegore; tunic: General Drakkisath | [16708](https://classicdb.ch/?item=16708), [16709](https://classicdb.ch/?item=16709), [16711](https://classicdb.ch/?item=16711), [16721](https://classicdb.ch/?item=16721) |
| 18506 | Mongoose Boots require Leatherworking 300; the **pattern** comes from Knot Thimblejack's Cache in Dire Maul North (Free Knot!); **earliest addon stage corrected from 1 to 3** | [Pattern](https://classicdb.ch/?item=18515), [Cache](https://classicdb.ch/?object=179501) |
| 18393, 18500, 18374 | Warpwood Binding: Tendris Warpwood; Tarnished Elven Ring: Gordok Tribute cache; Flamescarred Shoulders: Magister Kalendris | [18393](https://classicdb.ch/?item=18393), [18500](https://classicdb.ch/?item=18500), [18374](https://classicdb.ch/?item=18374) |
| 19146 | Wristguards of Stability are a **four-boss Molten Core drop**, not generic MC trash | [19146](https://classicdb.ch/?item=19146) |
| 19436 | Cloak of Draconic Might drops from **Death Talon raid trash** in BWL, not an unspecified boss | [NPC](https://classicdb.ch/?npc=12467), [Classic history](https://warcraft.wiki.gg/wiki/Cloak_of_Draconic_Might) |
| 19406, 19352 | Drake Fang Talisman: Ebonroc; Chromatically Tempered Sword: Chromaggus | [19406](https://classicdb.ch/?item=19406), [19352](https://classicdb.ch/?item=19352) |
| 14637, 14616 | Cadaverous Armor and Bloodmail Boots are dropped by multiple Scholomance bosses | [14637](https://classicdb.ch/?item=14637), [14616](https://classicdb.ch/?item=14616) |
| 11726 | Savage Gladiator Chain drops from **Gorosh the Dervish**, the randomly selected Ring of Law arena boss | [11726](https://classicdb.ch/?item=11726) |
| 18404, 15411 | Onyxia Tooth Pendant: Head of Onyxia quest choice; Mark of Fordring: In Dreams quest choice | [18404](https://classicdb.ch/?item=18404), [15411](https://classicdb.ch/?item=15411) |
| 13404, 17713, 13340, 12651 | Mask: The Unforgiven; Blackstone Ring: Princess Theradras; Cape: Baron Rivendare; Blackcrow: Shadow Hunter Vosh'gajin | [13404](https://classicdb.ch/?item=13404), [17713](https://classicdb.ch/?item=17713), [13340](https://classicdb.ch/?item=13340), [12651](https://classicdb.ch/?item=12651) |

Existing source records for Shadowcraft Bracers (16710) and Belt (16713) were also corrected to document their **multiple eligible NPCs**, rather than suggesting one guaranteed boss.

These review statuses confirm acquisition evidence, **not exact earliest patch unlock** or whether the proposed item is optimal for a class/spec. Source verification and patch verification remain separate tasks.

## Final source-verification batch: remaining 23 catalog items

| Item IDs | Confirmed acquisition | Evidence |
|---|---|---|
| 16905, 16911, 16910, 16909, 16906 | Bloodfang chest: Nefarian; bracers: Razorgore; belt: Vaelastrasz; pants: Ragnaros; boots: Broodlord Lashlayer | [Bloodfang set](https://classicdb.ch/?itemset=213), [Belt](https://classicdb.ch/?item=16910), [Bracers](https://classicdb.ch/?item=16911), [Pants](https://www.wowhead.com/classic/item=16909), [Broodlord](https://classicdb.ch/?npc=12017) |
| 17075, 18832, 19351 | Vis'kag: Onyxia; Brutality Blade: Garr; Maladath: Broodlord Lashlayer | [17075](https://classicdb.ch/?item=17075), [18832](https://classicdb.ch/?item=18832), [19351](https://classicdb.ch/?item=19351) |
| 15052, 15051 | Black Dragonscale Leggings pattern: Anvilrage Captain; Shoulders pattern: Anvilrage Marshal; crafted by Dragonscale Leatherworker | [Leggings pattern](https://classicdb.ch/?item=15781), [Shoulders pattern](https://classicdb.ch/?item=15770) |
| 12784 | Arcanite Reaper: Master Axesmith 300; plans drop from Bannok Grimaxe | [Plans](https://classicdb.ch/?item=12838) |
| 15063 | Devilsaur Gauntlets: Tribal Leatherworking pattern sold by Nergal in Un'Goro Crater | [Pattern](https://classicdb.ch/?item=15758) |
| 12587, 12940, 12939 | Eye of Rend and both Dal'Rend swords: Warchief Rend Blackhand in UBRS | [Eye](https://warcraft.wiki.gg/wiki/Eye_of_Rend), [Sacred Charge](https://warcraft.wiki.gg/wiki/Dal%27Rend%27s_Sacred_Charge), [Tribal Guardian](https://warcraft.wiki.gg/wiki/Dal%27Rend%27s_Tribal_Guardian) |
| 11815 | Hand of Justice: Emperor Dagran Thaurissan in BRD (final 1.12 loot listing) | [11815](https://classicdb.ch/?item=11815) |
| 13965 | Blackhand's Breadth: choose reward from For The Horde! or General Drakkisath's Demise, depending on faction | [13965](https://classicdb.ch/?item=13965) |
| 16823, 16820 | Nightslayer shoulders: Sulfuron Harbinger; chest: Golemagg | [16823](https://classicdb.ch/?item=16823), [16820](https://classicdb.ch/?item=16820) |
| 18817 | Crown of Destruction: Ragnaros in Molten Core | [Classic source](https://warcraft.wiki.gg/wiki/Crown_of_Destruction_(item)) |
| 18538 | Treant's Bane: Gordok Tribute chest in Dire Maul North; more guards left alive improves tribute quality | [Gordok Tribute](https://www.wowhead.com/classic/object=179564) |
| 19377, 19380 | Prestor's Talisman and Therazane's Link: Nefarian in BWL | [Prestor](https://warcraft.wiki.gg/wiki/Prestor%27s_Talisman_of_Connivery), [Therazane](https://www.wowhead.com/classic/item=19380) |

The CI source-coverage test now requires **a distinct evidence-bearing acquisition record for every catalog item**. Do not conflate this check with independent historical patch validation.

## Known source questions / remaining work

- Original 2005–06 patch-specific unlock history for all 59 items, particularly changes to dungeon loot tables around patch 1.10.
- For crafted items, recipe vendor/drop/acquisition and specialist crafting requirements, not merely the crafting profession.
- Quest reward chains, faction or race requirements, and any cases where loot eligibility depends on prior quest choices.
- For raid items, exact boss drop versus cache/reward sources. **Wristguards of True Flight** was corrected from a generic trash source to Majordomo Executus; this is an important example of why the structured audit exists.
- Acquisition sources for the current 59 items have been reviewed. **Exact first-available patch and historical loot-table evolution remain a separate incomplete audit**; do not equate an item source with availability from launch.

## Data-entry contract for future items

Every item must have: `id`, `name`, `slot`, `phase`, `source`, and an acquisition label. Every new reviewed entry should also have `sourceType`, `sourceRef`, `acquisitionRequirement` (where applicable), and `sourceStatus`. Rank/role/build recommendations belong to the recommendation table and are **not evidence of an acquisition source**.

The source-audit file is loaded after the raw item table, allowing acquisition corrections without editing or duplicating the rankings. Reviewed source metadata overrides the legacy source fields at runtime.

## Next source-review order

The initial 59-item acquisition-source audit is complete. Before bulk ZG/AQ/Naxx imports, audit precise Vanilla patch unlocks and final-1.12-versus-original loot table transitions. New items must provide acquisition evidence at import time.
