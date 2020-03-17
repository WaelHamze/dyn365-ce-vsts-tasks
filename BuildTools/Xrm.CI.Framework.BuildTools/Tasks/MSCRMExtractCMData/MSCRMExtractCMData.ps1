[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"


Write-Verbose 'Entering MSCRMExtractCMData.ps1'

#Get Parameters
$dataFile = Get-VstsInput -Name dataFile -Require
$extractFolder = Get-VstsInput -Name extractFolder -Require
$sortExtractedData = Get-VstsInput -Name sortExtractedData -AsBool
$splitExtractedData = Get-VstsInput -Name splitExtractedData -AsBool

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
	sortExtractedData = $sortExtractedData
	splitExtractedData = $splitExtractedData
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\ExtractCMData.ps1" @params
}
finally
{

}

Write-Verbose 'Leaving MSCRMExtractCMData.ps1'
