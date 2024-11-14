variable "shared_kms_key_arn" {
  description = "The ARN of the KMS key to use for encrypting the shared parameter"
  type        = string
}

variable "principals_to_share_with" {
  type        = list(string)
  description = <<EOT
  The principals to share the parameter with. The format of the principal can be:
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
