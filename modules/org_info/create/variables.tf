variable "shared_kms_key_arn" {
  description = "The ARN of the KMS key to use for encrypting the shared parameter"
  type        = string
}

variable "principals_to_share_with" {
  type        = map(string)
  description = <<EOT
  Map of stable identifiers to the principals to share the parameter with.
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
  description = "A map of tags to add to the resources created by this module"
  type        = map(string)
  default     = {}
}

variable "parameter_name" {
  description = "A name of the SSM parameter"
  type        = string
  default     = ""
}

variable "resource_share_name" {
  description = "A name of resource share for org info paramater"
  type        = string
  default     = ""
}