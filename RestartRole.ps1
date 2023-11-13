#===============================================================================
# Microsoft FastTrack for Azure
# Restart one or all Cloud Services Extended Support Roles
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================
param(
    [Parameter(Mandatory)]$subscriptionId,
    [Parameter(Mandatory)]$resourceGroupName,
    [Parameter(Mandatory)]$cloudServiceName,
    [Parameter(Mandatory)]$roleName,
    [switch]$interactive
)

if ($interactive -eq $true) {
    # Login to Azure
    Connect-AzAccount

    # Set subscription context
    Set-AzContext -Subscription $subscriptionId
}
else {
    # Ensures you do not inherit an AzContext in your runbook
    Disable-AzContextAutosave -Scope Process | Out-Null

    # Connect using a Managed Service Identity
    try {
        $AzureContext = (Connect-AzAccount -Identity).context
    }
    catch {
        Write-Output "There is no system-assigned user identity. Aborting."; 
        exit
    }

    # Set and store context
    $AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
}

# If wildcard is passed in for the role name, restart all role instances
if ($roleName -eq "*") {
    Write-Output "Restarting all role instances for cloud service $cloudServiceName..."
    Restart-AzCloudService -ResourceGroupName $resourceGroupName -CloudServiceName $cloudServiceName -RoleInstance "*"
    Write-Output "Role instances restarted successfully"
}
else {
    # Only restart role instances that match the provided role name
    $roleInstanceNames = @()
    $roleInstances = Get-AzCloudServiceRoleInstance -ResourceGroupName $resourceGroupName -CloudServiceName $cloudServiceName
    $roleInstances | ForEach-Object {
        if ($_.Name.StartsWith($roleName)) {
            $roleInstanceNames += $_.Name
        }
    }
    if ($roleInstanceNames.Length -gt 0) {
        Write-Output "Restarting the following role instances for cloud service ${cloudServiceName}: $roleInstanceNames..."
        Restart-AzCloudService -ResourceGroupName $resourceGroupName -CloudServiceName $cloudServiceName -RoleInstance $roleInstanceNames
        Write-Output "Role instances restarted successfully"
    }
}