$Azure_AD_Security_Group = $( Get-AzADGroup | Where-Object { $_.DisplayName -eq "AVD Users - Multi Session" } ).Id
Get-AzWvdApplicationGroup -Name "BicepTestApplicationGroup" -ResourceGroupName "F8TechAzureVMs"
Get-AzRoleAssignment | Where-Object { $_.DisplayName -match "AVD Users"}
New-AzRoleAssignment `
-ObjectId  $Azure_AD_Security_Group `
-RoleDefinitionName "Desktop Virtualization User" `
-ResourceName "BicepTestApplicationGroup" `
-ResourceGroupName "F8TechAzureVMs" `
-ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'