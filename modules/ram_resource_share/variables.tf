variable "name" {
  description = "(Required) The name of the resource share."
  type        = string
}

variable "permission_arns" {
  description = "(Optional) Specifies the Amazon Resource Names (ARNs) of the RAM permission to associate with the resource share. If you do not specify an ARN for the permission, RAM automatically attaches the default version of the permission for each resource type. You can associate only one permission with each resource type included in the resource share."
  type        = list(string)
  default     = null
}

variable "allow_external_principals" {
  description = "(Optional) Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = false
}

variable "principals" {
  description = "(Required) The principals to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  type        = list(string)
}

variable "resources" {
  description = "(Required) Amazon Resource Name (ARN's) of the resources to associate with the RAM Resource Share."
  type        = list(string)
}

variable "tags" {
  description = "(Optional) Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "number_of_resources" {
  description = "The number of resources to associate with the resource share"
  type        = number
  default     = 1
}
