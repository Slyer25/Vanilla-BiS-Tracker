local VBT = VanillaBiSTracker
-- First curated ORIGINAL Vanilla item shortlist, with final 1.12 stats supplied by the game client.
-- Numbers are original item IDs, not SoD/reissued identifiers.
-- 'phase' refers to this addon's chronological progression stage, NOT the content-phase
-- number printed by external databases (whose schedules may differ).
-- 'pvp' is a separate option; PvP equipment still obeys availability gating.
-- Sources/justification: see docs/DATA_SOURCES.md.
VBT.items = {
  [13404]={id=13404,name="Mask of the Unforgiven",slot="Head",phase=1,source="Stratholme",boss="The Unforgiven"},
  [12587]={id=12587,name="Eye of Rend",slot="Head",phase=1,source="Upper Blackrock Spire",boss="Warchief Rend Blackhand"},
  [15411]={id=15411,name="Mark of Fordring",slot="Neck",phase=1,source="Quest: In Dreams",boss="Tirion Fordring quest chain"},
  [12927]={id=12927,name="Truestrike Shoulders",slot="Shoulders",phase=1,source="Upper Blackrock Spire",boss="Pyroguard Emberseer"},
  [13340]={id=13340,name="Cape of the Black Baron",slot="Back",phase=1,source="Stratholme",boss="Baron Rivendare"},
  [14637]={id=14637,name="Cadaverous Armor",slot="Chest",phase=1,source="Scholomance",boss="Scholomance minibosses"},
  [15063]={id=15063,name="Devilsaur Gauntlets",slot="Hands",phase=1,source="Leatherworking",boss="Tribal Leatherworking; two-piece set"},
  [15062]={id=15062,name="Devilsaur Leggings",slot="Legs",phase=1,source="Leatherworking",boss="Tribal Leatherworking; two-piece set"},
  [17713]={id=17713,name="Blackstone Ring",slot="Finger",phase=1,source="Maraudon",boss="Princess Theradras"},
  [11815]={id=11815,name="Hand of Justice",slot="Trinket",phase=1,source="Blackrock Depths",boss="Emperor Dagran Thaurissan (1.12 loot)"},
  [13965]={id=13965,name="Blackhand's Breadth",slot="Trinket",phase=1,source="Quest: UBRS",boss="For The Horde! / General Drakkisath's Demise"},
  [12940]={id=12940,name="Dal'Rend's Sacred Charge",slot="Main Hand",phase=1,source="Upper Blackrock Spire",boss="Warchief Rend Blackhand; sword set"},
  [12939]={id=12939,name="Dal'Rend's Tribal Guardian",slot="Off Hand",phase=1,source="Upper Blackrock Spire",boss="Warchief Rend Blackhand; sword set"},
  [15051]={id=15051,name="Black Dragonscale Shoulders",slot="Shoulders",phase=1,source="Leatherworking",boss="Black Dragon Mail set bonus"},
  [16823]={id=16823,name="Nightslayer Shoulder Pads",slot="Shoulders",phase=2,source="Molten Core",boss="Sulfuron Harbinger",class="ROGUE"},
  [16820]={id=16820,name="Nightslayer Chestpiece",slot="Chest",phase=2,source="Molten Core",boss="Golemagg the Incinerator",class="ROGUE"},
  [18404]={id=18404,name="Onyxia Tooth Pendant",slot="Neck",phase=2,source="Onyxia",boss="Head of Onyxia quest reward"},
  [18812]={id=18812,name="Wristguards of True Flight",slot="Wrists",phase=2,source="Molten Core",boss="Molten Core trash"},
  [18817]={id=18817,name="Crown of Destruction",slot="Head",phase=2,source="Molten Core",boss="Ragnaros"},
  [18500]={id=18500,name="Tarnished Elven Ring",slot="Finger",phase=3,source="Dire Maul North",boss="Gordok Tribute"},
  [18538]={id=18538,name="Treant's Bane",slot="Main Hand",phase=3,source="Dire Maul North",boss="Gordok Tribute; two-handed axe"},
  [19325]={id=19325,name="Don Julio's Band",slot="Finger",phase=3,source="Alterac Valley",boss="Exalted reputation",pvp=true},
  [19377]={id=19377,name="Prestor's Talisman of Connivery",slot="Neck",phase=4,source="Blackwing Lair",boss="Nefarian"},
  [19406]={id=19406,name="Drake Fang Talisman",slot="Trinket",phase=4,source="Blackwing Lair",boss="Ebonroc"},
  [19380]={id=19380,name="Therazane's Link",slot="Waist",phase=4,source="Blackwing Lair",boss="Nefarian"},
  [19436]={id=19436,name="Cloak of Draconic Might",slot="Back",phase=4,source="Blackwing Lair",boss="Multiple bosses"},
}
-- Recommendations are curated *candidates*, not a complete simmed BiS solution.
-- rank determines display order among currently available candidates; independent
-- items and 2-piece set bonuses must be evaluated in the context of the full loadout.
-- In this first batch, only slots with checked item IDs are populated.
VBT.recommendations = {
  ["ROGUE:Combat"] = {
    ["Head"]={{id=13404,rank=1},{id=12587,rank=2}},
    ["Neck"]={{id=18404,rank=1},{id=19377,rank=1},{id=15411,rank=3}},
    ["Shoulders"]={{id=16823,rank=1},{id=12927,rank=2}},
    ["Back"]={{id=19436,rank=1},{id=13340,rank=2}},
    ["Chest"]={{id=16820,rank=1},{id=14637,rank=2}},
    ["Hands"]={{id=15063,rank=1,note="Pair with Devilsaur Leggings for +2% hit."}},
    ["Legs"]={{id=15062,rank=1,note="Pair with Devilsaur Gauntlets for +2% hit."}},
    ["Ring 1"]={{id=19325,rank=1},{id=18500,rank=2},{id=17713,rank=3}},
    ["Ring 2"]={{id=19325,rank=1},{id=18500,rank=2},{id=17713,rank=3}},
    ["Trinket 1"]={{id=19406,rank=1},{id=11815,rank=2},{id=13965,rank=3}},
    ["Trinket 2"]={{id=19406,rank=1},{id=11815,rank=2},{id=13965,rank=3}},
    ["Main Hand"]={{id=12940,rank=1,note="Sword build, pairs with Dal'Rend's Tribal Guardian."}},
    ["Off Hand"]={{id=12939,rank=1,note="Pairs with Sacred Charge for +50 AP."}},
  },
  ["SHAMAN:Enhancement"] = {
    ["Head"]={{id=18817,rank=1},{id=12587,rank=2}},
    ["Neck"]={{id=19377,rank=1},{id=18404,rank=2},{id=15411,rank=3}},
    ["Shoulders"]={{id=15051,rank=1,note="Value depends on Black Dragon Mail pieces."}},
    ["Back"]={{id=19436,rank=1},{id=13340,rank=2}},
    ["Wrists"]={{id=18812,rank=1}},
    ["Hands"]={{id=15063,rank=1,note="Requires Devilsaur Leggings for set hit bonus."}},
    ["Legs"]={{id=15062,rank=1,note="Requires Devilsaur Gauntlets for set hit bonus."}},
    ["Ring 1"]={{id=19325,rank=1},{id=18500,rank=2},{id=17713,rank=3}},
    ["Ring 2"]={{id=19325,rank=1},{id=18500,rank=2},{id=17713,rank=3}},
    ["Trinket 1"]={{id=19406,rank=1},{id=11815,rank=2},{id=13965,rank=3}},
    ["Trinket 2"]={{id=19406,rank=1},{id=11815,rank=2},{id=13965,rank=3}},
    ["Main Hand"]={{id=18538,rank=1,note="Requires the Enhancement Two-Handed Axes and Maces talent."}},
    ["Waist"]={{id=19380,rank=1}},
  },
}
