locals {
  parameter_arn = var.ignore_value_changes ? aws_ssm_parameter.this_ignore_value[0].arn : aws_ssm_parameter.this[0].arn
}

resource "aws_ssm_parameter" "this" {
  count = var.ignore_value_changes ? 0 : 1

  name        = var.parameter_name
  description = var.parameter_description
  type        = var.parameter_type
  key_id      = var.parameter_key_id
  tier        = "Advanced"
  value       = var.parameter_value
  tags        = var.tags
}

resource "aws_ssm_parameter" "this_ignore_value" {
  count = var.ignore_value_changes ? 1 : 0

  name        = var.parameter_name
  description = var.parameter_description
  type        = var.parameter_type
  key_id      = var.parameter_key_id
  tier        = "Advanced"
  value       = var.parameter_value
  tags        = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

moved {
  from = aws_ssm_parameter.this
  to   = aws_ssm_parameter.this[0]
}

module "ram_resource_share" {
  source = "../ram_resource_share"

  name                      = var.resource_share_name
  allow_external_principals = var.allow_external_principals

  resources  = [local.parameter_arn]
  principals = var.principals_to_share_with

  tags = var.tags
}
