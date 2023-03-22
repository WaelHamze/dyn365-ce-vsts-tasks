[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMShareFlow.ps1'

#Get Parameters
$ppServiceEndpointName = Get-VstsInput -Name ppServiceEndpoint -Require
$ppServiceEndpoint = Get-VstsEndpoint -Name $ppServiceEndpointName -Require

$shareType = Get-VstsInput -Name shareType -Require
$flowName = Get-VstsInput -Name flowName
$roleName = Get-VstsInput -Name roleName
$principalType = Get-VstsInput -Name principalType
$principal = Get-VstsInput -Name principal
$shareConfigFile = Get-VstsInput -Name shareConfigFile

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

$msalPS = 'MSAL.PS'
$msalPSInfo = Get-MSCRMTool -toolName $msalPS
Require-ToolVersion -toolName $msalPS -version $msalPSInfo.Version -minVersion '4.37.0'
$msalPSPath = "$($msalPSInfo.Path)"

$mgUsers = 'Microsoft.Graph.Users'
$mgUsersInfo = Get-MSCRMTool -toolName $mgUsers 
Require-ToolVersion -toolName $mgUsers -version $mgUsersInfo.Version -minVersion '1.9.2'
$mgUsersPath = "$($mgUsersInfo.Path)"

$mgGroups = 'Microsoft.Graph.Groups'
$mgGroupsInfo = Get-MSCRMTool -toolName $mgGroups 
Require-ToolVersion -toolName $mgGroups -version $mgGroupsInfo.Version -minVersion '1.9.2'
$mgGroupsPath = "$($mgGroupsInfo.Path)"

$CrmConnector = 'Microsoft.Xrm.Tooling.CrmConnector.PowerShell'
$CrmConnectorInfo = Get-MSCRMTool -toolName $CrmConnector
$CrmConnectorPath = "$($CrmConnectorInfo.Path)"

$powerAppsAdmin = 'Microsoft.PowerApps.Administration.PowerShell'
$powerAppsAdminInfo = Get-MSCRMTool -toolName $powerAppsAdmin 
Require-ToolVersion -toolName $powerAppsAdmin -version $powerAppsAdminInfo.Version -minVersion '2.0.142'
$powerAppsAdminPath = "$($powerAppsAdminInfo.Path)"

if ($shareType -eq "Advanced")
{
	$flowsToShareJson = (Get-Content "$shareConfigFile" -Raw)
}
else
{
	$flowsToShareJson = "{`"FlowSharing`":[{`"FlowName`":`"$FlowName`",`"ShareWith`":[{`"PrincipalType`":`"$principalType`",`"Principal`":`"$principal`",`"RoleName`":`"$roleName`"}]}]}"
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\ShareFlows.ps1" .\ShareFlows.ps1 -TenantId $TenantId -ApplicationId $ApplicationId -ApplicationSecret $ClientSecret -EnvironmentUrl "$EnvironmentUrl" -FlowsToShareJson $flowsToShareJson -MSALModulePath $msalPSPath -MGUsersModulePath $mgUsersPath -MGGroupsModulePath $mgGroupsPath -PowerAppsAdminModulePath $powerAppsAdminPath -CrmConnectorModulePath $CrmConnectorPath

Write-Verbose 'Leaving MSCRMShareFlow.ps1'