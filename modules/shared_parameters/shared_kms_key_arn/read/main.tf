module "naming_conventions" {
  source  = "fivexl/naming-convetions/aws"
  version = "0.0.1"
}

module "kms_key_arn" {
  source = "../../../shared_parameter_data"

  resource_share_name = module.naming_conventions.shared_kms_key_resource_share_name
  resource_owner      = var.resource_owner
}

locals {
  kms_key_arn = nonsensitive(module.kms_key_arn.value)
}

output "value" {
  value       = local.kms_key_arn
  description = "The ARN of the shared KMS key"
}

variable "resource_owner" {
  description = "The owner of the resource share"
  type        = string
  default     = "OTHER-ACCOUNTS"
}
