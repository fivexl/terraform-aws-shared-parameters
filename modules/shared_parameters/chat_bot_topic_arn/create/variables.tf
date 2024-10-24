variable "chat_bot_topic_arn" {
  description = "The ARN of the SNS topic for chatbot notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

