[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMGetSolutionMissingDependencies.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionName = Get-VstsInput -Name solutionName -Require
$warnIfMissing = Get-VstsInput -Name warnIfMissing -AsBool
$errorIfMissing = Get-VstsInput -Name errorIfMissing -AsBool
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

#Get Missing Components

& "$mscrmToolsPath\xRMCIFramework\9.0.0\GetSolutionMissingDependencies.ps1" -solutionName "$solutionName" -crmConnectionString "$CrmConnectionString" -warnIfMissing $warnIfMissing -errorIfMissing $errorIfMissing -Timeout $crmConnectionTimeout


Write-Verbose 'Leaving MSCRMGetSolutionMissingDependencies.ps1'
