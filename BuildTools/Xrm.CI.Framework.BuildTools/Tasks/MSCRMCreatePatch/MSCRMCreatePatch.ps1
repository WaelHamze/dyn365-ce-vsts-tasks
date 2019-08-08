[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCreatePatch.ps1'

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

#Load XrmCIFramework
$xrmCIToolkit = $mscrmToolsPath + "\xRMCIFramework\9.0.0\Xrm.Framework.CI.PowerShell.Cmdlets.dll"
Write-Verbose "Importing CIToolkit: $xrmCIToolkit" 
Import-Module $xrmCIToolkit
Write-Verbose "Imported CIToolkit"

$patchName = Add-XrmSolutionPatch -DisplayName $DisplayName -ParentSolutionUniqueName $UniqueName -VersionNumber $VersionNumber -ConnectionString $crmConnectionString -Timeout $crmConnectionTimeout

Write-Host ("Patch solution created with name: {0}" -f $patchName)

Write-Host "##vso[task.setvariable variable=PATCH_SOLUTION_NAME]$patchName"

Write-Verbose 'Leaving MSCRMCreatePatch.ps1'
