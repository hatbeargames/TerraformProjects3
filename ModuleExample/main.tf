terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

module "resourcegroup" {
  source    = "./ResourceGroup"
  base_name = "TerraformExample01"
  location  = "East US"
}

module "StorageAccount" {
  source              = "./StorageAccount"
  base_name           = "TerraformExample01"
  resource_group_Name = module.resourcegroup.rg_name_out
  location            = "East US"
}
