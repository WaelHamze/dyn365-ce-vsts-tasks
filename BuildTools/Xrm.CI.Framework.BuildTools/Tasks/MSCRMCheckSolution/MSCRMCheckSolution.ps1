[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMCheckSolution.ps1'

#Get Parameters
$solutionFile = Get-VstsInput -Name solutionFile -Require
$resultsVariableName = Get-VstsInput -Name resultsVariableName
$tenantId = Get-VstsInput -Name tenantId -Require
$applicationId = Get-VstsInput -Name applicationId -Require
$applicationSecret = Get-VstsInput -Name applicationSecret -Require
$ruleType = Get-VstsInput -Name ruleType -Require
$ruleset = Get-VstsInput -Name ruleset
$ruleCodes = Get-VstsInput -Name ruleCodes
$excludedFiles = Get-VstsInput -Name excludedFiles
$ruleLevelOverrides = Get-VstsInput -Name ruleLevelOverrides
$geography = Get-VstsInput -Name geography -Require

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

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$powerappChecker = 'Microsoft.PowerApps.Checker.PowerShell'
$powerappCheckerInfo = Get-MSCRMTool -toolName $powerappChecker
$powerappCheckerPath = "$($powerappCheckerInfo.Path)"
Require-ToolVersion -toolName $powerappChecker -version $powerappCheckerInfo.Version -minVersion '1.0.0.26'

#Logs
	
$outputPath = $env:System_DefaultWorkingDirectory
Write-Verbose "outputPath set to $outputPath"

$tempFolder =  "$outputPath\$(New-Guid)"
Write-Verbose "Creating Temp Results Folder: $tempFolder"
New-Item $tempFolder -ItemType directory | Out-Null

#Checker

$CheckParams = @{
	SolutionFile = "$solutionFile"
	OutputPath = "$tempFolder"
	TenantId = "$tenantId"
	ApplicationId = "$applicationId"
	ApplicationSecret = "$applicationSecret"
	Geography = "$geography"
	PowerAppsCheckerPath = "$powerappCheckerPath"
	RuleOverridesJson = $ruleLevelOverrides
}

if ($ruleType -eq 'RuleSet')
{
	$CheckParams.Ruleset = "$ruleset"
}
if ($ruleType -eq 'Rules')
{
	$CheckParams.RuleCodes = ConvertFrom-Json -InputObject "$ruleCodes"
}
if ($excludedFiles)
{
	$CheckParams.ExcludedFiles = ConvertFrom-Json -InputObject "$excludedFiles"
}

try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\CheckSolution.ps1" @CheckParams
}
finally
{
	$resultFile = Get-ChildItem -Path "$tempFolder" -Filter "*.zip"

	$mdFile = Get-ChildItem -Path "$tempFolder" -Filter "*.md"

	if ($mdFile)
	{	
		Copy-Item -Path $tempFolder\*.md -Destination "$OutputPath"

		$outputFile = "$OutputPath\$($mdFile.Name)"

		Write-Host "Uploading check summary file: $outputFile"
		
		Write-Host "##vso[task.addattachment type=Distributedtask.Core.Summary;name=MSCRM Checker Summary;]$outputFile"

		Write-Verbose "Check summary uploaded"
	}

	if ($resultFile)
	{	
		Copy-Item -Path $tempFolder\*.zip -Destination "$OutputPath"

		$outputFile = "$OutputPath\$($resultFile.Name)"

		Write-Host "Uploading check result file: $outputFile"

		Write-Host "##vso[task.uploadfile]$outputFile"

		Write-Host "##vso[task.setvariable variable=SOLUTION_CHECK_RESULT_FILE]$outputFile"

		Write-Host "##vso[task.setvariable variable=LAST_SOLUTION_CHECK_RESULT_FILE]$outputFile"

		if ($resultsVariableName)
		{
			Write-Host "##vso[task.setvariable variable=$resultsVariableName]$outputFile"
		}

		Write-Verbose "Check result uploaded"
	}
	else
	{
		Write-Verbose "Result file not found in $OutputPath"
	}

	Remove-Item $tempFolder -Force -Recurse
}

Write-Verbose 'Leaving MSCRMCheckSolution.ps1'
