param loadBalancerName string
param location string
param sku string
param frontendName string
param publicIpId string

resource loadBalancer 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: loadBalancerName
  location: location

  sku: {
    name: sku
    tier: 'Regional'
  }

  properties: {
    frontendIPConfigurations: [
      {
        name: frontendName

        properties: {
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
  }
}

output loadBalancerId string = loadBalancer.id
