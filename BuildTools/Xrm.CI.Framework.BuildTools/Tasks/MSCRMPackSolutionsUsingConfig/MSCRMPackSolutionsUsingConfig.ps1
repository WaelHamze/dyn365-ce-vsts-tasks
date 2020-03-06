[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMPackSolutionsUsingConfig.ps1'

#Get Parameters
$configFilePath = Get-VstsInput -Name configFilePath -Require
$outputFolder = Get-VstsInput -Name outputFolder -Require
$logsDirectory = Get-VstsInput -Name logsDirectory

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

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 10

$coreTools = 'Microsoft.CrmSdk.CoreTools'
$coreToolsInfo = Get-MSCRMToolInfo -toolName $coreTools
$coreToolsPath = "$($coreToolsInfo.Path)\content\bin\coretools"
Use-MSCRMTool -toolName $coreTools -version $coreToolsInfo.Version

#Import
try
{
	& "$mscrmToolsPath\xRMCIFramework\9.0.0\PackSolutionsUsingConfig.ps1" -configFilePath "$configFilePath" -CoreToolsPath "$coreToolsPath" -OutputFolder "$outputFolder" -logsDirectory "$logsDirectory"
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
