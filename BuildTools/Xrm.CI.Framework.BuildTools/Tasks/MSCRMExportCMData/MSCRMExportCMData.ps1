[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"


Write-Verbose 'Entering MSCRMExportCMData.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$schemaFile = Get-VstsInput -Name schemaFile -Require
$dataFile = Get-VstsInput -Name dataFile -Require
$logsDirectory = Get-VstsInput -Name logsDirectory
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#TFS Build Parameters
$buildNumber = $env:BUILD_BUILDNUMBER
$sourcesDirectory = $env:BUILD_SOURCESDIRECTORY
$binariesDirectory = $env:BUILD_BINARIESDIRECTORY

Write-Verbose "buildNumber = $buildNumber"
Write-Verbose "sourcesDirectory = $sourcesDirectory"
Write-Verbose "binariesDirectory = $binariesDirectory"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 10

$configMigration = 'Microsoft.Xrm.Tooling.ConfigurationMigration'
$configMigrationInfo = Get-MSCRMToolInfo -toolName $configMigration
$configMigrationInfoPath = "$($configMigrationInfo.Path)"
Require-ToolVersion -toolName $configMigration -version $configMigrationInfo.Version -minVersion '1.0.0.26'
Use-MSCRMTool -toolName $configMigration -version $configMigrationInfo.Version

$CrmConnector = 'Microsoft.Xrm.Tooling.CrmConnector.PowerShell'
$CrmConnectorInfo = Get-MSCRMToolInfo -toolName $CrmConnector
$CrmConnectorPath = "$($CrmConnectorInfo.Path)"
Use-MSCRMTool -toolName $CrmConnector -version $CrmConnectorInfo.Version

#Logs
if (-not $logsDirectory)
{
	Write-Verbose "logsDirectory not supplied"
	
	$logsDirectory = $env:System_DefaultWorkingDirectory

	Write-Verbose "logsDirectory set to $logsDirectory"
}

$params = @{
	crmConnectionString = "$crmConnectionString"
	crmConnectionTimeout = $crmConnectionTimeout
	dataFile = "$dataFile"
	schemaFile = "$schemaFile"
	logsDirectory = "$logsDirectory"
	configurationMigrationModulePath = "$configMigrationInfoPath"
	toolingConnectorModulePath = "$CrmConnectorPath"
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ExportCMData.ps1" @params
}
finally
{
	$Logs = Get-ChildItem "$logsDirectory" -Filter *.log

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

Write-Verbose 'Leaving MSCRMExportCMData.ps1'
