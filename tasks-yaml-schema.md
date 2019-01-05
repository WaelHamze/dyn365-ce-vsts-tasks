
### MSCRM Tool Installer
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMToolInstaller.MSCRMToolInstaller@9
  displayName: {String}
```
### MSCRM Set Online Instance Admin Mode
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMSetOnlineInstanceAdminMode.MSCRMSetOnlineInstanceAdminMode@10
  displayName: {String}
  inputs:
    username: {String}
    password: {String}
    instanceName: {String}
    enable: {Boolean}
    allowBackgroundOperations: false
    notificationText:{String}
  continueOnError: {Boolean}
  timeoutInMinutes: 100
```

### MSCRM Export Solution

```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMExportSolution.MSCRMExportSolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName:{String}
    exportManaged: {Boolean}
    targetVersion: {String}
    updateVersion: {Boolean}
    includeVersionInSolutionFile: {Boolean}
    exportAutoNumberingSettings: {Boolean}
    exportCalendarSettings: {Boolean}
    exportCustomizationSettings: {Boolean}
    exportEmailTrackingSettings: {Boolean}
    exportExternalApplications: {Boolean}
    exportGeneralSettings: {Boolean}
    exportIsvConfig: {Boolean}
    exportMarketingSettings: {Boolean}
    exportOutlookSynchronizationSettings: {Boolean}
    exportRelationshipRoles: {Boolean}
    exportSales: {Boolean}
  continueOnError: {Boolean}
```

### MSCRM Set Version

```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMSetVersion.MSCRMSetVersion@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName: {String}
    versionNumber:{String}
  continueOnError: {Boolean}
```

### MSCRM Get Online Instance By Name
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMGetOnlineInstanceByName.MSCRMGetOnlineInstanceByName@10
  displayName: {String}
  inputs:
    username: {String}
    Password:{String}
    instanceName: {String}
    vstsInstanceIdOutputVariableName: {String}
```

### MSCRM Update Secure Configuration
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMUpdateSecureConfiguration.MSCRMUpdateSecureConfiguration@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
```

### MSCRM Remove Solution Components
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMRemoveSolutionComponents.MSCRMRemoveSolutionComponents@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName:{String}
```

### MSCRM Publish Customizations
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMPublishCustomizations.MSCRMPublishCustomizations@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
```

### MSCRM Backup Online Instance
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMBackupOnlineInstance.MSCRMBackupOnlineInstance@10
  displayName: {String}
  inputs:
    username: {String}
    Password:{String}
    instanceName: {String}
    backupLabel: {String}
    notes: {String}
    isAzureBackup: {Boolean}
    containerName: {String}
    storageAccountKey:{String}
    storageAccountName:{String}
  continueOnError: {Boolean}  
```

### MSCRM Provision Online Instance
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMProvisionOnlineInstance.MSCRMProvisionOnlineInstance@10
  displayName: {String}
  inputs:
    username: {String}
    password:{String}
    domainName: {String}
    friendlyName: {String}
    instanceType: Production
```

### MSCRM Delete Online Instance
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMDeleteOnlineInstance.MSCRMDeleteOnlineInstance@10
  displayName: {String}
  inputs:
    username: {String}
    Password:{String}
    instanceName: {String}
```

### MSCRM Copy Solution Components
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMCopySolutionComponents.MSCRMCopySolutionComponents@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    fromSolutionName:{String}
    toSolutionName: {String}
```

### MSCRM Split Plugin Assembly
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMSplitPluginAssembly.MSCRMSplitPluginAssebly@10
  displayName: {String}
  inputs:
    projectFilePath: {String}
    regexType: filename | filecontaint
```

### MSCRM Remove Solution 
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMRemoveSolution.MSCRMRemoveSolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName: {String}
```

### MSCRM Restore Online Instance
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMRestoreOnlineInstance.MSCRMRestoreOnlineInstance@10
  displayName: {String}
  inputs:
    username: {String}
    Password: {String}
    sourceInstanceName:{String}
    backupLabel: {String}
    targetInstanceName: {String}
```

### MSCRM Extract Solution
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMExtractSolution.MSCRMExtractSolution@10
  displayName: {String}
  inputs:
    unpackedFilesFolder: {String}
    mappingFile: {String}
```

### MSCRM Ping
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMPing.MSCRMPing@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
```

### MSCRM Pack Solution
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMPackSolution.MSCRMPackSolution@10
  displayName: {String}
  inputs:
    unpackedFilesFolder: {String}
```

### MSCRM Service Endpoint Registration
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMServiceEndpointRegistration.MSCRMServiceEndpointRegistration@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    registrationType: upsert
    mappingFile: {String}
```

### MSCRM Package Deployment
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMPackageDeployer.MSCRMPackageDeployer@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    packageName:{String}
```

### MSCRM Plugin Registration
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMPluginRegistration.MSCRMPluginRegistration@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    registrationType: upsert
    assemblyPath: {String}
    solutionName:{String}
```

### MSCRM Update Web Resource
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMUpdateWebResources.MSCRMUpdateWebResource@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    webResourceDeploymentType: developerToolkit
    webResourceProjectPath: {String}
    solutionName:{String}
```

### MSCRM Update Configuration Records
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMUpdateConfigurationRecords.MSCRMUpdateConfigurationRecords@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    entityName:{String}
    lookupFieldName: {String}
    valueFieldName: {String}
```

### MSCRM Import Solution
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMImportSolution.MSCRMImportSolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    publishWorkflows: {Boolean}
    overwriteUnmanagedCustomizations: {Boolean}
    skipProductUpdateDependencies: {Boolean}
    convertToManaged: {Boolean}
    holdingSolution: {Boolean}
    override: {Boolean}
  continueOnError: {Boolean}
```

### MSCRM Apply Solution Upgrade
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMApplySolution.MSCRMApplySolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName: {String}
```

### MSCRM Create Solution
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMCreateSolution.MSCRMCreateSolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    uniqueName: {String}
	displayName: {String}
	publisherUniqueName: {String}
	versionNumber: {String}
	description: {String}
	crmConnectionTimeout: {String}

```

### MSCRM Create Patch
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMCreatePatch.MSCRMCreatePatch@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    uniqueName: {String}
	displayName: {String}
	versionNumber: {String}
	crmConnectionTimeout: {String}
```

### MSCRM Clone Solution
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMCloneSolution.MSCRMCloneSolution@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    uniqueName: {String}
	displayName: {String}
	versionNumber: {String}
	crmConnectionTimeout: {String}
```

### MSCRM Update Solution Description
```
- task: WaelHamze.xrm-ci-framework-build-tasks.MSCRMUpdateSolutionDescription.MSCRMUpdateSolutionDescription@10
  displayName: {String}
  inputs:
    crmConnectionString: {String}
    solutionName: {String}
	newDescription: {String}
	descriptionUpdateMethod: {String}
	crmConnectionTimeout: {String}
```
