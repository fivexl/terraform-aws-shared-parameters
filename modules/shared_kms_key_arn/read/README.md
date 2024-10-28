# Shared SSM parameter - `alias/shared` KMS key ARN

This module outputs the ARN of the `alias/shared` KMS key. This key is created in management account, and shared with organization, so it would be used to encrypt all shared SSM parameters and other shared resources across the organization. `Naming_conventions` module is used to create this resource share in management account, and guess the resource share name in this module.

## Usage
This module is intended to be used in child organization accounts, to get the ARN of the shared KMS key to encrypt shared across the organization resources.

```hcl
module "shared_kms_key_arn" {
  source = "../../shared_kms_key_arn/read"
}

locals {
  parameter_key_id      = module.shared_kms_key_arn.value
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