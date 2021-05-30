'''Self working script to populate relpaths folder.
When run, existing files are kept.

It fills up `relpaths` folder with files that needs to be filled manually.
These files are used to define some variables in .bat scripts.

Reason of creating such system is that said variables are defined
in more than 1 batch file. Because their values are the same and
those batch files can't interact using environment variables,
a single place to contain the values born hence this commit.'''
__version__ = "1.1.1"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-24"
from pathlib import Path


# Info: https://docs.python.org/3/library/pathlib.html#pathlib.Path.touch
def create():
    files = (
        "_path_temp_coa1.txt",
        "_path_temp_coa2.txt",
        "_path_temp_bioengine1.txt",
        "_path_temp_biogame1.txt",
        "_path_temp_gamersettings1.txt",
        "_path_temp_biocredits2.txt",
        "_path_temp_bioengine2.txt",
        "_path_temp_biogame2.txt",
        "_path_temp_bioinput2.txt",
        "_path_temp_bioui2.txt",
        "_path_temp_bioweapon2.txt",
        "_path_temp_gamersettings2.txt",
        "_path_zipContent_ME1.txt",
        "_path_zipContent_ME2.txt",
        "_path_zipContent_ME3.txt",
        "_path_zipFile.txt"
        )
    p = Path("./relpaths/")
    if not p.exists():
        p.mkdir()
    for f in files:
        try:
            if f == "_path_temp_coa2.txt":
                (p / f).touch(exist_ok=True)
            else:
                (p / f).touch(exist_ok=False)
            print("Created successfully:", f)
        except FileExistsError:
            print("File already exists:", f)
        except Exception:
            print("Failed to create file:", f)


if __name__ == "__main__":
    # Following commands will execute if this file is ran directly.
    # Importing this .py to another .py script won't invoke the following cmds
    # because of __name__ equality check
    create()
