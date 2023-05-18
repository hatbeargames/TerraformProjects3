terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

locals {
  tags = {
    environment = "${var.env}"
    owner       = "${var.owner}"
    ags         = "${var.ags}"
  }
}

resource "azurerm_resource_group" "localName_resourcegroup" {
  #name     = var.rsgname
  name     = "${var.ags}_rg"
  location = var.location
  tags     = local.tags
}
