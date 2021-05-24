from pathlib import Path

# Info: https://docs.python.org/3/library/pathlib.html#pathlib.Path.touch
if __name__ == "__main__":
    # Following commands will execute if this file is ran directly.
    # Importing this .py to another .py script won't invoke the following cmds
    # because of __name__ equality check
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
            (p / f).touch(exist_ok=False)
            print("Created successfully:", f)
        except FileExistsError:
            print("File already exists:", f)
        except Exception:
            print("Failed to create file:", f)
