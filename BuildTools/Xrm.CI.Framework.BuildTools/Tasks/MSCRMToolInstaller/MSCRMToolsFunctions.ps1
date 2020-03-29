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
		[string[]]$nugetArgList,
		[switch]$returnOutput
	)

	Write-Verbose "Nuget command: $nugetPath $nugetArgList"

	if ($returnOutput)
	{
		$output = & $nugetPath $nugetArgList

		Write-Output $output
	}
	else
	{
		& $nugetPath $nugetArgList
	}

	if ($lastexitcode -ne 0)
	{
		throw "Nuget.exe encountered an error: $lastexitcode $output"
	}
}

Function Set-NugetConfigValue
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
		Write-Verbose "Setting Nuget Username to: $username"
		
		$nugetArgList += "-Username"
		$nugetArgList += "$username"

		if ($password)
		{
			Write-Verbose "Setting Nuget Password"
			
			$nugetArgList += "-Password"
			$nugetArgList += "$password"
		}
	}

	Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList

	#Set APIKey
	if ($password -and (-not $username))
	{
		Write-Verbose "Setting Nuget API Key"
		
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
		Write-Verbose "Seting Nuget proxy to Url= $nugetProxyUrl | User=$nugetProxyUsername"
		
		Set-NugetConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY" -value "$nugetProxyUrl"

		if ($nugetProxyUsername)
		{
			Set-NugetConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY.USER" -value "$nugetProxyUsername"

			if ($nugetProxyPassword)
			{
				Set-NugetConfigValue -nugetPath "$nugetPath" -nugetConfigPath $nugetConfigPath -name "HTTP_PROXY.PASSWORD" -value "$nugetProxyPassword"
			}
		}
	}
}

function Set-MSCRMToolVersionVariable
{
	param(
		[string]$toolName,
		[string]$version
    )

	$tool = Get-MSCRMToolFromConfig -toolName $toolName

	if ($version)
	{
		Write-Host "Override version for $toolName : $version"

		$variable = Get-MSCRMToolVersionVariable -toolName $toolName

		Write-Host "##vso[task.setvariable variable=$variable]$version"
	}
	else
	{
		Write-Host "Using default version for  $toolName : $($tool.Version)"
	}
}

function Get-MSCRMToolVersionVariable
{
	param(
		[string]$toolName
	)

	return "MSCRM_$($toolName.replace('.', '_'))_Version"
}

function Get-MSCRMToolFromConfig
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

function Get-MSCRMToolPath
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
		Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
	}

	return "$mscrmToolsPath\$toolName.$version"
}

