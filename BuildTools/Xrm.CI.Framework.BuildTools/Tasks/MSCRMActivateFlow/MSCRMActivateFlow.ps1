[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMActivateFlow.ps1'

#Get Parameters
$ppServiceEndpointName = Get-VstsInput -Name ppServiceEndpoint -Require
$ppServiceEndpoint = Get-VstsEndpoint -Name $ppServiceEndpointName -Require

$activateType = Get-VstsInput -Name activateType -Require
$flowName = Get-VstsInput -Name flowName
$state = Get-VstsInput -Name state
$activateConfigFile = Get-VstsInput -Name activateConfigFile

$EnvironmentUrl = $ppServiceEndpoint.Url

$ApplicationId = $ppServiceEndpoint.Auth.Parameters.ApplicationId
$ClientSecret = $ppServiceEndpoint.Auth.Parameters.ClientSecret
$TenantId = $ppServiceEndpoint.Auth.Parameters.TenantId

$Username = $ppServiceEndpoint.Auth.Parameters.Username
$Password = $ppServiceEndpoint.Auth.Parameters.Password

Write-Verbose "Environment Url: $EnvironmentUrl"
Write-Verbose "Application Id: $ApplicationId"
Write-Verbose "ClientSecret: $ClientSecret"
Write-Verbose "TenantId: $TenantId"

#Script Location
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script Path: $scriptPath"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$CrmConnector = 'Microsoft.Xrm.Tooling.CrmConnector.PowerShell'
$CrmConnectorInfo = Get-MSCRMTool -toolName $CrmConnector
$CrmConnectorPath = "$($CrmConnectorInfo.Path)"

$powerAppsAdmin = 'Microsoft.PowerApps.Administration.PowerShell'
$powerAppsAdminInfo = Get-MSCRMTool -toolName $powerAppsAdmin 
Require-ToolVersion -toolName $powerAppsAdmin -version $powerAppsAdminInfo.Version -minVersion '2.0.142'
$powerAppsAdminPath = "$($powerAppsAdminInfo.Path)"

if ($activateType -eq "Advanced")
{
	$flowsToActivateJson = (Get-Content "$activateConfigFile" -Raw)
}
else
{
	$flowsToActivateJson = "{`"Flows`":[{`"FlowName`":`"$FlowName`",`"State`":`"$state`"}]}"
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\ActivateFlows.ps1" -TenantId $TenantId -ApplicationId $ApplicationId -ApplicationSecret $ClientSecret -EnvironmentUrl "$EnvironmentUrl" -FlowsToActivateJson $flowsToActivateJson -PowerAppsAdminModulePath $powerAppsAdminPath -CrmConnectorModulePath $CrmConnectorPath

Write-Verbose 'Leaving MSCRMActivateFlow.ps1'