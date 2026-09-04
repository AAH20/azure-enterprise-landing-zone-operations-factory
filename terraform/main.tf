terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

provider "azurerm" { features {} }

variable "location" { type = string, default = "eastus" }
variable "resource_group_name" { type = string, default = "rg-enterprise-lz-ops-lab" }

locals {
  tags = {
    owner = "a2zsoc"
    environment = "lab"
    costControl = "ephemeral"
    evidenceStatus = "implemented"
  }
}

resource "azurerm_resource_group" "lab" {
  name = var.resource_group_name
  location = var.location
  tags = local.tags
}

resource "azurerm_virtual_network" "hub" {
  name = "vnet-a2zlz-hub"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags = local.tags
}

resource "azurerm_virtual_network" "spoke" {
  name = "vnet-a2zlz-spoke"
  address_space = ["10.1.0.0/16"]
  location = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags = local.tags
}

output "resource_group_id" { value = azurerm_resource_group.lab.id }
