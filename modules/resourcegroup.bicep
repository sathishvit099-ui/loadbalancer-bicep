targetScope = 'subscription'

@description('Name of the resource group')
param rgname string

@description('Azure region')
param location string

@description('Resource group tags')
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgname
  location: location
  tags: tags
}

output resourceGroupId string = rg.id
