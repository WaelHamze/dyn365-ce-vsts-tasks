[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMExtractSolution.ps1'

#Get Parameters
$unpackedFilesFolder = Get-VstsInput -Name unpackedFilesFolder -Require
$mappingFile = Get-VstsInput -Name mappingFile
$packageType = Get-VstsInput -Name packageType -Require
$solutionFile = Get-VstsInput -Name solutionFile -Require
$treatUnpackWarningsAsErrors = Get-VstsInput -Name treatUnpackWarningsAsErrors -AsBool
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
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$coreTools = 'Microsoft.CrmSdk.CoreTools'
$coreToolsInfo = Get-MSCRMToolInfo -toolName $coreTools
$coreToolsPath = "$($coreToolsInfo.Path)\content\bin\coretools"
Use-MSCRMTool -toolName $coreTools -version $coreToolsInfo.Version

& "$mscrmToolsPath\xRMCIFramework\9.0.0\ExtractSolution.ps1" -UnpackedFilesFolder "$unpackedFilesFolder" -MappingFile "$mappingFile" -PackageType $packageType -solutionFile "$solutionFile" -TreatUnpackWarningsAsErrors $treatUnpackWarningsAsErrors -sourceLoc "$sourceLoc" -localize $localize -CoreToolsPath "$coreToolsPath"

Write-Verbose 'Leaving MSCRMExtractSolution.ps1'
