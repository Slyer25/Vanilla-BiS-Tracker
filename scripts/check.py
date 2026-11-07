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
for path in ADDON.rglob('*.lua'):
    content=path.read_text()
    blocked=[r'\bC_Item\.', r'\bC_Container\.', r'\bCreateFromMixins\b', r'\bRegisterAddonMessagePrefix\b',r'\bGetSpecialization\s*\(',r'\bSetScript\s*\([^,]+,\s*function\s*\(self\s*,',r'\btable\.unpack\b',r'\bstring\.gmatch\b',r'\bselect\s*\(']
    for pattern in blocked:
        assert not re.search(pattern,content),f'{path}: forbidden modern API/idiom: {pattern}'
    assert not re.search(r'(?<!\w)#[A-Za-z_(]',content),f'{path}: Lua 5.1 length operator'
    assert not re.search(r'\b(?:goto|continue)\b',content),f'{path}: unsupported keyword'
items=(ADDON/'data/Recommendations.lua').read_text()
assert 'VBT.items = {}' in items and 'VBT.recommendations = {}' in items
print('PASS: TOC load paths, vanilla static API checks, empty unverified database')
