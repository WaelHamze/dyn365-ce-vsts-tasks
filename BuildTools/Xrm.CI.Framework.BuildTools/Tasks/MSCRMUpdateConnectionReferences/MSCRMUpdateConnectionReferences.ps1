[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Verbose 'Entering MSCRMUpdateEnvironmentVariables.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$connectionReferencesJson = Get-VstsInput -Name connectionReferencesJson -Require

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "connectionReferencesJson = $connectionReferencesJson"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateConnectionReferences.ps1" -CrmConnectionString $crmConnectionString -ConnectionReferencesJson "$connectionReferencesJson"

Write-Verbose 'Leaving MSCRMUpdateEnvironmentVariables.ps1'