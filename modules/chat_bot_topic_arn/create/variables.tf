variable "chat_bot_topic_arn" {
  description = "The ARN of the SNS topic for chatbot notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "environment" {
  description = "The environment name: dev, stage, prod, for the generation of the ram resource share name"
  type        = string
}
