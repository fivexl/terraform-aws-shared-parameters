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
  source   = "../../chat_bot_topic_arn/create"
  for_each = local.topics_environment_configuration

  chat_bot_topic_arn = aws_sns_topic.chat_bot_environment_notifications[each.key].arn
  environment        = each.key
  tags               = module.tags.result
}
```

### Upgrading to `principals_to_share_with = map(string)`

This module's own inputs did **not** change: it still takes `chat_bot_topic_arn`,
`environment` and `tags`. What changed is internal -- it now passes
`{ org = module.org_info.org_arn }` to `shared_parameter` instead of
`[module.org_info.org_arn]`, so the `for_each` key of the RAM principal association
moved from the organization ARN to the literal string `org`.

Because the key is part of the resource address, an upgrade with no state move plans
**1 destroy + 1 create per association**. The two are independent instances with no
dependency between them, so Terraform gives no ordering guarantee: the apply can revoke
the share from the organization before re-granting it, leaving consumer accounts without
access to the parameter mid-apply. Move the address first instead:

```bash
# one move per instance of this module
terraform state mv \
  'module.shared_chat_bot_topic_arn["production"].module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["arn:aws:organizations::111122223333:organization/o-abc123456"]' \
  'module.shared_chat_bot_topic_arn["production"].module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["org"]'
```

Drop the `["production"]` index if you call this module without `for_each`. To list the
real addresses and organization ARN in your state rather than transcribing them:

```bash
terraform state list | grep 'aws_ram_principal_association'
```

A `terraform plan` that reports `0 to add, 0 to destroy` for
`aws_ram_principal_association` confirms the moves were complete.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | fivexl/naming-conventions/aws | 0.1.1 |
| <a name="module_org_info"></a> [org\_info](#module\_org\_info) | ../../org_info/read | n/a |
| <a name="module_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#module\_shared\_kms\_key\_arn) | ../../shared_kms_key_arn/read | n/a |
| <a name="module_shared_parameter"></a> [shared\_parameter](#module\_shared\_parameter) | ../../shared_parameter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chat_bot_topic_arn"></a> [chat\_bot\_topic\_arn](#input\_chat\_bot\_topic\_arn) | The ARN of the SNS topic for chatbot notifications | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name: dev, stage, prod, for the generation of the ram resource share name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->