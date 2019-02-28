#
# Make.ps1
# 
# Run this script to generate the tasks folder structure and extension
#

$ErrorActionPreference = "Stop"

Write-Host "Packaging Dynamics 365 Builds tools"

#Script Location
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Host "Script Path: $scriptPath"


#Creating output directory
$OutputDir = $scriptPath + "\bin"

if (Test-Path $OutputDir)
{
	Remove-Item $OutputDir -Force -Recurse
}

New-Item $OutputDir -ItemType directory | Out-Null

#Creating temp directory
$TempDir = $scriptPath + "\temp"

if (Test-Path $TempDir)
{
	Remove-Item $TempDir -Force -Recurse
}

New-Item $TempDir -ItemType directory | Out-Null

#Copy Extension Files
Copy-Item .\icon_128x128.png $OutputDir -Force -Recurse
Copy-Item .\license.txt $OutputDir -Force -Recurse
Copy-Item .\overview.md $OutputDir -Force -Recurse
Copy-Item .\vss-extension.json $OutputDir -Force -Recurse
Copy-Item .\Images $OutputDir -Force -Recurse
Copy-Item .\Screenshots $OutputDir -Force -Recurse

#Copy Initial Tasks
Copy-Item -Path .\Tasks -Destination $OutputDir -Recurse

$tasks = Get-ChildItem .\Tasks -directory

foreach($task in $tasks)
{
	Copy-Item -Path .\icon.png -Destination "$OutputDir\Tasks\$task"
	New-Item "$OutputDir\Tasks\$task\ps_modules\VstsTaskSdk" -ItemType directory | Out-Null
	Copy-Item -Path .\Lib\VstsTaskSdk\0.10.0\*.* -Destination "$OutputDir\Tasks\$task\ps_modules\VstsTaskSdk"
}

#MSCRMToolInstaller
$taskName = "MSCRMToolInstaller"
New-Item "$OutputDir\Tasks\$taskName\Lib\xRMCIFramework\8.2.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\xRMCIFramework\9.0.0\*.* -Destination "$OutputDir\Tasks\$taskName\Lib\xRMCIFramework\8.2.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\xRMCIFramework\9.0.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\xRMCIFramework\9.0.0\*.* -Destination "$OutputDir\Tasks\$taskName\Lib\xRMCIFramework\9.0.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\CoreTools\8.2.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\Microsoft.CrmSdk.CoreTools\8.2.0\SolutionPackager.exe -Destination "$OutputDir\Tasks\$taskName\Lib\CoreTools\8.2.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\CoreTools\9.0.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\Microsoft.CrmSdk.CoreTools\9.0.0\SolutionPackager.exe -Destination "$OutputDir\Tasks\$taskName\Lib\CoreTools\9.0.0"
Copy-Item -Path .\Lib\Microsoft.CrmSdk.CoreTools\9.0.0\SolutionPackager.exe.config -Destination "$OutputDir\Tasks\$taskName\Lib\CoreTools\9.0.0"
Copy-Item -Path .\Lib\Microsoft.CrmSdk.CoreTools\9.0.0\System.ValueTuple.dll -Destination "$OutputDir\Tasks\$taskName\Lib\CoreTools\9.0.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\OnlineManagementAPI\1.0.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\Microsoft.Xrm.OnlineManagementAPI\1.0.0\*.* -Destination "$OutputDir\Tasks\$taskName\Lib\OnlineManagementAPI\1.0.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\PackageDeployment\8.2.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\Microsoft.CrmSdk.XrmTooling.PackageDeployment.PowerShell\8.2.0\*.* -Destination "$OutputDir\Tasks\$taskName\Lib\PackageDeployment\8.2.0"
New-Item "$OutputDir\Tasks\$taskName\Lib\PackageDeployment\9.0.0" -ItemType directory | Out-Null
Copy-Item -Path .\Lib\Microsoft.CrmSdk.XrmTooling.PackageDeployment.PowerShell\9.0.0\*.* -Destination "$OutputDir\Tasks\$taskName\Lib\PackageDeployment\9.0.0"

#Clean Up
Remove-Item $TempDir -Force -Recurse
