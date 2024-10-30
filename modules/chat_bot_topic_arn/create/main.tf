module "naming_conventions" {
  source  = "fivexl/naming-convetions/aws"
  version = "0.0.1"
  environment = var.environment
}

module "shared_kms_key_arn" {
  source = "../../shared_kms_key_arn/read"

}

module "org_info" {
  source = "../../org_info/read"
}

module "shared_parameter" {
  source = "../../shared_parameter"

  parameter_name           = module.naming_conventions.chat_bot_topic_arn_ssm_parameter_name
  resource_share_name      = module.naming_conventions.chat_bot_topic_arn_resource_share_name
  parameter_description    = "Chatbot topic ARN for notifications and alerts"
  parameter_key_id         = module.shared_kms_key_arn.value
  parameter_value          = var.chat_bot_topic_arn
  principals_to_share_with = [module.org_info.org_arn]

  tags = var.tags
}



