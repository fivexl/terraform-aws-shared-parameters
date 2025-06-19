resource "aws_ssm_parameter" "this" {
  name        = var.parameter_name
  description = var.parameter_description
  type        = var.parameter_type
  key_id      = var.parameter_key_id != null ? var.parameter_key_id : null
  tier        = "Advanced"
  value       = var.parameter_value
  tags        = var.tags
}

module "ram_resource_share" {
  source = "../ram_resource_share"

  name                      = var.resource_share_name
  allow_external_principals = var.allow_external_principals

  resources  = [aws_ssm_parameter.this.arn]
  principals = var.principals_to_share_with

  tags = var.tags
}