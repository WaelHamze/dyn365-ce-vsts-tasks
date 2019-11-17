[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCheckerQualityGate.ps1'

#Get Parameters
$resultsFile = Get-VstsInput -Name resultsFile
$thresholdAction = Get-VstsInput -Name thresholdAction -Require
$criticalThreshold = Get-VstsInput -Name criticalThreshold -Require -AsInt
$highThreshold = Get-VstsInput -Name highThreshold -Require -AsInt
$mediumThreshold = Get-VstsInput -Name mediumThreshold -Require -AsInt
$lowThreshold = Get-VstsInput -Name lowThreshold -Require -AsInt

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

#Check File
$analysisFile = ''
$lastCheckResult = $env:LAST_SOLUTION_CHECK_RESULT_FILE

if ($resultsFile -and ($resultsFile -ne $env:System_DefaultWorkingDirectory))
{
	$analysisFile = $resultsFile
}
elseif ($lastCheckResult)
{
	$analysisFile = $lastCheckResult
}
else
{
	throw "Either 'Checker Results File' needs to be provided or 'MSCRM Check Solution' must be executed before this task in the same agent phase"
}

Write-Host "Performing Quality Gate using results file: $analysisFile"

$CheckParams = @{
	ResultsFile = "$analysisFile"
	ThresholdAction = $thresholdAction
	HighThreshold = $highThreshold
	MediumThreshold = $mediumThreshold
	LowThreshold = $lowThreshold
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\CheckerQualityGate.ps1" @CheckParams

Write-Verbose 'Leaving MSCRMCheckerQualityGate.ps1'
