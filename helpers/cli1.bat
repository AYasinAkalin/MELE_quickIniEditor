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

:: This batch can be called 2nd time.
:: If this is the second time, skip some processes
IF EXIST .\Temp\_massEffectDirectory.txt (
  FOR /f "tokens=*" %%s in (.\Temp\_massEffectDirectory.txt) do (SET _path_mele=%%s)
)
IF DEFINED _path_mele GOTO :SECTION_CRAWL_GAME_FILES

:: At this point we are sure this is 1st call.
:: Start the program with a welcoming message
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


SET /p waiter="Press ENTER to start"

:: CREATE NECASSARY FOLDERS
FOR /f "tokens=*" %%s in (.\relpaths\_path_zipContent_ME1.txt) do SET _path_zipContent_ME1=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_zipContent_ME2.txt) do SET _path_zipContent_ME2=%%s
::FOR /f "tokens=*" %%s in (.\relpaths\_path_zipContent_ME3.txt) do SET _path_zipContent_ME3=%%s
FOR /f "tokens=*" %%s in (.\relpaths\_path_zipFile.txt) do SET _path_zipFile=%%s
MD Temp\ME1\unpacked_coalescend Temp\ME2\unpacked_coalescend Temp\ME3\unpacked_coalescend >nul 2>nul
MD "%_path_zipContent_ME1%CookedPCConsole\" "%_path_zipContent_ME1%Config\" >nul 2>nul
MD "%_path_zipContent_ME2%CookedPCConsole\" "%_path_zipContent_ME2%Config\" >nul 2>nul
::MD "%_path_zipContent_ME3%CookedPCConsole\" "%_path_zipContent_ME3%Config\" >nul 2>nul
MD .\Backup >nul 2>nul

:: EXPORT GAME INSTALLATION PATH TO FILE FOR EXTERNAL SCRIPTS
@ECHO on
@ECHO %_path_mele%> .\Temp\_massEffectDirectory.txt
@ECHO off

:SECTION_CRAWL_GAME_FILES
:: DETECT GAME'S LANGUAGE (NEEDED FOR MASS EFFECT 2's COA FILE PICK)
IF EXIST .\Temp\_massEffectCoaSuffix.txt (
  FOR /f "tokens=*" %%s in (.\Temp\_massEffectCoaSuffix.txt) do SET _coa2_suffix=%%s
)
:: If game language is not detected, exit the execution
:: When exited with code 2, an external python script will run
:: It will find the language, and then run this batch script again
IF NOT DEFINED _coa2_suffix (
Rem :: are not used here for comments because when they are used, batch threw an error msg
Rem look here for more info https://stackoverflow.com/q/19843849
Rem debug:: echo ❕ Stop point #0: Msg: gamelanguage.py will work next.
Rem debug:: SET /p waiter="Waiting for debugging. Press ENTER to continue.  "
  EXIT 2
)

:: DEFINE FILES' ABSOLUTE PATHS
:: Mass Effect 1 files
SET _path_coa1=%_path_mele%Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin
SET _path_bioengine1=%_path_mele%Game\ME1\BioGame\Config\BIOEngine.ini
SET _path_biogame1=%_path_mele%Game\ME1\BioGame\Config\BIOGame.ini
SET _path_gamersettings1=%_path_mele%Game\ME1\BioGame\Config\GamerSettings.ini
:: Mass Effect 2 files
SET _path_coa2=%_path_mele%Game\ME2\BioGame\CookedPCConsole\Coalesced_%_coa2_suffix%.bin
SET _path_biocredits2=%_path_mele%Game\ME2\BioGame\Config\BIOCredits.ini
SET _path_bioengine2=%_path_mele%Game\ME2\BioGame\Config\BIOEngine.ini
SET _path_biogame2=%_path_mele%Game\ME2\BioGame\Config\BIOGame.ini
SET _path_bioinput2=%_path_mele%Game\ME2\BioGame\Config\BIOInput.ini
SET _path_bioui2=%_path_mele%Game\ME2\BioGame\Config\BIOUI.ini
SET _path_bioweapon2=%_path_mele%Game\ME2\BioGame\Config\BIOWeapon.ini
SET _path_gamersettings2=%_path_mele%Game\ME2\BioGame\Config\GamerSettings.ini
:: Mass Effect 3 files

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
:: Mass Effect 3 temp files

:: IMPORT FILES INTO THE PROGRAM
:: Take copy of Coalesced_INT.bin, BIOEngine.ini, BIOGame.ini quietly
:: Do not directly modify on original files! 
:: Mass Effect 1
COPY "%_path_coa1%" "%_path_temp_coa1%" >nul
COPY "%_path_bioengine1%" "%_path_temp_bioengine1%" >nul
COPY "%_path_biogame1%" "%_path_temp_biogame1%" >nul
COPY "%_path_gamersettings1%" "%_path_temp_gamersettings1%" >nul
:: Mass Effect 2
COPY "%_path_coa2%" "%_path_temp_coa2%" >nul
COPY "%_path_biocredits2%" "%_path_temp_biocredits2%" >nul
COPY "%_path_bioengine2%" "%_path_temp_bioengine2%" >nul
COPY "%_path_biogame2%" "%_path_temp_biogame2%" >nul
COPY "%_path_bioinput2%" "%_path_temp_bioinput2%" >nul
COPY "%_path_bioui2%" "%_path_temp_bioui2%" >nul
COPY "%_path_bioweapon2%" "%_path_temp_bioweapon2%" >nul
COPY "%_path_gamersettings2%" "%_path_temp_gamersettings2%" >nul
:: Mass Effect 3

:: UNPACK COALESCED_INT.BIN
.\LECoal\LECoal.exe unpack %_path_temp_coa1% .\Temp\ME1\unpacked_coalescend >nul
.\LECoal\LECoal.exe unpack %_path_temp_coa2% .\Temp\ME2\unpacked_coalescend >nul
:: TODO: Unpack Mass Effect 3's coalesced

:: TAKE A COPY OF IMPORTED FILES
:: Creating a second copy of imported files quietly.
:: This second copy will be used to detect any changes made by user

:: Mass Effect 1 files
COPY %_path_temp_coa1% "%_path_temp_coa1%.BAK" >nul
COPY %_path_temp_bioengine1% "%_path_temp_bioengine1%.BAK" >nul
COPY %_path_temp_biogame1% "%_path_temp_biogame1%.BAK" >nul
COPY %_path_temp_gamersettings1% "%_path_temp_gamersettings1%.BAK" >nul
:: Mass Effect 2 files
COPY %_path_temp_coa2% "%_path_temp_coa2%.BAK" >nul
COPY %_path_temp_biocredits2% "%_path_temp_biocredits2%.BAK" >nul
COPY %_path_temp_bioengine2% "%_path_temp_bioengine2%.BAK" >nul
COPY %_path_temp_biogame2% "%_path_temp_biogame2%.BAK" >nul
COPY %_path_temp_bioinput2% "%_path_temp_bioinput2%.BAK" >nul
COPY %_path_temp_bioui2% "%_path_temp_bioui2%.BAK" >nul
COPY %_path_temp_bioweapon2% "%_path_temp_bioweapon2%.BAK" >nul
COPY %_path_temp_gamersettings2% "%_path_temp_gamersettings2%.BAK" >nul
:: Mass Effect 3 files

::debug::echo ❕ Stop point #1: Msg: PYTHON will work next.
::debug::SET /p waiter="Waiting for debugging. Press ENTER to continue.  "

ENDLOCAL