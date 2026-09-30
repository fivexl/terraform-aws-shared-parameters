
variable "parameter_name" {
  description = "Name of the parameter"
  type        = string
}

variable "resource_share_name" {
  description = "Name of the resource share"
  type        = string
}

variable "parameter_value" {
  description = "Value of the parameter"
  type        = string
}

variable "ignore_value_changes" {
  description = "Whether to ignore later out-of-band changes to the parameter value after creation. Enabling this on an already-managed parameter requires a terraform state mv."
  type        = bool
  default     = false
}

variable "parameter_description" {
  description = "Description of the parameter"
  type        = string
}

variable "parameter_key_id" {
  description = "The KMS key id or arn for encrypting the parameter"
  type        = string
  default     = null
}

variable "parameter_type" {
  description = "Type of the parameter"
  type        = string
  default     = "SecureString"
}

variable "allow_external_principals" {
  description = "(Optional) Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = false
}

variable "principals_to_share_with" {
  type        = map(string)
  description = <<EOT
  Map of stable identifiers to the principals to share the resource with.
  Keys are used as for_each identifiers and MUST be known at plan time;
  values may be unknown until apply (e.g. the ARN of an OU created in the
  same run). The format of the principal value can be:
  an AWS account ID,
  an Amazon Resource Name (ARN) of an organization in AWS Organizations,
  an ARN of an organizational unit (OU) in AWS Organizations,
  an ARN of an IAM role, an ARN of an IAM user,
  or a service principal name.
  EOT
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
