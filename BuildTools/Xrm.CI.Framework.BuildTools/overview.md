# Dynamics 365 Build Tools
**Dynamics 365 Build Tools is a set of tools that makes it easy and quick to automate builds and deployment of your Dynamics 365 CE solutions.**

This will allow you to setup a fully automated DevOps pipeline so you can deliver CRM more frequently in a consistent and reliable way.

## Compatibility

**Dynamics 365 (8.x.x)**
**Dynamics 365 (9.x.x)**
(Some tasks may work with previous version of CRM)

**VSTS/TFS** For support and installation [instructions](https://docs.microsoft.com/en-us/vsts/marketplace/get-tfs-extensions)

Works with Hosted VSTS Agents

## Task Catalog

Below is a list of tasks that are included with this extension.

**You must add the 'MSCRM Tool Installer' at the begining of every agent phase for the task to work.**

| Task | Description |
| --- | --- |
| **MSCRM Apply Solution Upgrade** | Applies a solution upgrade after solution is import using stage for upgrade option |
| **MSCRM Backup Online Instance** | Creates a backup of a Dynamics 365 Customer Engagement Online Instance |
| **MSCRM Clone Solution** | Clones a CRM unmanaged Solution |
| **MSCRM Copy Solution Components** | Add components from a given solution to another solution if not present |
| **MSCRM Create Patch** | Creates an unmanaged CRM Solution Patch |
| **MSCRM Create Solution** | Creates an unmanaged CRM Solution |
| **MSCRM Delete Instance** | Deletes an Online Instance |
| **MSCRM Export Solution** | Exports a CRM Solution from the source CRM environment |
| **MSCRM Export Solutions Using Config** (preview) | Exports Dynamics 365 Solutions using a json configuration |
| **MSCRM Extract Solution** | Extracts CRM Solution xml files from CRM Solution zip using SolutionPackager.exe |
| **MSCRM Get Online Instance By Name** | Gets an Online instance ID based on the name of the instance. |
| **MSCRM Import Solution** | Import a Dynamics CRM Solution package |
| **MSCRM Import Solutions Using Config** (preview) | Imports Dynamics 365 Solutions using a json configuration |
| **MSCRM Package Deployer** | Deploys a CRM Package using the CRM Package Deployer PowerShell Cmdlets |
| **MSCRM Pack Solution** | Packages a CRM Solution using SolutionPackager.exe |
| **MSCRM Pack Solutions Using Config** (preview) | Packs Dynamics 365 Solutions using a json configuration |
| **MSCRM Ping** | A sample task that checks connectivity to a Dynamics 365 environment |
| **MSCRM Plugin Registration** (preview) | Upsert Dynamics 365 plugin/workflow activity assembly/types/steps |
| **MSCRM Provision Online Instance** | Creates a new Dynamics 365 Customer Engagement Online Instance |
| **MSCRM Publish Customizations** | Publishes all CRM customizations |
| **MSCRM Remove Solution** (preview) | Removes the given CRM Solution |
| **MSCRM Remove Solution Components** | Removes all components from a given CRM Solution |
| **MSCRM Restore Instance** | Restores an online instance from a previous backup |
| **MSCRM Service Endpoint Registration** (preview) | Upsert Dynamics 365 Service Endpoints and steps |
| **MSCRM Set Online Instance Admin Mode** | Enable/Disable administration mode on Online Instances |
| **MSCRM Set Version** | Updates the version of a CRM Solution |
| **MSCRM Split Plugin Assembly** (preview) | Splits the plugin assembly into multiple plugin assemblies |
| **MSCRM Tool Installer** | Installs the Dynamics 365 tools required by all of the tasks |
| **MSCRM Update Configuration Records** (preview) | Upserts a configuration entity records using lookup/value pairs |
| **MSCRM Update Plugin Assembly** (deprecated) | Updates Dynamics 365 plugin assembly from file |
| **MSCRM Update Secure Configuration** | A task that updates Dynamics 365 plugin secure configuration |
| **MSCRM Update Solution Description** (preview) | Updates the description of a given CRM Solution |
| **MSCRM Update Web Resources** (preview) | Updates Dynamics 365 Web Resources from source control |

Some explanation for tasks that have the below in the names:

preview: New functionality. May contain some bugs. Subject to breaking changes while in preview.

deprecated: Task has been replaced with another task or is no longer required. Will be removed in future release.

## Build Automation

You can combine the xRM CI Framework tasks with other tasks to create a build definition as needed.

Below is a sample build definition that publishes customizations, updates solution version to match build number, exports the solution from CRM and then publishes the zip as an artifact in VSTS

![Build Definition](Images/OnlineBuildDefinition.png)

![Build Console](Images/OnlineBuildConsole.png)

![Build Artifacts](Images/OnlineBuildArtifacts.png)

## Release Automation

You can combine the xRM CI Framework tasks with other tasks to create a release definition as needed.

Below is a sample release definition that imports the solution generated from the latest build into the QA environment.

![Release Definition](Images/ThirdPartyReleaseDefinition.png)

![Release Logs](Images/ThirdPartyReleaseLogs.png)

![Solution Imported](Images/ThirdPartySolutionImported.png)

## More Information

For more documentation and source code, check out Github using the links on this page.

## Known Issues

MSCRM Restore Online Instance: May return 'internval server error' due to issue at vendor platform

## Version History

**8.0.x**
Initial Release

**8.1.x**  
Added task to backup CRM online instances

**8.2.x**  
MSCRM Backup Online Instance now uses instance name instead of instance id
Added Tasks for Provision, Restore, Delete and Get Online Instances  
Added Task for updating Secure Configuration of Plug-ins  

**8.3.x**  
Added Task Set Online Instance Admin Mode

**9.0.x**  
Updated to use Dynamics 365 CE v9 Assemblies and Tools

**9.1.x**  
Added Tasks to managing Plugin Registration  
Added Task for updating Web Resources  
Added Tasks for removing/copying solution components  
Added tasks for Exracting Customisations into source

**9.2.x**  
Added Tools Installer Task to improve efficieny and reduce extension size  
Added new task to upsert configuration records  
Improvements to Plugin Registration and Web Resource Tasks  
Updated to 9.0.2.4 SDK Assemblies and Tools

**9.3.x**  
Added Task to manage Service Endpoints  
Added Task to Delete a Solution  
Added Synch mode for Solution Import Task  
Added Async mode for Apply Solution Task  
Update Configuration Records Task to support updating mutiple value fields  

**9.4.x**  
Updated to 9.0.2.5 SDK Assemblies and Tools  

**9.5.x**  
Added tasks to Create Solution, Clone Solution, Create Patch and Update Solution Description  
Enhancements to Import Solution stability and improved logging (ver. 11)  
Plugin Registration task now supports StateCode and AsyncAutoDelete in json for Plug-in Steps  

**9.6.x**  
Updated SDK core assemblies to 9.0.2.9 and tools to 9.0.2.11  
Added ability to specify custom log directory and file for Import Solution task  
Added tasks to allow exporting/importing mutiple solution using json configuration  
Added task to allow packing mutiple solutions using json configuration  
Enhacements to Pack Solution task and improved logging  
Set Version task now allows setting version on extracted solution files  
Updating version as part of Export/Pack Solution task is now deprecated. These will be removed in next release. Use the Set Version task instead.  


For more information on changes between versions, check the commits and releases on GitHub
