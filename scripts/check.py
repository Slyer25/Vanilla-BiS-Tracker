#!/usr/bin/env python3
"""Vanilla 1.12-oriented static checks, not an in-game execution test."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
ADDON=ROOT/'VanillaBiSTracker'
toc=(ADDON/'VanillaBiSTracker.toc').read_text(encoding='utf-8-sig')
assert re.search(r'^## Interface: 11200$',toc,re.M)
paths=[]
for line in toc.splitlines():
    if line.strip() and not line.startswith('##'):
        p=ADDON/line.replace('\\','/'); assert p.is_file(),str(p);paths.append(p)
assert len(paths)==len(set(paths))
assert paths[0].name == 'Bootstrap.lua', 'Bootstrap.lua must load first'
assert paths[1].name == 'Core.lua', 'Core.lua must load after bootstrap'
for path in ADDON.rglob('*.lua'):
    content=path.read_text()
    blocked=[r'\bC_Item\.', r'\bC_Container\.', r'\bCreateFromMixins\b', r'\bRegisterAddonMessagePrefix\b',r'\bGetSpecialization\s*\(',r'\bSetScript\s*\([^,]+,\s*function\s*\(self\s*,',r'\btable\.unpack\b',r'\bstring\.gmatch\b',r'\bselect\s*\(']
    for pattern in blocked:
        assert not re.search(pattern,content),f'{path}: forbidden modern API/idiom: {pattern}'
    assert not re.search(r'(?<!\w)#[A-Za-z_(]',content),f'{path}: Lua 5.1 length operator'
    assert not re.search(r'\b(?:goto|continue)\b',content),f'{path}: unsupported keyword'
items=(ADDON/'data/Recommendations.lua').read_text()
assert 'VBT.items = {}' in items and 'VBT.recommendations = {}' in items
version=re.search(r'^## Version:\s*(\S+)',toc,re.M).group(1)
changelog=(ROOT/'CHANGELOG.md').read_text()
assert re.search(r'^##\s+v?' + re.escape(version) + r'\b',changelog,re.M), 'Missing current release heading'
bootstrap=(ADDON/'Bootstrap.lua').read_text()
assert 'SLASH_VBT1' in bootstrap and 'SLASH_VBT2' in bootstrap and 'SLASH_VBTSTATUS1' in bootstrap
assert 'commandReady' in bootstrap
core=(ADDON/'Core.lua').read_text()
assert 'function VBT:HandleCommand' in core and 'VBT.commandReady = true' in core
assert r')\\ndriver:' not in core and r'\\n  elseif' not in core, 'Literal backslash-n in executable Lua'
print('PASS: TOC paths, Lua sanity, release heading, vanilla static API checks, empty verified database')
