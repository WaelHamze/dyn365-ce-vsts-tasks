[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMImportSolution.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionFile = Get-VstsInput -Name solutionFile -Require
$publishWorkflows = Get-VstsInput -Name publishWorkflows -AsBool
$overwriteUnmanagedCustomizations = Get-VstsInput -Name overwriteUnmanagedCustomizations -AsBool
$skipProductUpdateDependencies = Get-VstsInput -Name skipProductUpdateDependencies -AsBool
$convertToManaged = Get-VstsInput -Name convertToManaged -AsBool
$holdingSolution = Get-VstsInput -Name holdingSolution -AsBool
$override = Get-VstsInput -Name override -AsBool
$useAsyncMode = Get-VstsInput -Name useAsyncMode -Require -AsBool
$asyncWaitTimeout = Get-VstsInput -Name asyncWaitTimeout -Require -AsInt
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "solutionFile = $solutionFile"
Write-Verbose "publishWorkflows = $publishWorkflows"
Write-Verbose "overwriteUnmanagedCustomizations = $overwriteUnmanagedCustomizations"
Write-Verbose "skipProductUpdateDependencies = $skipProductUpdateDependencies"
Write-Verbose "convertToManaged = $convertToManaged"
Write-Verbose "holdingSolution = $holdingSolution"
Write-Verbose "override = $override"
Write-Verbose "useAsyncMode = $useAsyncMode"
Write-Verbose "asyncWaitTimeout = $asyncWaitTimeout"
Write-Verbose "crmConnectionTimeout = $crmConnectionTimeout"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

#Logs
$solutionFilename = $solutionFile.Substring($solutionFile.LastIndexOf("\") + 1)
$solutionDirectory = $solutionFile.Substring(0, $solutionFile.LastIndexOf("\"))

$logFilename = $solutionFilename.replace(".zip", "_importlog_" + [System.DateTime]::Now.ToString("yyyy_MM_dd__HH_mm") + ".xml")
$logFile = "$solutionDirectory\$logFilename"

#Import
try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ImportSolution.ps1" -solutionFile "$solutionFile" -crmConnectionString "$CrmConnectionString" -override $override -publishWorkflows $publishWorkflows -overwriteUnmanagedCustomizations $overwriteUnmanagedCustomizations -skipProductUpdateDependencies $skipProductUpdateDependencies -ConvertToManaged $convertToManaged -HoldingSolution $holdingSolution -logsDirectory "$solutionDirectory" -logFileName "$logFilename" -ImportAsync $useAsyncMode -AsyncWaitTimeout $asyncWaitTimeout -Timeout $crmConnectionTimeout
}
catch
{
	throw
}
finally
{
	if (Test-Path "$logFile")
	{
		Write-Verbose "Uploading import log $logFile"

		Write-Host "##vso[task.setvariable variable=SOLUTION_IMPORT_LOG_FILE]$logFile"

		Write-Host "##vso[task.uploadfile]$logFile"

		Write-Verbose "Import log uploaded"
	}
	else
	{
		Write-Verbose "Import log not found $logFile"
	}
}

Write-Verbose 'Leaving MSCRMImportSolution.ps1'
