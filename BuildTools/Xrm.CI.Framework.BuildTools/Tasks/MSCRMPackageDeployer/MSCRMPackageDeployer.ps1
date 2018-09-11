[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackageDeployer.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$packageName = Get-VstsInput -Name packageName -Require
$packageDirectory = Get-VstsInput -Name packageDirectory -Require
$crmSdkVersion = Get-VstsInput -Name crmSdkVersion -Require
$pdTimeout = Get-VstsInput -Name pdTimeout -Require
$unpackFilesDirectory = Get-VstsInput -Name unpackFilesDirectory
$runtimePackageSettings = Get-VstsInput -Name runtimePackageSettings

#TFS Release Parameters
$artifactsFolder = $env:AGENT_RELEASEDIRECTORY

#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "packageName = $packageName"
Write-Verbose "packageDirectory = $packageDirectory"
Write-Verbose "artifactsFolder = $artifactsFolder"
Write-Verbose "crmSdkVersion = $crmSdkVersion"
Write-Verbose "pdTimeout = pdTimeout"
Write-Verbose "unpackFilesDirectory = $unpackFilesDirectory"
Write-Verbose "runtimePackageSettings = $runtimePackageSettings"

$LogFile = "$packageDirectory" +"\Microsoft.Xrm.Tooling.PackageDeployment-" + (Get-Date -Format yyyy-MM-dd) + ".log"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

$PackageDeploymentPath = "$mscrmToolsPath\PackageDeployment\$crmSdkVersion"

try
{
	& "$mscrmToolsPath\xRMCIFramework\$crmSdkVersion\DeployPackage.ps1" -CrmConnectionString $crmConnectionString -PackageName $packageName -PackageDirectory $packageDirectory -LogsDirectory $packageDirectory -PackageDeploymentPath $PackageDeploymentPath -Timeout $pdTimeout -unpackFilesDirectory $unpackFilesDirectory -runtimePackageSettings $runtimePackageSettings
}
finally
{
	if (Test-Path "$LogFile")
	{
		Write-Host "##vso[task.uploadfile]$LogFile"
	}
}

Write-Verbose 'Leaving MSCRMPackageDeployer.ps1'
