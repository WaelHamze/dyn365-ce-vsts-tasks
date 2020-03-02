#
# MSCRMFunctions.ps1
#

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMToolFunctions.ps1'

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

$nugetConfigVariable = 'MSCRM_Tools_NugetConfig_Path'
$psConfigVariable = 'MSCRM_Tools_PSGalleryConfig_Path'

function Execute-Nuget
{
	param(
		[string]$nugetPath,
		[string[]]$nugetArgList
	)

	Write-Verbose "Nuget command: $nugetPath $nugetArgList"

	& $nugetPath $nugetArgList

	if ($lastexitcode -ne 0)
	{
		throw "Nuget.exe encountered an error: $lastexitcode"
	}
}

Function Set-Nuget-ConfigValue
{
	param(
		[string]$nugetPath,
		[string]$nugetConfigPath,
		[string]$name,
		[string]$value
	)

	$nugetArgList = @(
		"config","-Set",
		"$name=$value"
		"-ConfigFile", "$nugetConfigPath"
	)

	Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList
}

function Configure-Nuget
{
	param(
		[string]$nugetPath,
		[string]$nugetConfigPath,
		[string]$sourceName,
		[string]$source,
		[string]$username,
		[string]$password,
		[string]$nugetProxyUrl,
		[string]$nugetProxyUsername,
		[string]$nugetProxyPassword
	)

	#Set Source
	$nugetArgList = @(
	"sources","Add",
	"-Name","$sourceName",
	"-Source", "$source",
	"-ConfigFile", "$nugetConfigPath"
	)

	if ($username)
	{
		$nugetArgList += "-Username"
		$nugetArgList += "$username"

		if ($password)
		{
			$nugetArgList += "-Password"
			$nugetArgList += "$password"
		}
	}

	Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList

	#Set APIKey
	if ($password -and (-not $username))
	{
		$nugetArgList = @(
			"setapikey","$password",
			"-Source", "$source",
			"-ConfigFile", "$nugetConfigPath"
			)

		Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList
	}

	#Set Proxy
	if ($nugetProxyUrl)
	{
		Set-Nuget-ConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY" -value "$nugetProxyUrl"

		if ($nugetProxyUsername)
		{
			Set-Nuget-ConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY.USER" -value "$nugetProxyUsername"

			if ($nugetProxyPassword)
			{
				Set-Nuget-ConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY.PASSWORD" -value "$nugetProxyPassword"
			}
		}
	}
}

function Get-MSCRMTool-VersionVariable
{
	param(
		[string]$toolName
	)

	return "MSCRM_$($toolName.replace('.', '_'))_Version"
}

function Get-MSCRMToolInfo
{
	param(
		[string]$toolName
	)

	$toolsConfig = "$scriptPath\Tools.json"

	Write-Verbose "Getting $toolName details from $toolsConfig"

	$tools = ConvertFrom-Json (Get-Content -Path "$toolsConfig" -Raw)

	$tool = $tools | where Name -EQ "$toolName"

	if ($tool)
	{
		return $tool
	}
	else
	{
		throw "$toolName was was not found in $toolsConfig"
	}
}

function Get-MSCRMTool-Path
{
	param(
		[string]$toolName,
		[string]$version
    )

	#MSCRM Tools
	$mscrmToolsPath = $env:MSCRM_Tools_Path
	Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

	if (-not $mscrmToolsPath)
	{
		Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
	}

	return "$mscrmToolsPath\$toolName.$version"
}

function Get-MSCRMTool-Version
{
    param(
		[string]$toolName,
		[string]$version
    )
	
	$tool = Get-MSCRMTool-FromConfig -toolName "$toolName"

	if ($version)
	{
		Write-Verbose "Using version provided by specific task: $version"
	}
	else
	{
		$versionVariable = Get-MSCRMTool-VersionVariable -toolName "$toolName"

		$version = iex ('$env:' + $versionVariable)

		if ($version)
		{
			Write-Verbose "Using version provided in tool installer task: $version"
		}
		else
		{
			$version = $tool.Version

			if (-not $version)
			{
				throw "Couldn't find required version for tool: $toolName"
			}

			Write-Verbose "Using default version: $version"
		}
	}

	return $version
}

function Use-MSCRMTool
{
    param(
		[string]$toolName,
		[string]$version
    )

	#MSCRM Tools
	$mscrmToolsPath = $env:MSCRM_Tools_Path
	Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

	if (-not $mscrmToolsPath)
	{
		Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
	}

	$tool = Get-MSCRMTool-FromConfig -toolName "$toolName"

	$version = Get-MSCRMTool-Version -toolName $toolName -version $version

	$toolFolder = "$mscrmToolsPath\$toolName.$version"

	if (Test-Path -Path $toolFolder)
	{
		Write-Verbose "Tool already cached in $toolFolder"
	}
	else
	{
		if ($tool.Source -eq 'Nuget')
		{
			$configPath = iex ('$env:' + $nugetConfigVariable)
		}
		elseif ($tool.Source -eq 'PSGallery')
		{
			$configPath = iex ('$env:' + $psConfigVariable)
		}

		Write-Host "Saving $toolName  version: $version to $mscrmToolsPath" -ForegroundColor Green

		$nugetPath = "$mscrmToolsPath\Nuget\4.9.4\nuget.exe"

		$nugetArgList = @(
			"install",
			"$toolName",
			"-OutputDirectory","$mscrmToolsPath",
			"-ConfigFile", "$configPath"
		)

		Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList
	}

	return $toolFolder
}

#function Get-MSCRMTool   
#{
#    param(
#	[string]$nugetPath,
#    [string]$toolName,
#	[string]$version,
#    [string]$folderName,
#	[string]$nugetConfigPath,
#	[string]$repository
#    )

#    Write-Host "Saving $toolName  version: $version to $folderName" -ForegroundColor Green

#	$nugetArgList = @(
#		"install",
#		"$toolName",
#		"-OutputDirectory","$folderName",
#		"-ConfigFile", "$nugetConfigPath"
#	)

#	#Write-Verbose "Nuget command: $nugetPath $nugetArgList"

#	#& $nugetPath $nugetArgList

#	Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList

#	#Save-Package -Name $toolName -Path $folderName

#	#if ($lastexitcode -ne 0)
#	#{
#	#	throw "Nuget.exe encountered an error: $lastexitcode"
#	#}

#    #md .\Tools\$folderName
#    #Save-Module $moduleName -Path .\Tools -RequiredVersion $version

#    #$moduleFile = Get-ChildItem -Recurse ./Tools | Where-Object {$_.Name -match "$moduleName.psd1"}
#    #$moduleDir = $moduleFile.Directory.FullName
#    #move $moduleDir\*.* .\Tools\$folderName
#    #Remove-Item .\Tools\$moduleName -Force -Recurse
#}

Write-Verbose 'Leaving MSCRMToolFunctions.ps1'