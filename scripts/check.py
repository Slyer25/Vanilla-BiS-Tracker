#!/usr/bin/env python3
"""Validate Vanilla 1.12 packaging and curated data. Lua execution is tested separately."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "VanillaBiSTracker"
toc = (ADDON / "VanillaBiSTracker.toc").read_text(encoding="utf-8-sig")
assert re.search(r"^## Interface: 11200$", toc, re.M)
paths = []
for line in toc.splitlines():
    if line.strip() and not line.startswith("##"):
        p = ADDON / line.replace(chr(92), "/")
        assert p.is_file(), f"Missing TOC file: {p}"
        paths.append(p)
assert len(paths) == len(set(paths)), "Repeated TOC paths"
assert [p.name for p in paths[:2]] == ["Bootstrap.lua", "Core.lua"]
assert [p.name for p in paths[3:8]] == ["Recommendations.lua","GearRules.lua","SourceAudit.lua","GearEngine.lua","UI.lua"], "Gear/source modules must load after items and before UI"

for path in ADDON.rglob("*.lua"):
    content = path.read_text()
    banned = [r"\bC_Item\.", r"\bC_Container\.", r"\bCreateFromMixins\b",
              r"\bGetSpecialization\s*\(", r"\btable\.unpack\b", r"\bstring\.gmatch\b"]
    for expr in banned:
        assert not re.search(expr, content), f"{path}: non-Vanilla API {expr}"
    assert not re.search(r"(?<!\w)#[A-Za-z_(]", content), f"{path}: Lua 5.1 length operator"

version = re.search(r"^## Version:\s*(\S+)", toc, re.M).group(1)
changelog = (ROOT / "CHANGELOG.md").read_text()
assert re.search(r"^##\s+v?" + re.escape(version) + r"\b", changelog, re.M)

data = (ADDON / "data/Recommendations.lua").read_text()
item_rows = re.findall(r"^\s*\[(\d+)\]=\{id=(\d+),name=\"([^\"]+)\",slot=\"([^\"]+)\",phase=(\d+),source=\"([^\"]+)\"", data, re.M)
assert len(item_rows) >= 20, "Curated data missing"
assert len(item_rows) == len(set(row[0] for row in item_rows)), "Duplicate item IDs"
allowed_slots = {"Head","Neck","Shoulders","Back","Chest","Wrists","Hands","Waist","Legs","Feet","Finger","Trinket","Main Hand","Off Hand","Ranged"}
phase = {}
slot_by_id = {}
for key, inner, name, slot, stage, source in item_rows:
    assert key == inner and int(key) > 0
    assert slot in allowed_slots, (name,slot)
    assert 1 <= int(stage) <= 7, (name, stage)
    assert source.strip()
    phase[int(key)] = int(stage)
    slot_by_id[int(key)] = slot
recs = re.findall(r"\{id=(\d+),rank=(\d+)", data)
assert recs
assert all(int(item_id) in phase and int(rank) >= 1 for item_id, rank in recs), "Bad recommendation reference"
# Each displayed recommendation must target the matching equipment slot.
# Ring/Trinket recommendations reuse the same item type in two UI slots.
slot_blocks = re.findall(r'^    \["([^"]+)"\]=(\{\{[^\n]+)', data, re.M)
assert len(slot_blocks) >= 25, "Missing class/spec slot recommendations"
for display_slot, line in slot_blocks:
    accepted = display_slot
    if display_slot.startswith("Ring "): accepted="Finger"
    if display_slot.startswith("Trinket "): accepted="Trinket"
    for rec_id in re.findall(r'\{id=(\d+),rank=', line):
        assert slot_by_id[int(rec_id)] == accepted, (
            display_slot, rec_id, slot_by_id[int(rec_id)])
assert len(item_rows) >= 59, "Expanded dataset missing"
assert "pvp=true" in data, "PvP filtering lacks any example item"
assert re.search(r'\[19323\].*pvp=true',data), "Alterac Valley weapon must require PvP toggle"
# Validate structural source-review inventory before introducing later raid phases.
audit=(ADDON / "data/SourceAudit.lua").read_text()
reviewed=re.findall(r'^verified\((\d+),',audit,re.M)
assert len(reviewed)==len(set(reviewed)), "Duplicate reviewed source ID"
assert len(reviewed)>=36, "Reviewed acquisition records missing"
assert all(int(i) in slot_by_id for i in reviewed), "Audit references missing item IDs"
assert audit.count('https://') >= len(reviewed), "Not enough evidence links for reviewed items"
assert re.search(r'^verified\(18506,', audit, re.M), "Missing verified Dire Maul crafting source"
assert 'item.sourceStatus="needs-review"' in audit, "Missing default source confidence status"
assert 'item.sourceRef=url' in audit, "Missing source evidence references"
rules=(ADDON / "data/GearRules.lua").read_text()
assert 'VBT.gearSets' in rules, "Missing set-bonus metadata"
assert 'VBT.items[id].requiresTalent=' in rules, "Missing two-handed talent metadata"
assert 'VBT.items[id].unique=true' in rules, "Missing unique-item metadata"
engine=(ADDON / "GearEngine.lua").read_text()
for fn in ['GetWeaponBuild','MeetsTalentRequirement','PlanItem','GetSetCounts','GetPlanWarnings']:
    assert ('function VBT:'+fn) in engine, f"Shared gear function missing: {fn}"
assert 'PassesGearRequirements(item,slot)' in (ADDON / "Core.lua").read_text()
assert "SLASH_VBTSTATUS1" in (ADDON / "Bootstrap.lua").read_text()
core = (ADDON / "Core.lua").read_text()
assert "VBT:DetectCharacter(); VBT:ToggleUI()" in core, "Lost tested auto-spec refresh"
print(f"PASS: TOC paths, Vanilla checks, release notes, {len(item_rows)} item IDs, {len(recs)} recommendations, slot compatibility, {len(reviewed)} reviewed sources")
