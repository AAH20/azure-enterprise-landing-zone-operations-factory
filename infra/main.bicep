targetScope = 'resourceGroup'

@description('Short lowercase prefix used for globally unique names.')
@minLength(3)
@maxLength(12)
param prefix string

param location string = resourceGroup().location
param environment string = 'lab'
param deployOperations bool = true

var tags = {
  owner: 'a2zsoc'
  environment: environment
  workload: 'enterprise-landing-zone-operations-factory'
  costControl: 'ephemeral'
  evidenceStatus: 'implemented'
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    prefix: prefix
    location: location
    tags: tags
  }
}

module security 'modules/security.bicep' = {
  name: 'security'
  params: {
    prefix: prefix
    location: location
    tags: tags
    privateEndpointSubnetId: network.outputs.privateEndpointSubnetId
    spokeVnetId: network.outputs.spokeVnetId
  }
}

module operations 'modules/operations.bicep' = if (deployOperations) {
  name: 'operations'
  params: {
    prefix: prefix
    location: location
    tags: tags
  }
}

output inventory object = {
  hubVnet: network.outputs.hubVnetId
  spokeVnet: network.outputs.spokeVnetId
  storageAccount: security.outputs.storageAccountId
  keyVault: security.outputs.keyVaultId
  logAnalytics: deployOperations ? operations!.outputs.workspaceId : ''
}
