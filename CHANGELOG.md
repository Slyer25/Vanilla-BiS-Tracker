# Changelog

## 0.2.1 — Fix item-source UI crash
- Fix a name collision where the source description overwrote its FontString UI control, causing UI.lua:134 to attempt SetText on a string.
- Preserve the original source widget and store item acquisition text separately as itemSource.
- Add a mocked Lua UI test covering all seven progression phases, equipment slots and both initial specializations.

## 0.2.0 — First curated gear candidates and progression filtering
- Add 26 cross-checked original Vanilla item IDs with dungeon/crafted/MC/Onyxia/Dire Maul/PvP/BWL sources.
- First partial Combat Rogue and Enhancement Shaman PvE shortlists; PvP remains opt-in and phase-gated.
- Preserve earlier candidates in later phases and exclude future-phase items.
- Add paged item candidates, source notes, hover tooltips and improved opaque background.
- Add cited item source inventory and clear warning that a shortlist is not a fully simulated BiS set.
- Add executable Lua data regression tests and Lua syntax compilation to GitHub Actions.


## 0.1.3 — Specialization refresh on open
- Re-read the player talent-tree points whenever /bis or /vbt opens the window.
- Preserve the last valid detected specialization if the 1.12 client temporarily returns zero talent points.
- Keep /bis talents as an optional diagnostic tool.

## 0.1.2 — Loading diagnostics
- Register /bis and /vbt from a minimal bootstrap loaded before the main addon.
- Add /vbtstatus to distinguish missing installation from a broken addon initialization.
- Preserve bootstrap state in Core.lua and expose successful initialization status.
- Document the correct install-ready ZIP folder layout.

## 0.1.1 — Talent detection and easier downloads
- Read talent points from original Vanilla 1.12 GetTalentTabInfo third return value.
- Refresh specialization after talent/spell changes, display auto/manual state, and fix manual spec cycling.
- Add /bis talents diagnostics.
- Configure prerelease publication automatically when a new version reaches main.


## 0.1.0 — Foundation
- Vanilla 1.12 TOC, slash commands, character/faction/race and talent tree inference.
- Phase and optional PvP gating, specialization override, per-character and shared settings.
- UI scaffold with gear slots and no unverified recommendations.
- Automated static checks, reproducible install-ready ZIP, GitHub Actions workflow.
