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
  principals_to_share_with = {
    security       = local.security_ou_arn
    infrastructure = local.infrastructure_ou_arn
  }
  all_accounts = local.all_non_master_accounts
  tags = module.tags.result
}

module "organization_info_shared_parameter_secondary" {
  source                   = "../../org_info/create"
  shared_kms_key_arn       = module.shared_kms_key.secondary_key_arn
  principals_to_share_with = {
    security       = local.security_ou_arn
    infrastructure = local.infrastructure_ou_arn
  }
  all_accounts = local.all_non_master_accounts
  providers = {
    aws = aws.secondary
  }
  tags = module.tags.result
}

> **Breaking change:** `principals_to_share_with` is now `map(string)` instead of
> `list(string)`. The map keys become the `for_each` identifiers of the underlying RAM
> principal associations and must be known at plan time; the values (principal ARNs) may
> stay unknown until apply. This is what lets you share with an OU that is created in the
> same run -- previously that failed the plan with `Invalid for_each argument` and needed a
> `-target` two-step apply. See the `shared_parameter` module README for the
> `terraform state mv` migration.
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | fivexl/naming-conventions/aws | 0.1.1 |
| <a name="module_shared_parameters"></a> [shared\_parameters](#module\_shared\_parameters) | ../../shared_parameter | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_unit_child_accounts.accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_unit_child_accounts) | data source |
| [aws_organizations_organizational_units.level1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_parameter_name"></a> [parameter\_name](#input\_parameter\_name) | A name of the SSM parameter | `string` | `""` | no |
| <a name="input_principals_to_share_with"></a> [principals\_to\_share\_with](#input\_principals\_to\_share\_with) | Map of stable identifiers to the principals to share the parameter with.<br/>  Keys are used as for\_each identifiers and MUST be known at plan time;<br/>  values may be unknown until apply (e.g. the ARN of an OU created in the<br/>  same run). The format of the principal value can be:<br/>  an AWS account ID,<br/>  an Amazon Resource Name (ARN) of an organization in AWS Organizations,<br/>  an ARN of an organizational unit (OU) in AWS Organizations,<br/>  an ARN of an IAM role, an ARN of an IAM user,<br/>  or a service principal name. | `map(string)` | n/a | yes |
| <a name="input_resource_share_name"></a> [resource\_share\_name](#input\_resource\_share\_name) | A name of resource share for org info paramater | `string` | `""` | no |
| <a name="input_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#input\_shared\_kms\_key\_arn) | The ARN of the KMS key to use for encrypting the shared parameter | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created by this module | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->