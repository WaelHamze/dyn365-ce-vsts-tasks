[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCheckSolution.ps1'

#Get Parameters
$solutionFile = Get-VstsInput -Name solutionFile -Require
$outputPath = Get-VstsInput -Name outputPath -Require
$tenantId = Get-VstsInput -Name tenantId -Require
$applicationId = Get-VstsInput -Name applicationId -Require
$applicationSecret = Get-VstsInput -Name applicationSecret -Require
$rulesetId = Get-VstsInput -Name rulesetId -Require
$geography = Get-VstsInput -Name geography -Require
$enableThresholds = Get-VstsInput -Name enableThresholds -Require -AsBool
$thresholdAction = Get-VstsInput -Name thresholdAction -Require
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

#Logs
if (-not $outputPath)
{
	Write-Verbose "outputPath not supplied"
	
	$outputPath = $env:System_DefaultWorkingDirectory

	Write-Verbose "logsDirectory set to $outputPath"
}

$tempFolder =  "$outputPath\$(New-Guid)"
Write-Verbose "Creating Temp Results Folder: $tempFolder"
New-Item $tempFolder -ItemType directory | Out-Null

$CheckParams = @{
	SolutionFile = "$solutionFile"
	OutputPath = "$tempFolder"
	TenantId = "$tenantId"
	ApplicationId = "$applicationId"
	ApplicationSecret = "$applicationSecret"
	RulesetId = "$rulesetId"
	Geography = "$geography"
	#AzureADPath = "$mscrmToolsPath\AzureAD"
	PowerAppsCheckerPath = "$mscrmToolsPath\PowerAppsChecker"
	EnableThresholds = $enableThresholds
	ThresholdAction = $thresholdAction
	HighThreshold = $highThreshold
	MediumThreshold = $mediumThreshold
	LowThreshold = $lowThreshold
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\CheckSolution.ps1" @CheckParams
}
finally
{
	$resultFile = Get-ChildItem -Path "$tempFolder" -Filter "*.zip"

	if ($resultFile)
	{
		Copy-Item -Path $tempFolder\*.zip -Destination "$OutputPath"

		$outputFile = "$OutputPath\$($resultFile.Name)"

		Write-Host "Uploading check result file: $outputFile"

		Write-Host "##vso[task.uploadfile]$outputFile"

		Write-Host "##vso[task.setvariable variable=SOLUTION_CHECK_RESULT_FILE]$outputFile"

		Write-Verbose "Check result uploaded"

		Remove-Item $tempFolder -Force -Recurse
	}
	else
	{
		Write-Verbose "Result file not found in $OutputPath"
	}
}

Write-Verbose 'Leaving MSCRMExportSolution.ps1'
