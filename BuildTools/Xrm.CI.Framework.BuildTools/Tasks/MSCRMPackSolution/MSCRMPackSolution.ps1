[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackSolution.ps1'

#Get Parameters
$unpackedFilesFolder = Get-VstsInput -Name unpackedFilesFolder -Require
$mappingFile = Get-VstsInput -Name mappingFile
$packageType = Get-VstsInput -Name packageType -Require
$includeVersionInSolutionFile = Get-VstsInput -Name includeVersionInSolutionFile -AsBool
$outputPath = Get-VstsInput -Name outputPath
$treatPackWarningsAsErrors = Get-VstsInput -Name treatPackWarningsAsErrors -AsBool
$sourceLoc = Get-VstsInput -Name sourceLoc
$localize = Get-VstsInput -Name localize -AsBool

#TFS Build Parameters
$buildNumber = $env:BUILD_BUILDNUMBER
$sourcesDirectory = $env:BUILD_SOURCESDIRECTORY
$binariesDirectory = $env:BUILD_BINARIESDIRECTORY
$defaultDirectory = $env:System_DefaultWorkingDirectory

if ($mappingFile -eq $sourcesDirectory -or $mappingFile -eq $defaultDirectory)
{
	Write-Verbose "Setting mapping file to null as matches a pipeline directory"
	$mappingFile = $null
}

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 10

$coreTools = 'Microsoft.CrmSdk.CoreTools'
$coreToolsInfo = Get-MSCRMToolInfo -toolName $coreTools
$coreToolsPath = "$($coreToolsInfo.Path)\content\bin\coretools"
Use-MSCRMTool -toolName $coreTools -version $coreToolsInfo.Version

& "$mscrmToolsPath\xRMCIFramework\9.0.0\PackSolution.ps1" -UnpackedFilesFolder $unpackedFilesFolder -MappingFile $mappingFile -PackageType $packageType -IncludeVersionInSolutionFile $includeVersionInSolutionFile -OutputPath $outputPath -TreatPackWarningsAsErrors $treatPackWarningsAsErrors -sourceLoc "$sourceLoc" -localize $localize -CoreToolsPath "$CoreToolsPath"

Write-Verbose 'Leaving MSCRMPackSolution.ps1'
