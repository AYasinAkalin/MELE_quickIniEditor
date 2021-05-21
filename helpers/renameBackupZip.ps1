$n = "Originals $(Get-Date -Format "yyyy-MM-dd HH-mm")"

$i = 1
$fn = $n
WHILE (Test-Path -Path ".\Backup\$fn.zip"){
	$i++;
	$fn = "$n ($i)"
}
Rename-Item -Path .\Backup\Originals.zip -NewName "$fn.zip"
ECHO "$ENV:_fBGreen`Success!$ENV:_RESET Backup file created at: $ENV:_fBWhite$ENV:_bBBlue$(Get-Location)\Backup\$fn.zip$ENV:_RESET"