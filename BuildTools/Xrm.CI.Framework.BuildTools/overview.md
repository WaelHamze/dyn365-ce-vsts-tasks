# Dynamics 365 Build Tools
**Dynamics 365 Build Tools is a set of tools that makes it easy and quick to automate builds and deployment of your PowerApps/CDS/Dynamics 365 CE solutions.**

This will allow you to setup a fully automated DevOps pipeline so you can deliver CRM more frequently in a consistent and reliable way.

## Compatibility

**Dynamics 365 (8.x.x)**  
**Dynamics 365 (9.x.x)/CDS/PowerApps**  
(Some tasks may work with previous version of Dynamics CRM)

**Azure DevOps/Azure DevOps Server/TFS** For support and installation [instructions](https://docs.microsoft.com/en-us/vsts/marketplace/get-tfs-extensions)

Works with Hosted VSTS Agents

## Task Catalog

Below is a list of tasks that are included with this extension.

**You must add the 'MSCRM Tool Installer' at the begining of every agent phase for the other tasks to work.**

| Task | Category | Description |
| --- | --- | --- |
| **MSCRM Tool Installer** | Utility | Installs the Dynamics 365 tools required by all of the tasks |
| **MSCRM Ping** | Utility | A sample task that checks connectivity to a Dynamics 365 environment |
| **MSCRM Create Solution** | Solution | Creates an unmanaged CRM Solution |
| **MSCRM Create Patch** | Solution | Creates an unmanaged CRM Solution Patch |
| **MSCRM Get Solution** (preview) | Solution | Retrieves solution details from a CRM instance |
| **MSCRM Get Latest Patch** (preview) | Solution | Retrieves the latest patch for a given solution |
| **MSCRM Get Solution Missing Dependencies** (preview) | Solution | Retrieves missing dependencies for a solution in a instance |
| **MSCRM Update Solution Description** (preview) | Solution | Updates the description of a given CRM Solution |
| **MSCRM Set Version** | Solution | Updates the version of a CRM Solution |
| **MSCRM Copy Solution Components** | Solution | Add components from a given solution to another solution if not present |
| **MSCRM Export Solution** | Solution | Exports a CRM Solution from the source CRM environment |
| **MSCRM Extract Solution** | Solution | Extracts CRM Solution xml files from CRM Solution zip using SolutionPackager.exe |
| **MSCRM Pack Solution** | Solution | Packages a CRM Solution using SolutionPackager.exe |
| **MSCRM Pack Solutions Using Config** (preview) | Solution | Packs Dynamics 365 Solutions using a json configuration |
| **MSCRM Clone Solution** | Solution | Clones a CRM unmanaged Solution |
| **MSCRM Export Solutions Using Config** (preview) | Solution |  Exports Dynamics 365 Solutions using a json configuration |
| **MSCRM Get Solution Missing Components** (preview) | Solution | Retrieves missing components for a solution from a target instance |
| **MSCRM Import Solution** | Solution | Import a Dynamics CRM Solution package |
| **MSCRM Import Solutions Using Config** (preview) | Solution | Imports Dynamics 365 Solutions using a json configuration |
| **MSCRM Apply Solution Upgrade** | Solution | Applies a solution upgrade after solution is import using stage for upgrade option |
| **MSCRM Remove Solution** (preview) | Solution | Removes the given CRM Solution |
| **MSCRM Remove Solution Components** | Solution | Removes all components from a given CRM Solution |
| **MSCRM Publish Customizations** | Solution | Publishes all CRM customizations |
| **MSCRM Check Solution** | Solution | Uses PowerApps Checker API to validate your solution against a list of known issues |
| **MSCRM Checker Quality Gate** | Solution | Validates PowerApps Checker scan results against defined thresholds |
| **MSCRM Get Online Instance By Name** | Environment | Gets an Online instance ID based on the name of the instance. |
| **MSCRM Provision Online Instance** | Environment | Creates a new Dynamics 365 Customer Engagement Online Instance |
| **MSCRM Backup Online Instance** | Environment | Creates a backup of a Dynamics 365 Customer Engagement Online Instance |
| **MSCRM Restore Instance** | Environment | Restores an online instance from a previous backup |
| **MSCRM Copy Instance** (preview) | Environment | Copies a source instance to a target instance |
| **MSCRM Reset Online Instance** (preview) | Environment | Resets a Dynamics 365 Customer Engagement Online Instance |
| **MSCRM Set Online Instance Admin Mode** | Environment | Enable/Disable administration mode on Online Instances |
| **MSCRM Delete Instance** | Environment | Deletes an Online Instance |
| **MSCRM Export Config Migration Data** (preview) | Data | Exports data from a CRM instance using a Configuration Migration schema file |
| **MSCRM Extract Config Migration Data** (preview) |  Data | Extracts the data zip exported using Configuration Migration Tool into folder with the option split and sort the data.xml |
| **MSCRM Pack Config Migration Data** (preview) |  Data | Packs the data files that have been extracted using Extract task back into a data zip that can be imported using Configuration Migration Tool |
| **MSCRM Import Config Migration Data** (preview) |  Data | Import data exported using Configuration Migration Tool into a CRM instance |
| **MSCRM Get Configuration Record** (preview) | Data | Retrieves a configuration entity record value using a unique lookup value |
| **MSCRM Update Configuration Records** (preview) | Data | Upserts a configuration entity records using lookup/value pairs |
| **MSCRM Get Environment Variable** (preview) | Data | Retrieves the current environment variable value from a CDS instance |
| **MSCRM Update Environment Variables** (preview) | Data | Upserts environemnt variables current value record using name/value pairs |
| **MSCRM Package Deployer** | Package Deployer | Deploys a CRM Package using the CRM Package Deployer PowerShell Cmdlets |
| **MSCRM Plugin Registration** (preview) | Plug-ins | Upsert Dynamics 365 plugin/workflow activity assembly/types/steps |
| **MSCRM Split Plugin Assembly** (preview) | Plug-ins | Splits the plugin assembly into multiple plugin assemblies |
| **MSCRM Update Plugin Assembly** (deprecated) | Plug-ins | Updates Dynamics 365 plugin assembly from file |
| **MSCRM Update Secure Configuration** | Plug-ins | A task that updates Dynamics 365 plugin secure configuration |
| **MSCRM Service Endpoint Registration** (preview) | Plug-ins | Upsert Dynamics 365 Service Endpoints and steps |
| **MSCRM Update Web Resources** (preview) | Web Resources | Updates Dynamics 365 Web Resources from source control |

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

N/A  

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

**9.7.x**  
Added task to retrieve missing components for a solution for a target instance  
Added task to retrieve missing dependencies for a solution in the source instance  
Updated SDK assemblies/tools to 9.0.2.12  

**9.8.x**  
Updated Solution Packager to 9.0.3.1  
New task to reset v9 online instances  

**9.9.x**  
Update Solution Packager to SDK 9.0.3.4  
Enhancements to Package Deployer Task including addition of Crm Connection Timeout and more logging  
Added a task to copy online instances  
Updated Online Management PS SDK to 1.1.0.9053  
Added task to check solution using PowerApps Checker  

**9.10.x**  
Added support for localization parameters in solution packager tasks  
Added task to retrieve solution details from a CRM instance  
Added task to retrieve the latest patch for given solution  
Added task to retrieve a configuration record from a CRM instance  
Added tasks to export/import Configuration Migration Data  
Added tasks to extract/pack Configuration Migration data for version control management  

**9.11.x**  
Updated to the latest SDK Libraries (v9.1)  
Ability to use clientsecret authentication method in connection strings  
Added v9.1 in the SDK Version selection in Package Deployer Task  
Updated Check Solution Task to allow checking based on specific rules and exclude files/patterns from checks  

**9.12.x**  
Added tasks to manage Environment Variables (Get/Update)  
PowerApps Checker is now split into 2 tasks: Check Solution (v.11) and Checker Quality Gate  
Tasks that return values can be used in Task Groups through pipeline variables in addition to output parameters  
Fix for issue with updating solution description for Patches  

**9.13.x**  
PowerApps Checker task now supports rule level overrides  
PowerApps Checker/Quality Gate tasks now publishes results summary into build summary view  
Configuration Migration Import task now supports batching  
Configuration Migration Import/Export task now supports schemas containing fetch xml  
Updated Nuget Libraries/PS Modules to latest versions  

**9.14.x**  
Ability to restore an online instance using timestamp. Task now supports friendlyname and security group  
Backup instance task uses new API which is a lot faster now. Task now supports skipping if existing backup found  
Update PS modules and Nuget packages to latest versions  

For more information on changes between versions, check the milestones and releases on GitHub
