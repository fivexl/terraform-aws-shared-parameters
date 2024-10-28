# Shared SSM parameter - Organization information

This module creates a SSM parameter that is shared with RAM. The parameter contains information about the organization, such as the organization ID, master account ID, and the IDs of all accounts in the organization. This information is useful for cross-account permissions management.
It's intended to be created in the `management` account, because it depends on `data.aws_organizations_organization.this` data source, which requires permissions to list all accounts & OU's in the organization.

## Usage
For more information about output values and usage, please refer to `./read` module. 

```hcl
locals {
  all_non_master_accounts= {
    for account in data.aws_organizations_organization.this.non_master_accounts : account.name => {
      id = account.id
    }
  }
  root_id = data.aws_organizations_organization.this.roots[0].id
  
  security_ou_arn = [for ou in data.aws_organizations_organizational_units.root.children : ou if ou.name == "security"][0].arn
  infrastructure_ou_arn = [for ou in data.aws_organizations_organizational_units.root.children : ou if ou.name == "infrastructure"][0].arn
}

data "aws_organizations_organizational_units" "root" {
  parent_id = local.root_id
}

module "organization_info_shared_parameter_primary" {
  source                   = "../../org_info/create"
  shared_kms_key_arn       = module.shared_kms_key.primary_key_arn
  principals_to_share_with = [local.security_ou_arn, local.infrastructure_ou_arn]
  all_accounts = local.all_non_master_accounts
  tags = module.tags.result
}

module "organization_info_shared_parameter_secondary" {
  source                   = "../../org_info/create"
  shared_kms_key_arn       = module.shared_kms_key.secondary_key_arn
  principals_to_share_with = [local.security_ou_arn, local.infrastructure_ou_arn]
  all_accounts = local.all_non_master_accounts
  providers = {
    aws = aws.secondary
  }
  tags = module.tags.result
}
```


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