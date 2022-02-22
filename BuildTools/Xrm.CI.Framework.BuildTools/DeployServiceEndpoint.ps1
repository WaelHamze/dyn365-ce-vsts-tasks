#
# DeployTask.ps1
#

param(
[string]$Url,
[string]$token
)

$ErrorActionPreference = "Stop"

#Script Location
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Write-Host "Script Path: $scriptPath"

tfx login --service-url $url --auth-type 'pat' --token $token

#Creating output directory
$OutputDir = $scriptPath + "\bin"
$ManifestFile = "$scriptPath\vss-extension-servicecendpoint.json"

tfx extension create --manifest-globs $ManifestFile --output-path $OutputDir --root $OutputDir

tfx extension publish --vsix "$OutputDir\WaelHamze.xrm-ci-framework-service-endpoint-0.0.1.vsix" --share-with "crmdevops" --token $token  --auth-type 'pat'

Write-Host "Deployment Completed" -ForegroundColor Green