# Vanilla BiS Tracker — WoW 1.12

**v0.2.1 hotfix prerelease — v0.1.3 character detection was verified in-game; the new database and UI still need retesting after the item-source crash fix.** Independent from MTSL Zone Hunter.

A fully offline, original Vanilla 1.12 gear recommendation addon. Intended to use progressive content availability with final patch 1.12 item stats. v0.2.1 introduces a **partial, curated candidate list** for Combat Rogue and Enhancement Shaman (26 checked original Vanilla item IDs). It is not a complete BiS guide or an automatic gear optimizer. Recommendations use the final 1.12 items and progressive unlock stages; other class/spec slots remain unpopulated.

## Important: correct installation layout
Download **Vanilla-BiS-Tracker-0.2.1.zip** from the release's **Assets** section. Do not use GitHub's automatically generated *Source code (zip)* file as an installable addon. If using an Actions artifact, it is wrapped in an outer ZIP: open it and extract the *inner* `Vanilla-BiS-Tracker-0.2.1.zip`.

The directory must be exactly:

```text
<WoW 1.12>/Interface/AddOns/VanillaBiSTracker/VanillaBiSTracker.toc
<WoW 1.12>/Interface/AddOns/VanillaBiSTracker/Bootstrap.lua
<WoW 1.12>/Interface/AddOns/VanillaBiSTracker/Core.lua
<WoW 1.12>/Interface/AddOns/VanillaBiSTracker/UI.lua
<WoW 1.12>/Interface/AddOns/VanillaBiSTracker/data/Phases.lua
```

If `/bis` and `/vbt` do nothing, confirm *Vanilla BiS Tracker* is enabled in the character-select AddOns menu, quit and restart the game, then try **`/vbtstatus`**. If that command is also unknown, the game is not loading even the bootstrap (most likely wrong folder nesting, disabled addon or wrong game client). If it says core or UI is not loaded, capture the Lua error from the game. If initialized is no, capture the initialization error. Never delete your `WTF` folder to install the addon.

## Test feedback
A Rogue test on original Vanilla 1.12 confirmed `/bis talents` correctly reads Assassination 16 / Combat 32 / Subtlety 3 and selects Combat; the initial UI opening had shown Unknown. In 0.2.1, the default UI command refreshes character/talent information before showing the window. Retest automatic selection after login without issuing `/bis talents` first.

## Installation
Download the **install-ready** ZIP from GitHub Actions (`Vanilla-BiS-Tracker-install-ready` artifact), or from a published prerelease, extract its `VanillaBiSTracker/` directory directly into `Interface/AddOns/`, then enable it at the character selection screen. The original 1.12 client is the target (TOC `11200`).

Commands: `/vbtstatus` for loading diagnostics; `/bis` or `/vbt` to toggle; `/bis pvp` to toggle PvP inclusion; `/bis phase 1` through `/bis phase 7`; `/bis auto` clears character-specific specialization override; `/bis talents` shows talent-tree points and detected specialization. Inside the UI, click `Spec` to cycle between automatic and manual specialization selection.

## Scope / limits
- Real Vanilla Lua 5.0 and API assumptions; no modern Classic APIs. No SoD/custom private server item data.
- Phase order: pre-raid launch; MC/Onyxia; Dire Maul and world bosses; BWL; ZG; AQ; Naxx. Sub-patch content, Battleground releases, PvP Rank rewards, quests, and reputations require a more granular schedule before data import.
- Talent specialization is inferred from points spent per tree, not an official 1.12 specialization API. Hybrid builds may require a manual selection.
- The initial curated list is deliberately incomplete. Gear candidates, source notes, item tooltips and pagination are implemented. Bag/equipped detection, unique-equipped conflict handling and simmed/set-aware optimization are future work. See [item sources](docs/DATA_SOURCES.md).
- Automated static checks, Lua syntax compilation and a mocked Lua data-filter test run in GitHub Actions; manual in-game checks remain mandatory.

## Developer build
`python3 scripts/check.py && lua5.1 scripts/test_data.lua && python3 scripts/package.py && python3 scripts/release_notes.py`

GitHub Actions validates on pushes and pull requests and creates an install-ready artifact. On pushes to `main`, when the TOC version has a matching changelog section and no release tag exists yet, GitHub Actions creates a **prerelease** `v<TOC version>` with the install-ready ZIP and notes. Unchanged versions do not publish again. A manual workflow dispatch can also publish the current version using the `publish_release` option. This workflow never overwrites an existing version. A prerelease is not a claim of in-game validation. See `CONTRIBUTING.md` for the development process. Adapted from the packaging approach in `Slyer25/MTSL-Zone-Hunter`.

Reference guides for future curated item import: [Zockify](https://www.zockify.com/classic/shaman/enhancement/) and [WoWisClassic](https://www.wowisclassic.com/en/best-in-slot/). These are research sources, not bundled content.

## User test feedback\nThe v0.1.0 tester confirmed no Lua errors with basic interface, phase and manual specialization changes; auto spec detection did not work. The 0.2.1 fix uses GetTalentTabInfo on the 1.12 client and is awaiting retest.\n\n## v0.2.1 user testing
After installing the new release ZIP, test `/bis` on the previously validated Combat Rogue and compare Pre-Raid, MC, Dire Maul and BWL stages. Verify that `Truestrike Shoulders` appears at Pre-Raid, `Nightslayer Shoulder Pads` first appears at MC, `Tarnished Elven Ring` first appears at Dire Maul, and `Drake Fang Talisman` first appears at BWL. Verify the PvP toggle adds/removes `Don Julio's Band` from the Dire Maul stage onwards. Mouse over item candidates for tooltips; click a candidate to print its source. Other specs may remain empty at this stage.\n\n## Planned milestones
1. Test the foundation UI in an original 1.12 client; fix any UI/Lua issues.
2. Refine the simplified seven-stage model into a patch-granular content unlock table (including battleground, profession, quest, reputation and world boss unlocks).
3. Expand and validate Shaman Enhancement and Combat Rogue pre-raid/MC/BWL recommendations beyond the initial shortlist, with precise item IDs, sources and set-aware alternatives.
4. Expand class/spec coverage and automate data audits before any recommendation release.

Partial candidate data for Combat Rogue and Enhancement Shaman is available. **v0.2.1 has not yet been tested in-game.**
