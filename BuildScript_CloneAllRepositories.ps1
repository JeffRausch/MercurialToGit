
#The AllHGRepositories.json file is simply grabbed from the Chrome developer tool when you load the SCM Respositores page.
#  You will see a call to get Repositories.json

#Read the file into an object
$allRepositories = Get-Content "C:\Temp\AllHGRepositories.json" | ConvertFrom-Json

$clonePath = "C:\Temp\Mercurial\CloneAllRepositories.bat"
$tmpPath = "C:\Temp\Mercurial\CloneAllRepositories.tmp"
$pullPath = "C:\Temp\Mercurial\PullAllRepositories.bat"

#Delete the old file
if (Test-Path $clonePath){
    Remove-Item $clonePath
}

if (Test-Path $tmpPath){
    Remove-Item $tmpPath
}

$allRepositories | Sort-Object name | ForEach-Object {
	if (!($_.archived)){
		Write-Output "hg clone $($_.url)" >> $tmpPath
	}
}

#Copy the temp file to a new one with UTF8 and no BOM
[System.IO.File]::WriteAllLines($clonePath, (Get-Content $tmpPath))
    
#Remove the pull file
if (Test-Path $pullPath){
    Remove-Item $pullPath
}

$contents = Get-Content $tmpPath
[System.IO.File]::WriteAllLines($pullPath, ($contents -replace 'clone', 'pull'))

#Remove the temp file
if (Test-Path $tmpPath){
    Remove-Item $tmpPath
}