[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCloneSolution.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$UniqueName = Get-VstsInput -Name uniqueName -Require
$DisplayName = Get-VstsInput -Name displayName
$VersionNumber = Get-VstsInput -Name versionNumber
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\CloneSolution.ps1"  -CrmConnectionString $crmConnectionString -ParentSolutionUniqueName $UniqueName -DisplayName "$DisplayName" -VersionNumber "$VersionNumber" -Timeout $crmConnectionTimeout

Write-Verbose 'Leaving MSCRMCloneSolution.ps1'
