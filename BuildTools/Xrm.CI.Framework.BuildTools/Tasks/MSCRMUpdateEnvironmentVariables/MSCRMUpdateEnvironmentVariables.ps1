[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Verbose 'Entering MSCRMUpdateEnvironmentVariables.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$environmentVariablesJson = Get-VstsInput -Name environmentVariablesJson -Require

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "environmentVariablesJson = $environmentVariablesJson"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateEnvironmentVariables.ps1" -CrmConnectionString $crmConnectionString -environmentVariablesJson "$environmentVariablesJson"

Write-Verbose 'Leaving MSCRMUpdateEnvironmentVariables.ps1'