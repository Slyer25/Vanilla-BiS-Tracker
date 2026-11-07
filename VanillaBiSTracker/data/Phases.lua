local VBT = VanillaBiSTracker
-- Phase unlocks are explicitly modeled, not inferred from item ID.
-- Final patch 1.12 item stats apply throughout, but content is phase-gated.
VBT.phases = {
  { id=1, name="Pre-Raid (launch)" },
  { id=2, name="Molten Core / Onyxia" },
  { id=3, name="Dire Maul / World Bosses" },
  { id=4, name="Blackwing Lair" },
  { id=5, name="Zul'Gurub / Arathi Basin" },
  { id=6, name="Ahn'Qiraj" },
  { id=7, name="Naxxramas" },
}
-- TODO: refine intermediate patch unlocks (e.g. 1.10, 1.11 rewards)
-- before importing any recommendations. PvP honor unlocks also need phases.
