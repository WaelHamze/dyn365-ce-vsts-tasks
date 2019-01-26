[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMImportSolutionsUsingConfig.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$configFilePath = Get-VstsInput -Name configFilePath -Require
$logsDirectory = Get-VstsInput -Name logsDirectory
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "configFilePath = $configFilePath"
Write-Verbose "logsDirectory = $logsDirectory"
Write-Verbose "crmConnectionTimeout = $crmConnectionTimeout"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

#Logs
if (-not $logsDirectory)
{
	$logsDirectory = $env:System_DefaultWorkingDirectory
}
#Import
try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ImportSolutionsUsingConfig.ps1" -configFilePath "$configFilePath" -crmConnectionString "$CrmConnectionString" -logsDirectory "$logsDirectory" -Timeout $crmConnectionTimeout
}
catch
{
	$ErrorMessage = $_.Exception.Message

	Write-Host "Exception Caught: $ErrorMessage"
	
	throw
}
finally
{
	Write-Verbose "Uploading import log files"
	
	Get-ChildItem $logsDirectory -Filter ImportLog*.xml | 
		Foreach-Object {
			$logFile = $_.FullName

			Write-Verbose "Uploading import log $logFile"

			Write-Host "##vso[task.uploadfile]$logFile"

			Write-Verbose "Import log uploaded $logFile"
	}

	Write-Verbose "Completed uploading import log files"
}

Write-Verbose 'Leaving MSCRMImportSolutionsUsingConfig.ps1'
