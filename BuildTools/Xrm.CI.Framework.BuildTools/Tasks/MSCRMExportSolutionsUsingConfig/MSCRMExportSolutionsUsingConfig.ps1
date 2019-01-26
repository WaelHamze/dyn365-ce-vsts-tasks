[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMExportSolutionsUsingConfig.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$configFilePath = Get-VstsInput -Name configFilePath -Require
$outputPath = Get-VstsInput -Name outputPath -Require
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

#Import
try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ExportSolutionsUsingConfig.ps1" -configFilePath "$configFilePath" -crmConnectionString "$CrmConnectionString" -OutputFolder "$outputPath" -Timeout $crmConnectionTimeout
}
catch
{
	$ErrorMessage = $_.Exception.Message

	Write-Host "Exception Caught: $ErrorMessage"
	
	throw
}
finally
{
}

Write-Verbose 'Leaving MSCRMExportSolutionsUsingConfig.ps1'
