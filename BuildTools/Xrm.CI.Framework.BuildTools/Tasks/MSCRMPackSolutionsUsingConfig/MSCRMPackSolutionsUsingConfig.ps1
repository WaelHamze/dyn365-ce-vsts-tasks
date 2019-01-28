[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackSolutionsUsingConfig.ps1'

#Get Parameters
$configFilePath = Get-VstsInput -Name configFilePath -Require
$outputFolder = Get-VstsInput -Name outputFolder -Require
$logsDirectory = Get-VstsInput -Name logsDirectory
$solutionpackagerpath = Get-VstsInput -Name solutionpackagerpath

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

#Logs
if (-not $logsDirectory)
{
	Write-Verbose "logsDirectory not supplied"
	
	$logsDirectory = $env:System_DefaultWorkingDirectory

	Write-Verbose "logsDirectory set to $logsDirectory"
}

if ((-not $solutionpackagerpath) -or ($solutionpackagerpath -eq $env:System_DefaultWorkingDirectory))
{
	Write-Verbose "solutionpackagerpath not supplied"
	
	$solutionpackagerpath = "$mscrmToolsPath\CoreTools\9.0.0\SolutionPackager.exe"

	Write-Verbose "logFileName set to $solutionpackagerpath"
}

#Import
try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\PackSolutionsUsingConfig.ps1" -configFilePath "$configFilePath" -solutionPackagerPath "$solutionPackagerPath" -OutputFolder "$outputFolder" -logsDirectory "$logsDirectory"
}
catch
{
	$ErrorMessage = $_.Exception.Message

	Write-Host "Exception Caught: $ErrorMessage"
	
	throw
}
finally
{
	Write-Verbose "Uploading pack log files"
	
	Get-ChildItem $logsDirectory -Filter PackagerLog*.txt | 
		Foreach-Object {
			$logFile = $_.FullName

			Write-Verbose "Uploading pack log $logFile"

			Write-Host "##vso[task.uploadfile]$logFile"

			Write-Verbose "Pack log uploaded $logFile"
	}

	Write-Verbose "Completed uploading pack log files"
}

Write-Verbose 'Leaving MSCRMPackSolutionsUsingConfig.ps1'
