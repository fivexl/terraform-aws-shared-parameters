# Shared SSM parameter - Organization information

This module collects data from SSM parameter and provides it as outputs.
Commonly you would need this information in the `security-sso` account to manage permissions.
See outputs for more information.

## Usage
```hcl
module "org_info" {
  source = "../../org_info/read"
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | ../../../naming_conventions | n/a |
| <a name="module_org_info"></a> [org\_info](#module\_org\_info) | ../../../shared_parameter_data | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | The owner of the resource share | `string` | `"OTHER-ACCOUNTS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | The IDs of the organization's accounts, master account is excluded from the list. |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | The ID of the organization's master account |
| <a name="output_org_arn"></a> [org\_arn](#output\_org\_arn) | The ARN of the organization |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | The ID of the organization |
| <a name="output_root_id"></a> [root\_id](#output\_root\_id) | The ID of the organization's root |
<!-- END_TF_DOCS -->