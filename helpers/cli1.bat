@ECHO off
SETLOCAL
SETLOCAL enabledelayedexpansion

:: Enable Unicode support (if terminal supports it too), and colors
chcp 65001 >nul
Set _fBGreen=[92m
Set _fBWhite=[97m
Set _bBBlue=[104m
Set _fRed=[31m
Set _RESET=[0m

ECHO Hello^^! \(*°v°*)/

:: OBTAIN ABSOLUTE PATH TO GAME FOLDER
FOR /f "usebackq tokens=3*" %%a in (`
  REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Bioware\Mass Effect Legendary Edition" /v "install dir" 2^> nul
  `) do (SET _path_mele=%%b)

IF NOT DEFINED _path_mele (
  FOR /f "usebackq tokens=3*" %%a in (`
    REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\BioWare\Mass Effectâ„¢ Legendary Edition" /v "install dir" 2^> nul
    `) do (SET _path_mele=%%b)
)

IF NOT DEFINED _path_mele (
  FOR /f "usebackq tokens=2*" %%a in (`
    REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 1328670" /v "InstallLocation" 2^> nul
    `) do (SET _path_mele=%%b)
)

IF NOT DEFINED _path_mele (
  FOR /f "usebackq tokens=2*" %%a in (`
    REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{068668C4-0B89-4431-A749-1829F845DB87}" /v "installlocation" 2^> nul
    `) do (SET _path_mele=%%b)
)

IF NOT DEFINED _path_mele (
  ECHO %_fRed%Failure^^!%_RESET% Mass Effect Legendary Edition's installation location couldn't be found.
  ECHO Press any key to exit...
  pause >nul
  EXIT 1
)
ECHO %_fBGreen%Success^^!%_RESET% Game installation found at: %_fBWhite%%_bBBlue%%_path_mele%%_RESET%

:: DEFINE FILES' ABSOLUTE PATHS
:: Mass Effect 1 files
SET _path_coa1=%_path_mele%Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin
SET _path_bioengine1=%_path_mele%Game\ME1\BioGame\Config\BIOEngine.ini
SET _path_biogame1=%_path_mele%Game\ME1\BioGame\Config\BIOGame.ini

SET /p waiter="Press ENTER to start"

:: CREATE NECASSARY FOLDERS
SET _path_zipContent_ME1=".\Temp\z\Mass Effect Legendary Edition\Game\ME1\BioGame\"
SET _path_zipFile=.\Backup\Originals.zip
MD Temp\ME1\unpacked_coalescend Temp\ME2\unpacked_coalescend Temp\ME3\unpacked_coalescend >nul 2>nul
MD %_path_zipContent_ME1%CookedPCConsole\ %_path_zipContent_ME1%Config\ .\Backup >nul 2>nul

:: IMPORT FILES INTO THE PROGRAM
:: Take copy of Coalesced_INT.bin, BIOEngine.ini, BIOGame.ini quietly
:: Do not directly modify on original files! 
COPY "%_path_coa1%" .\Temp\ME1\Coalesced_INT.bin >nul
COPY "%_path_bioengine1%" .\Temp\ME1\BIOEngine.ini >nul
COPY "%_path_biogame1%" .\Temp\ME1\BIOGame.ini >nul

:: UNPACK COALESCED_INT.BIN
:: Mass Effect 1's coalesced
.\LECoal\LECoal.exe unpack .\Temp\ME1\Coalesced_INT.bin .\Temp\ME1\unpacked_coalescend >nul

:: TAKE A COPY OF IMPORTED FILES
:: Creating a second copy of imported files quietly.
:: This second copy will be used to detect any changes made by user

:: Mass Effect 1 files
COPY .\Temp\ME1\Coalesced_INT.bin .\Temp\ME1\Coalesced_INT.bin.BAK >nul
COPY .\Temp\ME1\BIOEngine.ini .\Temp\ME1\BIOEngine.ini.BAK >nul
COPY .\Temp\ME1\BIOGame.ini .\Temp\ME1\BIOGame.ini.BAK >nul

:: EXPORT GAME INSTALLATION PATH TO FILE FOR EXTERNAL SCRIPTS
@ECHO on
@ECHO %_path_mele%> .\Temp\_massEffectDirectory.txt
@ECHO off

::debug::echo ❕ Stop point #1: Msg: PYTHON will work next.
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue.  "

ENDLOCAL