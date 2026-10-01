# Shared SSM parameter - S3 access logs replication configuration

This module creates a SSM parameter that is shared by RAM with enrire aws organization. This parameter contains necessary information to configure S3 access logs replication to `log-archive` account, so that any child account in AWS organization can get inforation necessary to configure S3 access logs replication.
It's intended to be created in the `log-archive` account, used by account_baseline module.

## Usage
    
```hcl
module "s3_access_logs_replication_configuration_shared_parameter_primary" {
  source = "../../s3_access_logs_replication/create"

  bucket_arn = module.s3_server_access_logs_lake_primary.s3_bucket_arn

  tags = module.tags.result
}

module "s3_access_logs_replication_configuration_shared_parameter_secondary" {
  source = "../../s3_access_logs_replication/create"

  bucket_arn = module.s3_server_access_logs_lake_secondary.s3_bucket_arn

  tags = module.tags.result

  providers = {
    aws = aws.secondary
  }
}
```

### Upgrading to `principals_to_share_with = map(string)`

This module's own inputs did **not** change: it still takes `bucket_arn` and `tags`.
What changed is internal -- it now passes `{ org = module.org_info.org_arn }` to
`shared_parameter` instead of `[module.org_info.org_arn]`, so the `for_each` key of the
RAM principal association moved from the organization ARN to the literal string `org`.

Because the key is part of the resource address, an upgrade with no state move plans
**1 destroy + 1 create per association**. The two are independent instances with no
dependency between them, so Terraform gives no ordering guarantee: the apply can revoke
the share from the organization before re-granting it, leaving child accounts without
access to the replication configuration parameter mid-apply -- and this module is
consumed by `account_baseline`. Move the address first instead, once per instance
(primary and secondary are separate instances, each with its own provider):

```bash
terraform state mv \
  'module.s3_access_logs_replication_configuration_shared_parameter_primary.module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["arn:aws:organizations::111122223333:organization/o-abc123456"]' \
  'module.s3_access_logs_replication_configuration_shared_parameter_primary.module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["org"]'

terraform state mv \
  'module.s3_access_logs_replication_configuration_shared_parameter_secondary.module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["arn:aws:organizations::111122223333:organization/o-abc123456"]' \
  'module.s3_access_logs_replication_configuration_shared_parameter_secondary.module.shared_parameter.module.ram_resource_share.aws_ram_principal_association.this["org"]'
```

To list the real addresses and organization ARN in your state rather than transcribing
them:

```bash
terraform state list | grep 'aws_ram_principal_association'
```

A `terraform plan` that reports `0 to add, 0 to destroy` for
`aws_ram_principal_association` confirms the moves were complete.

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
| <a name="module_org_info"></a> [org\_info](#module\_org\_info) | ../../../shared_parameters/org_info/read | n/a |
| <a name="module_shared_kms_key_arn"></a> [shared\_kms\_key\_arn](#module\_shared\_kms\_key\_arn) | ../../../shared_parameters/shared_kms_key_arn/read | n/a |
| <a name="module_shared_parameter"></a> [shared\_parameter](#module\_shared\_parameter) | ../../../shared_parameter | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | The ARN of the S3 bucket where access logs are delivered. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->