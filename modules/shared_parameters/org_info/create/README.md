# Shared SSM parameter - Organization information

This module creates a SSM parameter that is shared with RAM. The parameter contains information about the organization, such as the organization ID, master account ID, and the IDs of all accounts in the organization. This information is useful for cross-account permissions management.
It's intended to be created in the `management` account, because it depends on `data.aws_organizations_organization.this` data source, which requires permissions to list all accounts & OU's in the organization.

## Usage
For more information about output values and usage, please refer to `./read` module. 


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | ../../../naming_conventions | n/a |
| <a name="module_organization_info_shared_parameter"></a> [organization\_info\_shared\_parameter](#module\_organization\_info\_shared\_parameter) | ../../../shared_parameter | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arn_of_principal_to_share_with"></a> [arn\_of\_principal\_to\_share\_with](#input\_arn\_of\_principal\_to\_share\_with) | The ARN of the principal to share the shared parameter with | `string` | n/a | yes |
| <a name="input_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#input\_shared\_kms\_key\_arn) | The ARN of the KMS key to use for encrypting the shared parameter | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created by this module | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->