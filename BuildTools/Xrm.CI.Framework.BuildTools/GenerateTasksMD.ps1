#
# GenerateTasksMD.ps1
#

$tasks = Get-ChildItem .\Tasks -directory
$counter = 1

$ErrorActionPreference = "Stop"

$tasksMD = "| Task | Description |`n"
$tasksMD = $tasksMD + "| --- | --- |`n"

foreach($task in $tasks)
{
	$taskJson = Get-Content "Tasks\$task\task.json" | Out-String | ConvertFrom-Json
	$name = $taskJson.name
	$friendlyName = $taskJson.friendlyName
	$description = $taskJson.description
	$preview = $taskJson.preview
	$deprecated = $taskJson.deprecated

	$tasksMD = $tasksMD + "| **$friendlyName**"
	if ($preview)
	{
		$tasksMD = $tasksMD + " (preview)"
	}
	if ($deprecated)
	{
		$tasksMD = $tasksMD + " (deprecated)"
	}
	$tasksMD = $tasksMD + " | $description |`n"
}

$tasksMD
