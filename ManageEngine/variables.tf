variable "ags" {
  type        = string
  description = "Application Gold Source Acronym. Must be submitted on creation"
}

variable "owner" {
  type        = string
  description = "Owner of the AGS. Must be submitted on creation"
}

variable "env" {
    type = string
    description = "The level of environment for resources"
    validation{
        condition = var.env == "prod" || var.env == "dev" || var.env == "qa"
        error_message = "Environment variable must be set to one of the three valid environments: prod, dev, or qa."
    }
}

# variable "subscription_id" {
#   type        = string
#   description = "Subscription ID"
# }

# variable "client_id" {
#   type        = string
#   description = "Client ID"
# }

# variable "client_secret" {
#   type        = string
#   description = "Client Secret"
# }

# variable "tenant_id" {
#   type        = string
#   description = "Tenant ID"
# }

# variable "resource_group_name" {
#   type        = string
#   description = "Resource Group Name"
# }

variable "location" {
  type        = string
  description = "Location"
  default     = "eastus"
}

variable "virtual_network_name" {
  type        = string
  description = "Network Name"
  default = "vnet"
}

variable "subnet_name" {
  type        = string
  description = "Subnet Name"
  default = "subnet"
}

variable "network_security_group_name" {
  type        = string
  description = "Network Security Group Name"
  default = "nsg"
}

variable "virtual_machine_name_prefix" {
  type        = string
  description = "Virtual Machine Name Prefix"
  default = "vm"
}

variable "admin_username" {
  type        = string
  description = "Admin UserName"
  default = "admin_user"
}

variable "admin_password" {
  type        = string
  description = "Admin Password"
  default     = "P@ssw0rd1234!"
}

variable "virtual_machine_count" {
  type        = number
  description = "Virtual Machine Count"
}

variable "virtual_machine_size" {
  type        = string
  description = "Virtual Machine Size"
  default = "Standard_B8ms"
}

variable "os_disk_caching" {
  type        = string
  description = "OS Disk Caching Setting"
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "Storage Acount Type"
}

variable "source_image_publisher" {
  type        = string
  description = "Source Image Publisher"
}

variable "source_image_offer" {
  type        = string
  description = "Source Image Offer"
}

variable "source_image_sku" {
  type        = string
  description = "Source Image SKU"
}

variable "source_image_version" {
  type        = string
  description = "Source Image Version"
  default     = "latest"
}

variable "network_interface_name_prefix" {
  type        = string
  description = "Network Interface Name Prefix"
  default = "nic"
}

variable "ip_configuration_name_prefix" {
  type        = string
  description = "IP Configuration Name Prefix"
  default = "ipc"
}

variable "private_ip_address_allocation" {
  type        = string
  description = "Private IP Address Allocation"
}

# variable "public_ip_address_id" {
#   type        = string
#   description = "Public IP Address ID"
# }

variable "virtual_network_address_space"{
    type = string
    description = "Virtual Network Address Space"
    default = "10.1.0.0/16"
}

variable "rdp_source_address_prefix" {
    type = string
    description ="Public IP of those allowed to RDP to the VMs"
}

variable "public_ip_name"{
    type = string
    description ="Name of the public IP used by the VM in question"
    default ="public_ip"
}
variable "subnet_address_prefixes"{
    type = string
    description = "Subnet Used by the system in question"
    default = "10.1.1.0/24"
}