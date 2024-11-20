module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.1"
}

module "shared_parameter_data" {
  source = "../../shared_parameter_data"

  resource_share_name = module.naming_conventions.default_kms_key_resource_share_name
  resource_owner      = var.resource_owner
}

output "value" {
  value       = nonsensitive(module.shared_parameter_data.value)
  description = "The ARN of the shared KMS key"
}

variable "resource_owner" {
  description = "The owner of the resource share"
  type        = string
  default     = "OTHER-ACCOUNTS"
}
