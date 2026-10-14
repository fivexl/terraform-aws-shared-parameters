locals {

  parameter_name      = var.parameter_name != "" ? var.parameter_name : module.naming_conventions.org_info_ssm_parameter_name
  resource_share_name = var.resource_share_name != "" ? var.resource_share_name : module.naming_conventions.org_info_ram_resource_share_name

  org_info = var.org_info != null ? var.org_info : module.discover[0].org_info
}
