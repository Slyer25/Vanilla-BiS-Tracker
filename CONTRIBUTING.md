# Development and data contribution rules

Target **original World of Warcraft Vanilla 1.12** (Interface 11200, Lua 5.0). Do not import Season of Discovery, Turtle WoW, Forever, or modern Classic-exclusive items or API calls.

## Recommendation validation

Every candidate BiS recommendation must have its original Vanilla item ID, slot, source, earliest content unlock/phase, role/class, and evidence for the ranking. Record faction, race, PvP and equip restrictions when applicable. Use final 1.12 item stats with **progressive historical content availability**. Do not equate the final 1.12 item DB with availability on launch day. Note disagreements among reference guides explicitly; no blind scraping of sites into recommendations.

Sources for research: Zockify, WoWisClassic, Wowhead (cross-check with original Vanilla data). Link back to sources in development notes; do not copy full guide text.

## Workflow

1. Implement small, independently testable steps. Update `CHANGELOG.md` and TOC version together.
2. Run `python3 scripts/check.py && python3 scripts/package.py && python3 scripts/release_notes.py`.
3. Test on an actual 1.12 client and record observations before marking a build tested.
4. Submit a PR for code/data changes; merge into main after checks.
5. GitHub Actions creates a **build artifact** on push to main. To publish a prerelease, open Actions -> `Validate and package Vanilla BiS Tracker` -> Run workflow (main) -> enable `publish_release`. The workflow creates `v<TOC version>` with ZIP and changelog notes and rejects reuse of an existing version.

Do not attach release builds of unsupported data or represent static checks as in-game testing.
