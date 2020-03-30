[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMGetSolution.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionName = Get-VstsInput -Name solutionName -Require
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt
$existsVariableName = Get-VstsInput -Name existsVariableName
$versionVariableName = Get-VstsInput -Name versionVariableName
$displayVariableName = Get-VstsInput -Name displayVariableName

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

$solution = Get-XrmSolution -UniqueSolutionName $solutionName -ConnectionString $crmConnectionString -Timeout $crmConnectionTimeout

if ($solution)
{
	$exists = $true
	$version = $($solution.Version)
	$display  = $($solution.FriendlyName)
	
	Write-Host "Solution Display Name: $display"
	Write-Host "Solution Version: $version"
}
else
{
	Write-Host "Solution $solutionName does not exist"
	
	$exists = $false
	$version = ''
	$display  = ''
}

Write-Host "##vso[task.setvariable variable=SOLUTION_EXISTS]$exists"
Write-Host "##vso[task.setvariable variable=SOLUTION_VERSION]$version"
Write-Host "##vso[task.setvariable variable=SOLUTION_DISPLAY_NAME]$display"

if ($existsVariableName)
{
	Write-Host "##vso[task.setvariable variable=$existsVariableName]$exists"
}
if ($versionVariableName)
{
	Write-Host "##vso[task.setvariable variable=$versionVariableName]$version"
}
if ($displayVariableName)
{
	Write-Host "##vso[task.setvariable variable=$displayVariableName]$display"
}

Write-Verbose 'Leaving MSCRMGetSolution.ps1'
