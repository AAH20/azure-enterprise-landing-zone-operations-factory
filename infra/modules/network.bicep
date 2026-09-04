param prefix string
param location string
param tags object

resource hub 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-${prefix}-hub'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      { name: 'AzureFirewallSubnet', properties: { addressPrefix: '10.0.0.0/26' } }
      { name: 'shared-services', properties: { addressPrefix: '10.0.1.0/24' } }
    ]
  }
}

resource workloadNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-${prefix}-workload'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'DenyInternetInbound'
        properties: {
          priority: 4096
          access: 'Deny'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource spoke 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-${prefix}-spoke'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.1.0.0/16'] }
    subnets: [
      {
        name: 'workload'
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: { id: workloadNsg.id }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.1.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: hub
  name: 'hub-to-spoke'
  properties: {
    remoteVirtualNetwork: { id: spoke.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: spoke
  name: 'spoke-to-hub'
  properties: {
    remoteVirtualNetwork: { id: hub.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output hubVnetId string = hub.id
output spokeVnetId string = spoke.id
output privateEndpointSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', spoke.name, 'private-endpoints')
