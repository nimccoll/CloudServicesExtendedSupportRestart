# CloudServicesExtendedSupportRestart
Sample PowerShell scripts to restart Cloud Services Extended Support Role Instances

# RestartRole.ps1
This script will allow you to restart all instances of a specified role or all role instances for an entire Cloud Services Extended Support service. Supplying a role name will restart all instances for that role. Supplying a wild card (*) for the role name will restart all role instances for the cloud service. The script has been designed to run interactively or via an Azure Automation run book.

## Inputs
- subscriptionId - Azure subscription ID
- resourceGroupName - Resource Group Name of the resource group that contains the cloud service
- cloudServiceName - Cloud Services Extended Support name
- roleName - The name of the role to restart. All role instances for this role name will be restarted. To restart all role instances for the entire cloud service pass in a wildcard (*).
- interactive - A switch parameter that when specified via -interactive will run the script in interactive mode prompting for your Azure credentials

## Prerequisites
- If you plan to run the script via an Azure Automation run book, create a system assigned managed identity for your Azure Automation account following the steps outlined [here](https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation#enable-using-the-azure-portal). Assign the system assigned managed identity the Contributor role on the Cloud Services Extended Support service.
- If you want to run the script interactively, add the -interactive switch.