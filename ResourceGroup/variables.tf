# variable "rsgname" {
#   type        = string
#   description = "Resource Group Name"
#   #default     = "TerraformRG"
# }

variable "location" {
  type        = string
  description = "The location for deployment"
  #default     = "West US"
}
variable "ags" {
  type        = string
  description = "Application Gold Source Acronym. Must be submitted on creation"
}

variable "owner" {
  type        = string
  description = "Owner of the AGS. Must be submitted on creation"
}

variable "env" {
  type        = string
  description = "The level of environment for resources"
  validation {
    condition     = var.env == "prod" || var.env == "dev" || var.env == "qa"
    error_message = "Environment variable must be set to one of the three valid environments: prod, dev, or qa."
  }
}
