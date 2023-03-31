# Share Power App

## Pre-requisites

  The SPN Should have the following API permissions. For more information on SPN creation visit this [link](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/use-single-tenant-server-server-authentication#azure-application-registration).

- Dynamics CRM
  - user_impersonation
- Microsof Graph
  - User.ReadAll (For sharing with users)
  - Groups.ReadAll (for sharing with groups)

  The SPN should have access to the connections used in the Flows. One way to do this is to share the connection with the SPN

In addition you must make the SPN a Power App Management App using the script below

[New-PowerAppManagementApp](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/new-powerappmanagementapp?view=pa-ps-latest) -ApplicationId [ApplicationGuid]
