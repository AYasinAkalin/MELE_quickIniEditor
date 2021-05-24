# READ THE PATH TO GAME FOLDER FOUND BY EARLIER SCRIPTS
$_path_mele = $(Get-Content -Path .\Temp\_massEffectDirectory.txt -TotalCount 1)

$_me2_coasuffix = $(Get-Content -Path .\Temp\_massEffectCoaSuffix.txt -TotalCount 1)

# DEFINE FILES PATHS
# These definition are made in `cli1.bat` but not made in `cli2.bat` (parent process)
# so we need to define them again. Definitions in `cli1.bat` can't be used with `$ENV:` prefix
# Mass Effect 1 files
$_path_coa1           = "$_path_mele`Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin"
$_path_bioengine1     = "$_path_mele`Game\ME1\BioGame\Config\BIOEngine.ini"
$_path_biogame1       = "$_path_mele`Game\ME1\BioGame\Config\BIOGame.ini"
$_path_gamersettings1 = "$_path_mele`Game\ME1\BioGame\Config\GamerSettings.ini"
# Mass Effect 2 files
$_path_coa2           = "$_path_mele`Game\ME2\BioGame\CookedPCConsole\Coalesced_$_me2_coasuffix`.bin"
$_path_biocredits2    = "$_path_mele`Game\ME2\BioGame\Config\BIOCredits.ini"
$_path_bioengine2     = "$_path_mele`Game\ME2\BioGame\Config\BIOEngine.ini"
$_path_biogame2 	  = "$_path_mele`Game\ME2\BioGame\Config\BIOGame.ini"
$_path_bioinput2      = "$_path_mele`Game\ME2\BioGame\Config\BIOInput.ini"
$_path_bioui2         = "$_path_mele`Game\ME2\BioGame\Config\BIOUI.ini"
$_path_bioweapon2     = "$_path_mele`Game\ME2\BioGame\Config\BIOWeapon.ini"
$_path_gamersettings2 = "$_path_mele`Game\ME2\BioGame\Config\GamerSettings.ini"


# COMPARE BACKED UP (.BAK) FILES WITH MODIFIED FILES
# if there are any changes made, copy modified file if changes've been made
# Compare ME1 files
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_coa1) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_coa1`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_coa1 -Destination $_path_coa1
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_bioengine1) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_bioengine1`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_bioengine1 -Destination $_path_bioengine1
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_biogame1) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_biogame1`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_biogame1 -Destination $_path_biogame1
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_gamersettings1) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_gamersettings1`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_gamersettings1 -Destination $_path_gamersettings1
}
# Compare ME2 files
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_coa2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_coa2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_coa2 -Destination $_path_coa2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_biocredits2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_biocredits2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_biocredits2 -Destination $_path_biocredits2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_bioengine2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_bioengine2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_bioengine2 -Destination $_path_bioengine2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_biogame2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_biogame2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_biogame2 -Destination $_path_biogame2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_bioinput2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_bioinput2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_bioinput2 -Destination $_path_bioinput2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_bioui2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_bioui2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_bioui2 -Destination $_path_bioui2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_bioweapon2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_bioweapon2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_bioweapon2 -Destination $_path_bioweapon2
}
IF(Compare-Object `
	-ReferenceObject  $(Get-Content $ENV:_path_temp_gamersettings2) `
	-DifferenceObject $(Get-Content "$ENV:_path_temp_gamersettings2`.BAK") `
  ){
  Copy-Item -Path $ENV:_path_temp_gamersettings2 -Destination $_path_gamersettings2
}

# Complete the process by printing out a message
IF(Test-Path -Path ".\Temp\_flag_no_modifications_made" -PathType leaf){
	ECHO "$ENV:_fYellow`Warning!$ENV:_RESET No file(s) copied!"
} ELSE{
	ECHO "$ENV:_fBGreen`Success!$ENV:_RESET File(s) copied!"	
}