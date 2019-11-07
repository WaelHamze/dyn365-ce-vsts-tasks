[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMDeleteOnlineInstance.ps1'

$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$sourceInstanceName = Get-VstsInput -Name sourceInstanceName -Require
$targetInstanceName = Get-VstsInput -Name targetInstanceName -Require
$copyType = Get-VstsInput -Name copyType -Require
$friendlyName = Get-VstsInput -Name friendlyName
$securityGroupName = Get-VstsInput -Name securityGroupName 
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

$PSModulePath = "$mscrmToolsPath\OnlineManagementAPI\1.1.0"
$AzureADModulePath = "$mscrmToolsPath\AzureAD"

& "$mscrmToolsPath\xRMCIFramework\9.0.0\CopyOnlineInstance.ps1" -ApiUrl $apiUrl -Username $username -Password $password -sourceInstanceName $sourceInstanceName  -targetInstanceName $targetInstanceName -copyType $copyType -friendlyName "$friendlyName" -securityGroupName "$securityGroupName" -PSModulePath $PSModulePath -azureADModulePath "$AzureADModulePath" -WaitForCompletion $WaitForCompletion -SleepDuration $sleepDuration

Write-Verbose 'Leaving MSCRMRestoreOnlineInstance.ps1'
