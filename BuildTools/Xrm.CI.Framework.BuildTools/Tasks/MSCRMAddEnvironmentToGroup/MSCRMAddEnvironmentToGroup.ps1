[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMAddEnvironmentToGroup.ps1'

#Get Parameters
$ppServiceEndpointName = Get-VstsInput -Name ppServiceEndpoint -Require
$ppServiceEndpoint = Get-VstsEndpoint -Name $ppServiceEndpointName -Require

$ppEnvironment = Get-VstsInput -Name ppEnvironment -Require
$ppGroupId = Get-VstsInput -Name ppGroupId -Require

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
Write-Verbose "Username: $Username"
Write-Verbose "Password: $Password"

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

$powerAppsCLI = 'Microsoft.PowerApps.CLI'
$powerAppsCLIInfo = Get-MSCRMTool -toolName $powerAppsCLI
Require-ToolVersion -toolName $powerAppsCLI -version $powerAppsCLIInfo.Version -minVersion '1.38.3'
$powerAppsCLIPath = "$($powerAppsCLIInfo.Path)\tools"

& "$mscrmToolsPath\xRMCIFramework\9.0.0\AddEnvironmentToGroup.ps1" -TenantId $TenantId -ApplicationId $ApplicationId -ApplicationSecret $ClientSecret -Username "$Username" -Password "$Password" -Environment "$ppEnvironment" -GroupId $ppGroupId -PowerAppsCLIPath $powerAppsCLIPath

Write-Verbose 'Leaving MSCRMAddEnvironmentToGroup.ps1'
