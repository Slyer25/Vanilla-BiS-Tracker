#!/usr/bin/env python3
"""Static validation for original WoW Vanilla 1.12 addon and sources.

Lua syntax and gameplay mocks are validated separately by GitHub Actions.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "VanillaBiSTracker"
toc = (ADDON / "VanillaBiSTracker.toc").read_text(encoding="utf-8-sig")
assert re.search(r"^## Interface: 11200$", toc, re.M), "Wrong Vanilla client interface"

paths = []
for line in toc.splitlines():
    if line.strip() and not line.startswith("##"):
        p = ADDON / line.replace("\\", "/")
        assert p.is_file(), f"Missing TOC file: {p}"
        paths.append(p)
assert len(paths) == len(set(paths)), "Duplicated TOC paths"
assert [p.name for p in paths] == [
    "Bootstrap.lua", "Core.lua", "Phases.lua", "Recommendations.lua",
    "GearRules.lua", "SourceAudit.lua", "GearEngine.lua", "UI.lua"
], "TOC loading order changed unexpectedly"

for path in ADDON.rglob("*.lua"):
    content = path.read_text()
    banned = [
        r"\bC_Item\.", r"\bC_Container\.", r"\bCreateFromMixins\b",
        r"\bGetSpecialization\s*\(", r"\btable\.unpack\b",
        r"\bstring\.gmatch\b"
    ]
    for pattern in banned:
        assert not re.search(pattern, content), f"Non-Vanilla API in {path}: {pattern}"
    assert not re.search(r"(?<!\w)#[A-Za-z_(]", content), f"Lua 5.1 length operator in {path}"

version_match = re.search(r"^## Version:\s*(\S+)$", toc, re.M)
assert version_match, "Missing TOC version"
version = version_match.group(1)
core = (ADDON / "Core.lua").read_text()
core_versions = [line for line in core.splitlines() if line.startswith("VBT.version = ")]
assert core_versions == ['VBT.version = "' + version + '"'], "Core/TOC versions must match"
assert "VBT:DetectCharacter(); VBT:ToggleUI()" in core, "Spec refresh was removed"
assert "PassesGearRequirements(item,slot)" in core, "Shared gear rules not connected"
changelog = (ROOT / "CHANGELOG.md").read_text()
assert re.search(r"^##\s+v?" + re.escape(version) + r"\b", changelog, re.M), "No changelog for version"

data = (ADDON / "data/Recommendations.lua").read_text()
rows = re.findall(
    r'^\s*\[(\d+)\]=\{id=(\d+),name="([^"]+)",slot="([^"]+)",phase=(\d+),source="([^"]+)"',
    data, re.M
)
assert len(rows) == 59, f"Unexpected catalog size: {len(rows)}"
assert len({r[0] for r in rows}) == len(rows), "Duplicate item IDs"
allowed_slots = {
    "Head", "Neck", "Shoulders", "Back", "Chest", "Wrists",
    "Hands", "Waist", "Legs", "Feet", "Finger", "Trinket",
    "Main Hand", "Off Hand", "Ranged"
}
slot_by_id = {}
phase_by_id = {}
for key, inner, name, slot, phase, source in rows:
    assert key == inner and int(key) > 0
    assert slot in allowed_slots and 1 <= int(phase) <= 7 and source.strip(), (key, name)
    slot_by_id[int(key)] = slot
    phase_by_id[int(key)] = int(phase)
assert phase_by_id[18506] == 3, "Mongoose Boots require Dire Maul pattern (phase 3)"
assert "pvp=true" in data
assert re.search(r"\[19323\].*pvp=true", data), "Alterac Valley weapon must be PvP-gated"

recs = re.findall(r"\{id=(\d+),rank=(\d+)", data)
assert len(recs) >= 90, "Recommendation entries missing"
for item_id, rank in recs:
    assert int(item_id) in slot_by_id and int(rank) >= 1, (item_id, rank)
slot_blocks = re.findall(r'^    \["([^"]+)"\]=(\{\{[^\n]+)', data, re.M)
assert len(slot_blocks) >= 25, "Slot recommendations missing"
for display_slot, line in slot_blocks:
    slot = "Finger" if display_slot.startswith("Ring ") else (
        "Trinket" if display_slot.startswith("Trinket ") else display_slot
    )
    for match in re.findall(r"\{id=(\d+),rank=", line):
        assert slot_by_id[int(match)] == slot, (display_slot, match)

audit = (ADDON / "data/SourceAudit.lua").read_text()
reviewed = [int(i) for i in re.findall(r"^verified\((\d+),", audit, re.M)]
assert len(reviewed) == len(set(reviewed)), "Duplicate source audits"
assert set(reviewed) == set(slot_by_id), "Every item needs an evidence-bearing acquisition record"
assert audit.count("https://") >= len(reviewed), "Insufficient source references"
assert 'item.sourceStatus="needs-review"' in audit, "Missing source confidence fallback"
assert "item.sourceRef=url" in audit, "Source references not attached to items"
assert re.search(r"^verified\(18506,", audit, re.M), "Mongoose Boots source not reviewed"
assert re.search(r"^verified\(19146,", audit, re.M), "Molten Core multi-boss item missing"
assert re.search(r"^verified\(19436,", audit, re.M), "BWL trash drop missing"

rules = (ADDON / "data/GearRules.lua").read_text()
assert "VBT.gearSets" in rules and "VBT.items[id].unique=true" in rules
assert "VBT.items[id].requiresTalent=" in rules
engine = (ADDON / "GearEngine.lua").read_text()
for name in ("GetWeaponBuild", "MeetsTalentRequirement", "PlanItem",
             "GetSetCounts", "GetPlanWarnings"):
    assert "function VBT:" + name in engine, name
bootstrap = (ADDON / "Bootstrap.lua").read_text()
assert "SLASH_VBTSTATUS1" in bootstrap, "Missing loading diagnostic"

print(f"PASS: Vanilla 1.12 TOC; {len(rows)} item IDs; {len(recs)} recommendations; "
      f"{len(reviewed)} reviewed sources; progression, slot, compatibility, and version checks")
