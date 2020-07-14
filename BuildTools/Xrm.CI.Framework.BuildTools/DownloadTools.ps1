$ErrorActionPreference = 'Stop'

# Download Nuget Package
function Download-NugetPackage
{
    param(
    [string]$packageName,
    [string]$folderName,
    [string]$version,
    [string]$packagePath = 'tools'
    )

    Write-Host Saving "$packageName $version to $folderName" -ForegroundColor Gree

    ./nuget install $packageName -O .\Tools -Version $version
    md .\Tools\$folderName
    $prtFolder = Get-ChildItem ./Tools | Where-Object {$_.Name -match "$packageName."}
    move .\Tools\$prtFolder\$packagePath\*.* .\Tools\$folderName
    Remove-Item .\Tools\$prtFolder -Force -Recurse
}

# Download PowerShell Module
function Download-PSModule   
{
    param(
    [string]$moduleName,
    [string]$folderName,
    [string]$version
    ) 
        Write-Host Saving "$moduleName $version to $folderName" -ForegroundColor Green

        md .\Tools\$folderName
        Save-Module $moduleName -Path .\Tools -RequiredVersion $version

        $moduleFile = Get-ChildItem -Recurse ./Tools | Where-Object {$_.Name -match "$moduleName.psd1"}
        $moduleDir = $moduleFile.Directory.FullName
        move $moduleDir\*.* .\Tools\$folderName
        Remove-Item .\Tools\$moduleName -Force -Recurse
    }

# Clean Tools Directory
Remove-Item .\Tools -Force -Recurse -ErrorAction Ignore

# Create Tools Directory
md .\Tools

# Download Nuget Installer
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = ".\nuget.exe"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
Set-Alias nuget $targetNugetExe -Scope Global -Verbose

# Download Nuget Packages
Download-NugetPackage -packageName 'Microsoft.CrmSdk.CoreTools' -version '9.1.0.46' -folderName 'CoreTools' -packagePath 'content\bin\coretools'

# Download PowerShell Modules
Download-PSModule -moduleName 'AzureAD' -version '2.0.2.52' -folderName 'AAD'
Download-PSModule -moduleName 'Microsoft.Xrm.Tooling.CrmConnector.PowerShell' -version '3.3.0.894' -folderName 'CrmConnector.PowerShell'
Download-PSModule -moduleName 'Microsoft.Xrm.Tooling.PackageDeployment.Powershell' -version '3.3.0.895' -folderName 'PackageDeployment.Powershell'
Download-PSModule -moduleName 'Microsoft.PowerApps.Checker.PowerShell' -version '1.0.12' -folderName 'PowerAppsChecker.PowerShell'
Download-PSModule -moduleName 'Microsoft.Xrm.Tooling.ConfigurationMigration' -version '1.0.0.49' -folderName 'ConfigurationMigration.Powershell'
Download-PSModule -moduleName 'Microsoft.Xrm.OnlineManagementAPI' -version '1.2.0.1' -folderName 'OnlineManagementAPI'
#Download-PSModule -moduleName 'Xrm.Framework.CI.PowerShell.Cmdlets' -version '9.0.0.41' -folderName 'xRMCIFramework'

##
##Remove NuGet.exe
##
Remove-Item nuget.exe
