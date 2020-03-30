[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMServiceEndpointRegistration.ps1'

#Get Parameters
$CrmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$RegistrationType = Get-VstsInput -Name registrationType -Require
$MappingFile = Get-VstsInput -Name mappingFile -Require
$SolutionName = Get-VstsInput -Name solutionName
$CrmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt

#Print Verbose
Write-Verbose "crmConnectionString = $CrmConnectionString"
Write-Verbose "registrationType = $RegistrationType"
Write-Verbose "MappingFile = $MappingFile"
Write-Verbose "solutionName = $SolutionName"
Write-Verbose "crmConnectionTimeout = $CrmConnectionTimeout"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\ServiceEndpointRegistration.ps1" -CrmConnectionString $CrmConnectionString -RegistrationType $RegistrationType -MappingFile $MappingFile -SolutionName $SolutionName -Timeout $crmConnectionTimeout

Write-Verbose 'Leaving MSCRMServiceEndpointRegistration.ps1'