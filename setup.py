from distutils.core import setup
import glob
import py2exe


setup(
    console=["quickIniEditor.py"],
    data_files=[("helpers",glob.glob("helpers\\*.ps1")),
                ("helpers", glob.glob("helpers\\*.bat")),
                ("MOD", glob.glob("MOD\\*.txt")),
                ("examples", glob.glob("examples\\*.txt")),
                ("7zip", glob.glob("7zip\\*.txt")),
                ("7zip", glob.glob("7zip\\*.dll")),
                ("7zip", ["7zip\\7za.exe"]),
                ("7zip\\x64", glob.glob("7zip\\x64\\*.dll")),
                ("7zip\\x64", ["7zip\\x64\\7za.exe"]),
                ("7zip\\Far", glob.glob("7zip\\Far\\*.dll")),
                ("7zip\\Far", glob.glob("7zip\\Far\\*.hlf")),
                ("7zip\\Far", glob.glob("7zip\\Far\\*.lng")),
                ("7zip\\Far", ["7zip\\Far\\7zToFar.ini", "7zip\\Far\\far7z.reg", "7zip\\Far\\far7z.txt"]),
                ("LECoal", glob.glob("LECoal\\*.dll")),
                ("LECoal", ["LECoal\\LECoal.exe", "LECoal\\README.md", "LECoal\\LECoal.pdb"]),
                (".", ["LICENSE", "README.md", "constants.py", "editors.py", "worker.py"])],
)
