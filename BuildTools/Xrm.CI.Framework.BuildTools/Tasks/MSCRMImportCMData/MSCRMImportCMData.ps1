[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"


Write-Verbose 'Entering MSCRMImportCMData.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$concurrentThreads = Get-VstsInput -Name concurrentThreads -AsInt
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
	concurrentThreads = $concurrentThreads
	logsDirectory = "$logsDirectory"
	configurationMigrationModulePath = "$mscrmToolsPath\Microsoft.Xrm.Tooling.ConfigurationMigration\1.0.0.12"
	toolingConnectorModulePath = "$mscrmToolsPath\Microsoft.Xrm.Tooling.CrmConnector.PowerShell\3.3.0.857"
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ImportCMData.ps1" @params
}
finally
{

}

Write-Verbose 'Leaving MSCRMImportCMData.ps1'
