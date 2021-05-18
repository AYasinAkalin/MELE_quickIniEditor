#!/usr/bin/env python
"""quickIniEditor.py
Starting point of the program. Created for to be able to bundle the program."""
__version__ = "1.0"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-18"

import sys
import subprocess
from pathlib import Path

assert sys.version_info >= (3, 5)

licenseNotice = "\
MELE_quickIniEditor  Copyright (C) 2021  A. Yasin Akalın\n\
This program comes with ABSOLUTELY NO WARRANTY.\n\
This is free software, and you are welcome to modify it , redistribute it\n\
under certain conditions. Read LICENSE.txt for details.\n"

p = Path(".")  # Dummy variable so py2exe bundles pathlib
print(licenseNotice)
process = subprocess.run(["cli.bat"])
