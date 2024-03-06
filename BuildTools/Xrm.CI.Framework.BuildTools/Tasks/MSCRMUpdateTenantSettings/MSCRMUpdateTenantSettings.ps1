[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMUpdateTenantSettings.ps1'

#Get Parameters
$ppServiceEndpointName = Get-VstsInput -Name ppServiceEndpoint -Require
$ppServiceEndpoint = Get-VstsEndpoint -Name $ppServiceEndpointName -Require
$settingsConfigFile = Get-VstsInput -Name settingsConfigFile -Require

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

$powerAppsAdmin = 'Microsoft.PowerApps.Administration.PowerShell'
$powerAppsAdminInfo = Get-MSCRMTool -toolName $powerAppsAdmin 
Require-ToolVersion -toolName $powerAppsAdmin -version $powerAppsAdminInfo.Version -minVersion '2.0.142'
$powerAppsAdminPath = "$($powerAppsAdminInfo.Path)"

$settingsConfigJson = (Get-Content "$settingsConfigFile" -Raw)

& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateTenantSettings.ps1" -TenantId $TenantId -ApplicationId $ApplicationId -ApplicationSecret $ClientSecret -TenantSettingsJson $settingsConfigJson -PowerAppsAdminModulePath $powerAppsAdminPath

Write-Verbose 'Leaving MSCRMSharePowerApp.ps1'