module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.2"
}

module "org_info" {
  source   = "../../shared_parameter_data"
  for_each = module.naming_conventions.org_info_ram_resource_share_names

  resource_share_name = each.value
  resource_owner      = var.resource_owner
}

locals {
  org_info = {
    for key, value in module.org_info :
    key => nonsensitive(jsondecode(value.value))
  }
}

variable "resource_owner" {
  description = "The owner of the resource share"
  type        = string
  default     = "OTHER-ACCOUNTS"
}
