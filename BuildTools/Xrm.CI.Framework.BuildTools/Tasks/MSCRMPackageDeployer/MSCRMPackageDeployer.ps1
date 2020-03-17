[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackageDeployer.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$packagePath = Get-VstsInput -Name packagePath -Require
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
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

if (-not($packagePath -match ".dll"))
{
	throw "$packagePath should be full path to package dll"
}

$packageDirectory = Split-Path $packagePath
$packageName = Split-Path $packagePath -leaf

Write-Host "Package Directory: $packageDirectory"
Write-Host "Package Name: $packageName"

Require-ToolsTaskVersion -version 12

$PackageDeployment = 'Microsoft.Xrm.Tooling.PackageDeployment.Powershell'
$PackageDeploymentInfo = Get-MSCRMToolInfo -toolName $PackageDeployment
$PackageDeploymentPath = "$($PackageDeploymentInfo.Path)"
Use-MSCRMTool -toolName $PackageDeployment -version $PackageDeploymentInfo.Version

$CrmConnector = 'Microsoft.Xrm.Tooling.CrmConnector.PowerShell'
$CrmConnectorInfo = Get-MSCRMToolInfo -toolName $CrmConnector
$CrmConnectorPath = "$($CrmConnectorInfo.Path)"
Use-MSCRMTool -toolName $CrmConnector -version $CrmConnectorInfo.Version

#Temp Directory
if ($env:AGENT_TEMPDIRECTORY)
{
	$tempDir = $env:AGENT_TEMPDIRECTORY
}
else
{
	$tempDir = $env:TEMP
}
$tempFolder =  "$tempDir\$(New-Guid)"
Write-Verbose "Creating Temp Logs Folder: $tempFolder"
New-Item $tempFolder -ItemType directory | Out-Null

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\DeployPackage.ps1" -CrmConnectionString $crmConnectionString -PackageName $packageName -PackageDirectory $packageDirectory -LogsDirectory $tempFolder -toolingConnectorModulePath $CrmConnectorPath -PackageDeploymentPath $PackageDeploymentPath -Timeout $pdTimeout -crmConnectionTimeout $crmConnectionTimeout -unpackFilesDirectory $unpackFilesDirectory -runtimePackageSettings $runtimePackageSettings
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
