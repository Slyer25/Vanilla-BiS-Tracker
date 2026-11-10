# Acquisition source audit — v0.5.0

## Scope and interpretation

The addon contains **59 unique original Vanilla item IDs** (from v0.4.0's 57 plus Perdition's Blade and Core Hound Tooth). Every item has a nonempty `source` entry and a basic `boss` or acquisition label, but this is **not the same as confirming its exact source**.

`data/SourceAudit.lua` currently makes source confidence explicit:
- **15 reviewed source records** have an identified acquisition type, acquisition reference, and a WoW Classic source link.
- **44 source records** remain `needs-review`; their legacy source strings are displayed but the item detail window clearly warns that verification is pending.
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

## Known source questions / remaining work

- Original 2005–06 patch-specific unlock history for all 59 items, particularly changes to dungeon loot tables around patch 1.10.
- For crafted items, recipe vendor/drop/acquisition and specialist crafting requirements, not merely the crafting profession.
- Quest reward chains, faction or race requirements, and any cases where loot eligibility depends on prior quest choices.
- For raid items, exact boss drop versus cache/reward sources. **Wristguards of True Flight** was corrected from a generic trash source to Majordomo Executus; this is an important example of why the structured audit exists.
- The other 44 records need independent source links and a review before their status may be upgraded. They must not silently become `verified`.

## Data-entry contract for future items

Every item must have: `id`, `name`, `slot`, `phase`, `source`, and an acquisition label. Every new reviewed entry should also have `sourceType`, `sourceRef`, `acquisitionRequirement` (where applicable), and `sourceStatus`. Rank/role/build recommendations belong to the recommendation table and are **not evidence of an acquisition source**.

The source-audit file is loaded after the raw item table, allowing acquisition corrections without editing or duplicating the rankings. Reviewed source metadata overrides the legacy source fields at runtime.

## Next source-review order

Start with remaining raid drops and dungeon rewards used in the earliest stages, then work through crafted/quest and reputation rewards. Only after that review should bulk ZG/AQ/Naxx gear additions be treated as production-ready.
