# Shared SSM parameter - Chatbot topic arn

This module is created to read `chat_bot_topic_arn` SSM parameter and provide its value as output. The parameter contains the ARN of the SNS topic that is used by the chatbot to send notifications. 

### Usage
This module depends on the following shared parameters:
-chat_bot_topic_arn


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
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | fivexl/naming-conventions/aws | 0.0.1 |
| <a name="module_shared_parameter_data"></a> [shared\_parameter\_data](#module\_shared\_parameter\_data) | ../../shared_parameter_data | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | The owner of the resource share | `string` | `"OTHER-ACCOUNTS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_value"></a> [value](#output\_value) | The ARN of the shared KMS key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->