@ECHO off
SETLOCAL
SETLOCAL enabledelayedexpansion

:: Enable Unicode support (if terminal supports it too), and colors
chcp 65001 >nul
Set _fBGreen=[92m
Set _fBWhite=[97m
Set _bBBlue=[104m
Set _fRed=[31m
Set _fYellow=[33m
Set _RESET=[0m

:: RETRIEVE BACK THE PATH TO GAME FOLDER
for /f "tokens=*" %%s in (.\Temp\_massEffectDirectory.txt) do SET _path_mele=%%s

:: DEFINE TEMP FILES' RELATIVE PATHS
:: Mass Effect 1 temp files
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_coa1.txt) do SET _path_temp_coa1=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_bioengine1.txt) do SET _path_temp_bioengine1=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_biogame1.txt) do SET _path_temp_biogame1=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_gamersettings1.txt) do SET _path_temp_gamersettings1=%%s
:: Mass Effect 2 temp files
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_coa2.txt) do SET _path_temp_coa2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_biocredits2.txt) do SET _path_temp_biocredits2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_bioengine2.txt) do SET _path_temp_bioengine2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_biogame2.txt) do SET _path_temp_biogame2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_bioinput2.txt) do SET _path_temp_bioinput2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_bioui2.txt) do SET _path_temp_bioui2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_bioweapon2.txt) do SET _path_temp_bioweapon2=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_temp_gamersettings2.txt) do SET _path_temp_gamersettings2=%%s

:: DEFINE DIRECTORIES REGARDING BACKUP 
SET _path_zipContent_ME1=".\Temp\z\Mass Effect Legendary Edition\Game\ME1\BioGame\"
SET _path_zipFile=.\Backup\Originals.zip

::debug::echo ❕ Stop point #2. Msg: PYTHON's job is done. 
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue. "

:: REPACK COALESCED_INT.BIN
.\LECoal\LECoal.exe pack .\Temp\unpacked_coalescend .\Temp\Coalesced_INT.bin >nul

:: DETECT MODIFIED FILES AND APPLY THE CHANGES
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\helpers\modificationDetector.ps1'"

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