function Get-MSCRMToolInfo
{
    param(
		[string]$toolName
    )
	
	$tool = Get-MSCRMToolFromConfig -toolName "$toolName"

	$versionVariable = Get-MSCRMToolVersionVariable -toolName "$toolName"

	$version = iex ('$env:' + $versionVariable)

	if ($version)
	{
		Write-Verbose "Using version provided in tool installer task: $version"
		
		$tool.Version = $version
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

	return $tool
}

function Get-LatestToolVersion
{
	param(
		[string]$toolName
		)

	Write-Verbose "Finding latest version for tool: $toolName"

	#MSCRM Tools
	$mscrmToolsPath = $env:MSCRM_Tools_Path
	Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

	if (-not $mscrmToolsPath)
	{
		Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
	}
	
	$tool = Get-MSCRMToolFromConfig -toolName $toolName

	if ($tool.Source -eq 'Nuget')
	{
		$configPath = iex ('$env:' + $nugetConfigVariable)
	}
	elseif ($tool.Source -eq 'PSGallery')
	{
		$configPath = iex ('$env:' + $psConfigVariable)
	}

	$nugetPath = "$mscrmToolsPath\Nuget\4.9.4\nuget.exe"

	$nugetArgList = @(
		"list",
		"$toolName",
		"-ConfigFile", "$configPath",
		"-NonInteractive"
	)

	$output = Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList -returnOutput

	$toolMatches = $output | Select-String "$toolName \d+(\.\d+)+"

	if ($toolMatches)
	{
		$toolMatch = $toolMatches.Matches.Value

		$versionMatch = $toolMatch | Select-String '\d+(\.\d+)+'

		if ($versionMatch)
		{
			$version = $versionMatch.matches.Value

			Write-Host "Latest Version of $toolName is: $version"

			Write-Output $version
		}
		else
		{
			throw "Couldn't extract version. Try to specify an exact version or leave blank. $output"
		}
	}
	else
	{
		throw "Couldn't extract version. Try to specify an exact version or leave blank. $output"
	}
}

function Get-MSCRMTool
{
	param(
		[string]$toolName
	)

	#MSCRM Tools
	$mscrmToolsPath = $env:MSCRM_Tools_Path
	Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

	if (-not $mscrmToolsPath)
	{
		Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
	}

	$tool = Get-MSCRMToolInfo -toolName $toolName

	if ($tool.Source -eq 'Nuget')
	{
		$configPath = iex ('$env:' + $nugetConfigVariable)
	}
	elseif ($tool.Source -eq 'PSGallery')
	{
		$configPath = iex ('$env:' + $psConfigVariable)
	}

	Write-Host "Downloading $toolName $($tool.Version) to: $mscrmToolsPath" -ForegroundColor Green

	$nugetPath = "$mscrmToolsPath\Nuget\4.9.4\nuget.exe"

	$nugetArgList = @(
		"install",
		"$toolName",
		"-OutputDirectory","$mscrmToolsPath",
		"-ConfigFile", "$configPath",
		"-NonInteractive"
	)

	if ($tool.Version -ne 'latest')
	{
		$nugetArgList += "-Version"
		$nugetArgList += "$($tool.Version)"
	}

	$output = Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList -returnOutput

	if ($tool.Version -eq 'latest')
	{
		$latestDir = Get-ChildItem -Path $mscrmToolsPath | Where-Object {$_.Name -like "$toolName.*"} | Sort Name -Descending | Select-Object -First 1

		if ($latestDir)
		{
			$versionMatch = $latestDir | Select-String "\d+(\.\d+)+"

			if ($versionMatch)
			{
				$version = $versionMatch.matches.Value

				Write-Host "Latest Version of $toolName is: $version"

				$tool.Version = $version
			}
			else
			{
				throw "Couldn't extract version. Try to specify an exact version or leave blank."
			}

		}
		else
		{
			throw "Can't find $toolName in $mscrmToolsPath. Try to specify an exact version or leave blank. $output"
		}
	}

	$toolFolder = Get-MSCRMToolPath -toolName $toolName -version $tool.Version

	$tool | Add-Member -MemberType NoteProperty -Name Path -Value $toolFolder

	return $tool
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
		Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
	}

	$tool = Get-MSCRMToolFromConfig -toolName $toolName

	$toolFolder = Get-MSCRMToolPath -toolName $toolName -version $version

	if (Test-Path -Path $toolFolder)
	{
		Write-Host "$toolName $version already cached in $toolFolder"
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

		Write-Host "Downloading $toolName $version to: $mscrmToolsPath" -ForegroundColor Green

		$nugetPath = "$mscrmToolsPath\Nuget\4.9.4\nuget.exe"

		$nugetArgList = @(
			"install",
			"$toolName",
			"-OutputDirectory","$mscrmToolsPath",
			"-ConfigFile", "$configPath",
			"-Version", "$version",
			"-NonInteractive"
		)

		Execute-Nuget -nugetPath $nugetPath -nugetArgList $nugetArgList
	}

	return $toolFolder
}

function Require-ToolsTaskVersion
{
	param(
		[int]$version
    )

	$currentVersion = $env:MSCRM_Tools_Task_Version

	if (-not $currentVersion)
	{
		Write-Error "MSCRM_Tools_Path_Version not found. Add 'Power DevOps Tool Installer' (ver. >= 12) before this task."
	}

	$currentVersion = $currentVersion -as [int]

	if ($currentVersion -lt $version)
	{
		Write-Error "'Power DevOps Tool Installer' version $version is required for this task version"
	}
}

function Require-ToolVersion
{
	param(
		[string]$toolName,
		[string]$version,
		[string]$minVersion
    )

	if ([System.Version]$version -lt [System.Version]$minVersion)
	{
		throw "$toolName minimum version $minVersion is required. Adjust version in 'Power DevOps Tool Installer' task"
	}
}

Write-Verbose 'Leaving MSCRMToolFunctions.ps1'