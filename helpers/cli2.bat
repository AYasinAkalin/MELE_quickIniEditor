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

:: RETRIEVE BACK THE PATH TO GAME FOLDER
for /f "tokens=*" %%s in (.\Temp\_massEffectDirectory.txt) do SET _path_mele=%%s

:: DEFINE FILES PATHS
:: Mass Effect 1 files
SET _path_coa1=%_path_mele%Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin
SET _path_bioengine1=%_path_mele%Game\ME1\BioGame\Config\BIOEngine.ini
SET _path_biogame1=%_path_mele%Game\ME1\BioGame\Config\BIOGame.ini

:: DEFINE DIRECTORIES REGARDING BACKUP 
SET _path_zipContent_ME1=".\Temp\z\Mass Effect Legendary Edition\Game\ME1\BioGame\"
SET _path_zipFile=.\Backup\Originals.zip

::debug::echo ❕ Stop point #2. Msg: PYTHON's job is done. 
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue. "

:: REPACK COALESCED_INT.BIN
.\LECoal\LECoal.exe pack .\Temp\unpacked_coalescend .\Temp\Coalesced_INT.bin >nul

:: DETECT MODIFIED FILES AND APPLY THE CHANGES
:: This option doesn't ask user for confirmation
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\helpers\modificationDetector.ps1'"
:: Disabled option below asks user for confirmation to overwrite for each file
::PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\helpers\modificationDetectorWithConfirmation.ps1'"

:: PRODUCE A BACKUP .ZIP FILE
SET backupFiles="n"
SET /p backupFiles="Would you like to backup your original files as a .zip file? [y|n]: "
:: /i parameter is for case insensitive comparison
IF /i "%backupFiles%" == "y" (
  MOVE .\Temp\ME1\Coalesced_INT.bin.BAK %_path_zipContent_ME1%CookedPCConsole\Coalesced_INT.bin >nul
  MOVE .\Temp\ME1\BIOEngine.ini.BAK %_path_zipContent_ME1%Config\BIOEngine.ini >nul
  MOVE .\Temp\ME1\BIOGame.ini.BAK %_path_zipContent_ME1%Config\BIOGame.ini >nul
  IF EXIST .\7zip\7za.exe (
    :: Using 7-zip to compress
    .\7zip\7za.exe a %_path_zipFile% .\Temp\z\* >nul
    ) ELSE (
    :: 7-zip is not available. Using PowerShell to compress
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\helpers\zipper.ps1'"
    )
  PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\helpers\renameBackupZip.ps1'" 
  ) ELSE (
  :: Remove Backup folder if empty because it won't be used
  RD /Q .\Backup >nul 2>nul
  ECHO %_fBGreen%Success^^!%_RESET% Skipping backup
  )

::debug::echo ❕ Stop point #3: Msg: Work work is done. Will clean temp. files then exit.
::debug::SET /p waiter="❕ Stop point #3. Waiting for debugging. Press ENTER to continue.  "

:: REMOVE TEMPORARY FILES AND FOLDERS
RD /S /Q .\Temp

ECHO %_fBGreen%All done^^!%_RESET%
ECHO Press any key to close...
pause >nul
ENDLOCAL