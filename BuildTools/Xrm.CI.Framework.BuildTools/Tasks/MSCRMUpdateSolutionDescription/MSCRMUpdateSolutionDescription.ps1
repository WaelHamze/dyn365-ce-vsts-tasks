[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMUpdateSolutionDescription.ps1'

#Get Parameters
$crmConnectionString = Get-VstsInput -Name crmConnectionString -Require
$solutionName = Get-VstsInput -Name solutionName -Require
$crmConnectionTimeout = Get-VstsInput -Name crmConnectionTimeout -Require -AsInt
$newDescription = Get-VstsInput -Name newDescription -Require
$descriptionUpdateMethod = Get-VstsInput -Name descriptionUpdateMethod -Require
      #"options": {
      #  "replace": "Replace",
      #  "appendToTop": "AppendToTop",
      #  "appendToBottom": "AppendToBottom"
      #},

#Validate Picklist
switch ($descriptionUpdateMethod.ToUpperInvariant()) {
    'REPLACE' { }
    'APPENDTOTOP' { }
    'APPENDTOBOTTOM' { }
    default {
        Write-Error "$descriptionUpdateMethod is not a valid input"
    }
}


#Print Verbose
Write-Verbose "crmConnectionString = $crmConnectionString"
Write-Verbose "solutionName = $solutionName"
Write-Verbose "crmConnectionTimeout = $crmConnectionTimeout"
Write-Verbose "newDescription = $newDescription"
Write-Verbose "descriptionUpdateMethod = $descriptionUpdateMethod"

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\UpdateSolutionDescriptionInCRM.ps1" -solutionName "$solutionName" -crmConnectionString "$CrmConnectionString" -Timeout $crmConnectionTimeout -NewDescription $newDescription -DescriptionUpdateMethod $descriptionUpdateMethod

Write-Verbose 'Leaving MSCRMUpdateSolutionDescription.ps1'
