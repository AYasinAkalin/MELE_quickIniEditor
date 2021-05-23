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


class ModFolderNotFoundError(Exception):
    """Exception class raised when MOD folder is not found."""
    def __init__(self):
        self.message = "MOD folder cannot be found. Without it I can't proceed."
        super(ModFolderNotFoundError, self).__init__(self.message)


class ModFolderIsCorruptedError(Exception):
    """Exception class to be used when MOD folder is corrupted.
    A possible reason is that MOD folder is removed and replaced by
    a file named MOD without an extension."""
    def __init__(self, notDirectory=False):
        self.message = "MOD folder is corrupted.\
Make sure there are ME1, ME2, ME3 folders inside it."
        if notDirectory:
            self.message = self.message + " It is not a directory anymore."
        super(ModFolderIsCorruptedError, self).__init__(self.message)


class NoModificationsMadeError(Exception):
    """Exception class raised when all .txt files are empty
    therefore no changes made.

    This situation is not a real error, yet an informative message is needed
    when this happens instead of my good old 'File(s) copied!' message."""
    def __init__(self):
        self.message = "No modifications detected. Your .txt files might be empty.\n\
If your .txt files are not empty:\n\
- Check the syntax. Don't forget to put ';;' where it should be put.\n\
- If you are trying to make additions, \n\
  make sure that you put '@[ASectionName]' at the end of the line.\n\
  Change 'ASectionName' as you'd like."
        super(NoModificationsMadeError, self).__init__(self.message)
        with open("./Temp/_flag_no_modifications_made", "w") as f:
            pass


def makepathfromname(txtFileName, gameNameAlias):
    '''Creates corresponding file paths for given `.txt` file in MOD folder.
    Corresponding files are `.ini` files directly copied from
    game's installation folder to Temp folder prior to execution of worker.py.

    Modifications are made directly to these files. Then a Powershell script
    copies them to Mass Effect's installation folder.

    Parameters:

    txtFileName
        string, Name of the file in one of the subfolders in MOD folder.
        MOD folder has got ME1, ME2, ME3 subfolders.
        `.txt` files for users to fill in are now in these folders.

    gameNameAlias
        string, Name of the subfolder in MOD folder which txtFile is presiding.
        It could and should be on of these: ME1, ME2, ME3.'''
    if (sys.version_info.minor >= 9):
        txtFileName = txtFileName.removeprefix('ModsTo').removesuffix('.txt')+'.ini'
    else:
        txtFileName = txtFileName.replace('ModsTo', '').replace('.txt', '.ini')

    if txtFileName[0:3] == "Coa":
        txtFileName = txtFileName.replace('Coa', '-_-_BIOGame_Config_')
        p = Path("./Temp") / gameNameAlias / "unpacked_coalescend" / txtFileName
    else:
        p = Path("./Temp") / gameNameAlias / txtFileName
    return p  # p is corresponding ini file's path


def foldercrawl():
    '''Creates and Editor object for all files inside MOD folder.
    Returns a list of these Editor objects.'''
    foldercontents = []

    # Open MOD folder
    p = Path("./MOD")
    if not p.exists():
        raise ModFolderNotFoundError
    elif not p.is_dir():
        raise ModFolderIsCorruptedError(notDirectory=True)

    # Open MOD/ME1, MOD/ME2, MOD/ME3 folders
    subfolders = confirmfolders([sf for sf in p.iterdir() if sf.is_dir()])

    # Go through all .txt files in all MOD/ME1, MOD/ME2, MOD/ME3 folders
    for folder in subfolders:
        for textfile in folder.iterdir():
            q = makepathfromname(textfile.name, folder.name)
            # file for Editor(file, modificationList) is found
            modificationlist = []
            with textfile.open() as f:
                for line in f:
                    vanillaString = line.split(delim)[0].strip()
                    modString = line.split(delim)[1].strip()
                    modificationlist.append((vanillaString, modString))
            if (len(modificationlist) > 0):
                foldercontents.append(Editor(q, modificationlist))
                # modificationList for editor(file, modificationList) is found
    return foldercontents


def confirmfolders(subfolderList):
    '''Gets a list of folders inside MOD folder, remove the non-default from
    the list, returns the new list.

    If the user renamed or removed all the default subfolders, raises an error.

    This is done to not let the program fail if the user created new folders
    in MOD folder and put unsupported files inside them.

    Parameters:

    subfolderList
        List or an iterable container with Path objects,
        The subfolders are the folders found inside MOD folder.'''
    defaultFolderNames = ('ME1', 'ME2', 'ME3')
    confirmedFolders = [sf for sf in subfolderList
                        if sf.name in defaultFolderNames]
    if len(confirmedFolders) == 0:
        raise ModFolderIsCorruptedError
    return confirmedFolders


# print("hello from python!✅❕❌")
def execute():
    ep = EditorPlus()
    try:
        mods = foldercrawl()
    except (ModFolderNotFoundError,
            ModFolderNotFoundError) as e:
        # Throw the same exception. Catch it on higher levels and
        # deal with it there
        raise e
    if len(mods) == 0:
        raise NoModificationsMadeError
    for m in mods:
        ep.import_editor_info(m)
    ep.process_many()
