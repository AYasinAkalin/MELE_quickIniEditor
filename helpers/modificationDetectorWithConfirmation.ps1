$file1 = ".\Temp\Coalesced_INT.bin"
$file1Backup = ".\Temp\Coalesced_INT.bin.BAK"
$file2 = ".\Temp\BIOEngine.ini"
$file2Backup = ".\Temp\BIOEngine.ini.BAK"
$file3 = ".\Temp\BIOGame.ini"
$file3Backup = ".\Temp\BIOGame.ini.BAK"

IF(Compare-Object -ReferenceObject $(Get-Content $file1) -DifferenceObject $(Get-Content $file1Backup)){
  Copy-Item -Path $file1 -Destination $ENV:_path_coa1 -Confirm
}

IF(Compare-Object -ReferenceObject $(Get-Content $file2) -DifferenceObject $(Get-Content $file2Backup)){
  Copy-Item -Path $file2 -Destination $ENV:_path_bioengine1 -Confirm
}

IF(Compare-Object -ReferenceObject $(Get-Content $file3) -DifferenceObject $(Get-Content $file3Backup)){
  Copy-Item -Path $file3 -Destination $ENV:_path_biogame1 -Confirm
}

ECHO "$ENV:_fBGreen`Success!$ENV:_RESET File(s) copied!" 