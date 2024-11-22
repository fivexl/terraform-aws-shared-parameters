module "naming_conventions" {
  source  = "fivexl/naming-conventions/aws"
  version = "0.0.3"
}

module "shared_parameters" {
  source   = "../../shared_parameter"
  for_each = local.org_info

  parameter_name           = module.naming_conventions.org_info_ssm_parametes_names[each.key]
  resource_share_name      = module.naming_conventions.org_info_ram_resource_share_names[each.key]
  parameter_description    = "Shared SSM parameter for ${each.key}"
  parameter_key_id         = var.shared_kms_key_arn
  parameter_value          = jsonencode(each.value)
  principals_to_share_with = var.principals_to_share_with
  tags                     = var.tags
}
