# Vanilla BiS Tracker — WoW 1.12

**Foundation build 0.1.0 — not yet in-game tested.** Independent from MTSL Zone Hunter.

A fully offline, original Vanilla 1.12 gear recommendation addon. Intended to use progressive content availability with final patch 1.12 item stats. This first build supplies the working UI and filters **without a BiS database**: no gear is presented as verified yet.

## Installation
Download the **install-ready** ZIP from GitHub Actions (`Vanilla-BiS-Tracker-install-ready` artifact), or from a published prerelease, extract its `VanillaBiSTracker/` directory directly into `Interface/AddOns/`, then enable it at the character selection screen. The original 1.12 client is the target (TOC `11200`).

Commands: `/bis` or `/vbt` to toggle; `/bis pvp` to toggle PvP inclusion; `/bis phase 1` through `/bis phase 7`; `/bis auto` clears character-specific specialization override. Inside the UI, click `Spec` to cycle between automatic and manual specialization selection.

## Scope / limits
- Real Vanilla Lua 5.0 and API assumptions; no modern Classic APIs. No SoD/custom private server item data.
- Phase order: pre-raid launch; MC/Onyxia; Dire Maul and world bosses; BWL; ZG; AQ; Naxx. Sub-patch content, Battleground releases, PvP Rank rewards, quests, and reputations require a more granular schedule before data import.
- Talent specialization is inferred from points spent per tree, not an official 1.12 specialization API. Hybrid builds may require a manual selection.
- Data files are empty pending item ID, availability, source and BiS validation. The UI is an initial foundation; tooltips, scroll/pagination, bag/equipped detection and alternate sets are follow-on work.
- Automated static sanity checks run without a game client; manual in-game checks remain mandatory.

## Developer build
`python3 scripts/check.py && python3 scripts/package.py && python3 scripts/release_notes.py`

GitHub Actions validates on pushes and pull requests and creates an install-ready artifact. Releases are **explicitly opt-in**, so untested commits do not automatically become advertised releases: Actions → `Validate and package Vanilla BiS Tracker` → `Run workflow` on `main` → check `publish_release`. This creates a prerelease `v<TOC version>` with ZIP and notes from `CHANGELOG.md`. Version tags are not overwritten. See `CONTRIBUTING.md` for the development process. Adapted from the packaging approach in `Slyer25/MTSL-Zone-Hunter`.

Reference guides for future curated item import: [Zockify](https://www.zockify.com/classic/shaman/enhancement/) and [WoWisClassic](https://www.wowisclassic.com/en/best-in-slot/). These are research sources, not bundled content.

## Planned milestones
1. Test the foundation UI in an original 1.12 client; fix any UI/Lua issues.
2. Build a patch-granular content unlock table (including battleground, profession, quest, reputation and world boss unlocks).
3. Curate and validate Shaman Enhancement pre-raid/MC/BWL recommendations and alternatives with precise item IDs and sources.
4. Expand class/spec coverage and automate data audits before any recommendation release.

No BiS data have been imported yet, and no in-game compatibility claim is made for v0.1.0.
