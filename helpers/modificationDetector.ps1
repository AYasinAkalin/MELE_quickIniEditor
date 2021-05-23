$file1 = ".\Temp\ME1\Coalesced_INT.bin"
$file1Backup = ".\Temp\ME1\Coalesced_INT.bin.BAK"
$file2 = ".\Temp\ME1\BIOEngine.ini"
$file2Backup = ".\Temp\ME1\BIOEngine.ini.BAK"
$file3 = ".\Temp\ME1\BIOGame.ini"
$file3Backup = ".\Temp\ME1\BIOGame.ini.BAK"

IF(Compare-Object -ReferenceObject $(Get-Content $file1) -DifferenceObject $(Get-Content $file1Backup)){
  Copy-Item -Path $file1 -Destination $ENV:_path_coa1
}

IF(Compare-Object -ReferenceObject $(Get-Content $file2) -DifferenceObject $(Get-Content $file2Backup)){
  Copy-Item -Path $file2 -Destination $ENV:_path_bioengine1
}

IF(Compare-Object -ReferenceObject $(Get-Content $file3) -DifferenceObject $(Get-Content $file3Backup)){
  Copy-Item -Path $file3 -Destination $ENV:_path_biogame1
}

IF(Test-Path -Path ".\Temp\_flag_no_modifications_made" -PathType leaf){
	ECHO "$ENV:_fYellow`Warning!$ENV:_RESET No file(s) copied!"
} ELSE{
	ECHO "$ENV:_fBGreen`Success!$ENV:_RESET File(s) copied!"	
}