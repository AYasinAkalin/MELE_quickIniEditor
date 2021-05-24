"""ASCII text manipulation codes are defined here.
Credits: https://stackoverflow.com/a/54955094"""
__version__ = "1.0.2"
__author__ = "A. Yasin Akalın"
__credits__ = "SimpleBinary https://stackoverflow.com/users/11073514/simplebinary"
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-23"
from os import system
system("")


class Style:
    """A very basic class ontaining string definitions of some of the
    ASCII color codes.
    These codes affect stdout stream. See the example function below
    for usage.

    Style can also be defined as Dictionary which will perform faster
    Speed tests: https://stackoverflow.com/a/16288316

    class definition is picked because calls for a key from a class
    looks more pleasing to eye than dictionary"""
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    LGREEN = '\033[92m'
    YELLOW = '\033[33m'
    LYELLOW = '\033[93m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    UNDERLINE = '\033[4m'
    BOLD = '\033[1m'
    RESET = '\033[0m'


def testColors():
    """"""
    print(Style.BLACK     + "BLACK"     + Style.RESET, "Hello")  # noqa: E221
    print(Style.RED       + "RED"       + Style.RESET, "Hello")  # noqa: E221
    print(Style.GREEN     + "GREEN"     + Style.RESET, "Hello")  # noqa: E221
    print(Style.LGREEN    + "LGREEN"    + Style.RESET, "Hello")  # noqa: E221
    print(Style.YELLOW    + "YELLOW"    + Style.RESET, "Hello")  # noqa: E221
    print(Style.LYELLOW   + "LYELLOW"   + Style.RESET, "Hello")  # noqa: E221
    print(Style.BLUE      + "BLUE"      + Style.RESET, "Hello")  # noqa: E221
    print(Style.MAGENTA   + "MAGENTA"   + Style.RESET, "Hello")  # noqa: E221
    print(Style.CYAN      + "CYAN"      + Style.RESET, "Hello")  # noqa: E221
    print(Style.WHITE     + "WHITE"     + Style.RESET, "Hello")  # noqa: E221
    print(Style.UNDERLINE + "UNDERLINE" + Style.RESET, "Hello")  # noqa: E221
    print(Style.BOLD      + "BOLD"      + Style.RESET, "Hello")  # noqa: E221
    print(Style.RESET     + "RESET"     + Style.RESET, "Hello")  # noqa: E221


if __name__ == "__main__":
    testColors()
