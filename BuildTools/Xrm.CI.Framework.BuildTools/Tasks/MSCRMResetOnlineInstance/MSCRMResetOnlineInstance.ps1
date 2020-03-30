[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMResetOnlineInstance.ps1'

#Get Parameters
$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$instanceName = Get-VstsInput -Name instanceName -Require
$domainName = Get-VstsInput -Name domainName -Require
$friendlyName = Get-VstsInput -Name friendlyName -Require
$purpose = Get-VstsInput -Name purpose
$targetReleaseName = Get-VstsInput -Name targetReleaseName -Require
$sales = Get-VstsInput -Name sales -AsBool
$customerService = Get-VstsInput -Name customerService -AsBool
$fieldService = Get-VstsInput -Name fieldService -AsBool
$projectService = Get-VstsInput -Name projectService -AsBool
$languageId = Get-VstsInput -Name languageId -AsInt
$preferredCulture = Get-VstsInput -Name preferredCulture -AsInt
$currencyCode = Get-VstsInput -Name currencyCode
$currencyName = Get-VstsInput -Name currencyName
$currencyPrecision = Get-VstsInput -Name currencyPrecision -AsInt
$currencySymbol = Get-VstsInput -Name currencySymbol
$securityGroupId = Get-VstsInput -Name securityGroupId
$securityGroupName = Get-VstsInput -Name securityGroupName
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$onlineAPI = 'Microsoft.Xrm.OnlineManagementAPI'
$onlineAPIInfo = Get-MSCRMTool -toolName $onlineAPI 
Require-ToolVersion -toolName $onlineAPI -version $onlineAPIInfo.Version -minVersion '1.2.0.1'
$onlineAPIPath = "$($onlineAPIInfo.Path)"

$azureAD = 'AzureAD'
$azureADInfo = Get-MSCRMTool -toolName $azureAD
Require-ToolVersion -toolName $azureAD -version $azureADInfo.Version -minVersion '2.0.2.52'
$azureADPath = "$($azureADInfo.Path)"

$templateNames = [string[]] @()
if ($sales)
{
    $templateNames += "D365_Sales"
}
if ($customerService)
{
    $templateNames += "D365_CustomerService"
}
if ($fieldService)
{
    $templateNames += "D365_FieldService"
}
if ($projectService)
{
    $templateNames += "D365_ProjectServiceAutomation"
}


& "$mscrmToolsPath\xRMCIFramework\9.0.0\ResetOnlineInstance.ps1" -ApiUrl $apiUrl -Username $username -Password $password -InstanceName $instanceName  -DomainName $domainName -FriendlyName $friendlyName -Purpose $purpose -TargetReleaseName $targetReleaseName -TemplateNames $templateNames -LanguageId $languageId -PreferredCulture $preferredCulture -CurrencyCode $currencyCode -CurrencyName $currencyName -CurrencyPrecision $currencyPrecision -CurrencySymbol $currencySymbol -SecurityGroupId $securityGroupId -SecurityGroupName $securityGroupName -PSModulePath $onlineAPIPath -azureADModulePath "$azureADPath" -WaitForCompletion $WaitForCompletion -SleepDuration $sleepDuration

Write-Verbose 'Leaving MSCRMResetOnlineInstance.ps1'
