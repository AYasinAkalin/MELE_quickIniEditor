#!/usr/bin/env python
"""worker.py does the file modifications.
It reads modifications from ./MOD then modifies files at ./Temp.
Modified files will be moved to Mass Effect's
installation folder outside of this script's aspect."""
__version__ = "1.0"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-18"

import sys
from constants import modFileDelimiter as delim
from editors import Editor, EditorPlus
from pathlib import Path

assert sys.version_info >= (3, 5)


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
    '''Creates and Editor object for all files inside MOD folder.
    Returns a list of these Editor objects.'''
    foldercontents = []
    p = Path("./MOD")
    if not p.exists():
        return 1
    for child in p.iterdir():
        # file of editor(file, modificationlist) is found
        q = makepathfromname(child.name)
        modificationlist = []
        with child.open() as f:
            for line in f:
                vanillaString = line.split(delim)[0].strip()
                modString = line.split(delim)[1].strip()
                modificationlist.append((vanillaString, modString))
        if (len(modificationlist) > 0):
            foldercontents.append(Editor(q, modificationlist))
        # at this point modificationlist of editor(file, modificationlist) is found
    return foldercontents


# print("hello from python!✅❕❌")
if __name__ == '__main__':
    ''' __name__ == '__main__' check stops following code to execute
    when this file is called from another Python script'''
    ep = EditorPlus()
    mods = foldercrawl()
    for m in mods:
        ep.import_editor_info(m)
    ep.process_many()
