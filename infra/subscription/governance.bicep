targetScope = 'subscription'

param location string
param resourceGroupName string
param monthlyBudgetUsd int = 15
param deployBudget bool = true
param budgetStartDate string = utcNow('yyyy-MM-01')

resource labRg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: {
    owner: 'a2zsoc'
    environment: 'lab'
    costControl: 'ephemeral'
  }
}

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'a2zsoc-landing-zone-guardrails'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'A2Z SOC landing-zone tag guardrail'
    metadata: { category: 'Tags' }
    parameters: {}
    policyRule: {
      if: {
        anyOf: [
          { field: 'tags[owner]', exists: 'false' }
          { field: 'tags[environment]', exists: 'false' }
        ]
      }
      then: { effect: 'audit' }
    }
  }
}

resource assignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'a2zsoc-landing-zone-guardrails'
  location: location
  properties: {
    displayName: 'Audit operational tags'
    policyDefinitionId: definition.id
    enforcementMode: 'Default'
  }
}

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = if (deployBudget) {
  name: 'budget-landing-zone-lab'
  properties: {
    amount: monthlyBudgetUsd
    category: 'Cost'
    timeGrain: 'Monthly'
    timePeriod: { startDate: budgetStartDate, endDate: '2027-12-01' }
    notifications: {
      Forecast80: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 80
        thresholdType: 'Forecasted'
        contactEmails: []
        contactGroups: []
        contactRoles: ['Owner']
      }
      Actual100: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 100
        thresholdType: 'Actual'
        contactEmails: []
        contactGroups: []
        contactRoles: ['Owner']
      }
    }
  }
}

output resourceGroupId string = labRg.id
output policyAssignmentId string = assignment.id
output budgetEnabled bool = deployBudget
