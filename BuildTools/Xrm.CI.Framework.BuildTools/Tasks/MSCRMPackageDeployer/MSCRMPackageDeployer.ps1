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
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt
$unpackFilesDirectory = Get-VstsInput -Name unpackFilesDirectory
$runtimePackageSettings = Get-VstsInput -Name runtimePackageSettings

#TFS Release Parameters
$artifactsFolder = $env:AGENT_RELEASEDIRECTORY

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

$PackageDeploymentPath = "$mscrmToolsPath\PackageDeployment\$crmSdkVersion"

$tempFolder =  "$packageDirectory\$(New-Guid)"
Write-Verbose "Creating Temp Logs Folder: $tempFolder"
New-Item $tempFolder -ItemType directory | Out-Null

try
{
	& "$mscrmToolsPath\xRMCIFramework\$crmSdkVersion\DeployPackage.ps1" -CrmConnectionString $crmConnectionString -PackageName $packageName -PackageDirectory $packageDirectory -LogsDirectory $tempFolder -PackageDeploymentPath $PackageDeploymentPath -Timeout $pdTimeout -crmConnectionTimeout $crmConnectionTimeout -unpackFilesDirectory $unpackFilesDirectory -runtimePackageSettings $runtimePackageSettings
}
finally
{
	$Logs = Get-ChildItem "$tempFolder" -Filter *.log

	Write-Verbose "$($Logs.Length) log files found"

	foreach($LogFile in $Logs)
	{
		try
		{
			Write-Host "##vso[task.uploadfile]$($LogFile.FullName)"
		}
		catch
		{
			Write-Warning "Unable to upload $($LogFile.FullName)"
			$_
		}
	}
}

Write-Verbose 'Leaving MSCRMPackageDeployer.ps1'
