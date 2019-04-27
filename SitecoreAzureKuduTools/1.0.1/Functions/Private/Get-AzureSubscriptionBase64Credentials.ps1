function Get-AzureSubscriptionBase64Credentials($ResourceGroupName, $ResourceName){
    
    $publishingCredentials = Get-PublishingProfileCredentials $ResourceGroupName $ResourceName
 
    return ("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword))))
}

function Get-PublishingProfileCredentials($resourceGroupName, $resourceAppName){
 
    $resourceType = "Microsoft.Web/sites/config"
    $resourceName = "$resourceAppName/publishingcredentials"
 
    $publishingCredentials = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType $resourceType -ResourceName $resourceName -Action list -ApiVersion 2015-08-01 -Force
 
    return $publishingCredentials
}