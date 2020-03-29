[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMBackupOnlineInstance.ps1'

#Get Parameters
$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$instanceName = Get-VstsInput -Name instanceName -Require
$backupLabel = Get-VstsInput -Name backupLabel -Require
$notes = Get-VstsInput -Name notes
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt
$backupExistsAction = Get-VstsInput -Name backupExistsAction -Require

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$onlineAPI = 'Microsoft.Xrm.OnlineManagementAPI'
$onlineAPIInfo = Get-MSCRMTool -toolName $onlineAPI 
Require-ToolVersion -toolName $onlineAPI -version $onlineAPIInfo.Version -minVersion '1.2.0.1'
$onlineAPIPath = "$($onlineAPIInfo.Path)"

& "$mscrmToolsPath\xRMCIFramework\9.0.0\BackupOnlineInstance.ps1" -ApiUrl $apiUrl -Username $username -Password $password -InstanceName $instanceName -BackupLabel "$backupLabel" -BackupNotes "$notes" -WaitForCompletion $waitForCompletion -SleepDuration $sleepDuration -PSModulePath $onlineAPIPath -BackupExistsAction $backupExistsAction

Write-Verbose 'Leaving MSCRMBackupOnlineInstance.ps1'
