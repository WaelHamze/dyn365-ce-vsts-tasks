[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCreateSolution.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$UniqueName = Get-VstsInput -Name uniqueName -Require
$DisplayName = Get-VstsInput -Name displayName -Require
$PublisherUniqueName = Get-VstsInput -Name publisherUniqueName -Require
$VersionNumber = Get-VstsInput -Name versionNumber -Require
$Description = Get-VstsInput -Name description
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\CreateSolution.ps1"  -CrmConnectionString $crmConnectionString -UniqueName $UniqueName -DisplayName "$DisplayName" -PublisherUniqueName $PublisherUniqueName -VersionNumber "$VersionNumber" -Description "$Description" -Timeout $crmConnectionTimeout

Write-Verbose 'Leaving MSCRMCreateSolution.ps1'
