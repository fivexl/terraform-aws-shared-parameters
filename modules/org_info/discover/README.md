# Organization information discovery

Reads organization metadata without creating SSM parameters, RAM shares, or other AWS resources. Run it with management-account credentials that can list the organization, accounts, and OUs.

The `org_info` output contains `org_arn`, `root_id`, `org_id`, `master_account_id`, `accounts`, and `accounts_by_environment`. Individual values are available as `module.org_info_discovery.org_info.org_id`, for example.
Discovery keeps the existing five-level OU traversal and environment grouping behavior.

## Usage

The following providers use different AWS profiles for discovery and publishing. Replace the profile names and supply your existing KMS key ARN.

```hcl
provider "aws" {
  alias   = "organization"
  region  = "eu-central-1"
  profile = "organization-reader"
}

provider "aws" {
  alias   = "publisher"
  region  = "eu-central-1"
  profile = "parameter-publisher"
}

variable "shared_kms_key_arn" {
  type = string
}

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

Use only `org_info_discovery` if you do not need to publish parameters. Its output can also be passed to several `org_info/create` instances.

## Separate Terraform configurations

In the discovery configuration, expose the object as a root output:

```hcl
output "org_info" {
  value = module.org_info_discovery.org_info
}
```

In the publishing configuration, accept that object as an input and set `org_info = var.org_info` on `org_info/create`:

```hcl
variable "org_info" {
  type = object({
    org_arn           = string
    root_id           = string
    org_id            = string
    master_account_id = string
    accounts = map(object({
      id = string
    }))
    accounts_by_environment = map(list(string))
  })
}
```

Pass the JSON from `terraform output -json org_info` in the discovery configuration as the publishing configuration's `org_info` variable. If you already share Terraform state, you can instead pass `data.terraform_remote_state.organization.outputs.org_info` using your configured backend.
These are snapshots: refresh discovery and pass the updated object when the organization changes.

## Local tests

From the repository root, use Terraform 1.11 or later and Python 3:

```sh
terraform -chdir=modules/org_info/create init -backend=false
python3 modules/org_info/create/tests/verify.py
```

The tests use a mocked AWS provider and only plan operations. They require no AWS credentials and create no infrastructure. The test runner checks the discovery contract, discovery bypass, and the SSM/RAM publishing plan. The module's Terraform and provider requirements are unchanged.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_unit_child_accounts.accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_unit_child_accounts) | data source |
| [aws_organizations_organizational_units.level1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_org_info"></a> [org\_info](#output\_org\_info) | Organization metadata for reuse by org\_info/create. |
<!-- END_TF_DOCS -->
