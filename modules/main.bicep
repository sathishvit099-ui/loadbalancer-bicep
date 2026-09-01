targetScope = 'subscription'

param environment string
param location string
param landingZones object


//===================================================
// RESOURCE GROUPS
//===================================================

module rModule 'resourcegroup.bicep' = [
  for rg in landingZones.resourceGroups: {

    name: 'rg-${rg.rgName}-${environment}-${location}'

    scope: subscription()

    params: {
      rgname: rg.rgName
      location: rg.location
      tags: rg.tags
    }
  }
]


//===================================================
// PUBLIC IPs
//===================================================

module publicIpModule 'networking/publicIp.bicep' = [
  for pip in landingZones.publicIps: {

    name: 'pip-${pip.publicIpName}-${environment}-${location}'

    scope: resourceGroup(pip.resourceGroupName)

    // Resource Group must be created first
    dependsOn: [
      rModule
    ]

    params: {
      publicIpName: pip.publicIpName
      location: pip.location
      sku: pip.sku
      allocationMethod: pip.allocationMethod
    }
  }
]


//===================================================
// STANDARD PUBLIC LOAD BALANCERS
//===================================================

module loadBalancerModule 'networking/loadBalancer.bicep' = [
  for (lb, i) in landingZones.loadBalancers: {

    name: 'lb-${lb.loadBalancerName}-${environment}-${location}'

    scope: resourceGroup(lb.resourceGroupName)

    // Resource Group and Public IP must exist first
    dependsOn: [
      rModule
      publicIpModule
    ]

    params: {
      loadBalancerName: lb.loadBalancerName
      location: lb.location
      sku: lb.sku

      frontendName: lb.frontend.name

      publicIpId: publicIpModule[i].outputs.publicIpId
    }
  }
]
