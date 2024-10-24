# Terraform AWS shared parameter data module
This module is used to retrieve AWS Systems Manager (SSM) parameter values that are shared across multiple accounts in your AWS organization using AWS Resource Access Manager (RAM). Often, this module is used in conjunction with the `shared_parameter` module, to create /create or /read modules for SSM parameters, more information, and examples you can find in the `/shared_parameters` directory.


### Features:
- Retrieves AWS RAM resource shares using the `aws_ram_resource_share` data source.
- Retrieves AWS Systems Manager (SSM) parameter values using the `aws_ssm_parameter` data source.
- Outputs the value of the retrieved SSM parameter.

### Usage:
This module is intended to be used when you need to retrieve SSM parameters that is shared across multiple accounts in your AWS organization using AWS Resource Access Manager (RAM).


### Examples:
```hcl
module "aws_ram_ssm_parameter" {
  source = "path/to/module"
  resource_share_name = "your_resource_share_name"
}
locals {
  ssm_parameter_value = module.aws_ram_ssm_parameter.value # This will return the value of the SSM parameter.
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ram_resource_share) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | (Optional) Owner of the resource share. Valid values are SELF or OTHER-ACCOUNTS. Defaults to OTHER-ACCOUNTS. | `string` | `"OTHER-ACCOUNTS"` | no |
| <a name="input_resource_share_name"></a> [resource\_share\_name](#input\_resource\_share\_name) | (Required) Name of the resource share to retrieve. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_value"></a> [value](#output\_value) | value - Value of the parameter. This value is always marked as sensitive in the Terraform plan output, regardless of type. In Terraform CLI version 0.15 and later, this may require additional configuration handling for certain scenarios. For more information, see the Terraform v0.15 Upgrade Guide. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->