# Shared SSM parameter - Organization information

This module publishes organization information as SSM parameters and shares them with RAM.
By default, it discovers the data using AWS Organizations and should run with management-account credentials that can list the organization, accounts, and OUs.
Set `org_info` to the output of [`org_info/discover`](../discover) to publish data that has already been read. In that case, this module makes no Organizations queries; its credentials still need permission to create the SSM parameters, use the KMS key, and manage RAM shares.

## Reuse discovered data

```hcl
module "org_info_discovery" {
  source = "fivexl/shared-parameters/aws//modules/org_info/discover"

  providers = { aws = aws.organization }
}

module "org_info_parameters" {
  source = "fivexl/shared-parameters/aws//modules/org_info/create"

  providers = { aws = aws.publisher }

  org_info           = module.org_info_discovery.org_info
  shared_kms_key_arn = var.shared_kms_key_arn
  principals_to_share_with = {
    organization = module.org_info_discovery.org_info.org_arn
  }
}
```

Configure `aws.organization` with Organizations read access and `aws.publisher` with publishing access. See the [discovery example](../discover#usage) for provider configuration and [passing data between configurations](../discover#separate-terraform-configurations).
Omit `org_info`, or set it to `null`, to keep automatic discovery.

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
```

> **Breaking change:** `principals_to_share_with` is now `map(string)` instead of
> `list(string)`. The map keys become the `for_each` identifiers of the underlying RAM
> principal associations and must be known at plan time; the values (principal ARNs) may
> stay unknown until apply. This is what lets you share with an OU that is created in the
> same run -- previously that failed the plan with `Invalid for_each argument` and needed a
> `-target` two-step apply. See the `shared_parameter` module README for the
> `terraform state mv` migration.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_discover"></a> [discover](#module\_discover) | ../discover | n/a |
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | fivexl/naming-conventions/aws | 0.1.1 |
| <a name="module_shared_parameters"></a> [shared\_parameters](#module\_shared\_parameters) | ../../shared_parameter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_info"></a> [org\_info](#input\_org\_info) | Precomputed organization metadata from org\_info/discover. When null, discover it automatically. | <pre>object({<br/>    org_arn           = string<br/>    root_id           = string<br/>    org_id            = string<br/>    master_account_id = string<br/>    accounts = map(object({<br/>      id = string<br/>    }))<br/>    accounts_by_environment = map(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_parameter_name"></a> [parameter\_name](#input\_parameter\_name) | A name of the SSM parameter | `string` | `""` | no |
| <a name="input_principals_to_share_with"></a> [principals\_to\_share\_with](#input\_principals\_to\_share\_with) | Map of stable identifiers to the principals to share the parameter with.<br/>  Keys are used as for\_each identifiers and MUST be known at plan time;<br/>  values may be unknown until apply (e.g. the ARN of an OU created in the<br/>  same run). The format of the principal value can be:<br/>  an AWS account ID,<br/>  an Amazon Resource Name (ARN) of an organization in AWS Organizations,<br/>  an ARN of an organizational unit (OU) in AWS Organizations,<br/>  an ARN of an IAM role, an ARN of an IAM user,<br/>  or a service principal name. | `map(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for the shared parameters and their RAM shares. Defaults to the provider region. | `string` | `null` | no |
| <a name="input_resource_share_name"></a> [resource\_share\_name](#input\_resource\_share\_name) | A name of resource share for org info paramater | `string` | `""` | no |
| <a name="input_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#input\_shared\_kms\_key\_arn) | The ARN of the KMS key to use for encrypting the shared parameter | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created by this module | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->