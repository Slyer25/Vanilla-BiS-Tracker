#!/usr/bin/env python3
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import re
ROOT=Path(__file__).resolve().parents[1]
ADDON=ROOT/'VanillaBiSTracker'
toc=(ADDON/'VanillaBiSTracker.toc').read_text()
version=re.search(r'^## Version:\s*(\S+)',toc,re.M).group(1)
dist=ROOT/'dist';dist.mkdir(exist_ok=True)
output=dist/f'Vanilla-BiS-Tracker-{version}.zip'
with ZipFile(output,'w',ZIP_DEFLATED,compresslevel=9) as z:
    for file in sorted(ADDON.rglob('*')):
        if file.is_file():z.write(file,file.relative_to(ROOT).as_posix())
with ZipFile(output) as z:
    assert z.testzip() is None
    assert 'VanillaBiSTracker/VanillaBiSTracker.toc' in z.namelist()
print(output)
