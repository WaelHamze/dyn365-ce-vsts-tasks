[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMUpdateConfigurationRecords.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$entityName = Get-VstsInput -Name entityName -Require
$lookupFieldName = Get-VstsInput -Name lookupFieldName -Require
$valueFieldName = Get-VstsInput -Name valueFieldName -Require
$configurationRecordsJson = Get-VstsInput -Name configurationRecordsJson -Require

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "entityName = $entityName"
Write-Verbose "lookupFieldName = $lookupFieldName"
Write-Verbose "valueFieldName = $valueFieldName"
Write-Verbose "configurationRecordsJson = $configurationRecordsJson"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateConfigurationRecords.ps1" -CrmConnectionString $crmConnectionString -entityName $entityName -lookupFieldName $lookupFieldName -valueFieldNames $valueFieldName -configurationRecordsJson $configurationRecordsJson

Write-Verbose 'Leaving MSCRMUpdateConfigurationRecords.ps1'