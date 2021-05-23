#!/usr/bin/env python
"""quickIniEditor.py
Starting point of the program. Created for to be able to bundle the program."""
__version__ = "1.0"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-18"

import sys
from os import system
import subprocess
import worker
import colors
assert sys.version_info >= (3, 5)

licenseNotice = "\
MELE Quick Ini Editor  Copyright (C) 2021  A. Yasin Akalın\n\
This program comes with ABSOLUTELY NO WARRANTY.\n\
This is free software, and you are welcome to modify it, redistribute it\n\
under certain conditions. Read LICENSE.txt for details.\n"

print(licenseNotice)
process = subprocess.run([".\\helpers\\cli1.bat"])
if process.returncode != 0:
    exit()
try:
    worker.execute()
except (worker.ModFolderNotFoundError,
        worker.ModFolderIsCorruptedError) as e:
    print(colors.Style.RED + "Failure!" + colors.Style.RESET, end=' ')
    print(e)
    print("Press any key to exit...")
    system("pause >nul")
    exit()
except worker.NoModificationsMadeError as e:
    print(colors.Style.YELLOW + "Warning!" + colors.Style.RESET, end=' ')
    print(e)
    pass
process = subprocess.run([".\\helpers\\cli2.bat"])
