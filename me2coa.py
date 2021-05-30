#!/usr/bin/env python
"""me2coa.py"""
__version__ = "1.1.1"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-24"

from pathlib import Path
from gamelanguage import GameLang
import constants
from colors import Style as color


def pick():
    gameInfo = GameLang()
    coalesced2Suffix = confirmcoafile(gameInfo)
    p = Path("./Temp/")
    if not p.exists():
        p.mkdir()
        # print("Python created Temp folder because it wasn't there")
    with open(p / "_massEffectCoaSuffix.txt", "w") as f:
        f.write(coalesced2Suffix)
    p = Path("./relpaths")
    with open(p / "_path_temp_coa2.txt", "w") as f:
        f.write(".\\Temp\\ME2\\Coalesced_"
                + coalesced2Suffix
                + ".bin")


def confirmcoafile(gameLangObj):
    language = gameLangObj.getLanguage()
    coaFile1 = "Coalesced_INT.bin"
    coaFile2 = "Coalesced_" + gameLangObj.getCoalescedSuffix() + ".bin"
    inf = color.LYELLOW + "Info!" + color.RESET
    succ = color.LGREEN + "Success!" + color.RESET
    warn = color.YELLOW + "Warning!" + color.RESET
    err = color.RED + "Error!" + color.RESET

    if gameLangObj.isConfigFileUsed():
        print(
            inf,
            "Mass Effect Legendary Edition's language setting is:",
            color.BOLD + language + color.RESET)
    else:
        # At this point an error occurred before when
        # reading LauncherConfig.cfg. A default language is chosen
        # Inform the user about this situation.
        print(
            err,
            "Game's language setting from configuration file couldn't read.")
        print(
            inf,
            "Default language is selected as game's language:",
            color.BOLD + language + color.RESET
            )
    print(
        inf,
        "Selected Mass Effect 1 Coalesced file (You CANNOT change this):",
        color.BOLD + coaFile1 + color.RESET)
    print(
        inf,
        "Selected Mass Effect 2 Coalesced file (You can change this)   :",
        color.BOLD + coaFile2 + color.RESET)
    response = "CycleMustContinue"
    while response not in ("y", "n", ""):
        if response != "CycleMustContinue":
            print(warn, "Unrecognized answer.")
        response = input("Continue with these files? [y|n]: ").lower()
    if response == 'n':
        selection = "Shepard must choose an ending!"
        printtable()
        while selection not in range(1, 6):
            if selection != "Shepard must choose an ending!":
                print(warn, "Unrecognized answer. Your response should be between 1-5.")
            _input = input("Select on of the file from the table for [1|2|3|4|5]: ")
            if _input.isdecimal():
                selection = int(_input)
            else:
                selection = 0
        suffix = constants.coa_suffix_map[selection]
        gameLangObj.setCoaSuffix(suffix)
        print(
            succ,
            "Mass Effect 2 Coalesced file changed to:",
            color.BOLD + "Coalesced_" + suffix + ".bin" + color.RESET)
    return gameLangObj.getCoalescedSuffix()


def printtable():
    coalFiles = constants.massEffect2CoalFiles
    style = (color.UNDERLINE, color.UNDERLINE + color.BOLD, color.RESET)
    headers = ("File Name", "Selection")
    # Print Headers
    print("{}{:46}{}".format(
        style[0], "", style[2])
    )
    print("|{}{:^44}{}|".format(
        style[1], "MASS EFFECT 2 Coalesced Options", style[2])
    )
    print("|{}{:^26}||{:^16}{}|".format(
        style[0], headers[0], headers[1], style[2])
    )
    # Print rows
    for selection, coa in enumerate(coalFiles, start=1):
        if selection == 5:
            print(style[0], end='')
        print("|{:^26}||{:^16}|".format(coa, selection))
        if selection == 5:
            print(style[2])
