#!/usr/bin/env python
"""me2coa.py"""
__version__ = "1.1b"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-24"

from pathlib import Path
from gamelanguage import GameLang


def pick():
    gameInfo = GameLang()
    # print("Game language is:", gameInfo.getLanguage())
    p = Path("./Temp/")
    if not p.exists():
        p.mkdir()
        # print("Python created Temp folder because it wasn't there")
    with open(p / "_massEffectCoaSuffix.txt", "w") as f:
        f.write(gameInfo.getCoalescedSuffix())
    p = Path("./relpaths")
    with open(p / "_path_temp_coa2.txt", "w") as f:
        f.write(".\\Temp\\ME2\\Coalesced_"
                + gameInfo.getCoalescedSuffix()
                + ".bin")
