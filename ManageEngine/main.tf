terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}
locals {
  tags = {
    environment = "${var.env}"
    owner       = "${var.owner}"
    ags         = "${var.ags}"
  }
}
resource "azurerm_resource_group" "rg" {
  
  name     = "${var.ags}_rg_${var.env}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.ags}_${var.virtual_network_name}"
  address_space       = [var.virtual_network_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.ags}_${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefixes]
}

# ROUGH DRAFT BUT NEEDS TWEAKING AND INPUT FROM NETWORK AND SECURITY TEAM
# resource "azurerm_network_security_group" "nsg" {
#   name                = "${var.ags}_${var.network_security_group_name}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "Allow RDP"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = var.rdp_source_address_prefix
#     destination_address_prefix = "*"
#   }
# }

#### THIS IS ONLY NECESSARY IF A PUBLIC IP WILL BE IN USE, WHICH IT WON'T WITH OUR PILOT 
#resource "azurerm_public_ip" "public_ip" {
#   count = var.virtual_machine_count
#   name                = "${var.ags}_${var.public_ip_name}-${count.index}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
#   tags                = local.tags
# }

###########
##APP VMs##
###########
resource "azurerm_network_interface" "nic" {
  count               = var.virtual_machine_count
  name                = "${var.ags}_${var.network_interface_name_prefix}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    #public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  #network_security_group_id = azurerm_network_security_group.nsg.id
  tags                      = local.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = var.virtual_machine_count
  name                  = "${var.virtual_machine_name_prefix}-${count.index}"
  location              = azurerm_resource_group.rg.location
  size = var.virtual_machine_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = "${var.virtual_machine_name_prefix}-${count.index}"
  tags = local.tags
}

#########
##DB VM##
#########

resource "azurerm_network_interface" "sqlnic" {

  name                = "${var.ags}_${var.network_interface_name_prefix}-sql"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    #public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  #network_security_group_id = azurerm_network_security_group.nsg.id
  tags                      = local.tags
}

resource "azurerm_windows_virtual_machine" "sqlvm" {
  name                  = "${var.virtual_machine_name_prefix}-sql"
  location              = azurerm_resource_group.rg.location
  size = var.virtual_machine_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = azurerm_network_interface.sqlnic.*.id

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
#   os_disk {
#     name              = "${var.virtual_machine_name_prefix}-${count.index}-osdisk"
#     caching           = var.os_disk_caching
#     create_option     = "FromImage"
#     managed_disk_type = var.os_disk_storage_account_type

#     encryption_settings {
#       enabled = true
#     }
#   }
  computer_name  = "${var.virtual_machine_name_prefix}-sql"
  tags = local.tags
}