
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
resource "azurerm_storage_account" "local_stg_name" {
  name                     = "${lower(var.base_name)}${random_string.random.result}"
  resource_group_name      = var.resource_group_Name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
