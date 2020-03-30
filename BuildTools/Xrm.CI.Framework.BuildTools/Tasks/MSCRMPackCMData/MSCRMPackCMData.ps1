[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"


Write-Verbose 'Entering MSCRMPackCMData.ps1'

#Get Parameters
$dataFile = Get-VstsInput -Name dataFile -Require
$extractFolder = Get-VstsInput -Name extractFolder -Require
$combineDataXmlFile = Get-VstsInput -Name combineDataXmlFile -AsBool

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
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

#Logs
if (-not $logsDirectory)
{
	Write-Verbose "logsDirectory not supplied"
	
	$logsDirectory = $env:System_DefaultWorkingDirectory

	Write-Verbose "logsDirectory set to $logsDirectory"
}

$params = @{
	dataFile = "$dataFile"
	extractFolder = "$extractFolder"
	combineDataXmlFile = $combineDataXmlFile
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\PackCMData.ps1" @params
}
finally
{

}

Write-Verbose 'Leaving MSCRMPackCMData.ps1'
