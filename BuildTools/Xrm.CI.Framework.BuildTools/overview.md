## Overview
**Power DevOps Tools (a.k.a. Dynamics 365 Build Tools) is a set of tools that makes it easy and quick to automate builds and deployment of your PowerApps/CDS/Dynamics 365 CE solutions.**

This will allow you to setup a fully automated DevOps pipeline so you can deliver CRM more frequently in a consistent and reliable way.

[Compatibility](#compatibility)  
[Task Catalog](#task-catalogue)  
[Version History](#version-history)  
[More Information](#more-information)  

## Compatibility

**Dynamics 365 (8.x.x)**  
**Dynamics 365 (9.x.x)/CDS/PowerApps**  
(Some tasks may work with previous versions of Dynamics CRM)

**Azure DevOps/Azure DevOps Server/TFS** For support and installation [instructions](https://docs.microsoft.com/en-us/vsts/marketplace/get-tfs-extensions)

Works with Hosted Azure Agents

## Task Catalog

Below is a list of tasks that are included with this extension.

**You must add the 'Power DevOps Tool Installer' at the begining of every agent phase for the other tasks to work.**

| Task | Category | Description |
| --- | --- | --- |
| **Export Config Migration Data** | Data | Exports data from a PowerApps/CDS/Dynamics 365 instance using a Configuration Migration schema file |
| **Extract Config Migration Data** (preview) | Data | Extracts the data zip exported using Configuration Migration Tool into folder with the option split and sort the data.xml |
| **Get Configuration Record** (preview) | Data | Retrieves a configuration entity record value using a lookup from a PowerApps/CDS/Dynamics 365 environment |
| **Get Environment Variable** (preview) | Data | Retrieves the current environment variable value from a PowerApps/CDS/Dynamics 365 environment |
| **Import Config Migration Data** | Data | Import data exported using Configuration Migration Tool into a CRM instance |
| **Pack Config Migration Data** (preview) | Data | Packs the data files that have been extracted using Extract task back into a data zip that can be imported using Configuration Migration Tool |
| **Update Configuration Records** | Data | Upserts a configuration entity records using lookup/value pairs in a PowerApps/CDS/Dynamics 365 environment |
| **Update Environment Variables** (preview) | Data | Upserts environemnt variables current value record using name/value pairs in a target PowerApps/CDS/Dynamics 365 environment |
| **Backup Online Instance** | Environment | Creates a backup of a PowerApps/CDS/Dynamics 365 Environment |
| **Copy Online Instance** (preview) | Environment | Copies a source PowerApps/CDS/Dynamics 365 environment to a target environment |
| **Delete Instance** | Environment | Deletes a PowerApps/CDS/Dynamics 365 environment |
| **Get Online Instance By Name** | Environment | Gets PowerApps/CDS/Dynamics 365 environment Id based on the name of the environment |
| **Provision Online Instance** | Environment | Creates a new PowerApps/CDS/Dynamics 365 environment |
| **Reset Online Instance** | Environment | Resets a PowerApps/CDS/Dynamics 365 environment |
| **Restore Online Instance** | Environment | Restores PowerApps/CDS/Dynamcics 365 environment from a previous backup using a timestamp or label |
| **Set Online Instance Admin Mode** | Environment | Enables/Disables Admin Mode for a PowerApps/CDS/Dynamics 365 environment |
| **Apply Solution Upgrade** | Solution | Applies a solution upgrade after solution is import using stage for upgrade option |
| **Checker Quality Gate** (preview) | Solution | Validates PowerApps Checker scan results against defined thresholds |
| **Check Solution** | Solution | Uses PowerApps Checker API to validate your solution against a list of known issues |
| **Clone Solution** | Solution | Clones a PowerApps/CDS/Dynamics 365 unmanaged Solution |
| **Copy Solution Components** | Solution | Adds components from a given solution to another solution if not present |
| **Create Patch** | Solution | Creates an unmanaged CRM Solution Patch |
| **Create Solution** | Solution | Creates an unmanaged Solution |
| **Export Solution** | Solution | Exports a PowerApps/CDS/Dynamics 365 Solution from the source environment |
| **Export Solutions Using Config** (preview) | Solution | Exports PowerApps/CDS/Dynamics 365 Solutions using a json configuration |
| **Extract Solution** | Solution | Unpacks a PowerApps/CDS/Dynamics 365 Solution zip into mutiple files using SolutionPackager.exe |
| **Get Latest Patch** (preview) | Solution | Retrieves the latest patch for a given solution from a PowerApps/CDS/Dynamics 365 environment |
| **Get Solution** (preview) | Solution | Retrieves solution details from a PowerApps/CDS/Dynamics 365 instance |
| **Get Solution Missing Components** (preview) | Solution | Retrieves missing components for a solution from a PowerApps/CDS/Dynamics 365 environment |
| **Get Solution Missing Dependencies** (preview) | Solution | Retrieves missing dependencies for a solution in PowerApps/CDS/Dynamics 365 environment |
| **Import Solution** | Solution | Import a Solution into a PowerApps/CDS/Dynamics 365 environment |
| **Import Solutions Using Config** (preview) | Solution | Imports PowerApps/CDS/Dynamics 365 Solutions using a json configuration |
| **Pack Solution** | Solution | Generates a PowerApps/CDS/Dynamics 365 Solution zip from previously extracted files using SolutionPackager.exe |
| **Pack Solutions Using Config** | Solution | Generates PowerApps/CDS/Dynamics 365 Solution zips(s) from previously extracted files using a json config and SolutionPackager.exe |
| **Remove Solution** | Solution | Deletes a managed/unmanaged Solution from a PowerApps/CDS/Dynamics 365 environment |
| **Remove Solution Components** | Solution | Removes all components from a given Solution in PowerApps/CDS/Dynamics 365 environment |
| **Set Version** | Solution | Updates the version of a PowerApps/CDS/Dynamics 365 Solution |
| **Update Solution Description** | Solution | Updates the description of a given Solution in a PowerApps/CDS/Dynamics 365 environment |
| **Package Deployer** | Utility | Deploys a CRM Package using the CRM Package Deployer PowerShell Cmdlets |
| **Ping Environment** | Utility | Use this task to test connectivity to a PowerApps/CDS/Dynamics 365 environment |
| **Plugin Registration** (preview) | Utility | Updates a CDS Plugin/Workflow activity assembly/types/steps in a PowerApps/CDS/Dynamics 365 environment |
| **Publish Customizations** | Utility | Publishes all customizations in a given PowerApps/CDS/Dynamics 365 environment |
| **Service Endpoint Registration** (preview) | Utility | Updates CDS Service Endpoints and steps in a PowerApps/CDS/Dynamics 365 environment |
| **Split Plugin Assembly** (preview) (deprecated) | Utility | Splits a PowerApps/CDS/Dynamics 365 plugin assembly into multiple plugin assemblies |
| **Power DevOps Tool Installer** | Utility | Configures the tools/dependencies required by all of the tasks |
| **Update Secure Configuration** | Utility | A task that updates plugin secure configuration in a PowerApps/CDS/Dynamics 365 environment |
| **Update Web Resources** (preview) | Utility | Updates Web Resources from source control on a target PowerApps/CDS/Dynamics 365 environment |

Some explanation for tasks that have the below in the names:

**preview**: New functionality. May contain some bugs. Subject to breaking changes while in preview.

**deprecated**: Task has been replaced with another task or is no longer required. Will be removed in future release.

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

**9.15.x**
Dependencies from Nuget/PS Gallery are no longer packaged with extension these are now downloaded at runtime. (Power DevOps Tool Installer v12)  
Ability to select official sources for dependencies (nuget.prg/PS Gallery) or supply custom repositories. (Power DevOps Tool Installer v12)  
Ability to override the default version of dependencies used by supplying a specific version (e.g. Solution Packager). (Power DevOps Tool Installer v12)  
Ability to select the latest version of a dependency package (e.g. Solution Packager). (Power DevOps Tool Installer v12)  
To be able to use the above features you will need to use v12 of Power DevOps Tool Installer and v12 of other tasks  
The previously deprecated feature to update the version of a solution in the export task has been removed now. Use Set Version task instead (Export Solution v12)  
The Package Deployer task now takes full path to dll instead of dll name and path to dll (Package Deployer v12)  
Extension name changed from "Dynamics 365 Build Tools" to "Power DevOps Tools"  
v12 Tasks are no longer prefixed with MSCRM. Search by keywords (i.e. Import, Reset) depending on action or check the task list  

For more information on changes between versions, check the milestones and releases on GitHub
