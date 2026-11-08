# Vanilla BiS Tracker — WoW 1.12

**Foundation build 0.1.3 — prior 0.1.2 UI tested in-game; 0.1.3 awaiting retest.** Independent from MTSL Zone Hunter.

A fully offline, original Vanilla 1.12 gear recommendation addon. Intended to use progressive content availability with final patch 1.12 item stats. This first build supplies the working UI and filters **without a BiS database**: no gear is presented as verified yet.

## Important: correct installation layout
Download **Vanilla-BiS-Tracker-0.1.3.zip** from the release's **Assets** section. Do not use GitHub's automatically generated *Source code (zip)* file as an installable addon. If using an Actions artifact, it is wrapped in an outer ZIP: open it and extract the *inner* `Vanilla-BiS-Tracker-0.1.3.zip`.

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
A Rogue test on original Vanilla 1.12 confirmed `/bis talents` correctly reads Assassination 16 / Combat 32 / Subtlety 3 and selects Combat; the initial UI opening had shown Unknown. In 0.1.3, the default UI command refreshes character/talent information before showing the window. Retest automatic selection after login without issuing `/bis talents` first.

## Installation
Download the **install-ready** ZIP from GitHub Actions (`Vanilla-BiS-Tracker-install-ready` artifact), or from a published prerelease, extract its `VanillaBiSTracker/` directory directly into `Interface/AddOns/`, then enable it at the character selection screen. The original 1.12 client is the target (TOC `11200`).

Commands: `/vbtstatus` for loading diagnostics; `/bis` or `/vbt` to toggle; `/bis pvp` to toggle PvP inclusion; `/bis phase 1` through `/bis phase 7`; `/bis auto` clears character-specific specialization override; `/bis talents` shows talent-tree points and detected specialization. Inside the UI, click `Spec` to cycle between automatic and manual specialization selection.

## Scope / limits
- Real Vanilla Lua 5.0 and API assumptions; no modern Classic APIs. No SoD/custom private server item data.
- Phase order: pre-raid launch; MC/Onyxia; Dire Maul and world bosses; BWL; ZG; AQ; Naxx. Sub-patch content, Battleground releases, PvP Rank rewards, quests, and reputations require a more granular schedule before data import.
- Talent specialization is inferred from points spent per tree, not an official 1.12 specialization API. Hybrid builds may require a manual selection.
- Data files are empty pending item ID, availability, source and BiS validation. The UI is an initial foundation; tooltips, scroll/pagination, bag/equipped detection and alternate sets are follow-on work.
- Automated static sanity checks run without a game client; manual in-game checks remain mandatory.

## Developer build
`python3 scripts/check.py && python3 scripts/package.py && python3 scripts/release_notes.py`

GitHub Actions validates on pushes and pull requests and creates an install-ready artifact. On pushes to `main`, when the TOC version has a matching changelog section and no release tag exists yet, GitHub Actions creates a **prerelease** `v<TOC version>` with the install-ready ZIP and notes. Unchanged versions do not publish again. A manual workflow dispatch can also publish the current version using the `publish_release` option. This workflow never overwrites an existing version. A prerelease is not a claim of in-game validation. See `CONTRIBUTING.md` for the development process. Adapted from the packaging approach in `Slyer25/MTSL-Zone-Hunter`.

Reference guides for future curated item import: [Zockify](https://www.zockify.com/classic/shaman/enhancement/) and [WoWisClassic](https://www.wowisclassic.com/en/best-in-slot/). These are research sources, not bundled content.

## User test feedback\nThe v0.1.0 tester confirmed no Lua errors with basic interface, phase and manual specialization changes; auto spec detection did not work. The 0.1.3 fix uses GetTalentTabInfo on the 1.12 client and is awaiting retest.\n\n## Planned milestones
1. Test the foundation UI in an original 1.12 client; fix any UI/Lua issues.
2. Build a patch-granular content unlock table (including battleground, profession, quest, reputation and world boss unlocks).
3. Curate and validate Shaman Enhancement pre-raid/MC/BWL recommendations and alternatives with precise item IDs and sources.
4. Expand class/spec coverage and automate data audits before any recommendation release.

No BiS data have been imported yet, and no in-game compatibility claim is made for v0.1.3.
