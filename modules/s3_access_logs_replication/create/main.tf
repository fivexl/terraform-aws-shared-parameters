data "aws_caller_identity" "current" {}

module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.1"
}

module "org_info" {
  source = "../../org_info/read"
}

module "shared_kms_key_arn" {
  source = "../../shared_kms_key_arn/read"
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket where access logs are delivered."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

module "shared_parameter" {
  source = "../../shared_parameter"

  parameter_name        = module.naming_conventions.s3_access_logs_replication_configuration_ssm_parameter_name
  resource_share_name   = module.naming_conventions.s3_access_logs_replication_configuration_resource_share_name
  parameter_description = "ARN of S3 bucket for S3 access logs delivery and log-archive account ID."
  parameter_key_id      = module.shared_kms_key_arn.value
  parameter_value = jsonencode({
    account_id = data.aws_caller_identity.current.account_id,
    bucket_arn = var.bucket_arn
  })
  parameter_type           = "SecureString"
  principals_to_share_with = [module.org_info.org_arn]

  tags = var.tags
}
