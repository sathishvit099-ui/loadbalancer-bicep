using '../modules/main.bicep'

param environment = 'dev'

param location = 'centralus'

param landingZones = {

  resourceGroups: [
    {
      rgName: 'rg-loadbalancer-dev'

      location: location

      tags: {
        Environment: environment
        Application: 'LoadBalancer'
        ManagedBy: 'Bicep'
        Team: 'CloudOps'
      }
    }
  ]

  publicIps: [
    {
      publicIpName: 'pip-loadbalancer-dev'

      resourceGroupName: 'rg-loadbalancer-dev'

      location: location

      sku: 'Standard'

      allocationMethod: 'Static'
    }
  ]

  loadBalancers: [
    {
      loadBalancerName: 'lb-dev'

      resourceGroupName: 'rg-loadbalancer-dev'

      location: location

      sku: 'Standard'

      frontend: {
        name: 'public-frontend'
      }
    }
  ]
}
