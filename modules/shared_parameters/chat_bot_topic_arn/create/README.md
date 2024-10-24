# Shared SSM parameter - Chatbot topic arn 

This module creates a SSM parameter that is by default shared with entire organization using RAM. The parameter contains the ARN of the SNS topic that is used by the chatbot to send notifications.

### Usage:
This module depends on the following shared parameters:
- shared_kms_key_arn
- org_info
They should be pre-created before using this module. 
This module is intended to be created in the `security-tooling` account.

```hcl
locals {
  topics_environment_configuration = {
    production = {
      topic_name       = "production_notifications"
      allowed_accounts = local.production_env_accounts
    }
  }
}

module "shared_chat_bot_topic_arn" {
  source   = "../../../modules/external/shared_parameters/chat_bot_topic_arn/create"
  for_each = local.topics_environment_configuration

  chat_bot_topic_arn = aws_sns_topic.chat_bot_environment_notifications[each.key].arn
  environment        = each.key
  tags               = module.tags.result
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | ../../../naming_conventions | n/a |
| <a name="module_org_info"></a> [org\_info](#module\_org\_info) | ../../../shared_parameters/org_info/read | n/a |
| <a name="module_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#module\_shared\_kms\_key\_arn) | ../../../shared_parameters/shared_kms_key_arn/read | n/a |
| <a name="module_shared_parameter"></a> [shared\_parameter](#module\_shared\_parameter) | ../../../shared_parameter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chat_bot_topic_arn"></a> [chat\_bot\_topic\_arn](#input\_chat\_bot\_topic\_arn) | The ARN of the SNS topic for chatbot notifications | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->