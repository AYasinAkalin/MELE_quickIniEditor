$file1 = ".\Temp\Coalesced_INT.bin"
$file1Backup = ".\Temp\Coalesced_INT.bin.BAK"

$lookForChanges1 = @{
  ReferenceObject = $(Get-Content $file1)
  DifferenceObject = $(Get-Content $file1Backup)
}

$applyChanges1 = @{
  Path = $file1
  Destination = $ENV:_path_coa1
}

if(Compare-Object @lookForChanges1){
  Copy-Item @applyChanges1 -Confirm
}

$file2 = ".\Temp\BIOEngine.ini"
$file2Backup = ".\Temp\BIOEngine.ini.BAK"

$lookForChanges2 = @{
  ReferenceObject = $(Get-Content $file2)
  DifferenceObject = $(Get-Content $file2Backup)
}

$applyChanges2 = @{
  Path = $file2
  Destination = $ENV:_path_bioengine
}

if(Compare-Object @lookForChanges2){
  Copy-Item @applyChanges2 -Confirm
}

$file3 = ".\Temp\BIOGame.ini"
$file3Backup = ".\Temp\BIOGame.ini.BAK"

$lookForChanges3 = @{
  ReferenceObject = $(Get-Content $file3)
  DifferenceObject = $(Get-Content $file3Backup)
}
$applyChanges3 = @{
	Path = $file3
	Destination = $ENV:_path_biogame
}

if(Compare-Object @lookForChanges3){
  Copy-Item @applyChanges3 -Confirm
}

ECHO "$ENV:_fBGreen`Success!$ENV:_RESET File(s) copied!" 