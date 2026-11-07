#!/usr/bin/env python3
"""Extract current TOC version section from changelog for GitHub Releases."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
toc = (root / 'VanillaBiSTracker/VanillaBiSTracker.toc').read_text(encoding='utf-8-sig')
version = re.search(r'^## Version:\s*(\S+)', toc, re.M).group(1)
changelog = (root / 'CHANGELOG.md').read_text(encoding='utf-8')
match = re.search(r'^##\s+(?:v)?' + re.escape(version) + r'\b[^\n]*\n(.*?)(?=^##\s|\Z)', changelog, re.M | re.S)
if not match:
    raise SystemExit('Missing CHANGELOG.md section for ' + version)
notes = match.group(1).strip()
if not notes:
    raise SystemExit('Empty changelog section for ' + version)
dist = root / 'dist'
dist.mkdir(exist_ok=True)
(dist / 'release-notes.md').write_text('**Foundation prerelease — not yet verified in a 1.12 client.**\n\n' + notes + '\n', encoding='utf-8')
print(dist / 'release-notes.md')
