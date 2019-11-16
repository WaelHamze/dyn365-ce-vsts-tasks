[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Verbose 'Entering MSCRMGetEnvironmentVariable.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$variableName = Get-VstsInput -Name variableName -Require
$valueVariableName = Get-VstsInput -Name valueVariableName
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

$value = Get-XrmEnvironmentVariableValue -Name $variableName -ConnectionString $crmConnectionString -Timeout $crmConnectionTimeout

Write-Host "##vso[task.setvariable variable=ENVIRONMENTVARIABLE_VALUE]$value"

if ($valueVariableName)
{
	Write-Host "##vso[task.setvariable variable=$valueVariableName]$value"
}

Write-Verbose 'Leaving MSCRMGetEnvironmentVariable.ps1'
