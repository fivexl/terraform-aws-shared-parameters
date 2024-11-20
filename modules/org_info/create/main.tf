module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.1"
}

module "shared_parameter" {
  source = "../../shared_parameter"

  parameter_name           = module.naming_conventions.org_info_ssm_parameter_name
  resource_share_name      = module.naming_conventions.org_info_ram_resource_share_name
  parameter_description    = "Organization information including ARN, root ID, org ID, and account IDs"
  parameter_key_id         = var.shared_kms_key_arn
  parameter_value          = jsonencode(local.org_info)
  principals_to_share_with = var.principals_to_share_with

  tags = var.tags
}
