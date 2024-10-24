
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

variable "parameter_description" {
  description = "Description of the parameter"
  type        = string
}

variable "parameter_key_id" {
  description = "The KMS key id or arn for encrypting the parameter"
  type        = string
}

variable "parameter_type" {
  description = "Type of the parameter"
  type        = string
  default     = "SecureString"
}

variable "principals_to_share_with" {
  type        = list(string)
  description = <<EOT
  The principals to share the resource with. The format of the principal can be:
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
