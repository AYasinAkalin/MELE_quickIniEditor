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

:: OBTAIN ABSOLUTE PATHS TO GAME FOLDER AND FILES
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
  EXIT [/B]
)
ECHO %_fBGreen%Success^^!%_RESET% Game installation found at: %_fBWhite%%_bBBlue%%_path_mele%%_RESET%

SET _path_coa1=%_path_mele%Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin
SET _path_bioengine=%_path_mele%Game\ME1\BioGame\Config\BIOEngine.ini
SET _path_biogame=%_path_mele%Game\ME1\BioGame\Config\BIOGame.ini

SET /p waiter="Press ENTER to start"

:: CREATE NECASSARY FOLDERS
SET _path_zipContent=".\Temp\z\Mass Effect Legendary Edition\Game\ME1\BioGame\"
SET _path_zipFile=.\Backup\Originals.zip
MD Temp\unpacked_coalescend %_path_zipContent%CookedPCConsole\ %_path_zipContent%Config\ .\Backup >nul 2>nul

:: Take copy of Coalesced_INT.bin, BIOEngine.ini, BIOGame.ini quietly
:: Do not directly modify on original files! 
COPY "%_path_coa1%" .\Temp\Coalesced_INT.bin >nul
COPY "%_path_bioengine%" .\Temp\BIOEngine.ini >nul
COPY "%_path_biogame%" .\Temp\BIOGame.ini >nul

:: UNPACK COALESCED_INT.BIN
.\LECoal\LECoal.exe unpack .\Temp\Coalesced_INT.bin .\Temp\unpacked_coalescend >nul

:: SAVE COPIED FILES AS BACKUP QUIETLY
COPY .\Temp\Coalesced_INT.bin .\Temp\Coalesced_INT.bin.BAK >nul
COPY .\Temp\BIOEngine.ini .\Temp\BIOEngine.ini.BAK >nul
COPY .\Temp\BIOGame.ini .\Temp\BIOGame.ini.BAK >nul

:: EXPORT GAME INSTALLATION PATH TO FILE FOR EXTERNAL SCRIPTS
@ECHO on
@ECHO %_path_mele%> .\Temp\_massEffectDirectory.txt
@ECHO off

::debug::echo ❕ Stop point #1: Msg: PYTHON will work next.
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue.  "

ENDLOCAL