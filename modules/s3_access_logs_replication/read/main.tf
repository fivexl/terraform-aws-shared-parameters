module "naming_conventions" {
  source  = "fivexl/naming-convetions/aws"
  version = "0.0.1"
}

module "shared_parameter_data" {
  source = "../../shared_parameter_data"

  resource_share_name = module.naming_conventions.s3_access_logs_replication_configuration_resource_share_name
  resource_owner      = var.resource_owner
}

locals {
  data = nonsensitive(jsondecode(module.shared_parameter_data.value))
}

variable "resource_owner" {
  description = "The owner of the resource share"
  type        = string
  default     = "OTHER-ACCOUNTS"
}
