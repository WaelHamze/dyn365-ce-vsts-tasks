[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMGetConfigurationRecord.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$entityName = Get-VstsInput -Name entityName -Require
$lookupFieldName = Get-VstsInput -Name lookupFieldName -Require
$valueFieldName = Get-VstsInput -Name valueFieldName -Require
$lookupValue = Get-VstsInput -Name lookupValue -Require
$existsVariableName = Get-VstsInput -Name existsVariableName
$valueVariableName = Get-VstsInput -Name valueVariableName

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

$records = Get-XrmEntities -ConnectionString $CrmConnectionString -EntityName $EntityName -Attribute $LookupFieldName -Value $lookupValue -ConditionOperator 0

if ($records.Count -eq 1)
{
	$record = $records[0]

	Write-Host ("Records found for: {0}" -f $lookupValue)
	Write-Host ("Record Id: {0}" -f $records.Id)

	$exists = $true
	$recordValue = $record.Attributes[$valueFieldName]

	Write-Host ("Record Value: {0}" -f $recordValue)
}
elseif ($records.Count -eq 0)
{
	$exists = $false
	$recordValue = ''

	Write-Host ("No records found for: {0}" -f $lookupValue)
}
else
{
	Write-Error ("Multiple matches found for {0}" -f $lookupValue)
}

Write-Host "##vso[task.setvariable variable=RECORD_EXISTS]$exists"
Write-Host "##vso[task.setvariable variable=RECORD_VALUE]$recordValue"

if ($existsVariableName)
{
	Write-Host "##vso[task.setvariable variable=$existsVariableName]$exists"
}
if ($valueVariableName)
{
	Write-Host "##vso[task.setvariable variable=$valueVariableName]$recordValue"
}


Write-Verbose 'Leaving MSCRMGetConfigurationRecord.ps1'