data "aws_ram_resource_share" "this" {
  name                  = var.resource_share_name
  resource_owner        = var.resource_owner
  resource_share_status = "ACTIVE"
}

data "aws_ssm_parameter" "this" {
  name = data.aws_ram_resource_share.this.resource_arns[0]
}

variable "resource_owner" {
  description = "(Optional) Owner of the resource share. Valid values are SELF or OTHER-ACCOUNTS. Defaults to OTHER-ACCOUNTS."
  type        = string
  default     = "OTHER-ACCOUNTS"
}

variable "resource_share_name" {
  description = "(Required) Name of the resource share to retrieve."
  type        = string
}

output "value" {
  description = "value - Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type. In Terraform CLI version 0.15 and later, this may require additional configuration handling for certain scenarios. For more information, see the Terraform v0.15 Upgrade Guide."
  value       = data.aws_ssm_parameter.this.value
}
