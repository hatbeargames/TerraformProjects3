resource "azurerm_resource_group" "local_rg_name" {
  name     = "${var.base_name}_rg"
  location = var.location
}
