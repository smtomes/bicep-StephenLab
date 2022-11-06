# Assing Azure AD security group "AVD Users - Multi Session" to desktop application group:

$Azure_AD_Security_Group = $( Get-AzADGroup | Where-Object { $_.DisplayName -eq "AVD Users - Multi Session" } ).Id
New-AzRoleAssignment `
-ObjectId  $Azure_AD_Security_Group `
-RoleDefinitionName "Desktop Virtualization User" `
-ResourceName "BicepTestApplicationGroup" `
-ResourceGroupName "StephenLab" `
-ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'