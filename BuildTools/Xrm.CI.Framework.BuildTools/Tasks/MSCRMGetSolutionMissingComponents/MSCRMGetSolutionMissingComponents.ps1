[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMGetSolutionMissingComponents.ps1.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionFile = Get-VstsInput -Name solutionFile -Require
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

& "$mscrmToolsPath\xRMCIFramework\9.0.0\GetSolutionMissingComponents.ps1" -solutionFile "$solutionFile" -crmConnectionString "$CrmConnectionString" -warnIfMissing $warnIfMissing -errorIfMissing $errorIfMissing -Timeout $crmConnectionTimeout


Write-Verbose 'Leaving MSCRMGetSolutionMissingComponents.ps1'
