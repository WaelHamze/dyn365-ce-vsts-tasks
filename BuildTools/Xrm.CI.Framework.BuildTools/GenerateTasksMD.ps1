#
# GenerateTasksMD.ps1
#

function Get-Category
{
	param(
		[string]$Name
    )

	if (($name -match 'Online') -or ($name -match 'Instance'))
	{
		$category = 'Environment'
	}
	elseif (($name -match 'Solution') -or ($name -match 'Patch')-or ($name -match 'Checker')-or ($name -match 'SetVersion'))
	{
		$category = 'Solution'
	}
	elseif (($name -match 'Data') -or ($name -match 'Variable') -or ($name -match 'Record'))
	{
		$category = 'Data'
	}
	else
	{
		$category = 'Utility'
	}

	return $category
}


$tasks = Get-ChildItem .\Tasks -directory

$tasksJson = @()

$ErrorActionPreference = "Stop"

$tasksMD = "| Task | Category | Description |`n"
$tasksMD = $tasksMD + "| --- | --- | --- |`n"

foreach($task in $tasks)
{
	$taskJson = Get-Content "Tasks\$task\task.json" | Out-String | ConvertFrom-Json

	$category = Get-Category -Name $taskJson.name
	$taskJson | Add-Member -MemberType NoteProperty -Name taskcategory -Value $category

	$tasksJson += $taskJson
}

$tasksJson = $tasksJson | Sort taskcategory,name

foreach($task in $tasksJson)
{
	$name = $task.name
	$friendlyName = $task.friendlyName
	$description = $task.description
	$preview = $task.preview
	$deprecated = $task.deprecated
	$category = $task.taskcategory

	$tasksMD = $tasksMD + "| **$friendlyName**"
	if ($preview)
	{
		$tasksMD = $tasksMD + " (preview)"
	}
	if ($deprecated)
	{
		$tasksMD = $tasksMD + " (deprecated)"
	}
	$tasksMD = $tasksMD + " | $category"
	$tasksMD = $tasksMD + " | $description |`n"
}

$tasksMD
