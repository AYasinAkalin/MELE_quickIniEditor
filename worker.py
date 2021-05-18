#!/usr/bin/env python
"""worker.py does the file modifications.
It reads modifications from ./MOD then modifies files at ./Temp.
Modified files will be moved to Mass Effect's
installation folder outside of this script's aspect."""

import sys
from pathlib import Path

assert sys.version_info >= (3, 5)

delim = ";;"


def makepathfromname(name):
    '''Creates corresponding file paths for given `.txt` file in MOD folder'''
    if (sys.version_info.minor >= 9):
        name = name.removeprefix('ModsTo').removesuffix('.txt')+'.ini'
    else:
        name = name.replace('ModsTo', '').replace('.txt', '.ini')

    if name[0:3] == "Coa":
        name = name.replace('Coa', '-_-_BIOGame_Config_')
        p = Path("./Temp") / "unpacked_coalescend" / name
    else:
        p = Path("./Temp") / name
    return p


def foldercrawl():
    foldercontents = []
    p = Path("./MOD")
    if not p.exists():
        return 1
    for child in p.iterdir():
        q = makepathfromname(child.name)
        modificationlist = []
        with child.open() as f:
            for line in f:
                vanillaString = line.split(delim)[0].strip()
                modString = line.split(delim)[1].strip()
                modificationlist.append((vanillaString, modString))
        if (len(modificationlist) > 0):
            foldercontents.append((q, modificationlist))
    return foldercontents


print("hello from python!✅❕❌")
mods = foldercrawl()
for m in mods:
    # DO WORK HERE
    pass
