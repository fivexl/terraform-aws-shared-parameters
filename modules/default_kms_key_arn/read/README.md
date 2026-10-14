# Shared SSM parameter - `alias/default` KMS key ARN

This module outputs the ARN of the `alias/default` KMS key. This is default key to be used for encryption across the environment. This module depends on pre-created KMS keys with ram resource share in every environment (dev, test, prod). Module uses `resource_share_name = module.naming_conventions.default_kms_key_resource_share_name` to guess the resource share name.

## Usage
```hcl
module "kms_key_arn" {
  source = "../../default_kms_key_arn/read"
}

output "kms_key_arn" {
  value = module.kms_key_arn.value
}
```

<!-- BEGIN_TF_DOCS -->
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
<!-- END_TF_DOCS -->