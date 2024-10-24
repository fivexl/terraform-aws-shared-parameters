# Shared SSM parameter - `alias/default` KMS key ARN

This module outputs the ARN of the `alias/default` KMS key. This is default key to be used for encryption across the environment. This module depends on pre-created KMS keys with ram resource share in every environment (dev, test, prod).

## Usage
```hcl
module "kms_key_arn" {
  source = "fivexl/shared-parameters/aws//modules/shared_parameters/default_kms_key_arn/read"
}

output "kms_key_arn" {
  value = module.kms_key_arn.value
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms_key_arn"></a> [kms\_key\_arn](#module\_kms\_key\_arn) | ../../../shared_parameter_data | n/a |
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | ../../../naming_conventions | n/a |

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