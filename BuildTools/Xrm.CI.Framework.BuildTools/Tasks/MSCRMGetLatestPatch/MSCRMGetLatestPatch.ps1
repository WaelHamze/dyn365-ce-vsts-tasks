[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMGetLatest.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionName = Get-VstsInput -Name solutionName -Require
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt
$existsVariableName = Get-VstsInput -Name existsVariableName
$patchVariableName = Get-VstsInput -Name patchVariableName

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

#Load XrmCIFramework
$xrmCIToolkit = $mscrmToolsPath + "\xRMCIFramework\9.0.0\Xrm.Framework.CI.PowerShell.Cmdlets.dll"
Write-Verbose "Importing CIToolkit: $xrmCIToolkit" 
Import-Module $xrmCIToolkit
Write-Verbose "Imported CIToolkit"

$patches = Get-XrmSolutionPatches -UniqueSolutionName $solutionName -ConnectionString $crmConnectionString -Timeout $crmConnectionTimeout

if ($patches.Count -gt 0)
{
	$latest = $patches[0]
	
	$exists = $true
	$name = $($latest.UniqueName)
		
	Write-Host "Patch Name: $name"
}
else
{
	Write-Host "Patch for solution $solutionName does not exist"
	
	$exists = $false
	$name = ''
}

Write-Host "##vso[task.setvariable variable=PATCH_EXISTS]$exists"
Write-Host "##vso[task.setvariable variable=PATCH_NAME]$name"

if ($existsVariableName)
{
	Write-Host "##vso[task.setvariable variable=$existsVariableName]$exists"
}
if ($patchVariableName)
{
	Write-Host "##vso[task.setvariable variable=$patchVariableName]$name"
}

Write-Verbose 'Leaving MSCRMGetLatest.ps1'
