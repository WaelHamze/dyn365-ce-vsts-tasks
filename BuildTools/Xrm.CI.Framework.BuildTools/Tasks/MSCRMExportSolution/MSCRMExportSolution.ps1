[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMExportSolution.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionName = Get-VstsInput -Name solutionName -Require
$exportManaged = Get-VstsInput -Name exportManaged -Require -AsBool
$exportUnmanaged = Get-VstsInput -Name exportUnmanaged -Require -AsBool
$includeVersionInSolutionFile = Get-VstsInput -Name includeVersionInSolutionFile -AsBool
$targetVersion = Get-VstsInput -Name targetVersion
$includeVersionInSolutionFile = Get-VstsInput -Name includeVersionInSolutionFile -AsBool
$outputPath = Get-VstsInput -Name outputPath -Require
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt
$exportAutoNumberingSettings = Get-VstsInput -Name exportAutoNumberingSettings -AsBool
$exportCalendarSettings = Get-VstsInput -Name exportCalendarSettings -AsBool
$exportCustomizationSettings = Get-VstsInput -Name exportCustomizationSettings -AsBool
$ExportEmailTrackingSettings = Get-VstsInput -Name exportEmailTrackingSettings -AsBool
$exportExternalApplications = Get-VstsInput -Name exportExternalApplications -AsBool
$exportGeneralSettings = Get-VstsInput -Name exportGeneralSettings -AsBool
$exportIsvConfig = Get-VstsInput -Name exportIsvConfig -AsBool
$exportMarketingSettings = Get-VstsInput -Name exportMarketingSettings -AsBool
$exportOutlookSynchronizationSettings = Get-VstsInput -Name exportOutlookSynchronizationSettings -AsBool
$exportRelationshipRoles = Get-VstsInput -Name exportRelationshipRoles -AsBool
$exportSales = Get-VstsInput -Name exportSales -AsBool

#TFS Build Parameters
$buildNumber = $env:BUILD_BUILDNUMBER
$sourcesDirectory = $env:BUILD_SOURCESDIRECTORY
$binariesDirectory = $env:BUILD_BINARIESDIRECTORY

if ($updateVersion)
{
    $splits = $buildNumber.Split("_")
    $versionNumber = $splits[$splits.Count-1]
}

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\ExportSolution.ps1"  -CrmConnectionString $crmConnectionString -SolutionName $solutionName -ExportManaged $exportManaged -ExportUnmanaged $exportUnmanaged -ExportSolutionOutputPath $outputPath -TargetVersion $targetVersion -RequiredVersion $versionNumber -ExportIncludeVersionInSolutionName $includeVersionInSolutionFile -ExportAutoNumberingSettings $exportAutoNumberingSettings -ExportCalendarSettings $exportCalendarSettings -ExportCustomizationSettings $exportCustomizationSettings -ExportEmailTrackingSettings $exportEmailTrackingSettings -ExportExternalApplications $exportExternalApplications -ExportGeneralSettings $exportGeneralSettings -ExportMarketingSettings $exportMarketingSettings -ExportOutlookSynchronizationSettings $exportOutlookSynchronizationSettings -ExportIsvConfig $exportIsvConfig -ExportRelationshipRoles $exportRelationshipRoles -ExportSales $exportSales -Timeout $crmConnectionTimeout

Write-Verbose 'Leaving MSCRMExportSolution.ps1'
