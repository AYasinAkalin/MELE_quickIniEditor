#!/usr/bin/env python
"""gamelanguage.py"""
__version__ = "1.1.1"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-24"

import winreg
from pathlib import Path
import configparser as cp
import constants


class GameLang(object):
    """Retrieves language setting of Mass Effect Legendary Edition,
    and corresponding Coalesced file's suffix for that language
    Methods:

    - getLangLocale()
        Returns language and locale in a single string (ex.: en_US)

    - getCoalescedSuffix()
        ONLY USE THIS METHOD FOR MASS EFFECT 2
        OTHER GAMES DON'T HAVE SEVERAL COALESCED FILES
        Returns a suffix for the corresponding language
        (ex.: 'FRA' is returned if game is in French.
        Game uses `Coalesced_FRA.bin`)
        (ex.: 'INT' is returned if game is in English.)
        (ex.: 'INT' is return even if game is NOT in English
        but there is no corresponding Coalesced file for that language,
        like Russian, Japanese, Spanish)

    - getLanguage()
        Returns the language as string in plain English (ex.: English, German)

    - _findDocumentsFolder()
        Don't call this method.
        An internal method that finds where Windows' Documents file is located.

    - _detectLangLocale()
        Don't call this method.
        An internal method that detects lang. and locale setting ME: LE uses.

    - _language()
        Don't call this method.
        An internal method that fills language info for this GameLang() class.

    - _coaSuffix()
        Don't call this method.
        An internal method that fills coa suffix
        (suffix is where * is Coalesced_*.bin ) info for this GameLang() class.

    - isConfigFileUsed()
        Returns True if everything went smoothly and game's configuration file
        is read.
        Return False if game's configuration file is not read and default
        values are used. Default language is English, default locale is US.

        If result of this method is False, let the user know that default
        values are used.

    Usage:
        gameInfo = GameLang()
        gameInfo.isConfigFileUsed()
        gameInfo.getLangLocale()
        gameInfo.getLanguage()
        gameInfo.getCoalescedSuffix()
    """
    def __init__(self):
        super(GameLang, self).__init__()
        self.configFileError = False
        self.documentsPath = self._findDocumentsFolder()
        self.lang_locale = self._detectLangLocale()
        self.languageLongString = self._language()
        self.coalescedSuffix = self._coaSuffix()

    def getLangLocale(self):
        return self.lang_locale

    def getCoalescedSuffix(self):
        return self.coalescedSuffix

    def getLanguage(self):
        return self.languageLongString

    def _findDocumentsFolder(self):
        rkey = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        rsubkey = r"Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
        query = winreg.OpenKey(rkey, rsubkey)

        # try-except with a loop is the way to look for
        # key-value pair in a registry subkey
        # Usage: https://docs.python.org/3.8/library/winreg.html#winreg.EnumValue
        try:
            i = 0
            while True:
                name, value, type = winreg.EnumValue(query, i)
                if name == "Personal":
                    documentsfolder = value
                    break
                # DEBUG:print(name, value, i)
                i += 1
        except WindowsError:
            # DEBUG:print(WindowsError)
            # DEBUG:print()
            pass
        return documentsfolder

    def _detectLangLocale(self):
        # DEBUG: print(self.documentsPath)
        cfilepath = Path(self.documentsPath) \
                / "BioWare"\
                / "Mass Effect Legendary Edition"\
                / "LauncherConfig.cfg"
        # DEBUG: print(cfilepath)
        parser = cp.ConfigParser(strict=False)
        gamelanglocale = ''
        try:
            with open(cfilepath) as f:
                parser.read_file(f)
            # DEBUG:
            print(parser.get("Main", "Language"))
            gamelanglocale = parser.get("Main", "Language")
        except FileNotFoundError:
            gamelanglocale = "en_US"  # Default val used, user config isnt read
            self.configFileError = True
        return gamelanglocale

    def _language(self):
        return constants.lang_locale_map[self.lang_locale]["language"]

    def _coaSuffix(self):
        return constants.lang_locale_map[self.lang_locale]["coaSuffix"]

    def setCoaSuffix(self, newSuffix):
        self.coalescedSuffix = newSuffix

    def isConfigFileUsed(self):
        return not self.configFileError


# DEBUG:gameInfo = GameLang()
# DEBUG:print(gameInfo.getLangLocale())
# DEBUG:print(gameInfo.getLanguage())
# DEBUG:print(gameInfo.getCoalescedSuffix())
