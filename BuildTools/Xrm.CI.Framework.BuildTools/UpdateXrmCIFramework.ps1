#
# UpdateXrmCIFramework.ps1
#

param
(
	[string]$SourcePath
)

$ErrorActionPreference = "Stop"

#Script Location
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Verbose "Script Path: $scriptPath"

$targetPath = "$scriptPath\Lib\xRMCIFramework\9.0.0"

$scriptsPath = "$SourcePath\MSDYNV9\Xrm.Framework.CI\Xrm.Framework.CI.PowerShell.Scripts\*.ps1"
Copy-Item -Path $scriptsPath -Destination $targetPath

$cmdletsPath = "$SourcePath\MSDYNV9\Xrm.Framework.CI\Xrm.Framework.CI.PowerShell.Cmdlets\bin\Release\*.dll"
Copy-Item -Path $cmdletsPath -Destination $targetPath

$cmdletsPath = "$SourcePath\MSDYNV9\Xrm.Framework.CI\Xrm.Framework.CI.PowerShell.Cmdlets\bin\Release\*.xslt"
Copy-Item -Path $cmdletsPath -Destination $targetPath

