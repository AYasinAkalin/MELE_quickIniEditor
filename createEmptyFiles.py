'''Self working script to populate MOD folder'''
__version__ = "1.0.2"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-23"
from pathlib import Path

# Info: https://docs.python.org/3/library/pathlib.html#pathlib.Path.touch
if __name__ == "__main__":
    # Following commands will execute if this file is ran directly.
    # Importing this .py to another .py script won't invoke the following cmds
    # because of __name__ equality check
    files = (
        "ModsToCoaBIOAI.txt",
        "ModsToCoaBIOCompat.txt",
        "ModsToCoaBIOCredits.txt",
        "ModsToCoaBIOEditor.txt",
        "ModsToCoaBIOEditorKeyBindings.txt",
        "ModsToCoaBIOEditorUserSettings.txt",
        "ModsToCoaBIOEngine.txt",
        "ModsToCoaBIOGame.txt",
        "ModsToCoaBIOInput.txt",
        "ModsToCoaBIOLightmass.txt",
        "ModsToCoaBIOParty.txt",
        "ModsToCoaBIOQA.txt",
        "ModsToCoaBIOStringTypeMap.txt",
        "ModsToCoaBIOTest.txt",
        "ModsToCoaBIOUI.txt",
        "ModsToCoaBIOWeapon.txt",
        "ModsToCoaPCConsole-BIOEngine.txt",
        "ModsToBIOCredits.txt",
        "ModsToBIOEngine.txt",
        "ModsToBIOGame.txt",
        "ModsToBIOInput.txt",
        "ModsToBIOUI.txt",
        "ModsToBIOWeapon.txt",
        "ModsToGamerSettings.txt"
        )
    p = Path("./MOD/ME2")
    for f in files:
        try:
            (p / f).touch()
            print("Created successfully:", f)
        except Exception:
            print("Failed to create file:", f)
