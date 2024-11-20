module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.1"
}

module "org_info" {
  source = "../../shared_parameter_data"

  resource_share_name = module.naming_conventions.org_info_ram_resource_share_name
  resource_owner      = var.resource_owner
}

locals {
  org_info = nonsensitive(jsondecode(module.org_info.value))
}

variable "resource_owner" {
  description = "The owner of the resource share"
  type        = string
  default     = "OTHER-ACCOUNTS"
}
