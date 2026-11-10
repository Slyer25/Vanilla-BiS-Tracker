# Changelog

## 0.5.0 — Shared gear rules, loadout planning and source auditing
- Distinguish Combat Rogue Sword/Dagger weapon candidates using talent detection and a manual build override.
- Filter Enhancement Shaman two-handed axes and maces using the original talent when talent information is available.
- Add an optional per-character planned loadout, independent from obtained-item tracking.
- Prevent the same unique item being planned in two ring slots and automatically clear off-hand choices when a two-handed weapon is selected.
- Display relevant Devilsaur, Shadowcraft, Bloodfang, Black Dragon Mail and Dal'Rend set effects based on planned items; this is a set-awareness tool, not a damage simulator.
- Add structured acquisition-source records with links, acquisition types, and requirements. Unreviewed items are explicitly marked pending.
- Add original Vanilla raid daggers Perdition's Blade and Core Hound Tooth for Combat Daggers.
- Increase detail-panel height to fit source requirements and set-impact notes.
- Extend mock data and UI tests for new talent/build, set, unique-item, planning and source-audit behavior.
- Preserve original 1.12 Lua API compatibility, seven progression stages, and existing saved obtained/position data.


## 0.4.0 — Expanded Combat Rogue and Enhancement Shaman databases
- Expand the original Vanilla 1.12 candidate item database from 26 to 57 item IDs, with 88 ranked entries across Combat Rogue and Enhancement Shaman.
- Add Rogue Bloodfang items, raid sword upgrades, rings, pre-raid Shadowcraft alternatives, crafted/dungeon boots, and the MC ranged weapon.
- Add Shaman chest, waist, boots, bracers, two-handed weapons, Black Dragon Mail set pieces and alternatives.
- Keep prior candidates available in later progression stages; require PvP toggle for both Don Julio's Band and The Unstoppable Force.
- Save separately movable main/details window positions per character (no change to item ownership storage).
- Audit item references and slot compatibility; extend phase, PvP and UI position regression tests.
- Add the new item ID and source evidence to docs/DATA_SOURCES.md.
- Data remains a curated shortlist, not a simulated or comprehensive BiS optimizer; historical patch sub-phases need further research.


## 0.3.2 — Independently movable item details
- Reparent the details window to UIParent so it moves independently of the main tracker.
- Allow dragging the details frame to a preferred position without moving the main tracker.
- Open details as a separate window with a solid inset background and clearer border.
- Close detached details when the main tracker is closed, avoiding an orphaned window.
- Extend mock UI tests for independent parenting, drag handlers, and closing both windows.


## 0.3.1 — Frame and item-detail visual cleanup
- Remove the extra black background texture covering the main addon frame; tint the frame backdrop directly.
- Correct the details panel backdrop texture paths, and use a dark opaque tooltip-style background and clearly visible border.
- Raise detail panel above the main content while preserving Back and obtained tracking.
- Extend the mocked UI checks for backdrop methods and regressions.


## 0.3.0 — Interactive item details and obtained tracking
- Left-click a recommendation to open an in-addon acquisition panel with source, boss/requisite, earliest phase, notes and current obtained status.
- Right-click an item to mark it obtained or missing without removing it from the list.
- Store obtained state by item ID in SavedVariablesPerCharacter, so flags persist across sessions independently for each character.
- Display [Owned] on obtained candidates and permit marking items from the details panel.
- Preserve hover item tooltips and progression/PvP filters.
- Add mock UI regression coverage for details and per-character obtained toggles.


## 0.2.2 — Fix clicking item recommendations
- Fix UI.lua:89 error when clicking items: the click handler now reads itemSource rather than concatenating the source FontString widget.
- Item clicks print the item name, ID, and acquisition source to chat. Hover tooltips and progression filtering are unchanged.
- Expand mock UI regression tests to execute item click callbacks across every slot and progression phase.

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
