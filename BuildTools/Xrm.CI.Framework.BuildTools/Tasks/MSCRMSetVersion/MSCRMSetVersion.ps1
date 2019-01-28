[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMSetVersion.ps1'

#Get Parameters
$target = Get-VstsInput -Name target -Require
$versionNumber = Get-VstsInput -Name versionNumber -Require
$crmConnectionString = Get-VstsInput -Name crmConnectionString
$solutionName = Get-VstsInput -Name solutionName
$unpackedFilesFolder = Get-VstsInput -Name unpackedFilesFolder

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

switch ($target)
{
	"crm"
	{
		if (-not $crmConnectionString)
		{
			throw "CRM Connection String is required"
		}
		if (-not $solutionName)
		{
			throw "CRM Solution Name is required"
		}
		
		& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateSolutionVersionInCRM.ps1" -CrmConnectionString $crmConnectionString -SolutionName $solutionName -VersionNumber $versionNumber
		break
	}
	"xml"
	{
		if ((-not $unpackedFilesFolder) -or ($unpackedFilesFolder -eq $env:System_DefaultWorkingDirectory))
		{
			throw "Unpacked Files Folder is required"
		}

		& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateSolutionVersionInFolder.ps1" -unpackedFilesFolder $unpackedFilesFolder -VersionNumber $versionNumber
		break
	}
}

Write-Verbose 'Leaving MSCRMSetVersion.ps1'
