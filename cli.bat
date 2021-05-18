@ECHO off
SETLOCAL
SETLOCAL enabledelayedexpansion

:: OBTAIN ABSOLUTE PATHS TO GAME FOLDER AND FILES
FOR /f "usebackq tokens=3*" %%a in (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Bioware\Mass Effect Legendary Edition" /v "install dir"`) do (
  SET _path_mele=%%b
  )
SET _path_coa1=%_path_mele%Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin
SET _path_bioengine=%_path_mele%Game\ME1\BioGame\Config\BIOEngine.ini
SET _path_biogame=%_path_mele%Game\ME1\BioGame\Config\BIOGame.ini

:: CREATE NECASSARY FOLDERS
SET _path_zipContent=".\Temp\z\Mass Effect Legendary Edition\Game\ME1\BioGame\"
SET _path_zipFile=.\Backup\Originals.zip
MD Temp\unpacked_coalescend %_path_zipContent%CookedPCConsole\ %_path_zipContent%Config\ .\Backup >nul

:: Take copy of Coalesced_INT.bin, BIOEngine.ini, BIOGame.ini quietly
:: Do not directly modify on original files! 
COPY "%_path_coa1%" .\Temp\Coalesced_INT.bin >nul
COPY "%_path_bioengine%" .\Temp\BIOEngine.ini >nul
COPY "%_path_biogame%" .\Temp\BIOGame.ini >nul

:: UNPACK COALESCED_INT.BIN
:: TODO: Add coalesced unpacker

:: SAVE COPIED FILES AS BACKUP QUIETLY
COPY .\Temp\Coalesced_INT.bin .\Temp\Coalesced_INT.bin.BAK >nul
COPY .\Temp\BIOEngine.ini .\Temp\BIOEngine.ini.BAK >nul
COPY .\Temp\BIOGame.ini .\Temp\BIOGame.ini.BAK >nul

:: EXPORT GAME INSTALLATION PATH TO FILE FOR EXTERNAL SCRIPTS
@ECHO on
@ECHO %_path_mele%> .\Temp\_massEffectDirectory.txt
@ECHO off

::debug::echo ❕ Stop point #1: Msg: External script will work next.
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue.  "

:: MAKE CHANGES IN EXTRACTED FILES
:: TODO: Create a script to work on files

::debug::echo ❕ Stop point #2. Msg: External script's job is done. 
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue. "

:: REPACK COALESCED_INT.BIN
:: TODO: Add coalesced packer

:: DETECT MODIFIED FILES AND APPLY THE CHANGES
:: TODO: Use powershell to control files if any changes has been made

:: PRODUCE A BACKUP .ZIP FILE
:: TODO: Use either 7zip or powershell to zip original files for backup

::debug::echo ❕ Stop point #3: Msg: Work work is done. Will clean temp. files then exit.
::debug::SET /p waiter="❕ Stop point #3. Waiting for debugging. Press ENTER to continue.  "

:: REMOVE TEMPORARY FILES AND FOLDERS
RD /S /Q .\Temp

ECHO All done^^!
SET /p close = "Press ENTER to close. "
ENDLOCAL